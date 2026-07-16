---
name: earnings-analysis
description: Create professional equity research earnings update reports (8-12 pages, 3,000-5,000 words) analyzing quarterly results for companies already under coverage. Fast-turnaround format focusing on beat/miss analysis, key metrics, updated estimates, and revised thesis. Includes 1-3 summary tables and 8-12 charts. Use when user requests "earnings update", "quarterly update", "earnings analysis", "Q1/Q2/Q3/Q4 results", or post-earnings report. Triggers on "earnings update", "quarterly update", "earnings analysis", "Q1/Q2/Q3/Q4 results", "post-earnings report", "how was the quarter".
---

# Earnings Update

> **Output:** deliverables carry the blocks defined in `plugins/core/OUTPUT-BLOCK.md`. The connector
> already appends the disclaimer to every response — do not add a second one.

## Data source

| What | Tool |
|------|------|
| The latest reported quarter | `get_fundamentals` (`fiscalDateEnding`) |
| What the company reported | `get_income_statement`, `get_balance_sheet`, `get_cash_flow` |
| What was expected of it | `get_earnings_estimates` |
| The call itself, speaker by speaker | `get_earnings_transcript` |
| When they reported | `get_market_calendar` |
| Coverage, with sentiment | `get_news` |

**If the connector is not available in this session: STOP.** Do not fill the gap from memory and do
not web-search it. Training data is outdated in the most dangerous way: confidently. A model that
"remembers" the quarter will produce a complete, well-formatted, entirely wrong report, and nothing
on the page will look wrong. Tell the user: "I need The Balanced Investor Club connector for this —
it isn't connected in this session. Install the plugin (or reconnect it), start a new chat, and ask
again."

**Do not use web search for market data. Ever.**

Create an **EARNINGS UPDATE REPORT** analyzing quarterly results for a company the reader already
follows: what beat, what missed, **why**, and what it changes about their understanding of the
business.

## ⚠️ No verdict — read this before writing a word

This report carries **no rating, no price target, and no buy / sell / hold call**. Not in the
summary, not on page 1, not in the valuation section, not anywhere. `BULLISH` / `BEARISH` are not
an escape hatch either — a relabelled recommendation is still a recommendation.

**Where a verdict would sit, the report gives three things instead:**

1. **The implied value range** under the stated assumptions — a range, never a single figure.
2. **The sensitivity** — what moves that range, and by how much.
3. **The falsifier** — what would prove this read wrong.

The framing block and the disclaimer are defined once in `plugins/core/OUTPUT-BLOCK.md`. Reproduce
them in the document; do not restate them here.

**Key Characteristics:**
- **Length**: 8-12 pages
- **Word Count**: 3,000-5,000 words
- **Tables**: 1-3 summary tables (NOT comprehensive)
- **Figures**: 8-12 charts
- **Turnaround**: 1-2 days (within 24-48 hours of earnings)
- **Audience**: Clients already familiar with the company
- **Focus**: What's NEW - beat/miss, updated estimates, thesis impact
- **Font**: Inter (fallback Calibri) throughout (unless user specifies otherwise)

## When to Use

Use when the user requests:
- "Create an earnings update for [Company] Q3 2024"
- "Analyze [Company]'s quarterly results"
- "Post-earnings report for [Company]"
- "Q1/Q2/Q3/Q4 update for [Company]"

**Do NOT use if:**
- User requests "initiation report" → Use different skill
- User requests "flash note" or "quick take" → Different format
- Company is not already covered → Need initiation first

## Critical Requirements

### 1. Speed & Timeliness
- Publish within 24-48 hours of earnings release
- Focus on NEW information only
- Don't rehash company background extensively

### 2. Beat/Miss Analysis
- Lead with whether company beat or missed estimates
- Quantify variances (e.g., "Revenue beat by $120M or 3%")
- Explain WHY results differed from expectations

### 3. Summary Format
- Keep tables to 1-3 (summary only, not comprehensive)
- No full P&L/Cash Flow/Balance Sheet (just key metrics)
- Assume reader has seen initiation report

