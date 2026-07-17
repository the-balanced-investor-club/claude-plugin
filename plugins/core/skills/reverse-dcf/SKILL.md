---
name: reverse-dcf
description: Turn a valuation on its head. Instead of asking what a company is worth, ask what growth and margin the price it trades at TODAY already requires — then let the reader judge whether that is believable. Uses the connector's pre-computed DCF inputs in a single call. Produces a range and a falsifier, never a target price and never a verdict. Triggers on "is it expensive", "what's priced in", "reverse DCF", "what does the market assume", "what would justify this price", "valuation", "DCF", "is this cheap".
---

# Reverse DCF

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

| What | Tool |
|------|------|
| **Most DCF inputs in one call** — price, shares, beta, **net** debt, trailing FCF, 4-year FCF history and CAGR, revenue growth, risk-free rate | `get_valuation_inputs` |
| **Gross debt and cash — you cannot weight the WACC without these** | **`get_balance_sheet`** |
| Cash-flow detail, when the FCF figures need reconciling | `get_cash_flow` |
| Peer multiples, for the sanity check | `comps-analysis`, `get_fundamentals` |
| Resolve a company name to a symbol | `search_instruments` |

⚠️ **`get_valuation_inputs` returns NET debt. The WACC needs GROSS debt.** They are not the same
number and one cannot be derived from the other. **Call `get_balance_sheet` too, every time.** The
rule this skill is proudest of — *weight on gross debt over total capital* — is unexecutable without
it, and a skill that states a rule it cannot follow is worse than one that never mentioned it.

`get_valuation_inputs` is **stocks only** — a DCF is not meaningful for an ETF or a coin. Say so and
stop if asked for one.

**If the connector is not available in this session: STOP.** Do not build a DCF from a price, a beta
or a cash-flow figure you recall. Every one of those will be wrong, and the model will look exactly
as authoritative as a correct one. Tell the user: "I need The Balanced Investor Club connector for
the valuation inputs — it isn't connected in this session. Install the plugin (or reconnect it),
start a new chat, and try again."

**Do not use web search for market data. Ever.**

---

## Why the DCF runs backwards here

A forward DCF asks *"what is this worth?"* and answers with a number. That number sits next to the
current price, and the reader draws the obvious conclusion. **We never issue a price target — and a
fair value printed beside the market price is one, whatever it is called.**

A **reverse DCF** asks the better question:

> **What growth, and what margin, does the price it already trades at require?**

Then it stops, and hands the reader the only judgement that was ever theirs to make: *do you believe
that?*

This is not a compliance workaround. It is a **better analysis**, and every good analyst eventually
gets here on their own:

- It cannot be gamed. In a forward DCF the assumptions are chosen to reach a number the analyst
  already had in mind. In a reverse DCF the market supplies the answer and the assumptions fall out.
- It is falsifiable. "The price requires 12% growth for a decade" is a claim you can check against
  what the company has actually done.
- It teaches the thing that matters: **a valuation is an opinion with decimals.**

---

## Step 0: Reconcile. Our own tools disagree with each other.

Before a single formula: **pull both `get_valuation_inputs` and `get_balance_sheet`, and check them
against each other.**

A real pull for NVDA:

| | `get_valuation_inputs` | `get_balance_sheet` |
|---|---|---|
| Net debt | −\$423M | LT debt \$7.47B − cash \$10.61B = **−\$3.14B** |
| Shares outstanding | 24.221B | **24.51B** |

Those are different numbers for the same two things. For NVDA the gap is immaterial — 0.05% of a
\$4.9tn enterprise value — and it would be easy to shrug at. **On a leveraged company it decides the
answer.**

**The rule, and it holds for every skill in this plugin:**

> **When two tools give different figures for the same thing, show both, say which one you used, and
> say why. Never average them. Never pick one silently.**

A tool that shows the reader where it disagrees with itself earns a kind of trust that no promise
buys. And this — *do I believe these numbers?* — is the product, applied to our own data, in front of
the person using it.

## Step 1: Pull the inputs, then distrust them

One call to `get_valuation_inputs` returns everything. **The trap is that the FCF figures often
disagree with each other, and the disagreement is the finding.**

A real pull for KO showed:

```
FCF (TTM)               \$12.562B
FCF, last full year      \$5.296B     ← less than half the TTM figure
FCF CAGR (~4y)            -17.18%    ← falling
Revenue growth (YoY)      +12.10%    ← rising
```

Trailing twelve months is **more than double** the last full fiscal year. Revenue is growing while
free cash flow is shrinking. **Both of those need explaining before a single formula is written.**

**Never just take the TTM number and run.** Look at the annual series the tool gives you. If the last
year is an outlier, say so and show what happens under each choice. A model whose answer swings by a
factor of two depending on which FCF you pick is a model whose answer must be presented as a range.

## Step 2: Build the cost of capital from the inputs given

```
Cost of equity  =  risk-free  +  beta × equity risk premium     (ERP ≈ 5–6%)
WACC            =  (E/(D+E)) × cost of equity  +  (D/(D+E)) × after-tax cost of debt
```

⚠️ **Weight on gross debt over total capital (D + E). Not net debt over enterprise value.** That
error produces a *negative* debt weight for any company holding net cash, and it silently corrupts
the WACC for most of quality technology. If your debt weight comes out below zero, the formula is
wrong — it is not a special case.

