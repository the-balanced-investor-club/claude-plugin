---
name: trade-log
description: >-
  Record a trade you have already made into your Trading Journal at The Balanced Investor Club — the ticker, the entry, the thesis you acted on, and how you felt when you pulled the trigger. Then close it later with an exit reflection and the lesson learned. This is the journal, not a broker: it records decisions, it never places them. Triggers on "log a trade", "journal this trade", "I bought", "I sold", "record my entry", "add to my journal", "close my trade", "I exited", "what did I learn".
---

# Trade Log

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

Everything here writes to and reads from **The Balanced Investor Club** connector. There is no other
source, and nothing here is computed locally.

| What | Tool |
|------|------|
| Record a new entry | `log_trade` |
| Close an open trade with a reflection | `close_trade` |
| Fix an entry you got wrong | `update_trade` |
| See what is open, and what the id is | `list_my_trades` |
| Check if the ticker is already on a tracker | `check_ticker_in_my_watchlists` |
| Resolve a company name to a ticker | `search_instruments` |

**If the connector is not available in this session: STOP.** Do not keep a trade log in a file, in a
table, or in the conversation. A journal that lives in a chat window is not a journal. Tell the user:
"I need The Balanced Investor Club connector to write to your journal — it isn't connected in this
session. Install the plugin (or reconnect it), start a new chat, and try again." A restart is often
required right after installing.

**Resolve names first.** If the user names a company rather than a ticker, call `search_instruments`
before anything else. Never guess a symbol.

---

## The one thing that makes this journal worth keeping

**The emotion is recorded at entry, before the outcome is known.**

That is the whole methodological point, and it is the only reason the data is worth anything. Anyone
can tell you, after a loss, that they felt uneasy about it. Almost nobody writes it down *first*.
When they do, the pattern that emerges is not a story they told themselves afterwards — it is
evidence.

So: **never ask how they feel about a trade whose outcome they already know.** If they are logging a
trade from three weeks ago and the position has already moved, ask what they felt *on the day they
entered*, and say why you are asking it that way. If they cannot remember honestly, it is better to
leave `emotional_state` empty than to fill it with hindsight. An empty field is missing data. A
remembered-through-the-outcome field is *wrong* data, and it will quietly poison the analysis.

---

## Step 1: Log the entry

`log_trade` takes:

| Field | Required | Notes |
|-------|----------|-------|
| `ticker` | ✅ | Stocks, ETFs and crypto pairs (`AAPL`, `SPY`, `BTC-USD`) |
| `direction` | ✅ | `Long` or `Short` — exactly these two strings |
| `entry_date` | ✅ | ISO: `YYYY-MM-DD` |
| `entry_price` | ✅ | Per share/unit, greater than zero |
| `quantity` | ✅ | Greater than zero |
| `emotional_state` | | **A number from −4 to +4.** See the scale below |
| `thesis` | | Why they took it. Max 500 chars |
| `notes` | | Anything else. Max 1000 chars |
| `confirm_duplicate` | | Set `true` only if the user confirms a same-ticker, same-date, same-direction trade is deliberate |

### The emotional scale — it is numeric, not a word

```
 -4  Panic          -1  Uneasy          2  Confident
 -3  Fearful         0  Neutral         3  Very Confident
 -2  Anxious         1  Calm            4  Euphoric
```

Pass the **number**. Ask the question in plain language — *"how did you feel when you hit buy?"* —
and map their answer to the scale yourself. Do not read them a nine-point list; that is a form, not
a conversation.

### What to ask, and what not to

Ask for the four required fields. Ask for the thesis in one line — *"what were you seeing?"* Ask how
they felt.

**Do not ask whether the trade was a good idea.** Do not offer an opinion on it. They have already
made it. Your job here is to record it accurately, not to grade it.

## Step 2: Confirm what was written

Read back what you logged, in one line. If the user is logging several trades, log them one at a
time and confirm each — a journal with a wrong entry price is worse than no journal, because the
error is invisible later.

If they got something wrong, `update_trade` fixes `entry_price`, `quantity`, `thesis`, `notes` and
`emotional_state`. It needs the `trade_id`, which comes from `list_my_trades`.

## Step 3: Close it, when the time comes

`close_trade` is where the loop closes, and it is the most valuable call in this skill:

| Field | Required | Notes |
|-------|----------|-------|
| `exit_price` | ✅ | |
| `exit_date` | ✅ | ISO |
| `trade_id` | | Preferred. From `list_my_trades` |
| `ticker` | | Works instead of `trade_id` **only** if there is a single open trade on it |
| `emotional_state` | | The same −4…+4 scale — how they felt **exiting** |
| `exit_reason` | | Why they got out. Max 200 chars |
| `lesson_learned` | | **The reflection.** Max 1000 chars |

**Ask for the lesson. Every time.** Not as a checkbox — as a real question, and one that is easier to
answer if you make it specific:

- *"Did it play out for the reason you wrote down, or for a different one?"*
- *"If you saw this same setup tomorrow, what would you do differently?"*
- *"Was the exit planned, or did something make you move?"*

A trade closed without a lesson is a transaction. A trade closed with one is a data point. The
difference compounds.

**A winning trade still has a lesson.** Being right for the wrong reason is the most expensive habit
in investing, and the only place it can ever be caught is here — at the exit, in writing, while the
memory is still honest.

---

## Output checklist

- [ ] Names resolved through `search_instruments` — no guessed tickers
- [ ] Emotion asked about the moment of **entry**, not coloured by what happened since
- [ ] `emotional_state` passed as a **number** between −4 and +4, not a word
- [ ] What was written is read back to the user
- [ ] On close: the lesson was **asked for**, not skipped
- [ ] **No opinion offered on the trade itself** — no verdict, no rating, no "good call"
- [ ] The connector's own disclaimer is present (it appends automatically — do not duplicate it)

## What this skill does NOT do

- **It does not place trades.** It has no broker, no order routing, no execution. It writes rows to a
  journal about decisions the user has already made, with their own money, on their own account.
- **It does not tell anyone what to trade.** If the user asks "should I buy this?", the answer is
  that we are educators, not advisors, and we do not make that call for anyone. Then offer what we
  *can* do: show them what their own journal says about how they behave in situations like this one.
- **It does not judge the trade.** Not "good entry", not "risky", not "well timed". The journal is a
  mirror, not a referee. The user's own numbers will say more than any opinion could.
- **It does not invent an emotion.** If the user cannot honestly recall how they felt at entry, the
  field is left empty. Missing data is recoverable. Fabricated data corrupts the one analysis in this
  product that nobody else can do.
- **It does not delete.** There is no delete in the journal by design — a record you can erase after
  a bad outcome is not a record. A trade entered by mistake can be corrected with `update_trade`.

---

## Attribution and disclaimer

Original work by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We
don't make buy or sell recommendations under any circumstance. Your decisions are your own.
