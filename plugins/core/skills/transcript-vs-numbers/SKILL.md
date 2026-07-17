---
name: transcript-vs-numbers
description: Put what management SAID on the earnings call next to what the financial statements DID, and read the gap. Pulls the full transcript speaker by speaker and the reported figures, then checks the headline against the fine print — calendar shifts, currency tailwinds, one-off tax rates, and the adjectives that carry no number. Reports the discrepancy, never the motive. Triggers on "earnings call", "what did management say", "transcript", "do I believe them", "read the call", "management tone", "what did they avoid", "is the guidance real".
---

# Transcript vs. Numbers

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

| What | Tool |
|------|------|
| The full call, speaker by speaker (paged: `offset` / `limit`) | `get_earnings_transcript` |
| The reported quarter — and the `fiscalDateEnding` you need for the transcript | `get_fundamentals` |
| What the statements actually did | `get_income_statement`, `get_cash_flow`, `get_balance_sheet` |
| What was expected of them | `get_earnings_estimates` |
| Whether cash is following the earnings | `get_valuation_inputs` (FCF history and CAGR) |

`get_earnings_transcript` needs a **fiscal quarter** in the form `2026Q1`. Get the latest reported
one from `get_fundamentals` (`fiscalDateEnding`) — do not guess it.

**If the connector is not available in this session: STOP.** Do not summarise a call from memory and
do not web-search a transcript. A remembered earnings call is a story about an earnings call. Tell
the user: "I need The Balanced Investor Club connector for the transcript — it isn't connected in
this session. Install the plugin (or reconnect it), start a new chat, and try again."

**Do not use web search for market data. Ever.**

---

## Purpose

This is the whole product, applied to one company: **do I believe these numbers?**

Management is not usually lying. Management is **selecting** — choosing which true thing to say first,
and which true thing to put in the fine print. Both halves are in the transcript. The skill's job is
to put them next to each other and let the reader see the distance.

**A CFO tells you everything. Just not in the same paragraph.**

---

## Step 1: Read the call. All of it.

Transcripts run long — 47 speaker turns is typical. Page through with `offset` and `limit`.

**The Q&A is where the information is.** Prepared remarks are written by the communications team over
a week. The Q&A is management answering questions they did not choose, and what they *decline* to
answer is data. If an analyst asks the same question twice in different words, note it — the second
ask means the first answer was not one.

## Step 2: Find the adjectives that carry no number

Go through the prepared remarks and mark every claim that is a word rather than a figure. "Strong."
"Solid." "Resilient." "Well positioned."

Then look for the number that should be attached — in the transcript, in the income statement, in the
cash-flow statement — and put it beside the word.

Sometimes the number is there and it supports the adjective. **Sometimes it is there and it does
not**, and it is usually two paragraphs further down, spoken by the CFO in a flatter tone.

## Step 3: The four places the headline gets flattered

These are the ones to check every single time, because they recur:

**1. Calendar effects.** Extra days, shifted holidays, a 53rd week.
> KO's Q1 2026: *"organic revenues grew 10%"* — and the CFO adds *"the impact of six additional days
> in the quarter."* The CEO himself concedes: *"Excluding the impact from six extra days and the
> timing of concentrate shipments, organic revenue growth is **on track with our full year
> guidance**"* — which is 4–5%, not 10%. **And Q4 will have six days fewer.** The days come back.

**2. Currency.** A tailwind is not performance.
> *"Comparable EPS of \$0.86 increased 18% year-over-year, **helped by 3% currency tailwinds**."*
> Fifteen, not eighteen, is the operating number.

**3. Below-the-line and tax.** Watch where a guidance raise comes from.
> KO raised full-year EPS guidance from 7–8% to 8–9%. The reason, stated plainly: *"**due to the
> lower effective tax rate**."* The raise came from the tax line, not the business. That is a real
> increase in earnings and it is **not** an improvement in operations, and a reader deserves to know
> which one they are being handed.

**4. Margin, buried.** The direction of margin is often mentioned once, quietly.
> *"Comparable gross margin **declined approximately 30 basis points**"* — in the same paragraph as
> the strong quarter.

## Step 4: Does the cash agree with the story?

The last check, and often the loudest. Earnings are an opinion; cash is a fact.

Pull the FCF history from `get_valuation_inputs` or `get_cash_flow` and put it against what was said.
A company describing *"confidence in our long-term free cash flow generation"* while its four-year
FCF CAGR reads **−17%** is not lying — but those two things belong on the same page, and only one of
them was said out loud.

---

## Step 5: Report the discrepancy. Never the motive.

This is the line, and it is not a stylistic preference:

- ✅ *"Guidance says margin expansion. Comparable gross margin fell 30 basis points this quarter."*
- ✅ *"Revenue grew 10%. Six of those points were extra calendar days and shipment timing, on management's own account."*
- ✅ *"The EPS guidance went up. The reason given was the tax rate."*
- ❌ *"Management is spinning the numbers."* — a motive, and you cannot see motives.
- ❌ *"This suggests the quarter was weaker than it looks, so..."* — the "so" is where a recommendation begins.

**Put the two quotes side by side, cite them both, and stop.** The gap speaks. Anything you add is
you talking, and the reader is perfectly capable of drawing the conclusion — which is the entire
point of teaching them to do it.

---

## Output checklist

- [ ] The fiscal quarter taken from `get_fundamentals`, never guessed
- [ ] The **Q&A** read, not just the prepared remarks
- [ ] Calendar effects, currency, tax and below-the-line items checked **every time**
- [ ] Every adjective with a number attached, where a number exists
- [ ] Cash checked against the earnings story
- [ ] Both sides **quoted, with attribution** — the transcript line and the statement line
- [ ] **The discrepancy reported. The motive never inferred.**
- [ ] No "so", no "which means you should", no verdict

## What this skill does NOT do

- **It does not accuse anyone of anything.** "Management is misleading you" is a claim about intent,
  made from a transcript, and it is both unprovable and a de facto sell call. The gap between two
  sentences is a fact. Why it exists is not visible from here.
- **It does not conclude.** It ends with the two quotes and the distance between them. If the reader
  concludes the quarter was weaker than the headline, they concluded it — and they will remember it,
  because they did the work.
- **It does not treat a management adjective as evidence.** "Strong" is not a number. Neither is
  "resilient", "solid", or "well positioned".
- **It does not treat an adjusted figure as the truth.** Nor as a lie. Report both the comparable and
  the reported figure, and say what sits between them.
- **It does not predict what the stock will do** when the market works this out. That is a forecast,
  and it is usually wrong, and it is never ours to make.

---

## Attribution and disclaimer

Original work by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We
don't make buy or sell recommendations under any circumstance. Your decisions are your own.
