# The Balanced Investor Club for Claude

55 financial workflows for Claude: earnings analysis, comparable company analysis, DCF models, morning notes, thesis tracking, portfolio reviews and more. The same workflow catalog that institutional analysts run with paid market data terminals, served here by The Balanced Investor Club connector.

You sign in once. No API keys, no terminal subscription, no setup beyond the install below.

> Educational content. Not investment advice or recommendations. We're educators, not advisors. We don't make buy or sell recommendations under any circumstance. Your decisions are your own. Every output is a draft for review by a qualified professional. Nothing here executes transactions.

## What's inside

| Area | Skills | Examples |
|---|---|---|
| Financial analysis | 13 | `/comps`, `/dcf`, `/lbo`, 3-statement models, Excel audit |
| Equity research | 9 | `/earnings`, `/morning-note`, `/thesis`, sector overviews |
| Wealth workflows | 6 | portfolio reviews, rebalancing drift analysis, planning workbooks |
| Private equity | 10 | deal screening, IC memos, unit economics, returns analysis |
| Investment banking | 9 | company profiles, merger models, data packs, teasers |
| Fund administration | 6 | GL reconciliation, NAV tie-outs, variance commentary |
| Operations | 2 | KYC document parsing and rules evaluation |

Skills are step-by-step methods Claude follows automatically when relevant. Commands are actions you trigger yourself, like `/comps` or `/earnings`. The connector is an MCP server (Model Context Protocol, the open standard for wiring data into Claude) that serves market data, fundamentals, analyst estimates, news and market calendars.

## Install

### Claude (web and desktop)

1. Open Settings, then Plugins, then Add plugin.
2. Paste this repository URL: `https://github.com/the-balanced-investor-club/claude-plugin`
3. Select the plugin and sign in to The Balanced Investor Club when prompted.

No GitHub account is needed.

### Claude Code (terminal)

```bash
claude plugin marketplace add the-balanced-investor-club/claude-plugin
claude plugin install the-balanced-investor-club@the-balanced-investor-club-for-claude
```

> **After installing (or reinstalling): restart Claude, or start a new chat.** The market data tools register on the next session — until then, skills may report that the connector isn't available. This also applies after plugin updates.

> **If the tools still don't appear** after a restart: add the connector manually once — Settings, then Connectors, then Add custom connector, with the URL `https://thebalancedinvestorclub.com/api/mcp/mcp` — and authorize it. The plugin picks up that authorization from then on.

## Try it

Three prompts to see it working, right after install:

1. *"What's the market pulse today?"* — aggregate mood counts across the coverage universe
2. *"Build a comps analysis for AAPL versus MSFT and GOOGL"* — the `/comps` workflow with live fundamentals and statements
3. *"Draft my morning note"* — mood shifts, news and the earnings calendar; add your own watchlists by signing in

### What the connector adds

Market data tools work without an account. Signing in (free) adds your own data: Stock Tracker, Trading Journal and Trust Score, so workflows like portfolio reviews and thesis tracking can read your actual positions instead of a spreadsheet you paste in.

## Privacy and security

- Market data tools are read-only and anonymous — no account needed.
- Signing in (OAuth 2.1) adds tools scoped to your own data: Stock Tracker, Trading Journal, Trust Score. Each is gated by an explicit permission scope, and you can revoke access anytime from your Claude settings.
- Nothing here executes transactions or connects to a brokerage.
- The fine print lives on the site: [Privacy](https://thebalancedinvestorclub.com/privacy) · [Terms](https://thebalancedinvestorclub.com/terms) · [Disclaimer](https://thebalancedinvestorclub.com/disclaimer)
- Security reports: see [SECURITY.md](SECURITY.md)

## Built with

The catalog in this repository is Markdown skills plus Python helper scripts for the spreadsheet workflows. The connector behind it is a TypeScript / Next.js API, with a data pipeline on AWS (Lambda, Step Functions) and MongoDB Atlas — the same stack that runs [thebalancedinvestorclub.com](https://thebalancedinvestorclub.com).

## How this relates to Claude for Financial Services

This plugin adapts the workflow catalog of [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0). The original catalog connects to institutional data providers that require paid subscriptions. This adaptation replaces those connectors with The Balanced Investor Club connector so the same methods are usable without a terminal contract. Attribution and license terms are preserved in [NOTICE](NOTICE) and [LICENSE](LICENSE).

Some skills work entirely on documents you provide (Excel workbooks, decks, deal materials) and use no external data at all. Each skill states its data sources in its own `SKILL.md`.

## Questions

If you'd rather talk to a person, write to hello@thebalancedinvestorclub.com.
