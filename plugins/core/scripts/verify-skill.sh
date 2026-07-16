#!/bin/bash
# Verify one skill against the plugin's rules. Usage: scripts/verify-skill.sh <skill-name>
# Run from plugins/core. Exits non-zero on any failure, so it can gate CI.
set -uo pipefail

name="${1:?usage: verify-skill.sh <skill-name>}"
dir="skills/$name"
f="$dir/SKILL.md"
fail=0

# The prohibited vocabulary — defined once, in one file, shared with CI.
# shellcheck source=scripts/vocabulary.sh
. "$(dirname "$0")/vocabulary.sh"

check() { # check <label> <ok:0|1> [detail]
  if [ "$2" -eq 0 ]; then printf "  ✅ %s%s\n" "$1" "${3:+ — $3}"
  else printf "  ❌ %s%s\n" "$1" "${3:+ — $3}"; fail=1; fi
}

echo "── $name"

[ -f "$f" ] || { echo "  ❌ no existe $f"; exit 1; }

# 1. frontmatter name == directory name (Agent Skills spec)
fm=$(awk -F': *' '/^name:/{print $2; exit}' "$f")
[ "$fm" = "$name" ]; check "name coincide con el directorio" $? "$fm"

# 2. name is lowercase-hyphen and free of reserved words
echo "$fm" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' && ! echo "$fm" | grep -qiE 'claude|anthropic'
check "name válido por spec (sin 'claude'/'anthropic')" $?

# 3. description exists and carries trigger phrases
grep -q '^description:' "$f" && grep -qi 'trigger' "$f"
check "description con frases de disparo" $?

# 4. length budget
n=$(wc -l < "$f" | tr -d ' ')
[ "$n" -lt 500 ]; check "bajo el presupuesto de 500 líneas (guía de Anthropic)" $? "$n líneas"

# 5. Perimeter. A skill that pulls market data MUST stop when the connector is absent — silently
#    falling back to memory or the web is how a number with no provenance ends up in a deliverable.
#    A skill that works only on files the user brings has no connector to lose, and demanding a
#    guard from it is cargo cult. It must instead say so, out loud: no market data, no web.
if grep -qE '`(get_|list_|search_instruments|compare_tickers|log_trade|close_trade|update_trade|create_watchlist|add_to_watchlist|remove_from_watchlist|follow_watchlist|check_ticker|discover_community|whoami|start_here|about_us)' "$f"; then
  grep -q "not available in this session: STOP" "$f"
  check "guard del conector (STOP) — usa datos del conector" $?
else
  grep -qiE "uses no market data|no market data.*never web|does not touch the connector" "$f"
  check "perímetro declarado — no usa datos de mercado" $?
fi

# 6. output block referenced, never restated
grep -q "OUTPUT-BLOCK.md" "$f"
check "referencia a OUTPUT-BLOCK.md" $?

# 7. the invariant both official Anthropic verticals honour, 20/20
grep -q "## What this skill does NOT do" "$f"
check "sección 'What this skill does NOT do'" $?

# 8. attribution
grep -q "^## Attribution and disclaimer" "$f"
check "sección de atribución" $?

# 9. references/ present, even when empty — the room is made before it is needed
[ -d "$dir/references" ]; check "references/ existe" $?

# 10. Prohibited vocabulary — across the WHOLE skill directory, not just SKILL.md.
#
#     This check used to look only at SKILL.md, and it was wrong. When the oversized skills were
#     split into references/, the verdicts went with them: four price targets and two fair values
#     walked straight out of a file the verifier was watching and into one it was not. A skill is
#     everything Claude loads, and the reference files are loaded on demand — so they count.
#
#     The vocabulary itself lives in scripts/vocabulary.sh, which CI sources too. It used to be
#     duplicated here and in the workflow, and the two copies drifted: this verifier passed 26/26
#     while CI failed on a line this one excluded. One list, or no list.
hits=$(vocab_sweep "$dir" || true)
[ -z "$hits" ]; check "cero vocabulario prohibido (SKILL.md + references/)" $? "${hits:+$(echo "$hits" | head -3)}"

# 11. A skill that emits a file must stamp it — and must fetch the date rather than recall one.
#     A model does not know what day it is. A report dated by a model is dated by a guess, and
#     nothing on the page will look wrong. `whoami` / `start_here` return the server's date.
if grep -qiE '\.xlsx|\.docx|\.pptx|\.pdf|write to|report|workbook|deliverable' "$f"; then
  grep -qE '`whoami`|`start_here`|date from the connector|OUTPUT-BLOCK' "$f"
  check "emite ficheros → la fecha se pide, no se recuerda" $?
fi

exit $fail
