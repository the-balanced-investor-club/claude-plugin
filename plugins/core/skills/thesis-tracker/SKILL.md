---
name: thesis-tracker
description: Keep an investment thesis honest over time. Writes down what you believe and — crucially — what would prove you wrong, then tracks the evidence against it, weighting disconfirming evidence as heavily as the confirming kind. Reads the theses you already wrote when you logged your trades. Triggers on "my thesis", "is my thesis still intact", "thesis check", "why did I buy this", "what would prove me wrong", "review my reasoning", "has anything changed".
---

# Thesis Tracker

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

The user's theses **already exist**. They wrote them when they logged the trade.

| What | Tool |
|------|------|
| The theses they wrote at entry, and the lessons at exit | `list_my_trades` |
| Whether the pattern is in the person, not the position | `get_my_journal_stats` |
| Update a thesis as it evolves | `update_trade` (the `thesis` field) |
| What is coming that could test it | `get_market_calendar`, `catalyst-calendar` |
| What management said, against what the numbers did | `transcript-vs-numbers` |
| What the price already assumes | `reverse-dcf` |
| The names they are watching | `get_my_watchlists` |

**If the connector is not available in this session: STOP.** A thesis tracked in a chat window is a
thesis that will be quietly rewritten after the outcome is known — which is precisely the failure
this skill exists to prevent. Tell the user: "I need The Balanced Investor Club connector to read the
theses in your journal — it isn't connected in this session. Install the plugin (or reconnect it),
start a new chat, and try again."

---

## Purpose

> **A thesis you cannot be wrong about is not a thesis. It is a feeling with a ticker attached.**

The single most valuable thing this skill does is force the sentence nobody writes voluntarily:
**what would make me wrong?**

Everything else follows from it. A pillar you cannot test is decoration. A catalyst that cannot
disappoint you is a date in a diary. And an update log that only records good news is a machine for
manufacturing conviction.

---

## Step 1: Read what they already wrote

Before asking for anything, call `list_my_trades` and look at the `thesis` field. Most users have
already written the thesis and forgotten it — that is the entire problem, and reading it back to them
is often the whole session.

For a closed trade, read the `lesson_learned` too, and put it next to the thesis. **The gap between
what someone believed at entry and what they concluded at exit is the most educational two lines in
this product.**

## Step 2: Build it so it can break

A thesis has four parts, and only one of them is optional:

| Part | Required | What it is |
|------|----------|------------|
| **The claim** | ✅ | One or two sentences. What has to be true. |
| **The pillars** | ✅ | 3–5 supporting arguments. Each must be **checkable** — a number, a threshold, a date. |
| **The falsifiers** | ✅ | **What specifically would prove this wrong.** Not "competition could increase" — that is a platitude. *"If gross margin has not reached 22% by FY28, the pillar is gone."* |
| **The catalysts** | | Events that will test it, and roughly when. |

**Refuse a pillar you cannot test.** "Great management" is not a pillar. "Management said margins
reach 22% by FY28, and they have hit their last three targets" is one, and it has a date on it.

Push back once, kindly, and explain why: a pillar that cannot fail cannot inform anything, and it
will still be sitting there in three years, doing nothing but reassuring its author.

**There is no Position field, no Target price, and no Stop-loss.** A thesis is a claim about a
business. What the user does about it is theirs, is not written here, and is not our business.

## Step 3: Log the evidence — both kinds

For each new development:

| Field | What goes in it |
|-------|-----------------|
| **Date** | |
| **What happened** | The fact. Sourced. |
| **Which pillar it touches** | Name it, or it is not evidence — it is news. |
| **Which way it cuts** | Supports / undermines / **neither** |
| **Does it hit a falsifier?** | The question that gets skipped, and the only one that matters |

**Track disconfirming evidence as rigorously as the confirming kind, and show them side by side.**

The failure mode is not stupidity — it is asymmetry. Good news gets logged, bad news gets explained
away as noise, and after a year the log "proves" a thesis that was dead by spring. **If the
disconfirming column is empty, that is a finding about the log, not about the company.** Say so.

**There is no Action field and no Conviction rating.** "Increase / Trim / Exit" is a buy-sell-hold
call in a different jacket, and a conviction score is a rating. Neither belongs here, and neither is
needed: a scorecard that shows three pillars breaking says everything a conviction score would, and
it says it with evidence.

## Step 4: The scorecard

| Pillar | What I expected | What has happened | Falsifier hit? |
|--------|-----------------|-------------------|----------------|
| Revenue growth >20% | 20%+ through FY27 | Q3 came in at 22% | No |
| Margin expansion | 22% by FY28 | Flat YoY for four quarters | **Approaching** |
| New product ships | Q1 launch | Slipped to Q2 | No — but watch |

**Review it on a schedule, not on a mood.** Quarterly, even when nothing has happened — *especially*
when nothing has happened. A thesis nobody has looked at in a year is not intact. It is unexamined,
and those are different things.

## Step 5: Close the loop with the journal

When a thesis is finished — right or wrong — the lesson belongs in the journal, on the trade, via
`close_trade`'s `lesson_learned`. That is where it compounds. A reflection written in a chat window
disappears; one written to the journal shows up the next time they look at their own patterns.

**And check the person, not just the position.** Call `get_my_journal_stats`. If a thesis broke on a
trade the user logged in panic, the thesis may not have been the problem. That is the most useful
thing this skill can tell anyone, and it is only visible because both halves live in the same place.

---

## Output checklist

- [ ] Existing theses **read from the journal** before anything new is written
- [ ] Every pillar is **checkable** — a number, a threshold, a date
- [ ] **Falsifiers written**, specific and checkable. A thesis without one is refused
- [ ] Disconfirming evidence logged and shown **beside** the confirming kind
- [ ] An empty disconfirming column **flagged as a problem with the log**
- [ ] **No Position. No Target price. No Stop-loss. No Action. No Conviction rating.**
- [ ] The lesson written back to the journal when a thesis closes

## What this skill does NOT do

- **It does not say whether to hold, add or sell.** Not as an "Action", not as a "conviction level",
  and not implied by tone. It tells the user whether their reasoning is still standing. What they do
  about it is theirs, and we would be wrong to guess.
- **It does not rate conviction.** High / Medium / Low is a rating scale attached to a security. Show
  the scorecard instead: it carries the same information, with the evidence still attached.
- **It does not accept an untestable pillar.** "Strong brand" is a belief. It has no falsifier, so it
  can never be wrong, so it can never teach the user anything.
- **It does not let a broken thesis quietly become a new one.** If the pillars have failed and the
  user is still holding, that is worth naming plainly — not as a criticism, but because rewriting the
  thesis to fit the position is the single most common way an investor lies to themselves, and they
  will not see themselves doing it.
- **It does not predict the catalyst.** It records that one is coming and what it would prove.

---

## Attribution and disclaimer

Original work by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We
don't make buy or sell recommendations under any circumstance. Your decisions are your own.
