# Detailed Workflow for Earnings Updates

This document provides detailed step-by-step instructions for each phase of the earnings update process.

## ⚠️ The data comes from the connector. Not from memory, and not from the web.

**Training data is outdated, and it is outdated in the most dangerous way: confidently.** A model
that "remembers" Q3 will produce a complete, well-formatted, entirely wrong earnings report, and
nothing on the page will look wrong.

**Do not use web search for market data. Ever.** Not as a primary source, not as a fallback, not to
"check the latest". Web results are undated and unsourced, and a number you cannot trace is a number
you cannot defend.

**If the connector tools are not available in this session: STOP.** Do not build the report from
substitute sources. Tell the user: "I need The Balanced Investor Club connector for this — it isn't
connected in this session. Install the plugin (or reconnect it), start a new chat, and ask again."

## Phase 1: Earnings Data Collection (30-60 minutes)

### Step 1: Establish today's date, from the connector

**Write down today's date.** Not the date you think it is — the date the connector reports. A model's
sense of "today" is wrong by however long it has been since it was trained, and every staleness check
below depends on getting this right.

### Step 2: Find the latest reported quarter

```
get_fundamentals(ticker)  →  read `fiscalDateEnding`
```

That is the latest quarter the company has actually reported. **Do not infer it from the calendar.**
Fiscal years are not calendar years: Apple's Q1 ends in December, Nike's in August, Walmart's in
April. Guessing produces a report about a quarter that does not exist yet.

### Step 3: Verify it is fresh

- Is `fiscalDateEnding` within the last ~3 months of the connector's date?
- If it is older, **the company has not reported since.** That is a fact about the company, not a
  failure of the search. Say so, and ask the user whether they want the last reported quarter or a
  preview of the next one.
- Cross-check the report date with `get_market_calendar`.

**Never search again hoping for a newer quarter.** The connector has what the company has filed. If
it is not there, it does not exist.

### Step 4: Pull the materials

| What you need | Call |
|---------------|------|
| Reported figures | `get_income_statement`, `get_balance_sheet`, `get_cash_flow` |
| What was expected | `get_earnings_estimates` |
| The call itself, speaker by speaker | `get_earnings_transcript(ticker, quarter)` — quarter formatted `2026Q1` |
| Market cap, shares, beta, margins | `get_fundamentals` |
| The report date | `get_market_calendar` |
| Coverage and sentiment | `get_news` |

**The transcript is the primary source and the one most people skip.** Guidance, segment colour and
management's own hedges are all in it, in their words, and the Q&A is where they answer questions
they did not choose.

### Step 5: Verify before you analyse

- [ ] Today's date taken from the connector, written down
- [ ] `fiscalDateEnding` read from `get_fundamentals`, not assumed
- [ ] The quarter is within ~3 months, or the gap is explained
- [ ] Statements, estimates and transcript all pulled for the **same** quarter
- [ ] **Zero figures from memory. Zero figures from the web.**
- [ ] Every number traceable to a tool call and a fetch date — anything else is marked `[UNSOURCED]`

**🚩 If you cannot name the tool a number came from, you cannot use the number.**

## Phase 2: Analysis (2-3 hours)

### Step 5: Beat/Miss Analysis

For EACH key metric that beat or missed, explain:

**If BEAT:**
- What drove the outperformance?
- Was it one-time or sustainable?
- Did management guide higher going forward?
- How does this impact our thesis?

**If MISS:**
- What went wrong?
- Was it company-specific or industry-wide?
- Is management taking corrective action?
- How does this impact our thesis?

**Example Format:**
```
■ **Revenue Beat by 3% Driven by Strong DTC Performance**

Revenue of $13.5B exceeded our estimate of $13.1B by $400M (3%) and consensus
of $13.2B by $300M (2%). The outperformance was driven primarily by Direct-to-
Consumer channels, which grew 18% YoY (vs. our 12% estimate), offsetting
weaker-than-expected wholesale (-5% vs. flat estimate). Management cited strong
digital demand and successful product launches (Pegasus 40 running shoe, new
Jordan colorways) as key drivers. DTC now represents 42% of total revenue vs.
38% a year ago, demonstrating successful channel shift strategy.
```

### Step 6: Segment/Geographic/Product Analysis

Analyze performance by:
- Business segment (if multi-segment company)
- Geography (North America, Europe, China, etc.)
- Product category
- Channel (retail, wholesale, e-commerce)

Identify:
- What outperformed expectations?
- What underperformed?
- Trends vs. prior quarters
- Management commentary on outlook for each area

### Step 7: Margin Analysis

