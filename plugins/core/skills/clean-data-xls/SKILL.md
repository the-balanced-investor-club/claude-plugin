---
name: clean-data-xls
description: Clean up messy spreadsheet data — trim whitespace, fix inconsistent casing, convert numbers-stored-as-text, standardize dates, remove duplicates, and flag mixed-type columns. Use when data is messy, inconsistent, or needs prep before analysis. Triggers on "clean this data", "clean up this sheet", "normalize this data", "fix formatting", "dedupe", "standardize this column", "this data is messy".
---

# Clean Data

> **Output:** deliverables carry the blocks defined in `plugins/core/OUTPUT-BLOCK.md`.

## Perimeter

**This skill uses no market data and never web-searches.** It works only on the spreadsheet the user
brings to the session. Nothing here needs the connector, and nothing here should reach for it.

If the user asks a question that needs market data, say so and hand off — do not answer it from
memory.

Clean messy data in the active sheet or a specified range.

## Environment

- **If running inside Excel (Office Add-in / Office JS):** Use Office JS directly (`Excel.run(async (context) => {...})`). Read via `range.values`, write helper-column formulas via `range.formulas = [["=TRIM(A2)"]]`. The in-place vs helper-column decision still applies.
- **If operating on a standalone .xlsx file:** Use Python/openpyxl.

## Workflow

### Step 1: Scope

- If a range is given (e.g. `A1:F200`), use it
- Otherwise use the full used range of the active sheet
- Profile each column: detect its dominant type (text / number / date) and identify outliers

### Step 2: Detect issues

| Issue | What to look for |
|---|---|
| Whitespace | leading/trailing spaces, double spaces |
| Casing | inconsistent casing in categorical columns (`usa` / `USA` / `Usa`) |
| Number-as-text | numeric values stored as text; stray `$`, `,`, `%` in number cells |
| Dates | mixed formats in the same column (`3/8/26`, `2026-03-08`, `March 8 2026`) |
| Duplicates | exact-duplicate rows and near-duplicates (case/whitespace differences) |
| Blanks | empty cells in otherwise-populated columns |
| Mixed types | a column that's 98% numbers but has 3 text entries |
| Encoding | mojibake (`Ã©`, `â€™`), non-printing characters |
| Errors | `#REF!`, `#N/A`, `#VALUE!`, `#DIV/0!` |

### Step 3: Propose fixes

Show a summary table before changing anything:

| Column | Issue | Count | Proposed Fix |
|---|---|---|---|

### Step 4: Apply

- **Prefer formulas over hardcoded cleaned values** — where the cleaned output can be expressed as a formula (e.g. `=TRIM(A2)`, `=VALUE(SUBSTITUTE(B2,"$",""))`, `=UPPER(C2)`, `=DATEVALUE(D2)`), write the formula in an adjacent helper column rather than computing the result in Python and overwriting the original. This keeps the transformation transparent and auditable.
- Only overwrite in place with computed values when the user explicitly asks for it, or when no sensible formula equivalent exists (e.g. encoding/mojibake repair)
- For destructive operations (removing duplicates, filling blanks, overwriting originals), confirm with the user first
- After each category of fix (whitespace → casing → number conversion → dates → dedup), show the user a sample of what changed and get confirmation before moving to the next category
- Report a before/after summary of what changed

---

## What this skill does NOT do

- **It does not overwrite the original.** The cleaned output goes in a helper column, as a formula,
  where the transformation stays visible. A cleaning step you cannot see is a cleaning step you
  cannot audit — and the day the numbers look wrong, that column is the only way to find out why.
- **It does not guess what a value was meant to be.** An ambiguous date, a mixed-type column, a
  number that might be text — these get **flagged**, not silently coerced. Silent coercion is how a
  dataset quietly becomes fiction.
- **It does not delete rows it thinks are wrong.** It marks them. The user decides.
- **It does not interpret the data.** It cleans it. What the numbers mean is somebody else's job.

---

## Attribution and disclaimer

This skill is adapted from [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0) by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We don't make buy or sell recommendations under any circumstance. Your decisions are your own. Every output of this skill is a draft for review by a qualified professional.
