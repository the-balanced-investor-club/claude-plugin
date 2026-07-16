---
name: mood-regime
description: Read the Market Mood — The Balanced Investor Club's behavioural signal, built from how short and long-term moving averages align. Shows a single instrument's mood against the distribution of its whole sector, so the user can tell an idiosyncratic move from a sector-wide re-rating, and noise from a trend. Educational, never predictive. Triggers on "market mood", "what's the mood", "how is the market feeling", "mood for", "what changed today", "market pulse", "is this a trend", "golden cross", "what's moving".
---

# Market Mood

> **Output:** deliverables carry the blocks defined in `plugins/core/OUTPUT-BLOCK.md`. The connector
> already appends the disclaimer to every response — do not add a second one.

## Data source

| What | Tool |
|------|------|
| One instrument: mood, history, change rate, detected patterns | `get_mood_for_ticker` |
| The distribution across a sector, industry or asset type | `list_market_moods` |
| Instruments whose mood **flipped in the last 24h** | `get_today_mood_changes` |
| The whole-market snapshot | `get_market_pulse` |
| Resolve a company name to a symbol | `search_instruments` |

**If the connector is not available in this session: STOP.** Market Mood is a proprietary read — it
does not exist anywhere else, and you cannot reconstruct it from a price chart or from memory. Tell
the user: "I need The Balanced Investor Club connector for the mood — it isn't connected in this
session. Install the plugin (or reconnect it), start a new chat, and try again."

**Do not use web search for market data. Ever.**

---

## What the mood actually is

The mood is **a description of moving-average alignment**, computed daily. Nothing more.

`Strong Bullish` · `Bullish` · `Neutral` · `Bearish` · `Strong Bearish`

It is **not a forecast**. It says where the averages sit today, not where the price goes tomorrow. It
is backward-looking by construction, because a moving average is an average of things that already
happened.

Say this plainly the first time a user meets it. Not as a disclaimer — as the actual explanation.
Someone who thinks "Strong Bullish" is a prediction will misread everything that follows, and they
will blame the tool, correctly.

⚠️ **It lags by up to one session.** Mood snapshots refresh on a daily cycle. For the freshest price,
use `get_close_history`. Never present a mood as though it were live.

---

## The rule: never show one mood without its distribution

**A single instrument's mood is almost meaningless on its own.** The number that gives it meaning is
what the rest of its sector is doing.

Always call **both**: `get_mood_for_ticker` for the instrument, and `list_market_moods` filtered to
its sector for the backdrop. `list_market_moods` returns the full distribution across the filter, not
just the rows shown — use it.

The question the user actually cares about is not "is my stock bullish?" It is:

> **Is this move its own, or is the whole sector being re-rated around it?**

If the instrument is Bullish and 45% of its sector is too, the answer is: **this is not about your
company.** That is a genuinely useful thing to learn, and it is invisible without the distribution.

## The rule: lead with the change rate, not the label

`get_mood_for_ticker` returns a **change rate** and a **momentum** flag over the recent history. Read
them before you read the mood, because they tell you whether the mood is worth reading at all.

A change rate of 40% means the label flipped in four of the last ten readings. That is not a trend.
That is a moving average crossing back and forth over a price that is going sideways, and the label
is chasing it.

**When the change rate is high, say so first.** "It's Bullish today, and it's been Bullish, Neutral,
Bullish, Neutral for the last two weeks" is the honest sentence. "It's Bullish" is technically true
and quietly misleading.

### And when the change rate is ZERO, say that first too — for the opposite reason

This is the case that will catch you, because it does not look like a problem. It looks like an
answer.

A real pull for AAPL:

```
Latest mood:  Strong Bullish
Change rate:  0%   ·   Momentum: STABLE
Distribution (last 10 readings):  Strong Bullish: 10 · everything else: 0
```

**Ten out of ten. Never changed. Perfectly stable.** It is the most persuasive reading the tool can
produce, and it is exactly the one a reader will take as *proof*.

**It is not proof of anything.**

> **A change rate of 0% is not a strong signal. It is a signal with no information in it.**
>
> Ten identical readings mean the indicator **has not changed its mind** — not that it is right. A
> moving average that has stayed aligned is describing the past with more confidence, not the future
> with any.

And notice the trap the pair of them sets: a **noisy** mood is easy to distrust, and this skill spends
half a page teaching you to. A **unanimous** mood is almost impossible to distrust, and that is
precisely why it needs the warning more.

**When the change rate is low, do two things:**
1. **Say how long it has been that way.** "Strong Bullish for ten straight readings" is the fact.
2. **Say what happened the last time it broke.** If the history does not go back far enough to
   answer that, say *that* — an unbroken streak in a short window is a short window, not a streak.

## Detected patterns: treat a repeat as evidence of noise

The tool surfaces patterns like **Golden Cross** — a short MA crossing above a long one.

**Check the dates.** Two Golden Crosses inside a week are not two signals; they are one average
oscillating around another. The pattern list is a fact about the maths, and when it fires repeatedly
in a short window, **that repetition is the finding** — it is the tool telling you the instrument has
no trend to speak of.

Never present a Golden Cross as a bullish event. It is a description of two lines crossing. What it
has meant historically, for this instrument, is the interesting question — and the change rate is
what answers it.

## Today's changes

`get_today_mood_changes` returns **transitions only** — instruments whose label flipped in the last
24 hours. It is not a list of price movers, and it is not a list of anything to do.

**An empty result is normal on a quiet day, and is not a failure.** When it comes back empty, say
that markets were quiet on the mood dimension and fall back to `list_market_moods` with
`only_with_changes: true` for the most recent cycle of transitions.

---

## Output checklist

- [ ] The mood is explained as **MA alignment**, not as a prediction, the first time it appears
- [ ] Single-instrument mood is **never shown without its sector distribution**
- [ ] Change rate and momentum reported **before** the label
- [ ] **A change rate near zero flagged as "no new information", not as a strong signal**
- [ ] Repeated patterns inside a short window flagged as noise, not as signals
- [ ] The one-session lag stated if the user is looking at anything time-sensitive
- [ ] An empty `get_today_mood_changes` reported as a quiet day, not as an error
- [ ] **No implication that any mood is a reason to act**

## What this skill does NOT do

- **It does not predict.** The mood is an average of the past. It has no view on tomorrow, and any
  sentence that gives it one is a fabrication. "Strong Bullish" describes two lines; it does not
  describe a future.
- **It does not read unanimity as proof.** Ten identical readings mean the indicator has not changed
  its mind. It does not mean the indicator is right. **The more one-sided the data looks, the more
  carefully this has to be said** — a noisy signal defends against itself, and a unanimous one does
  not.
- **It does not turn a mood into a recommendation.** Not "Strong Bullish names to look at", not "the
  bearish ones to avoid". A mood-filtered list is a list of instruments whose averages are aligned a
  certain way, and it must never be presented as a shortlist of anything else.
- **It does not report a Golden Cross as good news.** It is a crossing. Whether it has ever meant
  anything for this instrument is an empirical question, and the change rate usually answers it: no.
- **It does not show a single mood in isolation.** Without the distribution, a mood is a number
  without a denominator, and it will be misread every time.
- **It does not claim to be live.** The snapshot can lag the close by a session, and the user is told
  so whenever it could matter.

---

## Attribution and disclaimer

Original work by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We
don't make buy or sell recommendations under any circumstance. Your decisions are your own.
