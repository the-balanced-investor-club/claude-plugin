---
name: earnings-preview
description: Build pre-earnings analysis with estimate models, scenario frameworks, and key metrics to watch. Use before a company reports quarterly earnings to prepare positioning notes, set up bull/bear scenarios, and identify what will move the stock. Triggers on "earnings preview", "what to watch for [company] earnings", "pre-earnings", "earnings setup", or "preview Q[X] for [company]".
---

# Earnings Preview

> **Output:** deliverables carry the blocks defined in `plugins/core/OUTPUT-BLOCK.md`. The connector
> already appends the disclaimer to every response — do not add a second one.

## Data source

| What | Tool |
|------|------|
| Consensus for the quarter | `get_earnings_estimates` |
| When they report | `get_market_calendar` |
| What they said last time | `get_earnings_transcript` |
| The trend the estimate sits on | `get_income_statement` |

**If the connector is not available in this session: STOP.** Do not fill the gap from memory and do
not web-search it. A number with no provenance looks exactly like a number with one, and that is
precisely what makes it dangerous. Tell the user: "I need The Balanced Investor Club connector for
this — it isn't connected in this session. Install the plugin (or reconnect it), start a new chat,
and ask again." A restart is often required right after installing.

**Do not use web search for market data. Ever.**

## Workflow

### Step 1: Gather Context

- Identify the company and reporting quarter
- Pull consensus estimates from the connector: `get_earnings_estimates`. **Never web search for market data.**
- Find the earnings date and time (pre-market vs. after-hours)
- Review the company's prior quarter earnings call for any guidance or commentary

### Step 2: Key Metrics Framework

Build a "what to watch" framework specific to the company:

**Financial Metrics:**
- Revenue vs. consensus (total and by segment)
- EPS vs. consensus
- Margins (gross, operating, net) — expanding or contracting?
- Free cash flow
- Forward guidance vs. consensus

**Operational Metrics** (sector-specific):
- Tech/SaaS: ARR, net retention, RPO, customer count
- Retail: Same-store sales, traffic, basket size
- Industrials: Backlog, book-to-bill, price vs. volume
- Financials: NIM, credit quality, loan growth, fee income
- Healthcare: Scripts, patient volumes, pipeline updates

### Step 3: Scenario Analysis

Build 3 scenarios with stock price implications:

| Scenario | Revenue | EPS | Key Driver | What it would prove |
|----------|---------|-----|------------|----------------|
| Bull | | | | |
| Base | | | | |
| Bear | | | | |

For each scenario:
- What would need to happen operationally
- What management commentary would signal this
- Historical context — how has the stock moved on similar prints?

### Step 4: Catalyst Checklist

Identify the 3-5 things that will determine the stock's reaction:

1. [Metric] vs. [consensus/whisper number] — why it matters
2. [Guidance item] — what the buy-side expects to hear
3. [Narrative shift] — any strategic changes, M&A, restructuring

### Step 5: Output

One-page earnings preview with:
- Company, quarter, earnings date
- Consensus estimates table
- Key metrics to watch (ranked by importance)
- Bull/base/bear scenario table
- Catalyst checklist
- Trading setup: recent stock performance, implied move from options

## Important Notes

- Consensus estimates change — always note the source and date of estimates
- "Whisper numbers" from buy-side surveys are often more relevant than published consensus
- Historical context comes from `get_close_history` around past report dates (`get_market_calendar`). **Never web search for it.** And note: how the price moved last time says nothing about how it will move this time.
- Options-implied move tells you what the market expects — compare to your scenarios

---

## What this skill does NOT do

- **It does not forecast the stock's reaction.** Not bull/base/bear on the price, not "the setup",
  not the options-implied move. How the market reacts to a print is not knowable and is not our
  business.
- **It does not source whisper numbers.** Unpublished expectations from buy-side surveys are not
  data; they are gossip with a spreadsheet, and chasing them is the opposite of what this product is.
- **It does not tell anyone what to do before a print.** A preview says what to watch and why it would
  matter. It never says to act.
- **It does not treat the last reaction as a guide to the next one.** How the price moved after the
  previous quarter says nothing about this one, and implying otherwise is the most common way a
  preview becomes a trade idea.

---

## Attribution and disclaimer

This skill is adapted from [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0) by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We don't make buy or sell recommendations under any circumstance. Your decisions are your own. Every output of this skill is a draft for review by a qualified professional.
