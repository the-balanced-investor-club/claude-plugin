---
name: morning-note
description: Draft concise morning notes summarizing overnight developments, what to watch, and key events for the stocks the user follows. Designed for a 7am reading format, tight and factual. Triggers on "morning note", "morning briefing", "what happened overnight", "morning call prep", or "daily note".
---

# Morning Note

## Data sources

Pull everything from The Balanced Investor Club connector:

- Market backdrop: `get_market_pulse`; notable trend shifts: `get_today_mood_changes`; biggest movers: `get_top_movers` (when available)
- News with sentiment per ticker: `get_news`
- Today's earnings and IPO calendar: `get_market_calendar`
- The user's universe: `get_my_watchlists` and `get_my_briefing` when signed in; otherwise ask which tickers to cover
- Earnings actuals vs. estimates: `get_fundamentals` and `get_earnings_estimates`

Cite the fetch time. Do not fill gaps from memory; if a data point is unavailable, say so.

## Workflow

### Step 1: Overnight Developments

Scan for relevant events across the user's universe:

**Earnings & Guidance**
- Any coverage companies reporting overnight or pre-market?
- Earnings surprises (beat/miss on revenue, EPS, key metrics)
- Guidance changes (raised, lowered, maintained)

**News & Events**
- M&A announcements or rumors
- Management changes
- Product launches or regulatory decisions
- Analyst upgrades/downgrades from competitors
- Macro data or policy changes affecting the sector

**Market Context**
- Overnight futures / pre-market moves
- Sector ETF performance
- Relevant commodity or currency moves
- Key economic data releases today

### Step 2: Morning Note Format

Keep it tight — a morning note should be readable in 2 minutes:

---

**[Date] Morning Note**
**[Tickers or sectors covered]**

**The Headline: [The one thing worth reading first]**
- 2-3 sentences on the key development and why it matters
- Observed impact: pre-market move, estimate revisions, guidance change (facts, not price targets)

**Overnight/Pre-Market Developments**
- [Company A]: One-line summary of earnings/news + a factual read
- [Company B]: One-line summary + a factual read
- [Sector/Macro]: Relevant sector-wide development

**Key Events Today**
- [Time]: [Company] earnings call
- [Time]: Economic data release (consensus expectation)
- [Time]: Conference or investor day

**What to Watch** (if anything stands out)
- [Company]: What the data shows, in 1-2 sentences, and which upcoming event will confirm or refute it
- The other side: what would make this read wrong
- This is an observation to research, not a recommendation to act

---

### Step 3: Quick Takes on Earnings

If a coverage company reported, provide a quick reaction:

| Metric | Consensus | Actual | Beat/Miss |
|--------|-----------|--------|-----------|
| Revenue | | | |
| EPS | | | |
| [Key metric] | | | |
| Guidance | | | |

**The Read**: 2-3 sentences — what changed versus expectations, and does it alter the picture the user has been tracking?

**Worth Journaling**: if the user follows this ticker, suggest noting the reaction and their own read while it's fresh. No ratings, no price targets.

### Step 4: Output

- Markdown text for email/Slack distribution
- Word document if formal distribution is needed
- Keep to 1 page max — PMs and traders won't read more

## Important Notes

- Have a view on what matters — notes that just list news without separating signal from noise are useless. The view is about relevance, never about buying or selling
- Lead with the most important thing — don't bury the headline
- "No news" is a valid morning note — say "nothing material overnight" and stop there
- Distinguish between actionable events (earnings, M&A) and noise (minor analyst notes, non-events)
- Time-stamp your takes — if you're writing at 6am, note that pre-market may change by open
- If you're wrong, own it in the next morning note — credibility matters more than being right every time

---

## Attribution and disclaimer

This skill is adapted from [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0) by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We don't make buy or sell recommendations under any circumstance. Your decisions are your own. Every output of this skill is a draft for review by a qualified professional.
