---
name: sector-overview
description: Create comprehensive industry and sector landscape reports covering market dynamics, competitive positioning, key players, and thematic trends. Use for client requests, sector initiations, thematic research pieces, or internal knowledge building. Triggers on "sector overview", "industry report", "market landscape", "sector analysis", "industry deep dive", or "thematic research".
---

# Sector Overview

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

| What | Tool |
|------|------|
| Every company in the sector or industry | `list_securities_by` |
| The sector's return — **weighted and simple** | `get_sector_returns`, `get_industry_returns` |
| The behavioural distribution across the same set | `list_market_moods` |
| Size, multiples, margins per company | `get_fundamentals` |
| What is happening, with sentiment | `get_news` |

**If the connector is not available in this session: STOP.** Do not fill the gap from memory and do
not web-search it. A number with no provenance looks exactly like a number with one, and that is
precisely what makes it dangerous. Tell the user: "I need The Balanced Investor Club connector for
this — it isn't connected in this session. Install the plugin (or reconnect it), start a new chat,
and ask again." A restart is often required right after installing.

**Do not use web search for market data. Ever.**

## Workflow

### Step 1: Define Scope

- **Sector / subsector**: What industry and how narrowly defined?
- **Purpose**: Client report, internal research, pitch material, idea generation
- **Depth**: High-level overview (5-10 pages) or deep dive (20-30 pages)
- **Angle**: Neutral landscape vs. thematic thesis (e.g., "AI infrastructure buildout")
- **Universe**: Public companies only, or include private?

### Step 2: Market Overview

**Market Size & Growth**
- Total addressable market (TAM) with source
- Historical growth rate (5-year CAGR)
- Forecast growth rate and key assumptions
- Market segmentation (by product, geography, end market, customer type)

**Industry Structure**
- Fragmented vs. consolidated — top 5 market share
- Value chain map — where does value accrue?
- Business model types (subscription, transaction, licensing, services)
- Barriers to entry (capital, regulatory, technical, network effects)

**Key Trends & Drivers**
- Secular tailwinds (3-5 major trends)
- Headwinds and risks
- Technology disruption vectors
- Regulatory developments
- M&A activity and consolidation trends

### Step 3: Competitive Landscape

**Company Profiles** (for top 5-10 players):

| Company | Revenue | Growth | EBITDA Margin | Market Share | Key Differentiator |
|---------|---------|--------|--------------|-------------|-------------------|
| | | | | | |

For each company, brief profile:
- Business description (2-3 sentences)
- Strategic positioning and moat
- Recent developments (earnings, M&A, product launches)
- Valuation snapshot (P/E, EV/EBITDA, EV/Revenue)

**Competitive Dynamics**
- How do companies compete? (price, product, service, distribution)
- Who is gaining/losing share and why?
- Disruption risk from new entrants or adjacent players

### Step 4: Valuation Context

- Sector trading multiples (current and historical range)
- Premium/discount drivers (growth, margins, market position)
- Recent M&A transaction multiples
- How does the sector compare to the broader market?

### Step 5: The Open Questions

- What are the live debates in this sector — where do reasonable people disagree, and on what evidence?
- What would have to change for the sector's story to break? Name the specific, checkable condition.
- Key debates in the sector (bull vs. bear arguments)
- Catalysts that could change the sector narrative

### Step 6: Output

- Word document or PowerPoint with:
  - Market overview and sizing
  - Competitive landscape map
  - Company comparison table
  - Valuation summary
  - Key charts: market growth, share trends, valuation history
- Excel appendix with detailed company data

## Important Notes

- Source all market size data — cite the research firm or methodology
- Distinguish between TAM hype and realistic addressable market
- Sector overviews age fast — note the date and flag data that may be stale
- Charts are essential — market size waterfall, competitive positioning matrix, valuation scatter plot
- If for a client, tailor the "so what" to their specific situation (M&A target identification, competitive positioning, market entry)

---

## What this skill does NOT do

- **It does not name opportunities.** No "best risk/reward", no "where to look first", no thematic
  bets. It maps a sector. Where a reader goes in it is theirs.
- **It does not report an average without its dispersion.** The weighted and the simple return usually
  disagree, sometimes by twenty points, and **the gap is the finding**: it tells you whether the
  sector's story belongs to the whole sector or to four companies at the top of it.
- **It does not confuse TAM with a market.** A total addressable market is an arithmetic ceiling, not
  a forecast, and a sector overview that leads with one is a pitch.
- **It does not settle the debate.** It names what reasonable people disagree about and on what
  evidence, then stops. The disagreement is the useful part.

---

## Attribution and disclaimer

This skill is adapted from [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0) by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We don't make buy or sell recommendations under any circumstance. Your decisions are your own. Every output of this skill is a draft for review by a qualified professional.
