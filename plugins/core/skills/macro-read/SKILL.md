---
name: macro-read
description: >-
  Read the US macro backdrop — rates, jobs, growth, energy, metals and commodities — as context behind the market, never as a signal about any one company. Handles the traps: indicators arrive on different dates, and some are levels or index points rather than rates. Triggers on "macro", "the economy", "interest rates", "inflation", "unemployment", "what's the backdrop", "oil price", "gold price", "commodities", "what's happening in the economy".
---

# Macro Read

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

| What | Tool |
|------|------|
| All 22 indicators, latest reading + change from prior | `get_macro_indicators` |
| History for specific indicators (up to 60 readings) | `get_macro_indicators` with `include_keys` |

**If the connector is not available in this session: STOP.** Do not recall a Fed funds rate from
memory, and do not web-search one. A macro number a model half-remembers is a number that will be
wrong by a quarter and stated with total confidence. Tell the user: "I need The Balanced Investor
Club connector for the macro data — it isn't connected in this session. Install the plugin (or
reconnect it), start a new chat, and try again."

**Do not use web search for market data. Ever.**

---

## The two traps, and they will both catch you

### Trap 1: the indicators do not share a date

Every row carries its own `As of`. They are **not** a single snapshot.

A real pull showed gold as of `2026-07-12`, treasuries as of `2026-06-01`, and CPI as of
`2026-05-01`. That is a **two-month spread** inside one table. Metals update daily; CPI updates
monthly and with a lag; GDP is quarterly.

**Never say "as of today" over the whole set.** When you compare two indicators — "real rates are
rising while inflation cools" — **check that they are from the same period first**, or you are
comparing June to May and calling it a trend.

State the vintage of anything you lean on.

### Trap 2: some of these are not rates

Read the units before you read the number:

| Kind | Examples | What the `Change` column means |
|------|----------|-------------------------------|
| **Rate (%)** | `fedfunds`, `treasury2y/10y/30y`, `unemployment` | Percentage points. A `+0.11` is 11bp |
| **Index level** | `cpi` (335.12) | **Index points, not percent.** A `+2.10` is **not** 2.1% inflation |
| **Level** | `realgdp`, `payrolls`, `retail`, `durables` | Absolute units (billions, thousands of jobs) |
| **Price** | `wti`, `brent`, `gold`, `silver`, `copper`, `wheat`… | Currency per unit |

**CPI is the one that will burn you.** It is an index. To get inflation you need the year-over-year
change, which means pulling history: `include_keys: ["cpi"]` with `history: 13` and computing it.
**Never present the raw change in the CPI index as an inflation rate.** It is a different number by
an order of magnitude, and reporting it as inflation is the kind of error that destroys a user's
trust in everything else on the page.

---

## How to read it

**Lead with what actually moved.** Twenty-two rows is not a briefing; it is a wall. Pick the two or
three whose change is large relative to their own history, and say why they matter.

**Percent, not points, for anything a person thinks about in percent.** WTI going from 102.13 to
84.81 is a **17% fall**, and that is the sentence. "−17.32" is the raw field, and it means nothing to
a reader.

**Say what an indicator is context for — and what it is not.** Rates set the discount rate in every
valuation, so they belong in a conversation about what a company is worth. They say nothing about
whether that company is a good business. Keep the two apart.

---

## Output checklist

- [ ] The **`As of` date** is stated for anything leaned on
- [ ] No two indicators from **different periods** compared as though they were simultaneous
- [ ] CPI never reported as an inflation rate without a year-over-year computation from history
- [ ] Changes in **percent** where a person thinks in percent
- [ ] Two or three indicators surfaced, not a wall of twenty-two
- [ ] **No link drawn from a macro reading to any individual company's prospects**

## What this skill does NOT do

- **It does not turn macro into a trade.** "Rates are falling, so buy X" is a recommendation with an
  economics lecture in front of it. The macro is context; it is not a signal about any one company,
  and the tool's own description says exactly that.
- **It does not forecast.** Nothing here predicts the next Fed decision, the next CPI print, or the
  next move in oil. These are readings of what has already been measured.
- **It does not read CPI as inflation.** The index and the rate are different numbers, and the tool
  returns the index.
- **It does not present staggered vintages as a single moment.** Gold from Friday and CPI from six
  weeks ago are not "the current picture".
- **It does not explain a company's stock move with a macro number.** A causal story linking one
  indicator to one company is almost always invented after the fact, and it teaches the user to see
  causation where there is only a chart with two lines on it.

---

## Attribution and disclaimer

Original work by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We
don't make buy or sell recommendations under any circumstance. Your decisions are your own.
