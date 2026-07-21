#!/usr/bin/env bash
# Headless e2e QA of the 0.3.0 plugin (26 skills) against the PROD connector.
# Run in a FRESH Claude Code session / real terminal (nested claude EPERMs mid-session).
#
#   bash qa-headless-e2e.sh
#
# For each skill: fires claude -p with a trigger prompt, saves the jsonl, then checks
#   [FIRED]      the skill/its work ran
#   [CONNECTOR]  at least one mcp__ connector tool was called
#   [DISCLAIMER] "not investment advice" / "Educational content" in the result
#   [NO-WEB]     no WebSearch/WebFetch fallback (self-containment)
set -uo pipefail
cd "$(dirname "$0")"
OUT="./qa-e2e-out"; mkdir -p "$OUT"

echo "== install local 0.3.0 plugin =="
claude plugin marketplace add "$(pwd)" 2>&1 | tail -2
claude plugin install the-balanced-investor-club@the-balanced-investor-club-for-claude 2>&1 | tail -2
echo

# skill => trigger prompt. File-input skills (audit-xls, clean-data-xls) need a fixture -> MANUAL.
declare -A P=(
  [3-statement-model]="Build a 3-statement model for AAPL"
  [catalyst-calendar]="Build a catalyst calendar for NVDA for the next quarter"
  [competitive-analysis]="Build a competitive analysis for NVDA in the semiconductor space"
  [comps-analysis]="Build a comps analysis for AAPL versus its peers"
  [dcf-model]="Build a DCF model for MSFT"
  [dividends]="Show me KO's dividend history"
  [earnings-analysis]="Analyze AAPL's latest quarterly earnings"
  [earnings-preview]="Build an earnings preview for NVDA's next quarter"
  [initiating-coverage]="Write an initiating coverage report on AMD"
  [journal-mirror]="Read my trading journal back to me: win rate by emotion and what is dragging my trust score"
  [macro-read]="Read the US macro backdrop right now"
  [model-update]="Update the model for AAPL with the latest earnings"
  [mood-regime]="Read the market mood for NVDA"
  [morning-note]="Draft a morning note for the stocks I follow"
  [ownership-context]="Who owns TSLA and what have insiders been doing lately?"
  [reverse-dcf]="Run a reverse DCF on TSLA: what growth does the current price require?"
  [screener]="List the largest companies in the semiconductor industry"
  [sector-overview]="Create a sector overview for energy"
  [stock-tracker]="Show me my stock trackers"
  [thesis-tracker]="Start an investment thesis for MSFT and note what would prove it wrong"
  [trade-log]="Log a trade: bought 10 AAPL at 220, thesis was services growth, felt confident"
  [transcript-vs-numbers]="Put what NVDA management said on the last earnings call next to what the statements did"
  [unit-economics]="Analyze the unit economics of a SaaS company like Salesforce"
  [xlsx-author]="Create an Excel workbook with a simple DCF for AAPL"
)
MANUAL="audit-xls clean-data-xls"  # need an input spreadsheet fixture

printf "%-24s %-7s %-11s %-12s %-8s\n" SKILL FIRED CONNECTOR DISCLAIMER NO-WEB
for s in $(printf "%s\n" "${!P[@]}" | sort); do
  f="$OUT/$s.jsonl"
  claude -p "${P[$s]}" --output-format stream-json --verbose --dangerously-skip-permissions --max-turns 25 > "$f" 2>&1
  fired=$([ -s "$f" ] && echo YES || echo no)
  conn=$(grep -qE '"name":"mcp__' "$f" && echo YES || echo NO)
  disc=$(grep -qiE "not investment advice|educational content" "$f" && echo YES || echo NO)
  noweb=$(grep -qE '"name":"(WebSearch|WebFetch)"' "$f" && echo LEAK || echo ok)
  printf "%-24s %-7s %-11s %-12s %-8s\n" "$s" "$fired" "$conn" "$disc" "$noweb"
done
echo
echo "MANUAL (need a fixture spreadsheet, run by hand): $MANUAL"
echo "Raw jsonl per skill in $OUT/ — spot-check cited figures against tool_result events."
