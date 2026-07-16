# The Balanced Investor Club for Claude

**26 skills. Not one of them tells you what to buy.**

A trading journal that records the thesis *and* how you felt when you took the trade. A reverse DCF
that asks what the price already assumes, instead of announcing what a company is worth. An
earnings-call reader that puts what management said next to what the statements did. And real market
data on 13,000+ instruments behind all of it.

You sign in once. No API keys, no terminal subscription.

> Educational content. Not investment advice or recommendations. We're educators, not advisors. We
> don't make buy or sell recommendations under any circumstance. Your decisions are your own. Nothing
> here executes transactions.

## What's inside

| Area | Skills | Examples |
|---|---|---|
| **Your journal** | 4 | `/journal` `/mirror` `/thesis` `/tracker` — log a trade with the thesis and the emotion, then find out which of the two predicted the outcome |
| **Only in the plugin** | 3 | `/valuation` `/ownership` `/call` — a reverse DCF, an insider table that shows you the option exercises, and the earnings call read against the statements |
| **The market** | 8 | `/mood` `/screen` `/macro` `/dividends`, morning notes, catalysts, sector maps, competitive landscapes |
| **Company analysis** | 8 | `/comps` `/dcf` `/earnings`, three-statement models, unit economics |
| **Your files** | 3 | Audit a spreadsheet, clean a messy export, build a workbook you can actually change |

Skills are step-by-step methods Claude follows when they're relevant. Commands (`/comps`, `/mirror`)
are the ones you trigger yourself. The connector is an MCP server — the open standard for wiring data
into Claude — serving market data, fundamentals, estimates, transcripts, insider filings, news, and
your own journal.

## The one thing this plugin does that nothing else can

Your broker knows your trades. A data vendor knows the prices. **Only your journal knows the third
column** — what you were feeling when you clicked buy.

Log a few dozen trades with the emotion at entry, ask for `/mirror`, and you get a table nobody else
on earth can produce for you. It tends to look something like this:

| Felt at entry | Trades | Win rate |
|---|---|---|
| Confident | 10 | **80%** |
| Neutral | 13 | 77% |
| Euphoric | 6 | 33% |
| Fearful | 6 | **0%** |

**Both ends cost you money. The middle pays.**

We don't tell you what to do about that. We show you the row and let it land.

## Why there are no ratings

A price target is an opinion with decimals.

Where a verdict would sit, every deliverable here carries three things instead:

1. **The implied value range** under *your* assumptions — a range, never a single figure.
2. **The sensitivity** — what moves it, and by how much.
3. **The falsifier** — what would prove the read wrong. Specific, checkable, with a date on it.

This isn't a compliance workaround. It's the better analysis, and it's the one thing the industry
won't sell you: a valuation honest about how much confidence it deserves.

**And CI fails the build** if any skill acquires a rating, a price target or an implied upside. The
rule isn't a promise. It's a test.

## Agents

Three specialists Claude delegates whole jobs to. Each runs a multi-step workflow and comes back with
a draft.

| Agent | What it does |
|---|---|
| `earnings-reviewer` | Works a quarter end to end: the print, the call, the model, and what it changes |
| `market-researcher` | Maps a sector: overview, landscape, peer spread, and the distribution the average hides |
| `model-builder` | Builds the engine — a DCF, a three-statement model or a comps table — as a workbook you can change |

> **Agents draft. They don't decide, and they don't publish.** Every output is a starting point. They
> treat any document you hand them as untrusted — data to extract, never instructions to follow — and
> anything they can't trace to a source is marked `[UNSOURCED]`.

## Install

### Claude (web and desktop)

1. Settings → Plugins → Add plugin.
2. Paste: `https://github.com/the-balanced-investor-club/claude-plugin`
3. Select the plugin and sign in when prompted.

### Claude Code (terminal)

```bash
claude plugin marketplace add the-balanced-investor-club/claude-plugin
claude plugin install the-balanced-investor-club@the-balanced-investor-club-for-claude
```

> **After installing (or updating): restart Claude, or start a new chat.** The tools register on the
> next session — until then, skills will tell you the connector isn't available, which is them working
> correctly.

> **If the tools still don't appear:** add the connector manually once — Settings → Connectors → Add
> custom connector → `https://thebalancedinvestorclub.com/api/mcp/mcp` — and authorize it.

> **First session:** Claude asks approval the first time each tool runs. Choose **"Allow always"** —
> the market-data tools are read-only. Tools that write to your account (journal, trackers) will still
> ask each time, which is the behaviour you want.

## Try it

1. *"Log the trade I made yesterday — 10 shares of AAPL at $203, I was nervous about it."*
2. *"Show me my journal. When do I actually lose money?"*
3. *"What does NVDA's price already assume?"* — the reverse DCF
4. *"Read Apple's last earnings call against what the statements actually did."*

## Privacy and security

- Market-data tools are read-only and anonymous. No account needed.
- Signing in (OAuth 2.1) adds tools scoped to **your** data — journal, trackers, Trust Score. Each is
  gated by an explicit permission scope, revocable any time from Claude's settings.
- Nothing here connects to a brokerage or executes anything.
- [Privacy](https://thebalancedinvestorclub.com/privacy) ·
  [Terms](https://thebalancedinvestorclub.com/terms) ·
  [Disclaimer](https://thebalancedinvestorclub.com/disclaimer) · [SECURITY.md](SECURITY.md)

## Structure, and the checks

```
plugins/core/
  BRANDING.md              palette, type, logo — the single source. No skill hardcodes a colour
  OUTPUT-BLOCK.md          what every deliverable carries. Defined once, referenced everywhere
  skills/<name>/SKILL.md   26 skills
  commands/<name>.md       24 thin delegators. They load a skill; they never restate it
  agents/<name>.md         3 agents
  scripts/verify-skill.sh  one skill, against the rules
  scripts/smoke-test.sh    manifests, frontmatter, dangling refs, every tool it names
parked/                    skills routed to other verticals, kept for the record
```

```bash
cd plugins/core
./scripts/smoke-test.sh
./scripts/verify-skill.sh trade-log
```

The verifier reads the **whole** skill directory — `SKILL.md` *and* `references/`. It learned that the
hard way: when three oversized skills were split into `references/`, six price targets went with them
— straight out of a file the verifier was watching, and into one it wasn't.

## How this relates to Claude for Financial Services

The starting point was
[anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache 2.0), a
catalogue built for bankers, analysts and fund administrators. That's not who this is for.

So the catalogue was **re-scoped, not just re-badged**: the workflows that presuppose a client book, a
data room or an investment committee were removed, the sell-side rating apparatus was taken out
entirely, and the skills that make this product what it is — the journal, the reverse DCF, the call
reader — were written from scratch.

Attribution and licence terms are in [NOTICE](NOTICE) and [LICENSE](LICENSE).

## Questions

hello@thebalancedinvestorclub.com