Analyze profitability:
- Gross margin: up or down? why?
- Operating margin: up or down? why?
- Key drivers (pricing, mix, costs, leverage)
- Outlook going forward

### Step 8: Guidance Analysis

If company provided guidance:
- Compare new guidance to prior guidance
- Compare to internal estimates and Street estimates
- Assess credibility (does company have track record of sandbagging? beating?)
- Identify key assumptions behind guidance

If company did NOT provide guidance:
- Note this explicitly
- Provide independent outlook based on results and commentary

### Step 9: Update Financial Model

Update estimates for:
- Current year (remaining quarters)
- Next year
- Potentially year after

**Show clearly:**
```
UPDATED ESTIMATES:
─────────────────────────────────────────────────
                        Old Est     New Est     Change      Reason
FY2024E Revenue         $XX.XB      $XX.XB      +X.X%      [Brief reason]
FY2024E EBITDA          $X.XB       $X.XB       +X.X%      [Brief reason]
FY2024E EPS             $X.XX       $X.XX       +X.X%      [Brief reason]

FY2025E Revenue         $XX.XB      $XX.XB      +X.X%      [Brief reason]
FY2025E EBITDA          $X.XB       $X.XB       +X.X%      [Brief reason]
FY2025E EPS             $X.XX       $X.XX       +X.X%      [Brief reason]
```

### Step 10: Update the Valuation Range

Based on updated estimates:
- Recalculate DCF (use updated cash flows)
- Update comparable company multiples (if peer group has reported)
- Produce the **implied value range** across the assumption grid — bear / base / bull, never a
  single figure

**Show the sensitivity.** Which assumption moves the range most, and by how much? A DCF whose output
swings 15% on a one-point change in WACC is telling the reader something important about how much
confidence the number deserves. Say it out loud.

**Never collapse the range into a target.** A price target is an opinion with decimals. The range,
its drivers, and the current price sitting inside or outside it — that is the lesson.

### Step 11: Assess What Changed in the Read

Do **not** decide a rating. There is no rating. Instead, answer:

- **Which pillar of the thesis moved?** Name it. Growth, margin, competitive position, capital
  allocation — which one did this quarter actually inform?
- **Did it move enough to matter,** or is this noise inside a normal quarter's variance?
- **What would prove this read wrong?** State the specific, checkable condition — a metric, a
  threshold, a date. "If gross margin doesn't reach 22% by FY28, the base case collapses."

**Consider:**
- Stock reaction (up/down/flat?) — and note that the market's reaction is information, not a verdict
- Where the current price sits relative to the implied range, and what growth that price already assumes
- Which assumptions are doing the heavy lifting

## Phase 3: Chart Generation (1-2 hours)

### Step 12: Generate 8-12 Charts

Create charts focusing on QUARTERLY TRENDS and WHAT'S NEW.

**REQUIRED CHARTS (8-12 total):**

1. **Quarterly Revenue Progression** (Bar chart)
   - Last 8-12 quarters
   - Show beat/miss vs. estimates each quarter
   - Highlight current quarter

2. **Quarterly EPS Progression** (Bar chart)
   - Last 8-12 quarters
   - Show beat/miss vs. estimates
   - Adjusted and GAAP

3. **Quarterly Margin Trend** (Line chart)
   - Gross margin, EBIT margin, net margin
   - Last 8-12 quarters
   - Show trajectory

4. **Revenue by Segment/Geography** (Stacked bar OR table)
   - Current quarter vs. YoY
   - Growth rates by segment

5. **Key Operating Metrics** (Multi-line chart)
   - Customer count, ARPU, units sold, etc. (whatever is relevant)
   - Last 8-12 quarters

6. **Beat/Miss Summary** (Waterfall or table)
   - Show components of beat/miss
   - What drove variance from estimates

7. **Estimate Revision Chart** (Before/after comparison)
   - Old FY estimates vs. new FY estimates
   - Bar chart showing change

8. **Valuation Chart** (P/E or EV/EBITDA multiple)
   - Historical multiple range
   - Current multiple
   - The multiple the model implies, against the peer median — and what explains the gap

**OPTIONAL CHARTS (if space allows):**
- Peer comparison (if peers have reported)
- Guidance vs. Street comparison
- Cash flow metrics
- Balance sheet highlights (if notable)

**Chart Style Guidelines:**
- Focus on TRENDS (quarterly progression)
- Highlight CHANGES (beat/miss, estimate revisions)
- Keep simple and clear (this is a fast-turnaround report)

## Phase 4: Report Creation (2-3 hours)

### Step 13: Create DOCX Report

