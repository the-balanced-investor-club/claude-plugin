---
name: stock-tracker
description: Manage your Stock Trackers at The Balanced Investor Club — create a tracker, add or remove instruments, see what you already follow, and browse the official trackers curated by the research team. A tracker is where you keep the companies you are watching, so the briefing and the mood alerts know what you care about. Triggers on "add to my tracker", "add to my watchlist", "watch this stock", "keep an eye on", "my trackers", "my watchlist", "what am I following", "create a tracker", "remove from my tracker", "follow this list".
---

# Stock Tracker

> **Output:** deliverables carry the blocks defined in `../../OUTPUT-BLOCK.md`.

## Data source

| What | Tool |
|------|------|
| What the user owns and follows | `get_my_watchlists` |
| Create a tracker | `create_watchlist` |
| Add an instrument | `add_to_watchlist` |
| Remove an instrument | `remove_from_watchlist` |
| Is this ticker already tracked? | `check_ticker_in_my_watchlists` |
| Browse the official trackers | `discover_community_watchlists` |
| Open one and see its constituents | `get_watchlist_by_slug` |
| Follow a public one | `follow_watchlist` |
| Resolve a company name to a symbol | `search_instruments` |

**If the connector is not available in this session: STOP.** Do not keep a list of tickers in the
conversation and call it a tracker. A tracker that lives in a chat window feeds nothing — not the
briefing, not the mood alerts, not the journal. Tell the user: "I need The Balanced Investor Club
connector to manage your trackers — it isn't connected in this session. Install the plugin (or
reconnect it), start a new chat, and try again."

---

## Purpose

A Stock Tracker is not a list. It is **the input to everything else in the product**: the daily
briefing reads it, the mood alerts fire from it, and the journal checks against it. A user with no
tracker gets a generic product. A user with a good tracker gets theirs.

So the job here is not "add the ticker". It is to make the tracker say something — which usually
means asking one question the user did not expect.

---

## The three things that will trip you up

These come from the tool schemas, and getting them wrong fails the call:

**1. `asset_type` is required to add, and it is not optional.**
`add_to_watchlist` needs `stock` | `etf` | `crypto` | `forex`. So does
`check_ticker_in_my_watchlists`. **Never guess it.** Resolve the instrument with
`search_instruments` first and take the type from there. `SPY` is an `etf`, not a `stock`, and the
call will behave differently if you assume.

⚠️ **Lowercase it.** `search_instruments` reports the type as `ETF` / `Stock`; the `asset_type` enum
only accepts `etf` / `stock`. Passing it straight through fails.

**2. `ma_type` decides how the mood is read for that item.**
It defaults to `EMA`; the alternative is `SMA`. This is not cosmetic: the instrument's mood on the
platform is computed from moving-average alignment, so the MA type chosen here is the lens through
which the user will see this company from now on. Leave the default unless the user asks — and if
they do ask, tell them what it changes.

**3. Removing is permanent.**
The tool says it plainly: *"This action cannot be undone."* **Confirm the ticker and the tracker by
name before calling it.** Read it back. There is no undo, and a tracker quietly missing a company is
worse than an obviously empty one.

## Step 1: Check before you add

Call `check_ticker_in_my_watchlists` first. If the ticker is already somewhere, say where, and ask
whether they meant a different tracker — do not silently add a second copy across two lists and leave
them with a mood alert firing twice.

## Step 2: Add, or create then add

`create_watchlist` takes `name` (required, unique per user), `description`, `is_public`, and
`alert_frequency` (`none` | `daily` | `weekly` | `monthly`, default `none`).

**Ask what the tracker is *for* before naming it.** "Tech" is a tracker that will be abandoned in a
month. "Companies whose moat I don't believe in" is one that will still be useful in a year, because
it has a question inside it.

If the user is on the free plan they get three trackers. If a create call comes back refused on those
grounds, say so plainly and without a sales pitch — tell them which trackers they already have, and
that they can reuse one.

## Step 3: Say what the tracker now does

After a successful add, tell them what changed — not "added AAPL to Tech". Something like: *"AAPL is
on 'Moats I doubt'. It'll show up in your briefing, and you'll see it when its mood shifts."* The
user should leave knowing the tracker is wired into something, because it is.

## Following the official trackers

`discover_community_watchlists` returns the trackers curated by the research team (23 of them: S&P
500 Core, Dividend Yield, AI & Tech Infrastructure, Biotechnology, Aerospace & Defense,
Transportation, and more), each with a **slug**.

`follow_watchlist` takes the **slug**, not the name and not an id. Get it from `discover_community_watchlists` or `get_watchlist_by_slug`.

**A curated tracker is a place to look, not a list to buy.** When you surface one, describe what it
*is* — "fifteen large caps with a long dividend record" — and never what it implies. The user is
following a lens, not a portfolio.

---

## Output checklist

- [ ] `asset_type` resolved via `search_instruments`, never assumed
- [ ] `check_ticker_in_my_watchlists` called before adding
- [ ] Removals read back and confirmed **before** the call — there is no undo
- [ ] Tracker names questioned, not just accepted
- [ ] The user is told what the tracker now feeds (briefing, mood)
- [ ] **No opinion on the companies themselves.** Not "good addition", not "solid list"

## What this skill does NOT do

- **It does not tell anyone what to track.** If asked "what should I be watching?", say that we are
  educators, not advisors, and we do not pick for anyone. Then offer what we can: the official
  trackers, so they can see what a research team put together and decide for themselves; or their own
  journal, so they can see what they already keep coming back to.
- **It does not read a tracker as a buy list.** A company being on a tracker means someone is
  watching it. It means nothing else, and it must never be reported as though it did.
- **It cannot delete a tracker, rename one, or unfollow one.** The connector exposes create, add,
  remove and follow — and nothing else. If the user wants to delete or rename, say so honestly and
  send them to `thebalancedinvestorclub.com/stock-tracker`. **Do not fake it** by emptying a tracker
  of its items and calling it deleted.
- **It does not set up alerts it cannot see.** `alert_frequency` is a paid feature. If the user is on
  the free plan, the field will not take effect — do not promise them a daily alert that will never
  arrive.
- **It does not judge the tracker.** No "well diversified", no "heavy in tech". Those are portfolio
  opinions wearing a description's clothes.

---

## Attribution and disclaimer

Original work by The Balanced Investor Club.

Educational content. Not investment advice or recommendations. We're educators, not advisors. We
don't make buy or sell recommendations under any circumstance. Your decisions are your own.
