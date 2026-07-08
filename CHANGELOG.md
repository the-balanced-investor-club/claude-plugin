# Changelog

All notable changes to this plugin are documented here. Versions follow [Semantic Versioning](https://semver.org/).

## 0.1.4 — 2026-07-09

- Manifest metadata: homepage and repository links for directory listings
- Repository documentation: security policy, changelog, quickstart and privacy sections in the README

## 0.1.3 — 2026-07-09

- Skills resolve company and coin names through `search_instruments` before any per-ticker call
- When an instrument isn't covered (private company, unlisted), skills say so plainly instead of pointing at other data sources; account-gated tools invite you to sign in
- Removed a reference to a tool that isn't part of the connector catalog
- Install guide: added the manual-connector workaround for sessions where tools don't register

## 0.1.2 — 2026-07-08

- Hard data-sourcing rule: if the connector isn't available in the session, skills stop and say so — they never substitute web sources for market data
- Every comps deliverable now ends with the educational disclaimer
- Data-driven skills reference The Balanced Investor Club connector as their only named data source
- Install guide: restart Claude (or start a new chat) after installing or updating

## 0.1.1 — 2026-07-08

- comps-analysis and morning-note adapted to the connector with a tool-by-tool data mapping
- Replaced institutional data-terminal references across the catalog with connector tools

## 0.1.0 — 2026-07-08

- Initial release: 55 skills, 39 commands, and The Balanced Investor Club connector
- Adapted from [anthropics/financial-services](https://github.com/anthropics/financial-services) (Apache License 2.0) — see NOTICE