### 4. Citations & Source Attribution ⭐⭐⭐ MANDATORY

**CRITICAL**: Properly cite all data with SPECIFIC sources and CLICKABLE HYPERLINKS.

**Include specific citations WITH CLICKABLE LINKS in every figure and table:**

```
Source: Q3 2024 10-Q filed November 8, 2024; Company earnings release
        [Hyperlink "10-Q" to the filing on the company's investor relations site]
        [Hyperlink "earnings release" to: https://investor.company.com/news/q3-2024]
```

**HOW HYPERLINKS SHOULD APPEAR IN WORD:**
- Document names appear as blue, underlined clickable links
- Reader can Ctrl+Click to open source directly
- Not plain text URLs - formatted hyperlinks with display text

**REQUIRED SOURCES LIST:**

Cite in every earnings update:
- ✅ Earnings release (with date and URL)
- ✅ 10-Q filing (with filing date and a link to the company's investor relations site)
- ✅ Earnings call transcript (with date)
- ✅ Investor presentation/supplemental materials (if available)
- ✅ Consensus estimates source (The Balanced Investor Club connector: get_earnings_estimates, with date)
- ✅ Prior guidance (from previous quarter's materials)

**REFERENCE SECTION WITH CLICKABLE HYPERLINKS:**

Include "Sources" section at end of report:

```
SOURCES & REFERENCES

Earnings Materials (Q3 2024):
• Earnings Release (November 7, 2024)
  [Hyperlink entire line to: https://investor.company.com/news/q3-2024-earnings]

• Form 10-Q (Filed November 8, 2024)
  [Hyperlink to the filing on the company's investor relations site]

• Earnings Call Transcript (November 7, 2024)
  Source: The Balanced Investor Club connector — get_earnings_transcript, [quarter], retrieved [date]

• Investor Presentation (November 7, 2024)
  [Hyperlink to: https://investor.company.com/presentations/q3-2024.pdf]
```

**VERIFICATION CHECKLIST:**
- [ ] Every figure has source with specific document and date
- [ ] Every table has source with document reference
- [ ] Beat/miss analysis cites consensus source with date
- [ ] Guidance changes cite current and prior guidance sources
- [ ] Key statistics have footnotes
- [ ] Sources section lists all materials with URLs
- [ ] ALL URLs are CLICKABLE HYPERLINKS (not plain text)
- [ ] All filings hyperlinked (company investor relations site)

### 5. Updated Estimates
- Update forward estimates based on results
- Show old vs. new estimates clearly
- Explain what changed and why

## High-Level Workflow

The earnings update process follows 5 phases:

### Phase 1: Data Collection (30-60 minutes)

**🚨🚨🚨 CRITICAL: TRAINING DATA IS OUTDATED 🚨🚨🚨**

**BEFORE STARTING - COMPLETE THESE 4 STEPS IN ORDER:**
1. **CHECK TODAY'S DATE** - Write down the current date
2. **GET THE LATEST QUARTER** — call `get_fundamentals` for `fiscalDateEnding`, then `get_earnings_transcript` and `get_income_statement` for that quarter. **Never web search for earnings data.**
3. **VERIFY THE DATE** - Confirm earnings release is within last 3 months
4. **CHECK TRANSCRIPT DATE** - Verify transcript date matches release date

**COMMON MISTAKE**: Using outdated earnings calls from training data instead of pulling the latest from the connector.

**REQUIREMENTS:**
- ✅ Pull the latest earnings from the connector — do NOT rely on training data, and do NOT web search
- ✅ Write down today's date and the release date found
- ✅ Verify release date is within 3 months of today
- ✅ Verify transcript date matches release date
- ✅ If dates don't match or are old (>3 months), re-pull from the connector

**See [references/workflow.md](references/workflow.md)** for the connector calls and the verification steps.

### Phase 2: Analysis (2-3 hours)
- Beat/miss analysis for each key metric
- Segment/geographic/product breakdown
- Margin and guidance analysis
- Update financial model and estimates

**See [references/workflow.md](references/workflow.md)** for detailed analysis framework.

### Phase 3: Chart Generation (1-2 hours)
Create 8-12 charts focusing on quarterly trends and what's new:
- Quarterly revenue progression
- Quarterly EPS progression
- Quarterly margin trends
- Revenue by segment/geography
- Key operating metrics
- Beat/miss summary
- Estimate revisions
- Valuation charts

**See [references/workflow.md](references/workflow.md)** for chart specifications.

### Phase 4: Report Creation (2-3 hours)
Create 8-12 page DOCX report with specific structure.

**See [references/report-structure.md](references/report-structure.md)** for complete page-by-page templates and formatting requirements.

**High-level structure:**
- Page 1: Educational framing block, earnings summary, key takeaways, and what would prove the read wrong
- Pages 2-3: Detailed results analysis
- Pages 4-5: Key metrics & guidance
- Pages 6-7: Updated investment thesis
- Pages 8-10: Valuation & estimates
- Pages 11-12: Appendix (optional)

### Phase 5: Quality Check & Delivery (30 minutes)
Verify content, formatting, accuracy, and timeliness before delivery.

**See [references/best-practices.md](references/best-practices.md)** for quality checklist and common mistakes to avoid.

## Output Specification

**Primary Deliverable**: DOCX report (8-12 pages)
**File Name**: `[Company]_Q[Quarter]_[Year]_Earnings_Update.docx`
**Example**: `Nike_Q2_FY24_Earnings_Update.docx`

**Contents:**
- Page 1: Educational framing block, summary, key takeaways, and the falsifier
- Pages 2-3: Detailed results analysis
- Pages 4-5: Key metrics and guidance
- Pages 6-7: Updated thesis assessment
- Pages 8-10: Valuation and estimates
- Pages 11-12: Appendix (optional)
- 8-12 embedded charts
- 1-3 summary tables
- Complete sources section with clickable hyperlinks

**Optional Deliverable**: XLS model update (optional for earnings updates)

## Key Differences from Initiation Report

| Aspect | Earnings Update | Initiation Report |
|--------|----------------|-------------------|
| **Length** | 8-12 pages | 30-50 pages |
| **Words** | 3,000-5,000 | 10,000-15,000 |
| **Tables** | 1-3 summary | 12-20 comprehensive |
| **Figures** | 8-12 | 25-35 |
| **Turnaround** | 1-2 days | 3-6 weeks |
| **Scope** | Quarterly results | Complete company |
| **Focus** | What's NEW | Everything |
| **Company Background** | Brief mention | 6-10 pages |
| **XLS Model** | Optional | Required |

## Resources

### references/workflow.md
Detailed Phase 1-5 instructions with step-by-step procedures for data collection, analysis, chart generation, and report creation.

### references/report-structure.md
Complete page-by-page templates, table formats, and formatting requirements for the DOCX report.

### references/best-practices.md
Examples of good/bad headlines, tips for success, common mistakes to avoid, and comprehensive quality checklist.

## Dependencies

**Required:**
- Python (matplotlib, pandas, seaborn) for chart generation
- DOCX skill for report creation

**Optional:**
- XLS skill for model updates (not required for earnings updates)

---

## What this skill does NOT do

- **It does not issue a rating, a price target, or a verdict.** Not on page 1, not in the valuation
  section, not anywhere. `BULLISH` / `BEARISH` are not an escape hatch — a relabelled recommendation
  is still a recommendation, and the rules reach implicit ones.
- **It does not treat an adjusted figure as the truth.** Nor as a lie. Report the comparable and the
  reported number, and say what sits between them.
- **It does not accept an adjective as evidence.** "Strong quarter" is not a number. The number is
  usually two paragraphs further down, in a flatter tone.
- **It does not write from memory.** Every figure traces to a tool call and a fetch date, or it is
  marked `[UNSOURCED]`. If you cannot name where a number came from, you cannot use it.

---

## Attribution and disclaimer

This skill is adapted from [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0) by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We don't make buy or sell recommendations under any circumstance. Your decisions are your own. Every output of this skill is a draft for review by a qualified professional.
