# Changelog

All notable changes to this plugin are documented here. Versions follow [Semantic Versioning](https://semver.org/).

## 0.3.0 — 2026-07-14

The catalogue was re-scoped rather than re-badged. **55 skills became 26**, and the ones that
remained had their audience changed.

### Removed — because a retail investor is not an advisor with clients

- `financial-plan`, `client-review`, `client-report`, `investment-proposal` — all four presuppose a
  client book and a fiduciary relationship. `financial-plan` instructed Claude to align its output
  with *"suitability/fiduciary standards"*.
- `tax-loss-harvesting`, `portfolio-rebalance` — both emit a trade blotter with named tickers.
- `kyc-doc-parse`, `kyc-rules` — onboarding for a regulated institution.
- `idea-generation` — a ranked long/short pitch list, with a short screen. Its shape was the
  violation, not its vocabulary.
- The investment-banking, private-equity and fund-administration clusters, and 6 of the 9 agents.

### Removed — the rating apparatus

**No skill in this catalogue can now emit a rating, a price target, an implied upside or a fair
value.** That included the rating box on the cover of the flagship research report, which the quality
checklist had been *requiring*.

Where a verdict would sit, deliverables now carry the implied value range, the sensitivity, and the
falsifier.

### Added — the skills that make this product what it is

- **`trade-log`** — records a trade with the thesis *and* the emotion at entry, before the outcome is
  known. This is the whole methodological point: an emotion recalled after a loss is a story; one
  written down first is evidence.
- **`journal-mirror`** — reads the journal back: win rate by emotional state, and what is dragging the
  Trust Score. The only analysis in this product nobody else on earth can run.
- **`reverse-dcf`** — asks what growth the current price already requires, rather than announcing what
  a company is worth. Runs both the single-stage and two-stage models, because the choice between them
  changes the answer more than any assumption inside either.
- **`transcript-vs-numbers`** — puts what management said next to what the statements did.
- **`ownership-context`** — teaches the reader to see that most insider "buying" is an option exercise.
- **`mood-regime`**, **`screener`**, **`stock-tracker`**, **`macro-read`**, **`dividends`**.

### Fixed

- **The disclaimer never reached the document.** It sat at the bottom of each `SKILL.md`, next to the
  licence attribution — metadata about the instructions, not an instruction about the output. One skill
  in fifty-five actually put it in the deliverable. It is now defined once in `OUTPUT-BLOCK.md` and
  referenced by every skill.
- **The date was invented.** A model does not know what day it is. `whoami` and `start_here` now return
  the server's date, and no skill may stamp a date it did not fetch.
- **`recalc.py`** was invoked twelve times and did not exist. `validate_dcf.py`, which does exist and
  opens the generated workbook, was dead code. Now the opposite is true.
- **Four phantom MCP servers** were referenced. There is one, and it is declared.
- **Broken template references** — three skills told Claude to copy an `.xlsx` that was not in the repo.
- **A WACC bug** in `dcf-model`: weights computed on net debt over enterprise value, producing a
  *negative* debt weight for any company holding net cash — which is most of quality technology.
- **`ib-terminology.md`**, a table that translated "cheap" into "attractive valuation" and "expensive"
  into "premium valuation". Deleted.

### Added — the checks

- `scripts/verify-skill.sh` — eleven checks per skill, across `SKILL.md` **and** `references/`.
- `scripts/smoke-test.sh` — manifests, frontmatter, dangling references, and every tool a skill names
  checked against the 52 the connector actually serves.
- Both run in CI, on every push. A rule that nothing enforces gets followed about eleven percent of
  the time. We measured it.

## 0.2.0 — 2026-07-09

- **9 agents**, adapted from the upstream catalog: model-builder, earnings-reviewer, market-researcher, pitch-agent, meeting-prep-agent, gl-reconciler, month-end-closer, statement-auditor, valuation-reviewer. Agents run whole multi-step workflows and return the deliverable; every output remains a draft for professional review
- **Club branding in deliverables**: new `BRANDING.md` as single source of truth; the logo ships in `assets/`
