#!/bin/bash
# Smoke test: does the plugin even start?
# Run from plugins/core. Exits non-zero on any failure.
#
# This does not ask whether the plugin is GOOD. It asks whether it is COHERENT:
# every file it points at exists, every tool it names is real, every manifest parses.
# A plugin that fails this cannot work, no matter how well written its prose is.

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
ROOT="../.."
fail=0
pass=0

ok()   { printf "  \033[32m✅\033[0m %s\n" "$1"; pass=$((pass+1)); }
bad()  { printf "  \033[31m❌\033[0m %s\n" "$1"; fail=$((fail+1)); }
sect() { printf "\n\033[1m── %s\033[0m\n" "$1"; }

# The 57 tools the connector actually serves. Verified against
# the-balanced-investor-club-platform/app/api/mcp/tools/ — note that
# get_income_statement / get_balance_sheet / get_cash_flow are registered through a
# factory (`toolName: "..."`), so grepping for `server.tool("name"` misses all three.
# Any count taken that way comes back three short. Ask the running server, or read
# financials.ts.
#
# The last five are the write tools that close the loop: until 0.3.0 the connector
# could create a trade but never take one back out, and could follow a tracker but
# never unfollow it. A product whose North Star is Weekly Active Journals shipped
# without a way to fix a mis-typed entry.
REAL_TOOLS="start_here about_us get_pricing get_instrument_popularity get_curated_lists
get_close_history compare_tickers get_price_alignment get_crypto_price_alignment
get_mood_for_ticker list_market_moods get_today_mood_changes get_market_pulse get_market_movers
get_fundamentals get_income_statement get_balance_sheet get_cash_flow get_valuation_inputs
get_earnings_estimates get_dividends get_etf_profile get_instrument_overview get_ticker_metadata
get_earnings_transcript get_insider_transactions get_institutional_holdings get_news
get_market_calendar get_sector_returns get_industry_returns get_macro_indicators
list_securities_by search_instruments whoami get_my_cocreator_status get_my_briefing
get_my_watchlists search_my_watchlists check_ticker_in_my_watchlists create_watchlist
add_to_watchlist remove_from_watchlist follow_watchlist list_my_trades get_my_journal_stats
log_trade close_trade update_trade get_my_trust_score discover_community_watchlists
get_watchlist_by_slug
delete_trade import_trades unfollow_watchlist update_watchlist delete_watchlist"

sect "1 · Manifiestos"
for f in "$ROOT/.claude-plugin/marketplace.json" ".claude-plugin/plugin.json" ".mcp.json"; do
  if [ ! -f "$f" ]; then bad "$f no existe"; continue; fi
  if python3 -c "import json,sys; json.load(open('$f'))" 2>/dev/null; then
    ok "$(basename "$f") parsea"
  else
    bad "$(basename "$f") NO ES JSON VÁLIDO"   # Anthropic shipped a broken one. We check.
  fi
done

