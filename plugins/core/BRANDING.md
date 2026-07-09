# Branding — The Balanced Investor Club

Single source of truth for visual identity in every document this plugin produces (Excel workbooks, PowerPoint decks, Word/PDF reports). New skills MUST reference this file instead of hardcoding their own values.

## Palette (New Birth)

| Role | Hex | RGB | Usage |
|------|-----|-----|-------|
| Ink | `#28333C` | 40,51,60 | Section header fills (white bold text on top), titles, body text |
| Pale green | `#E7EFE6` | 231,239,230 | Column header fills (ink/black bold text on top) |
| Medium green | `#CBDCCB` | 203,220,203 | Totals, check rows, sensitivity-table base-case cell (bold text) |
| Light grey | `#F2F2F2` | 242,242,242 | Input cell backgrounds |
| Cream | `#F4F2EC` | 244,242,236 | Page/slide backgrounds where a tinted canvas is wanted |
| Emerald | `#4F9173` | 79,145,115 | Single accent (charts, highlights) — use sparingly |
| Amber | `#9A7B3A` | 154,123,58 | Negative values / warnings. Never red. |

## Semantic cell coding — DO NOT restyle

Financial-model auditing convention, not aesthetics (audit-xls checks it):

- **Blue `#0000FF` font** — hardcoded inputs
- **Black font** — formulas
- **Green `#008000` font** — links to other sheets

These font colors stay exactly as-is regardless of the palette above.

## Typography

- **Font family:** Inter — fallback **Calibri** when Inter is not installed on the machine rendering the document. Times New Roman is never used.
- Data 11pt, headers 12pt (Excel defaults; skills may specify otherwise).

## Logo

- `assets/logo.png` — full lockup (trending-up icon + "The Balanced Investor Club" wordmark) in ink, transparent background. For light backgrounds.
- `assets/logo.svg` — vector source of the same lockup.
- **Excel:** insert at the top-left of the first worksheet, next to the workbook title.
- **PowerPoint:** cover slide + footer of content slides.

## Rules

1. Never use the classic banking palette (navy `#1F4E79`/`#17365D`, light blue `#D9E1F2`, medium blue `#BDD7EE`).
2. Never introduce red for negatives — amber is the negative color.
3. One accent color per document (emerald). Muted everything else.
4. When a user supplies their own template, the user's template wins.
