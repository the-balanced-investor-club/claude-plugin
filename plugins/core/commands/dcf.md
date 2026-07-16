---
description: Build a DCF model, with the peer set informing and then checking it
argument-hint: "[company name or ticker]"
---

Load the `comps-analysis` skill first to build the peer set, then the `dcf-model` skill to construct the valuation — the peers inform the terminal multiple and the sensitivity range going in, and check the model's implied multiples coming out.

The output is a workbook the user can change, a range, and what would prove it wrong. **No fair value, no price target, no implied upside.** For the reading — what the current price already assumes — use `/valuation`.

If a ticker is provided, use it. Otherwise ask which company.
