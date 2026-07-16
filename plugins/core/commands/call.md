---
description: Read the earnings call against what the statements actually did
argument-hint: "[ticker] [quarter, e.g. 2026Q1]"
---

Load the `transcript-vs-numbers` skill.

Pull the full call and the reported figures, and put the headline next to the fine print — calendar effects, currency, tax, and the margin line. Report the discrepancy; never infer the motive.

If a ticker is provided, use it. Get the fiscal quarter from `get_fundamentals` if the user does not give one.
