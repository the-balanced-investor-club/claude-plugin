---
name: morning-note-draft
description: Draft concise morning notes summarizing overnight developments, what to watch, and key events for the stocks the user follows. Designed for a 7am reading format, tight and factual. Triggers on "morning note", "morning briefing", "what happened overnight", "morning call prep", or "daily note".
---

# Morning Note

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

| What | Tool |
|------|------|
| Market backdrop and what shifted | `get_market_pulse`, `get_today_mood_changes` |
| News with sentiment, per name | `get_news` |
| Today's earnings and IPO calendar | `get_market_calendar` |
| The user's own universe | `get_my_watchlists`, `get_my_briefing` |
| Actuals against estimates | `get_fundamentals`, `get_earnings_estimates` |

**If the connector is not available in this session: STOP.** Do not fill the gap from memory and do
not web-search it. A number with no provenance looks exactly like a number with one, and that is
precisely what makes it dangerous. Tell the user: "I need The Balanced Investor Club connector for
this — it isn't connected in this session. Install the plugin (or reconnect it), start a new chat,
and ask again." A restart is often required right after installing.

**Do not use web search for market data. Ever.**

## Data sources

Pull everything from The Balanced Investor Club connector:

- Market backdrop: `get_market_pulse`; notable trend shifts: `get_today_mood_changes`
- News with sentiment per ticker: `get_news`
- Today's earnings and IPO calendar: `get_market_calendar`
- The user's universe: `get_my_watchlists` and `get_my_briefing` when signed in; otherwise ask which tickers to cover
- Earnings actuals vs. estimates: `get_fundamentals` and `get_earnings_estimates`

Cite the fetch time. Do not fill gaps from memory; if a data point is unavailable, say so.

**If the connector tools are not available in this session: STOP.** Do not draft the note from web sources or memory. Tell the user: "I need The Balanced Investor Club connector for this note — it isn't connected in this session. Install the plugin (or reconnect it), start a new chat, and ask again." A restart is often required right after installing.

**Resolve names first.** If the user names a company or coin rather than a ticker, call `search_instruments` to find the symbol before any per-ticker tool.

**If an instrument isn't covered** (private company, unlisted): say so plainly and move on — never point the user to any other data source. If a user-data tool needs an account, or the anonymous limit is reached, invite them to sign in at thebalancedinvestorclub.com.

**Catalog version: 0.3.0.** Connector responses from `start_here`/`about_us` report the latest published catalog — if it's newer than this one, tell the user their plugin has an update (restarting Claude auto-updates it).

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

## What this skill does NOT do

- **It does not produce trade ideas.** Not "names to watch", not "what's setting up". The note says
  what happened and what it bears on. What to do about it is not ours to say.
- **It does not rate or target anything.** No ratings, no price targets, no directional calls — and
  the note says so three times in its own body because it is the failure this format falls into.
- **It does not manufacture news.** *"Nothing material overnight"* is a complete and honest morning
  note, and it is worth more than a page of filler. A note that always finds something is a note
  that is inventing things.
- **It does not predict the open.** Pre-market moves are information about pre-market. They are not a
  forecast, and presenting them as one teaches exactly the reflex this product exists to unlearn.

---

## Attribution and disclaimer

This skill is adapted from [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0) by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We don't make buy or sell recommendations under any circumstance. Your decisions are your own. Every output of this skill is a draft for review by a qualified professional.