Use DOCX skill to create 8-12 page report.

See [report-structure.md](report-structure.md) for complete page-by-page templates and formatting requirements.

**Key Steps:**
1. Create Page 1 with earnings summary and quick takeaways
2. Add detailed results analysis (Pages 2-3)
3. Include key metrics and guidance (Pages 4-5)
4. Update investment thesis (Pages 6-7)
5. Provide valuation and estimates (Pages 8-10)
6. Add appendix if needed (Pages 11-12)
7. Embed all 8-12 charts throughout
8. Add 1-3 summary tables
9. Include complete sources section with clickable hyperlinks

### Step 14: Optional - Update XLS Model

If a full financial model exists for this company (from initiation), update it with:
- Actual Q[X] results
- Revised estimates for future quarters
- Updated valuation

**Note**: For earnings updates, a full XLS file is OPTIONAL (not required like in initiation reports). The DOCX report is the primary deliverable.

If creating XLS, include:
- Quarterly model tab
- Updated annual projections
- Revised DCF
- Updated comps analysis

## Phase 5: Quality Check & Delivery (30 minutes)

### Step 15: Quality Checklist

Before publishing, verify:

**Content:**
- [ ] Beat/miss clearly stated and quantified
- [ ] Key drivers explained (not just "strong performance")
- [ ] Updated estimates provided (old vs. new shown)
- [ ] Implied value **range** updated, with its sensitivity shown
- [ ] The falsifier is stated: what would prove this read wrong
- [ ] **NO rating. NO price target. NO buy/sell/hold verdict** (and none relabelled as BULLISH/BEARISH)
- [ ] Framing block and disclaimer present, per `plugins/core/OUTPUT-BLOCK.md`
- [ ] Guidance analyzed (if provided)
- [ ] Thesis impact assessed — which pillar moved

**Formatting:**
- [ ] Page 1 has summary box and key bullets
- [ ] All tables have source lines
- [ ] All figures numbered and captioned
- [ ] Estimates table shows old vs. new
- [ ] 8-12 charts embedded throughout
- [ ] Report is 8-12 pages (not too long, not too short)

**Accuracy:**
- [ ] Numbers match company's reported results exactly
- [ ] Math checks out (estimates, valuation)
- [ ] No typos in ticker, company name, numbers
- [ ] Charts match text descriptions
- [ ] Date is current

**Citations:** ⭐ MANDATORY
- [ ] Every figure has specific source with document and date
- [ ] Every table has specific source with document reference
- [ ] Beat/miss analysis cites consensus source with date
- [ ] Guidance changes cite current and prior guidance sources
- [ ] Key statistics have footnotes with specific page/slide references
- [ ] Sources section lists all materials with URLs
- [ ] ALL URLs are CLICKABLE HYPERLINKS (not plain text)
- [ ] Hyperlinks tested and working (Ctrl+Click opens correct page)
- [ ] All filings hyperlinked (company investor relations site)
- [ ] All earnings materials hyperlinked (release, transcript, presentation)
- [ ] Prior guidance hyperlinked to prior quarter's materials
- [ ] No raw URLs displayed - all formatted as clickable links
- [ ] Earnings call quotes cite specific speaker and approximate timestamp

**Timeliness:**
- [ ] Report published within 24-48 hours of earnings release
- [ ] All data is from LATEST quarter
- [ ] Consensus estimates are pre-earnings (not post-earnings)

### Step 16: Deliver Report

Provide user with:

1. **DOCX file**: `[Company]_Q[X]_[Year]_Earnings_Update.docx`
2. **Chart files**: All PNG/JPG charts (for reference)
3. **Optional XLS**: Updated financial model if maintained

**Brief summary for user:**
```
[Company] Q[X] [Year] Earnings Update Complete

Results: [BEAT / INLINE / MISS]
- Revenue: $X.XB ([beat/missed] by $XXM or X%)
- EPS: $X.XX ([beat/missed] by $X.XX)

Key Takeaways:
■ [Takeaway 1]
■ [Takeaway 2]
■ [Takeaway 3]

Updated Estimates:
- FY[Year]E Revenue: $XX.XB (prior: $XX.XB, [+/-]X%)
- FY[Year]E EPS: $X.XX (prior: $X.XX, [+/-]X%)

Implied Value Range (your assumptions): $XX – $XX – $XX
What moves it most: [driver] ±[X]pt → ±[Y]%
What would prove this read wrong: [the falsifier]

Educational content, not investment advice. No buy/sell recommendations — observations for your own research.

Deliverable: 8-12 page earnings update report with updated estimates and valuation.
```
