---
name: dcf-model
description: Build a discounted cash-flow model as a working Excel file — projections, WACC, terminal value, and a two-way sensitivity grid, every cell a formula the reader can change. It builds the engine; it does not deliver a verdict. For the interpretation — what the current price already assumes — use reverse-dcf. Triggers on "build a DCF", "DCF model", "value this company", "discounted cash flow", "intrinsic value", "build me the model", "WACC", "terminal value".
---

# DCF Model Builder

> **Branding:** Deliverables follow the club brand. Palette, font, and logo placement are defined in
> `plugins/core/BRANDING.md`; the logo lockup is `plugins/core/assets/logo.png`. When the user
> supplies their own template, the template wins.
>
> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

| What | Tool |
|------|------|
| **Most DCF inputs in one call** — price, shares, beta, **net** debt, trailing FCF, 4-year FCF history and CAGR, revenue growth, risk-free rate | **`get_valuation_inputs`** |
| **Gross debt and cash — the WACC cannot be weighted without them** | **`get_balance_sheet`** |
| The rest of the statements | `get_income_statement`, `get_cash_flow` |
| Peer multiples, for the exit-multiple cross-check | `comps-analysis`, `get_fundamentals` |
| The price series | `get_close_history` |
| Resolve a company name to a symbol | `search_instruments` |

`get_valuation_inputs` replaces five separate lookups. Start there — **and then call
`get_balance_sheet` anyway**, because `get_valuation_inputs` returns *net* debt and the WACC needs
*gross*. They are different numbers and one cannot be derived from the other.

**The two tools also disagree.** For NVDA, `get_valuation_inputs` reported net debt of −\$423M while
the balance sheet implied −\$3.14B, and the share counts differed by 1.2%. **Reconcile them, show both,
and say which you used.** Never average them.

**If the connector is not available in this session: STOP.** Do not build a DCF from a price, a beta
or a cash-flow figure you recall. Every one of them will be wrong, and the model will look exactly as
authoritative as a correct one. Tell the user: "I need The Balanced Investor Club connector for the
valuation inputs — it isn't connected in this session. Install the plugin (or reconnect it), start a
new chat, and try again."

**Do not use web search for market data. Ever.**

---

## What this skill is for

**It builds the engine. It does not decide anything.**

The output is a workbook the reader can open, change one assumption in, and watch the answer move by
forty percent. **That movement is the lesson** — it is the model telling them, honestly, how much
confidence the number deserves.

For the *interpretation* — what growth the current price already requires, and whether the company has
ever delivered it — use **`reverse-dcf`**. That is where the reading happens. This skill hands it the
machine.

---

## The three rules that decide whether the model is worth anything

### 1. Formulas, never hardcodes

Every derived cell is a **formula**. Every input lives on the Inputs tab, in blue. If the reader
cannot change an assumption and see the whole model move, they have been handed a screenshot, and a
screenshot teaches nothing.

### 2. The WACC weights, and the bug that hides in them

```
Cost of equity  =  risk-free  +  beta × equity risk premium     (ERP ≈ 5–6%)
WACC            =  (E/(D+E)) × cost of equity  +  (D/(D+E)) × after-tax cost of debt
```

⚠️ **Weight on gross debt over total capital (D + E). Not net debt over enterprise value.**

That error produces a **negative debt weight** for any company holding net cash — which is most of
quality technology — and it silently corrupts the WACC. **If your debt weight comes out below zero,
the formula is wrong. It is not a special case.**

### 3. The sensitivity grid is the deliverable

Not the point estimate. The grid.

- **Odd dimensions**, so the base case sits in the centre.
- **The centre cell must equal the model's own output.** If it does not, the table is not wired to
  the model, and every number in it is decorative. This check is the single most useful line in the
  workbook.
- WACC × terminal growth, five by five, minimum.

**Sanity checks that must pass:** terminal growth **below** WACC · terminal value between 40% and 70%
of enterprise value · WACC in a defensible band (8–14% for most listed companies) · opex driven off
revenue, never off gross profit.

---

## Let the peers inform the assumptions — then check the model against them

A DCF built in isolation will justify whatever it was set up to justify. **The peer set is the only
external check the model has**, and using it twice — once going in, once coming out — is what keeps
the exercise honest.

