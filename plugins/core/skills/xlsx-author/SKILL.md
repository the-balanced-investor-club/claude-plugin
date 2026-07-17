---
name: xlsx-author
description: Produce a .xlsx file on disk — a workbook the user can open, poke at and change, with every input on its own tab and a Checks tab that goes red when something breaks. Triggers on "build me a workbook", "export to Excel", "give me the model as a file", "make a spreadsheet", "xlsx".
---

# xlsx-author

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Perimeter

**This skill uses no market data and never web-searches.** It works only on the spreadsheet the user
brings to the session. Nothing here needs the connector, and nothing here should reach for it.

If the user asks a question that needs market data, say so and hand off — do not answer it from
memory.

Use this skill to deliver an Excel workbook as a **file the user can open, change and re-run**. Every input on its own tab, every calc a formula, and a Checks tab that goes red when something breaks.

## Output contract

- Write to `./out/<name>.xlsx`. Create `./out/` if it does not exist.
- Return the relative path in your final message so the orchestration layer can collect it.

## How to build the workbook

Write a short Python script and run it with Bash. Use `openpyxl`:

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill

wb = Workbook()
ws = wb.active; ws.title = "Inputs"
ws["B2"] = "Revenue"; ws["C2"] = 1_250_000_000
ws["C2"].font = Font(color="0000FF")           # blue = hardcoded input
calc = wb.create_sheet("DCF")
calc["C5"] = "=Inputs!C2*(1+Inputs!C3)"        # black = formula
wb.save("./out/model.xlsx")
```

## Conventions (mirror `audit-xls`)

- **Blue / black / green.** Blue = hardcoded input, black = formula, green = link to another sheet/file.
- **No hardcodes in calc cells.** Every calculation cell is a formula; every input lives on an Inputs tab.
- **Named ranges** for any value referenced from a deck or memo.
- **Balance checks.** Include a Checks tab that ties (BS balances, CF ties to cash, etc.) and surfaces TRUE/FALSE.
- **One model per file.** Do not append to an existing workbook unless explicitly asked.

## When NOT to use

If the user is working inside a live Excel session and the client exposes tools to drive it, use those instead — editing the open workbook with review checkpoints beats handing over a new file. This skill is the file-producing path, and it is the only one this plugin's connector supports.

---

## What this skill does NOT do

- **It does not decide what goes in the workbook.** It builds the file the analysis asked for. The
  analysis lives in the skill that called it.
- **It does not send, share or upload anything.** It writes a file to disk. Distribution is a human
  action, taken outside this skill.
- **It does not hardcode a calculated value into a formula cell.** Every calc cell is a formula, and
  every input lives on the Inputs tab. A workbook whose numbers cannot be traced is a screenshot with
  extra steps.
- **It does not ship without a Checks tab.** If nothing in the workbook can come back FALSE, nothing
  in it is being checked.

---

## Attribution and disclaimer

This skill is adapted from [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0) by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We don't make buy or sell recommendations under any circumstance. Your decisions are your own. Every output of this skill is a draft for review by a qualified professional.
