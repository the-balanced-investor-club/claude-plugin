---
name: screener
description: Map and filter the coverage universe — list every company in a sector or industry, sort by size, compare a handful side by side, and see the distribution the headline average hides. Teaches what a screen actually selects for and what it systematically misses. It narrows a universe down to something a person can study; it never produces a list of what to buy. Triggers on "screen for", "what's in the Technology sector", "show me the semiconductor companies", "find companies", "compare these tickers", "who are the peers", "how did the sector do", "build a peer set".
---

# Screener

> **Output:** deliverables carry the blocks defined in `plugins/core/OUTPUT-BLOCK.md`. The connector
> already appends the disclaimer to every response — do not add a second one.

## Data source

| What | Tool |
|------|------|
| Every company in a sector or industry, optionally by market cap | `list_securities_by` |
| Side-by-side returns and volatility for 2–5 tickers | `compare_tickers` |
| The sector's average return — **weighted and simple** | `get_sector_returns` |
| The same, for one industry | `get_industry_returns` |
| Valuation and size metrics per company | `get_fundamentals` |
| The behavioural distribution across the same set | `list_market_moods` |
| Resolve a company name to a symbol | `search_instruments` |

**If the connector is not available in this session: STOP.** Do not screen from memory, and do not
web-search a list of companies. A screen built from a model's recollection of who is in an industry
is not a screen — it is a guess with a table around it. Tell the user: "I need The Balanced Investor
Club connector to screen the universe — it isn't connected in this session. Install the plugin (or
reconnect it), start a new chat, and try again."

**Do not use web search for market data. Ever.**

---

## Purpose

This is the mirror of the Explore page: **a way to map a universe before drilling into it.**

The deliverable is a **filtered universe with its distribution** — not a ranked shortlist, and never
a list of what to act on. The user leaves knowing what the screen selected for, what it excluded, and
why the answer would change if they moved one criterion.

**A screen is a question, not an answer.** The skill's job is to make the question a good one.

---

## Step 1: Always pull the distribution, not just the average

This is the single most important thing this skill does, and it takes one extra call.

`get_sector_returns` returns **two** numbers: a market-cap-**weighted** average and a **simple**
average. **Report both, always, and lead with the gap between them.**

A real example from the Technology sector over one year:

```
Weighted average return:   +13.72%
Simple average return:      -8.46%
Tickers analyzed:              891
```

Those are twenty-two points apart. The weighted number says technology had a good year. The simple
number says **the average technology company lost money** — and that the entire sector return was
carried by a handful of giants at the top.

"Tech was up 14%" is what a headline says. "The median tech company was down 8%" is what happened.
**A user who only ever sees the weighted number will systematically misunderstand every sector they
look at**, and will conclude that things are working when they are not.

When the two numbers diverge sharply, **say what the divergence means**: the index is a few names,
and the typical company in it is having a different experience.

## Step 2: Map the universe

`list_securities_by` takes `field` (`sector` | `industry`) and `value`. Set `sort: "market_cap"` to
get the size column and order — that is how you build a peer set for a comps analysis, and it is how
you show the user that "Semiconductors" spans a $5.1T company and a sub-billion one in the same list.

Report the **total count**, not just the rows you show. "70 companies in Semiconductors, here are the
six largest" is honest. Showing six and saying nothing about the other sixty-four is not.

⚠️ Market caps come from the fundamentals cache; rarely-viewed small names may show `—`. Say so
rather than silently dropping them, because the dropped ones are exactly the ones a size-sorted
screen is biased against.

## Step 3: Teach what the screen misses

Every screen has a blind spot, and naming it is the lesson.

- **A low-P/E screen** selects for cyclical companies at peak earnings, where the "E" is about to
  fall. It systematically excludes quality compounders, which always look expensive — and always
  have.
- **A high-growth screen** selects for companies whose growth is already priced in, and for the ones
  whose base is small enough to make any number look large.
- **A market-cap sort** buries the entire small-cap universe below the fold, which is where the
  dispersion lives.

**Say the blind spot out loud.** A user who leaves knowing what their filter cannot see has learned
something durable. A user who leaves with a list has learned nothing.

## Step 4: Compare, with the distribution behind it

`compare_tickers` takes 2–5 tickers and returns date-aligned log-returns, volatility, total return,
max and min, over a chosen period (default `1Y`).

Two things to say every time:
- **Volatility is not risk, and return is not skill.** A name that returned more with twice the
  volatility did not necessarily do better; it did differently.
- **Five tickers is a sample of five.** Put the comparison against the sector distribution from Step
  1, or it will read as though those five were the universe.

Pair it with `list_market_moods` on the same sector for the behavioural distribution — the same
universe, seen through a second lens.

---

## Output checklist

- [ ] **Both** the weighted and the simple average reported, with the gap explained
- [ ] The **total** count of the universe stated, not just the rows shown
- [ ] The screen's **blind spot** named explicitly
- [ ] Missing market caps disclosed, not silently dropped
- [ ] Comparisons placed against the distribution, never presented as the universe
- [ ] **No ranking of what to research first. No labels. No shortlist.**

## What this skill does NOT do

- **It does not produce a list of what to buy.** Not directly, not as a "shortlist", not as "names to
  look at first", and not by ranking. A filtered universe is a filtered universe. The moment it is
  ordered by attractiveness it becomes a recommendation, whatever the column header says.
- **It does not label companies Long or Short.** There is no direction column, no conviction score,
  no rating. Those are verdicts, and we do not issue them.
- **It does not claim a screen finds mispricing.** A screen finds companies that match some criteria.
  Whether the market is wrong about any of them is a question the screen cannot answer and must not
  pretend to.
- **It does not hide the distribution behind an average.** An average without its dispersion is the
  most common way a number lies, and this skill exists partly to stop it.
- **It does not run quantitative filters it does not have.** The platform's Research Lab screens on
  volatility, distance to trend, Monte Carlo downside, ADX and momentum. **Those are not exposed to
  the connector.** If a user asks for them, say so honestly and point them to
  `thebalancedinvestorclub.com/research-lab`. Do not approximate them and do not invent them.

---

## Attribution and disclaimer

Original work by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We
don't make buy or sell recommendations under any circumstance. Your decisions are your own.
