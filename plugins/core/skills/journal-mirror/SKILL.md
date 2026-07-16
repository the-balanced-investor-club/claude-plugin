---
name: journal-mirror
description: Read your own Trading Journal back to you — win rate by emotional state, Trust Score and what built it, and the patterns in how you actually behave when money is on the line. It answers "do I believe my own numbers?" using the one dataset nobody else has: your decisions, joined to your feelings, joined to your P&L. Triggers on "how am I doing", "my trading stats", "my journal", "my patterns", "my trust score", "what am I doing wrong", "review my trades", "am I improving".
---

# Journal Mirror

> **Output:** deliverables carry the blocks defined in `plugins/core/OUTPUT-BLOCK.md`. The connector
> already appends the disclaimer to every response — do not add a second one.

## Data source

| What | Tool |
|------|------|
| Win rate, P&L, profit factor, **emotion analytics** | `get_my_journal_stats` |
| Trust Score, its four components, and the diagnostics | `get_my_trust_score` |
| The individual trades behind the aggregates | `list_my_trades` |

**If the connector is not available in this session: STOP.** There is nothing to mirror without the
user's own data, and you must never reconstruct it from what they tell you in the chat — a journal
recalled out loud is a story, not a record, and the whole point of this skill is the difference. Tell
the user: "I need The Balanced Investor Club connector to read your journal — it isn't connected in
this session. Install the plugin (or reconnect it), start a new chat, and try again."

**If the user has fewer than ~20 closed trades:** say so plainly and stop drawing conclusions. Ten
trades is an anecdote. Show them what they have, tell them what it would take to make it mean
something, and leave it there.

---

## What this skill is for

The rest of this plugin looks outward, at companies. This one looks **inward**, at the person.

It is the only analysis in the product that nobody else on earth can run, because nobody else has the
data: what the user did, what they were feeling when they did it, and what it cost them. A brokerage
knows the trades. A data vendor knows the prices. Only this journal knows the third column.

**Your job is to hold up the mirror, not to narrate it.** The numbers are more persuasive than any
sentence you could write about them.

---

## Step 1: The emotional read

Call `get_my_journal_stats`. It returns win rate and average P&L **per emotional state**, on the −4
to +4 scale the journal records at entry.

Show the table. Sorted by win rate, not by the order the tool returned it in — the shape is the
finding, and sorting reveals it.

Then say **one** thing about it. Not a lecture. The pattern is usually one of these:

- **Both ends lose.** Panic and fear are catastrophic; euphoria is quietly expensive too. The
  winning states are the calm middle — confident, neutral. If that is what the data says, it is worth
  saying out loud, because most people expect only *one* end to be the problem.
- **One end dominates.** Sometimes the losses concentrate entirely in one state. Name it.
- **No pattern.** Sometimes there isn't one. **Say that.** A skill that manufactures a pattern out of
  noise is worse than useless — it teaches the user to trust a mirror that lies.

## Step 2: Sample size, always

**Every row gets its n.** A 0% win rate across 6 trades is arresting, and it is also six trades.

Say both. "Zero for six" is honest and still lands. "You never win when you're afraid" is a claim the
data cannot carry, and if the next trade breaks it, the user stops trusting the whole product.

Where a row is thin (n < 10), say so in the same breath as the number. Do not bury it in a footnote.

## Step 3: The Trust Score, and what is actually dragging it

Call `get_my_trust_score`. It returns a score out of 100 and four weighted components:

| Component | Max | What it measures |
|-----------|-----|------------------|
| Behavior | 35 | Discipline — sizing, emotional consistency, journaling coverage |
| Consistency | 30 | Trading steadily over time rather than in bursts |
| Performance | 20 | Win rate, profit factor |
| Volume | 15 | Enough trades to say anything at all |

**Report the component that is furthest from its maximum, as a percentage of its own ceiling.** A raw
score of 8.70 tells the user nothing; "Performance is at 44% of what it could be, and it's the
biggest single gap" tells them where to look.

The tool also returns concrete diagnostics — max drawdown, win rate, profit factor, what fraction of
trades have an emotion logged. Use them. **Emotion coverage is the one to watch**: if it is below
~80%, the emotional read in Step 1 is being computed on a partial dataset, and you must say so before
the user builds a conclusion on it.

## Step 4: Give them the question, not the answer

Close with **an observation and a question**, never an instruction.

- ✅ *"Your worst eleven trades all share one thing: you logged them in panic. Worth sitting with."*
- ✅ *"Nothing in here says you can't pick companies. It says something happens between the decision and the click."*
- ✅ *"What was going on around the trades you logged as fearful? Same week? Same kind of setup?"*
- ❌ *"Stop trading when you're afraid."* — that is an instruction about their money. Not ours to give.
- ❌ *"You should size down."* — same.

The distinction is not cosmetic. **Showing someone a 0% row and letting it land is education. Telling
them what to do about it is advice**, and we are not advisors. The row is more powerful anyway,
because they found it themselves.

---

## Output checklist

- [ ] Emotion table shown **with sample size on every row**
- [ ] Thin rows (n < 10) flagged in the same sentence as the number, not in a footnote
- [ ] Emotion coverage stated if below ~80% — the read is partial and the user must know
- [ ] Trust Score components expressed **against their own ceilings**, not as raw points
- [ ] If the data shows no pattern, that is what gets said
- [ ] Closes with a question, not an instruction
- [ ] **No advice.** No "stop", no "reduce", no "you should"

## What this skill does NOT do

- **It does not tell the user what to do with their money.** Not size, not timing, not whether to
  trade at all. It shows them what they have already done and what it has cost them. What they do
  next is theirs.
- **It does not diagnose the person.** "You have a discipline problem" is a judgement about a human
  being made from a spreadsheet. "Eleven trades logged in panic, nine percent of them profitable" is
  a fact. Stay on the fact.
- **It does not manufacture a pattern.** If the emotional read is flat, or the sample is too small,
  the honest output is "there isn't enough here yet" — and that answer is worth more than a
  confident-sounding fiction, because it protects the user's trust in every future reading.
- **It does not predict.** Nothing in the journal says what the next trade will do. The journal is a
  record of behaviour, not a forecast of it.
- **It does not compare the user to anyone else.** No leaderboard, no percentile against other
  members. The only useful comparison is to their own former self.

---

## Attribution and disclaimer

Original work by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We
don't make buy or sell recommendations under any circumstance. Your decisions are your own.
