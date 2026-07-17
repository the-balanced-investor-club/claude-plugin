---
name: ownership-context
description: Read who owns a company and what they have been doing — insider transactions and institutional 13F holdings — and teach the reader to see through the headlines. Most insider "buying" is an option exercise, and most 13F data is a quarter stale. Context, never a signal. Triggers on "insider buying", "insider selling", "who owns this", "institutional ownership", "are insiders buying", "13F", "what are the funds doing", "smart money".
---

# Ownership Context

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

| What | Tool |
|------|------|
| Who bought or sold, role, shares, price (up to 100, newest first) | `get_insider_transactions` |
| Institutional holders, ownership %, increased vs decreased, top holders | `get_institutional_holdings` |
| Market cap, to size a transaction against the company | `get_fundamentals` |
| Resolve a company name to a symbol | `search_instruments` |

Both are **individual companies only** — not ETFs, not crypto.

**If the connector is not available in this session: STOP.** Do not recall who owns what. Tell the
user: "I need The Balanced Investor Club connector for ownership data — it isn't connected in this
session. Install the plugin (or reconnect it), start a new chat, and try again."

**Do not use web search for market data. Ever.**

---

## Purpose

*"Insiders are buying!"* is one of the most misleading headlines in finance, and the data to see
through it is right here. This skill exists to teach a reader to read the table themselves.

The tool's own description says it: **"executives sell for taxes, diversification and personal
reasons."** Take that seriously. It is not a disclaimer — it is the finding.

---

## The tell: an exercise-and-sell looks exactly like a purchase

Read the **price** column and the **share counts**, not the Buy/Sell label.

A real pull for KO, all on **the same day**:

```
2026-06-09  MANN, JENNIFER K  EVP  Buy   55.15K  @ \$61.34   ← well below market
2026-06-09  MANN, JENNIFER K  EVP  Sell  55.15K  @ \$80.75   ← at market. Same count. Same day.
2026-06-09  MANN, JENNIFER K  EVP  Buy   18.83K  @ \$50.44
2026-06-09  MANN, JENNIFER K  EVP  Sell  18.83K  @ \$80.75   ← same again
```

That is **not** an executive buying stock. It is an **option exercise and immediate sale**: buy at
the strike, sell at the market, same day, same number of shares. The "Buy" rows are the strike price.
The cash never touched an investment decision.

**The three tells, in the order you should check them:**

1. **A Buy and a Sell of the identical share count on the same day.** That is the exercise, and the
   sale funding it. **This is the most reliable tell, and the only one that always works.**
2. **A "Buy" priced well below the market price.** Nobody buys shares at a discount on the open
   market. That is a strike price.
3. **A "Buy" with no price at all** (`—` in the table). **This is not a gap in the data — it is
   evidence.** An option exercise is often reported without a market price *precisely because no
   market transaction happened*. Treat an unpriced "Buy" as suspect by default, not as a row to skim
   past.

A real pull for AAPL:

```
2026-06-15  NEWSTEAD, JENNIFER  SVP, GC  Buy   30.10K  —
2026-06-15  NEWSTEAD, JENNIFER  SVP, GC  Sell  30.10K  —
2026-06-15  BORDERS, BEN        PAO      Buy     240   —
2026-06-15  BORDERS, BEN        PAO      Sell    240   —
```

Same day. Identical counts. **No price on either side.** Tell 2 cannot fire here — there is no price
to compare. Tells 1 and 3 both do, and between them the picture is unambiguous: **nobody bought
anything.**

**And the closing rule: if none of the three can be evaluated, say you cannot evaluate it.** Do not
turn an absence of evidence into evidence.

When you see this, say what it is. A reader who learns to spot a paired same-day exercise has learned
something they will use for the rest of their life, and it takes one sentence.

## Uniform, same-day transactions across several directors

If four directors each acquire exactly the same number of shares on the same date, that is a **board
grant** — scheduled compensation, decided months earlier. It says nothing about anyone's view of the
company. Say so.

## What *would* be interesting

A genuine open-market purchase, at or near the market price, unpaired, by someone with real
information. It is rare. **When you find one, say it is rare, and still do not call it a signal** —
insiders are wrong about their own companies with great regularity, and the research on whether their
buying predicts anything is a good deal weaker than the folklore.

Size it: is this large against the person's own holding? Against the company's market cap? A \$2m
purchase in a \$360bn company is a rounding error, however confident it looks.

---

## Institutional holdings: read the split, not the headline

`get_institutional_holdings` returns holders, ownership %, and — the useful part — **how many
increased versus decreased**.

A real pull for KO:

```
Institutional ownership   84%
Holders that increased    1.68K
Holders that decreased    1.57K
```

Eighty-four percent institutional ownership sounds like conviction. **It is not.** Sixteen hundred
funds bought and fifteen hundred sold. That is **near-parity — an absence of consensus**, dressed up
as a number that sounds like agreement.

**Always report increased against decreased.** The single ownership percentage, alone, tells a reader
almost nothing except that the company is large enough to be in the indices.

### ⚠️ The data is stale, and by more than you think

13F filings are **at least one quarter behind**. In practice it is worse: a single pull showed
Vanguard's position reported as of `2025-12-31` while others were `2026-03-31` — **six months old**,
sitting in the same table as three-month-old rows, with no visual difference.

**State the `Reported` date on every holder you cite.** A fund may have sold the entire position the
day after it filed, and you would have no way of knowing.

### A zero-percent change is not a decision

Berkshire's KO position showed `0.00%` change. That means they did nothing this quarter. It is not
conviction, and it is not doubt. It is the absence of an event, and it must not be narrated as
though it were one.

---

## Output checklist

- [ ] Paired same-day Buy/Sell of identical size named as an **exercise-and-sell** — the tell that always works
- [ ] Insider "Buy" rows checked **against the market price** — below-market means a strike
- [ ] **An unpriced "Buy" treated as evidence, not as a gap** — no market price often means no market transaction
- [ ] Where none of the three tells can be evaluated, **that is said**, not glossed over
- [ ] Uniform same-day transactions across directors named as **compensation**
- [ ] Any genuine open-market purchase **sized** against the company and the holder
- [ ] Institutional: **increased vs decreased reported**, never the ownership % alone
- [ ] The **`Reported` date** stated for every holder cited — some are two quarters stale
- [ ] **No inference drawn about what the stock will do**

## What this skill does NOT do

- **It does not treat insider buying as bullish.** The tool says executives sell for many reasons;
  they buy for several too, and most of what looks like buying is not.
- **It does not follow the smart money.** A 13F is a photograph of a position that may no longer
  exist, taken months ago, by someone with a mandate and a time horizon that are not the reader's.
- **It does not read a high ownership percentage as conviction.** Index funds own everything. That is
  what index funds do.
- **It does not turn an absence of evidence into evidence.** When the price column is empty and the
  counts do not pair, the honest answer is that you cannot tell what this transaction was. Say it.
- **It does not narrate a non-event.** A holder at 0.00% change did nothing, and "Buffett is holding
  firm" is a story imposed on an empty cell.
- **It does not turn ownership into a decision.** This is context — who is around the table. It is
  never a reason to do anything, and it must never be presented as one.

---

## Attribution and disclaimer

Original work by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We
don't make buy or sell recommendations under any circumstance. Your decisions are your own.