**A low beta is not a low risk.** KO's beta of 0.35 gives a cost of equity near 6%, which makes
almost any price look justifiable. Say that out loud: at a 6% discount rate, the model is barely
discounting, and the output is enormously sensitive to the terminal assumption.

## Step 3: Solve for what the price requires — with BOTH models. Always.

Enterprise value is what the market is paying: `market cap + net debt`. Hold it fixed, and solve
backwards for the growth rate that makes the model return exactly that.

### ⚠️ The model choice decides the answer. So run both, and show both.

This is the single most important instruction in this skill, and it exists because getting it wrong
produces a confident, well-formatted, opposite conclusion.

A real reverse DCF on NVDA — same price, same free cash flow, same WACC:

| Model | What the price requires | How it reads |
|-------|------------------------|--------------|
| **Single-stage perpetuity** | **13.9% FCF growth, forever** | Five times world GDP, in perpetuity. Arithmetically impossible → *screams overvalued* |
| **Two-stage** (10 years, then fade to 2.5%) | **~30% for a decade**, then GDP | A **deceleration** from the 86% it has managed for four years → *says almost nothing* |

**Same data. Opposite readings.** A skill that leaves this open will hand the reader whichever answer
the model happened to reach for that day, and the reader will have no way to know a choice was made
at all.

**So: run both. Print both. Side by side, with what the company has actually delivered underneath.**

```
Single-stage perpetuity:   the price requires 13.9% FCF growth, forever
Two-stage (10y + fade):    the price requires ~30% for a decade, then 2.5%
The company has delivered: 86% a year, for four years
```

**Hard rule: when recent growth exceeds ~25%, the single-stage perpetuity may never stand alone.** It
is mathematically valid and economically mute — a perpetuity assumes the growth rate is the one the
company will hold *for the rest of time*, and for a hyper-growth business that assumption is not an
approximation, it is a category error.

**And say out loud that the choice was made.** *"Which of these two you find more believable is the
whole question, and it is yours."* That sentence teaches more than either number.

### Also run it on more than one cash-flow figure

Do it on **trailing** free cash flow, and again on the **last full year** or the four-year average.
When those disagree — and for real companies they often do, sometimes by 2× — the spread is part of
the answer, not noise to be averaged out.

Then put the answer where a reader can judge it:

| The price requires | The company has actually delivered |
|--------------------|-----------------------------------|
| X% FCF growth, forever | −17% per year, over four years |
| Y% terminal margin | What it earned last year |

**When the implied growth exceeds long-run GDP (~2–3%), say so plainly.** Nothing grows faster than
the economy forever; a model that assumes it will is a model that has assumed the conclusion.

## Step 4: Sensitivity, and the falsifier

Give the **grid**, not the point: WACC × terminal growth, five by five. The spread across that grid
*is* the answer. A DCF that moves 40% on a one-point change in WACC is telling the reader precisely
how much confidence the number deserves — which is the most honest thing it will say all day.

Close with **the falsifier**, and make it checkable:

> *"The current price needs free cash flow to compound at 6% from here. It has fallen 17% a year for
> four. Either the last four years were the anomaly, or the price is. **The next two cash-flow
> statements will tell you which** — watch the FY26 figure against the \$5.3bn the company managed
> last year."*

That is a testable claim, with a date and a number the reader can go and check. It is not a
recommendation, and it is worth more than one.

---

## Output checklist

- [ ] FCF figures **reconciled** — TTM vs last full year vs the multi-year series, with the gap explained
- [ ] WACC weights on **gross debt over total capital**, never net debt over EV
- [ ] A **negative debt weight** treated as a bug, never as a special case
- [ ] The implied growth rate compared against **what the company has actually delivered**
- [ ] Implied growth above long-run GDP flagged as such
- [ ] A **sensitivity grid**, not a point estimate
- [ ] A **falsifier** with a date and a number the reader can go and check
- [ ] **No fair value. No price target. No "implied upside". No verdict.**

## What this skill does NOT do

- **It does not produce a fair value.** Not a point, not a "midpoint of the range", not an "implied
  price". The output is what the market is assuming, and the sensitivity around it. A single number
  next to the current price is a recommendation with a model bolted on, whatever it is labelled.
- **It does not say whether the assumptions are reasonable.** It shows what the price requires and
  what the company has done. The comparison is the reader's to draw, and it is far more powerful when
  they draw it themselves.
- **It does not average away a disagreement.** When trailing and annual free cash flow differ by 2×,
  taking the mean produces a number describing no world that exists. Show both. **This applies to our
  own tools too**: when `get_valuation_inputs` and the balance sheet report different net debt, both
  numbers go in the output.
- **It does not pick a model quietly.** The choice between a perpetuity and a two-stage fade changes
  the answer more than any assumption inside either of them. Run both, print both, and say that the
  choice was made — because a reader who does not know a choice existed cannot evaluate it.
- **It does not hide behind precision.** \$84.19 is not more truthful than "somewhere in the low
  eighties". Decimals in a DCF are a costume.
- **It does not work on ETFs or crypto.** The tool is stocks-only, and discounting the free cash flow
  of a coin is a category error.

---

## Attribution and disclaimer

Original work by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We
don't make buy or sell recommendations under any circumstance. Your decisions are your own.