### Going in: what the comps tell the DCF

Run `comps-analysis` first. Then:

| From the peer set | Feeds into the DCF |
|-------------------|--------------------|
| Median EV/EBITDA | The terminal exit multiple |
| 25th–75th percentile EV/EBITDA | The **range** for the sensitivity grid |
| Median revenue growth | A benchmark for the projection — not a target |
| Median EBITDA margin | A benchmark for the terminal margin |
| Median P/E | A cross-check on what the model implies |

**These are benchmarks, not answers.** A company growing at twice the peer median may well deserve
to. The point is to know that you are assuming it, on purpose, and to say so.

### Coming out: what the DCF has to answer for

Once the model is built, check it against the same peers:

1. **The EV/EBITDA the model implies, against the peer median.** If the DCF implies 25× and the peers
   trade at 12×, **something has to explain that** — and "our model says so" is not an explanation.
   Find it, or fix the assumptions.
2. **The P/E the model implies, against the peer median.**
3. **Terminal value as a share of enterprise value.** Outside 40–70%, the model is not valuing a
   business — it is valuing a guess about the year 2036.
4. **The growth the model has embedded, against what the peers actually grow at.**

**When the model and the peers disagree, that disagreement goes in the output.** It is the most
informative thing the exercise produces, and burying it is how a DCF becomes an argument instead of
an analysis.

---

## The method, in detail

**See [references/dcf-method.md](references/dcf-method.md)** — the full workflow: projections, WACC
construction, terminal value both ways, the EV→equity bridge, scenario blocks, and the sensitivity
tables.

**See [references/excel-construction.md](references/excel-construction.md)** — the Excel build: sheet
structure, formula patterns, the case selector, number formats, and the cell-comment convention that
makes every input traceable.

**See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)** — when the model will not balance or the case
selector misbehaves.

---

## Verify the workbook before you deliver it

The repo ships **`scripts/validate_dcf.py`**, which opens the generated `.xlsx` and checks it: no
`#REF!` / `#DIV/0!`, terminal growth below WACC, WACC inside 5–20%, terminal value 40–80% of EV. It
exits non-zero when it fails.

```bash
python skills/dcf-model/scripts/validate_dcf.py <model.xlsx>
```

**Run it. Do not eyeball these checks in prose** — that is what the script is for, and a check a human
performs by reading is a check that will be skipped the day it matters.

---

## Output checklist

- [ ] **Both** `get_valuation_inputs` **and** `get_balance_sheet` pulled — the WACC needs gross debt
- [ ] Net debt and share count **reconciled** between the two tools; the gap shown, never averaged
- [ ] Zero figures from memory, zero from the web
- [ ] Every derived cell is a **formula**; every input is on the Inputs tab
- [ ] WACC weighted on **gross debt over total capital** (from the balance sheet). A negative debt weight is a bug
- [ ] Terminal growth **below** WACC; terminal value 40–70% of EV
- [ ] Sensitivity grid present, odd-dimensioned, and its **centre cell equals the model's output**
- [ ] `validate_dcf.py` run, and it passed
- [ ] The output is presented as a **range** with its drivers — never a fair value, never a target
- [ ] Framing block and disclaimer, per `../../OUTPUT-BLOCK.md`

## What this skill does NOT do

- **It does not produce a fair value.** Not a point, not a midpoint, not an "implied price". A single
  number printed beside the current price is a recommendation with a model bolted on, whatever the
  cell is labelled. The deliverable is the range, its sensitivity, and what would break it.
- **It does not say whether the assumptions are reasonable.** It shows what they produce, and how
  hard the answer moves when they change. Judging them is the reader's job, and they can only do it
  if the model lets them try.
- **It does not average away a disagreement.** When trailing free cash flow is double the last full
  year — and for real companies it sometimes is — taking the mean produces a number describing no
  world that exists. Model both. Show both.
- **It does not hide behind precision.** \$84.19 is not more truthful than "somewhere in the low
  eighties". Decimals in a DCF are a costume.
- **It does not work on ETFs or crypto.** Discounting the free cash flow of a coin is a category
  error.

---

## Attribution and disclaimer

This skill is adapted from [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0) by The Balanced Investor Club. This file modifies the original.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We don't make buy or sell recommendations under any circumstance. Your decisions are your own.