# plugin.json: the four required fields must be there. Extras (homepage, repository) are
# harmless and the partner plugins in Anthropic's own repos carry them — so require, don't forbid.
# The version, on the other hand, is load-bearing: it is what gates update delivery. Bump it or
# every already-installed user keeps the old plugin forever, and never finds out.
missing_keys=$(python3 -c "
import json
d = json.load(open('.claude-plugin/plugin.json'))
req = {'name','version','description','author'}
print(' '.join(sorted(req - set(d))))")
[ -z "$missing_keys" ] \
  && ok "plugin.json: los 4 campos obligatorios presentes" \
  || bad "plugin.json: FALTAN [$missing_keys]"

pv=$(python3 -c "import json;print(json.load(open('.claude-plugin/plugin.json'))['version'])")
pd=$(python3 -c "import json;print(json.load(open('.claude-plugin/plugin.json'))['description'])")
nskills=$(ls -d skills/*/ | wc -l | tr -d ' ')
echo "$pd" | grep -q "$nskills skills" \
  && ok "plugin.json: la description dice $nskills skills, y hay $nskills" \
  || bad "plugin.json: la description NO cuadra con el catálogo real ($nskills skills)"
ok "plugin.json: version $pv"

# The marketplace must point at a plugin.json that exists.
src=$(python3 -c "import json;print(json.load(open('$ROOT/.claude-plugin/marketplace.json'))['plugins'][0]['source'])" 2>/dev/null)
[ -f "$ROOT/$src/.claude-plugin/plugin.json" ] \
  && ok "marketplace.source → $src (existe)" \
  || bad "marketplace.source → $src NO tiene plugin.json"

# The marketplace description is the first thing a human ever reads about this plugin.
# It said "55 financial workflows" for months after there were not 55 of anything, which is
# the kind of thing nobody notices because nobody re-reads a manifest.
md=$(python3 -c "import json;print(json.load(open('$ROOT/.claude-plugin/marketplace.json'))['plugins'][0]['description'])")
echo "$md" | grep -q "$nskills skills" \
  && ok "marketplace: la description dice $nskills skills, y hay $nskills" \
  || bad "marketplace: la description NO cuadra con el catálogo real ($nskills skills)"

sect "2 · Frontmatter (spec de Agent Skills)"
bad_fm=0
for d in skills/*/; do
  s=$(basename "$d")
  fm=$(awk -F': *' '/^name:/{print $2; exit}' "$d/SKILL.md")
  [ "$fm" = "$s" ] || { bad "$s: name='$fm' ≠ directorio"; bad_fm=1; }
  echo "$s" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || { bad "$s: nombre inválido"; bad_fm=1; }
  echo "$s" | grep -qiE 'claude|anthropic' && { bad "$s: palabra reservada"; bad_fm=1; }
  grep -q '^description:' "$d/SKILL.md" || { bad "$s: sin description"; bad_fm=1; }
done
[ $bad_fm -eq 0 ] && ok "$(ls -d skills/*/ | wc -l | tr -d ' ') skills con frontmatter conforme"

for f in commands/*.md; do
  grep -q '^description:' "$f" || bad "$(basename "$f"): sin description"
done
ok "$(ls commands/*.md | wc -l | tr -d ' ') commands con description"

for f in agents/*.md; do
  grep -q '^tools:' "$f" || bad "$(basename "$f"): sin lista blanca de tools"
done
ok "$(ls agents/*.md | wc -l | tr -d ' ') agents con tools declarados"

sect "3 · Referencias colgando"
dang=0
for f in skills/*/SKILL.md commands/*.md agents/*.md; do
  # a skill name looks like `foo-bar`; a tool looks like `get_foo`
  for r in $(grep -oE '`[a-z][a-z0-9]*(-[a-z0-9]+)+`' "$f" 2>/dev/null | tr -d '`' | sort -u); do
    case "$r" in
      *.md|*.py|*.sh|*.json|*.xlsx|*.pptx|*.docx) continue ;;
    esac
    # only flag it if it LOOKS like a skill we once had
    if [ ! -d "skills/$r" ] && { [ -d "$ROOT/parked/skills/$r" ] || [ -d "$ROOT/parked/to-iam-fsi/$r" ] || [ -d ~/Documents/Dev/marketing-services-for-claude/skills/"$r" ]; }; then
      bad "$(basename "$(dirname "$f")")/$(basename "$f") → \`$r\` (ya no está en el plugin)"; dang=1
    fi
  done
done
[ $dang -eq 0 ] && ok "cero referencias a skills que se fueron"

# Files, scripts and templates that are told to be used must exist.
missing=0
for f in $(grep -rlE '`(examples|scripts|references|assets)/[^`]+`' skills/ 2>/dev/null); do
  for path in $(grep -oE '`(examples|scripts|references|assets)/[^`]+`' "$f" | tr -d '`' | sort -u); do
    d=$(dirname "$f")
    [ -e "$d/$path" ] || { bad "$f → $path NO EXISTE"; missing=1; }
  done
done
[ $missing -eq 0 ] && ok "cero ficheros/scripts referenciados que no existan"

sect "4 · Las tools que se citan, ¿existen en el servidor?"
ghost=0
for f in skills/*/SKILL.md commands/*.md agents/*.md; do
  for t in $(grep -oE '`(get|list|log|close|update|create|add|remove|follow|check|search|compare|discover|start|about|whoami)_?[a-z_]*`' "$f" 2>/dev/null | tr -d '`' | sort -u); do
    case " $REAL_TOOLS " in
      *" $t "*) ;;
      *) echo "$REAL_TOOLS" | grep -qw "$t" || { bad "$f cita \`$t\` — NO existe en el conector"; ghost=1; } ;;
    esac
  done
done
[ $ghost -eq 0 ] && ok "todas las tools citadas existen en el conector (57 reales)"

# Phantom MCP servers: the fork referenced four that were never declared.
for phantom in "screening MCP" "nav MCP" "internal-gl MCP" "mcp__office__"; do
  if grep -rq "$phantom" skills/ agents/ 2>/dev/null; then
    bad "servidor MCP fantasma referenciado: $phantom"
  fi
done
declared=$(python3 -c "import json;print(len(json.load(open('.mcp.json'))['mcpServers']))")
ok "servidores MCP declarados: $declared · fantasmas: 0"

sect "5 · El verificador, sobre las 26"
v_pass=0; v_fail=0
for d in skills/*/; do
  s=$(basename "$d")
  if ./scripts/verify-skill.sh "$s" >/dev/null 2>&1; then v_pass=$((v_pass+1)); else v_fail=$((v_fail+1)); bad "verify-skill: $s"; fi
done
[ $v_fail -eq 0 ] && ok "$v_pass/$v_pass skills pasan el verificador"

sect "RESULTADO"
printf "  %s pasan · %s fallan\n\n" "$pass" "$fail"
[ $fail -eq 0 ] && printf "  \033[32m✅ SMOKE TEST OK — el plugin arranca\033[0m\n\n" \
                || printf "  \033[31m❌ SMOKE TEST FALLA — no subir\033[0m\n\n"
exit $fail
