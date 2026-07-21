---
name: catalyst-calendar
description: Build and maintain a calendar of upcoming catalysts across a coverage universe — earnings dates, conferences, product launches, regulatory decisions, and macro events. Helps prioritize attention and position ahead of events. Triggers on "catalyst calendar", "upcoming events", "what's coming up", "earnings calendar", "event calendar", or "catalyst tracker".
---

# Catalyst Calendar

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

| What | Tool |
|------|------|
| Earnings dates, IPOs, the calendar itself | `get_market_calendar` |
| The names the user actually follows | `get_my_watchlists` |
| What the company has guided to | `get_earnings_estimates` |
| Their own thesis, so an event can test it | `list_my_trades` (the `thesis` field) |

**If the connector is not available in this session: STOP.** Do not fill the gap from memory and do
not web-search it. A number with no provenance looks exactly like a number with one, and that is
precisely what makes it dangerous. Tell the user: "I need The Balanced Investor Club connector for
this — it isn't connected in this session. Install the plugin (or reconnect it), start a new chat,
and ask again." A restart is often required right after installing.

**Do not use web search for market data. Ever.**

## Workflow

### Step 1: Define the coverage universe

- Get the names to track: `get_my_watchlists` for what the user already follows, or take the tickers / sector they name.
- Set a time horizon (next 2 weeks, month, quarter) — this becomes the `from` / `to` window.
- Decide whether to include macro events (Fed meetings, economic data, regulatory deadlines).

### Step 2: Pull the calendar, scoped to the coverage

Call `get_market_calendar` with `tickers` set to the coverage list and `from` / `to` set to the horizon. The tool filters server-side, so you get only the events that matter — not the whole market. **Passing no `tickers` returns the entire market, so always scope it to the coverage.** For event types the calendar does not carry, layer in the ones below where you already know them — never invent a date; if it is not served and you do not know it, say so:

**Earnings & Financial Events (from `get_market_calendar`)**
- Quarterly earnings date and time (pre/post market)
- Annual shareholder meeting
- Investor day / analyst day
- Capital markets day
- Debt maturity / refinancing dates

**Corporate Events**
- Product launches or announcements
- FDA approvals / regulatory decisions
- Contract renewals or expirations
- M&A milestones (close dates, regulatory approvals)
- Management transitions
- Insider trading windows (lockup expirations)

**Industry Events**
- Major conferences (dates, which companies presenting)
- Trade shows and expos
- Regulatory comment periods or rulings
- Industry data releases (monthly sales, traffic, etc.)

**Macro Events**
- Fed meetings (FOMC dates)
- Jobs report, CPI, GDP releases
- Central bank decisions (ECB, BOJ, etc.)
- Geopolitical events with market impact

### Step 3: Calendar View

| Date | Event | Company/Sector | Type | Impact (H/M/L) | What it would prove | Notes |
|------|-------|---------------|------|-----------------|--------------------|-------|
| | | | Earnings/Corp/Industry/Macro | | Which thesis pillar it tests | |

### Step 4: Weekly Preview

Each week, generate a forward-looking summary:

**This Week's Key Events:**
1. [Day]: [Company] Q[X] earnings — consensus [$X EPS], our estimate [$X], key focus: [metric]
2. [Day]: [Event] — why it matters for [stocks]
3. [Day]: [Macro release] — expectations and positioning

**Next Week Preview:**
- Early heads-up on important events coming

**What each event would prove:**
- Which pillar of the reader's thesis this event actually tests
- What result would confirm it, and what result would break it — **decide both BEFORE the event**, because afterwards the answer will feel obvious either way
- **No positioning. No pre-positioning. No suggestion to act ahead of anything.** A calendar tells you what is coming, not what to do about it

### Step 5: Output

- Excel workbook with calendar view and sortable columns
- Weekly preview email/note (markdown)
- Optional: integration with Google Calendar

## Important Notes

- Earnings dates shift — verify against company IR pages and the connector's get_market_calendar closer to the date
- Pre-announce risk: track companies with a history of pre-announcing (positive or negative)
- Conference attendance lists are valuable — which companies are presenting and which are conspicuously absent?
- Some catalysts are recurring (monthly industry data) — build a template and auto-populate
- Color-code by impact level: Red = high impact, Yellow = moderate, Green = routine
- Archive past catalysts with the actual outcome — builds pattern recognition over time

---

## What this skill does NOT do

- **It does not position for an event.** No pre-positioning, no "ahead of the print", no direction of
  any kind. A calendar tells you what is coming. It does not tell you what to do about it, and the
  gap between those two things is the whole product.
- **It does not predict the outcome.** It records what an event **would prove** — and the discipline
  is to write down both answers, the confirming one and the breaking one, **before** the event. After
  it, whichever happened will feel like it was always obvious.
- **It does not treat every date as a catalyst.** Most earnings reports change nothing. An event only
  earns a row if it can actually move a pillar of the reader's thesis.
- **It does not let a passed catalyst disappear.** Archive it **with what actually happened.** That
  archive is where pattern recognition comes from, and it is the most valuable thing this skill
  builds.

---

## Attribution and disclaimer

This skill is adapted from [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0) by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We don't make buy or sell recommendations under any circumstance. Your decisions are your own. Every output of this skill is a draft for review by a qualified professional.
