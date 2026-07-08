# Security Policy

## Reporting a vulnerability

If you find a security issue in this plugin or in The Balanced Investor Club connector, write to **hello@thebalancedinvestorclub.com** with the details. We read everything and will respond as fast as we can. Please don't open a public issue for security reports.

## Scope

- **This repository** — skill and command definitions (Markdown) and packaging manifests. It contains no secrets and no executable install steps.
- **The connector** — an MCP server at `https://thebalancedinvestorclub.com/api/mcp/mcp`. Authentication uses OAuth 2.1; anonymous access is limited to public market data tools.

## What the plugin can and cannot do

- Market data tools are read-only and work without an account.
- Signing in adds tools scoped to your own data (Stock Tracker, Trading Journal, Trust Score), each gated by explicit OAuth scopes.
- Nothing in this plugin executes transactions, places orders, or moves money. There is no brokerage connection.
- You can revoke the connector's authorization at any time from your Claude settings.
