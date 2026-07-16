---
description: Read a quarter — what beat, what missed, why, and what it changes
argument-hint: "[company name or ticker] [quarter, e.g. 2026Q1]"
---

Load the `earnings-analysis` skill and produce the earnings update: what beat, what missed, **why**, and which pillar of the reader's thesis it actually informs.

Get the latest reported quarter from `get_fundamentals` (`fiscalDateEnding`) — never assume it from the calendar, and never web-search it.

**No rating, no price target, no verdict.** Where one would sit, give the implied value range, what moves it most, and what would prove the read wrong.

If a ticker is provided, use it. Otherwise ask which company.
