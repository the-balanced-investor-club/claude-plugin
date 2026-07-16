---
name: model-update
description: Update financial models with new data — quarterly earnings, management guidance, macro changes, or revised assumptions. Adjusts estimates, recalculates valuation, and flags material changes. Use after earnings, guidance updates, or when assumptions need refreshing. Triggers on "update model", "plug earnings", "refresh estimates", "update numbers for [company]", "new guidance", or "revise estimates".
---

# Model Update

> **Output:** deliverables carry the blocks defined in `plugins/core/OUTPUT-BLOCK.md`. The connector
> already appends the disclaimer to every response — do not add a second one.

## Data source

| What | Tool |
|------|------|
| The quarter that just landed | `get_income_statement`, `get_balance_sheet`, `get_cash_flow` |
| What was expected of it | `get_earnings_estimates` |
| What management said about the next one | `get_earnings_transcript` |
| The valuation inputs, in one call | `get_valuation_inputs` |
| The thesis the reader wrote at entry | `list_my_trades` |

**If the connector is not available in this session: STOP.** Do not fill the gap from memory and do
not web-search it. A number with no provenance looks exactly like a number with one, and that is
precisely what makes it dangerous. Tell the user: "I need The Balanced Investor Club connector for
this — it isn't connected in this session. Install the plugin (or reconnect it), start a new chat,
and ask again." A restart is often required right after installing.

**Do not use web search for market data. Ever.**

## Workflow

### Step 1: Identify What Changed

Determine the update trigger:
- **Earnings release**: New quarterly actuals to plug in
- **Guidance change**: Company updated forward outlook
- **Estimate revision**: Analyst changing assumptions based on new data
- **Macro update**: Interest rates, FX, commodity prices changed
- **Event-driven**: M&A, restructuring, new product, management change

### Step 2: Plug New Data

#### After Earnings
Update the model with reported actuals:

| Line Item | Prior Estimate | Actual | Delta | Notes |
|-----------|---------------|--------|-------|-------|
| Revenue | | | | |
| Gross Margin | | | | |
| Operating Expenses | | | | |
| EBITDA | | | | |
| EPS | | | | |
| [Key metric 1] | | | | |
| [Key metric 2] | | | | |

**Segment Detail** (if applicable):
- Update each segment's revenue and margin
- Note any segment mix shifts

**Balance Sheet / Cash Flow Updates**:
- Cash and debt balances
- Share count (buybacks, dilution)
- Capex actual vs. estimate
- Working capital changes

### Step 3: Revise Forward Estimates

Based on the new data, adjust forward estimates:

| | Old FY Est | New FY Est | Change | Old Next FY | New Next FY | Change |
|---|-----------|-----------|--------|------------|------------|--------|
| Revenue | | | | | | |
| EBITDA | | | | | | |
| EPS | | | | | | |

**Key Assumption Changes:**
- What assumptions are you changing and why?
- Revenue growth rate: old → new (reason)
- Margin assumption: old → new (reason)
- Any new items (restructuring charges, one-time gains, etc.)

### Step 4: Valuation Impact

Recalculate valuation with updated estimates:

| Valuation Method | Prior | Updated | Change |
|-----------------|-------|---------|--------|
| DCF implied value (range) | | | |
| P/E (NTM EPS × peer multiple) | | | |
| EV/EBITDA (NTM EBITDA × peer multiple) | | | |
| **Implied value range** | | | |

Each method gives a **range**, not a figure. Show the range. Do not average them into a single
number, and do not label any number a target.

### Step 5: What Changed in the Read

**Estimate Change Summary:**
- One paragraph: what changed, why, and **which pillar of the thesis it informs**
- Is this a thesis-changing event, or noise inside a normal quarter's variance?

**The three things that replace a verdict:**
- **The range**: where the implied value sits now, and where the current price sits relative to it
- **The sensitivity**: which assumption moves that range most, and by how much
- **The falsifier**: what specific, checkable condition would prove this read wrong

**No rating. No price target. No buy/sell/hold call** — and `BULLISH` / `BEARISH` are not an escape
hatch. This step does not tell the reader what to do. It tells them what they now know, and what
would change it.

### Step 6: Output

- Updated Excel model (if user provides the existing model)
- Estimate change summary (markdown or Word)
- Implied value range with its sensitivity, and the falsifier
- Framing block and disclaimer, per `plugins/core/OUTPUT-BLOCK.md`

## Important Notes

- Always reconcile your estimates to the company's reported figures before projecting forward
- Note any non-recurring items and whether your estimates are GAAP or adjusted
- Track your estimate revision history — it shows your analytical progression
- If the quarter was noisy, separate signal from noise in your estimate changes
- Check consensus after updating — how do your revised estimates compare to the Street?
- Share count matters — dilution from stock comp, converts, or buybacks can materially affect EPS

---

## What this skill does NOT do

- **It does not issue an action.** No maintain, no add, no trim. The model updates; the reader
  decides. The step where an analyst would write "our recommendation" is the step this skill deletes.
- **It does not rate conviction.** Show which pillar moved and by how much. That carries the same
  information with the evidence still attached to it.
- **It does not project forward from a single quarter.** One print is one data point, and a model
  rebuilt around it every ninety days is a model that is chasing noise.
- **It does not reconcile silently.** If the reported figures do not tie to the model's prior
  actuals, **stop and say so.** A model that has been quietly re-based to fit the new numbers has
  forgotten what it used to believe, which was the only useful thing about it.

---

## Attribution and disclaimer

This skill is adapted from [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0) by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We don't make buy or sell recommendations under any circumstance. Your decisions are your own. Every output of this skill is a draft for review by a qualified professional.
