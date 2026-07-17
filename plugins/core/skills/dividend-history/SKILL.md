---
name: dividend-history
description: Read a company's dividend history — ex-dividend dates, payment dates, and amount per share — and what it says about the payout over time. Computes yield from the price, because the dividend tool does not return it. Stocks and distributing ETFs only. Triggers on "dividends", "dividend history", "what does it pay", "dividend yield", "ex-dividend date", "did they raise the dividend", "income", "payout".
---

# Dividends

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

| What | Tool |
|------|------|
| Ex-dividend date, payment date, amount per share (up to 40) | `get_dividends` |
| The current price — **needed for yield; the dividend tool does not return it** | `get_close_history` |
| Payout ratio, EPS, and the rest of the picture | `get_fundamentals` |
| Cash actually generated, to test whether the payout is funded | `get_cash_flow` |
| Resolve a company name to a symbol | `search_instruments` |

**If the connector is not available in this session: STOP.** Do not recall a dividend from memory —
payouts get raised, cut and suspended, and a remembered figure is a figure from an unknown year. Tell
the user: "I need The Balanced Investor Club connector for dividend history — it isn't connected in
this session. Install the plugin (or reconnect it), start a new chat, and try again."

**Do not use web search for market data. Ever.**

---

## The tool does not return yield. You compute it, or you say nothing.

`get_dividends` returns **amounts and dates only**. Its own response says so: *"Dividend yield —
which depends on price — arrives in a later iteration."*

So yield requires two calls, and a decision you must make explicitly:

```
Trailing yield  =  sum of the last four quarterly payments  ÷  current price
Forward yield   =  most recent payment × 4                  ÷  current price
```

**These are different numbers, and the gap between them is the story.** A company that just raised
its dividend has a forward yield above its trailing one — and quoting the trailing figure hides the
raise. A company that just cut it has the opposite, and quoting the trailing figure hides the cut,
which is worse.

**Say which one you computed, and why.** "2.9% on the last twelve months' payments; 3.0% if the
current rate holds" is honest. A single unlabelled percentage is not.

## Ex-dividend, not payment date

The **ex-dividend date** is the one that matters: own the shares before it, and the payment is yours.
The **payment date** is just when the cash lands, weeks later.

Users routinely confuse the two and think they can buy the day before payment. Say which is which the
first time both appear.

## Read the sequence, not the last number

The value is in the series. Lay it out and look for the shape:

- **A raise.** KO went from \$0.51 to \$0.53 per quarter between December and March. That is a 3.9%
  increase, and it is a decision the board made and announced — a fact, not an omen.
- **A flat line.** Years of the same amount is a dividend being eroded by inflation in real terms,
  even though the nominal number never falls.
- **A cut, or a skipped quarter.** Look for it. It is the single most informative event in a dividend
  history, and it is easy to miss when you only read the top row.
- **Irregular amounts.** Common in ETFs and some non-US payers. Do not annualize a special dividend
  by multiplying it by four — that manufactures a yield that does not exist.

## Is the payout funded?

The question a dividend history alone cannot answer: **is the company paying this out of cash it
actually earns?**

`get_cash_flow` and `get_fundamentals` are how you check. A payout ratio above 100%, or a dividend
larger than free cash flow, means the payment is coming from somewhere other than the business —
debt, or the balance sheet.

**That is an observation, not a warning.** Report the ratio and what it means arithmetically. Do not
predict a cut; companies fund dividends from reserves for years, deliberately, and calling it is a
forecast dressed as prudence.

---

## Output checklist

- [ ] Yield **labelled** trailing or forward, never bare — and the gap explained if they differ
- [ ] Yield computed from a real price via `get_close_history`, never estimated
- [ ] **Ex-dividend** date distinguished from **payment** date the first time both appear
- [ ] The **sequence** read, not just the latest payment — raises, cuts and flat lines named
- [ ] Special or irregular dividends never annualized by ×4
- [ ] Funding checked against cash flow when the user is thinking about durability
- [ ] **No verdict on whether the payout is attractive, safe, or worth owning**

## What this skill does NOT do

- **It does not say whether a dividend is worth buying for.** Not "an attractive yield", not "a
  reliable payer", not "solid income". Those are recommendations with a percentage sign attached.
- **It does not predict a cut or a raise.** A high payout ratio is arithmetic. A future dividend
  decision is a board's, made on information nobody in this conversation has.
- **It does not quote a yield it did not compute.** The tool does not return one. If the price is
  unavailable, say the yield is unavailable — do not estimate it from a price you think you remember.
- **It does not annualize a one-off.** A special dividend multiplied by four is a fiction, and it is
  the most common way a yield gets overstated.
- **It does not treat dividend history as a promise.** The tool says it plainly: *past dividends are
  not a guide to future payouts.* Neither is a fifty-year streak.

---

## Attribution and disclaimer

Original work by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We
don't make buy or sell recommendations under any circumstance. Your decisions are your own.
