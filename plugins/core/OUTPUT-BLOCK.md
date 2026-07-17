# Output block

Single source of truth for what every deliverable this plugin produces must carry — **in the document
itself**, not in the chat around it. Skills reference this file; they never restate it. Change it here
and it changes everywhere.

The last catalogue got this wrong in a way worth remembering: the disclaimer sat at the bottom of
each `SKILL.md`, next to the licence attribution, where Claude read it and no reader ever saw it. **It
was metadata about the instructions, not an instruction about the output.** One skill in fifty-five
actually put it in the document.

---

## 1 · The framing — first block of every deliverable, once

> **Educational exercise — not investment advice.**
> We're educators, not advisors. We don't tell anyone what to buy or sell, and that includes you.
> The numbers come from assumptions you set; change them and they change.

## 2 · The source block — first block or cover, once

Every file this plugin produces says where it came from and when.

```
Produced with The Balanced Investor Club for Claude
thebalancedinvestorclub.com

Data: The Balanced Investor Club connector · retrieved {stamp}
Prepared: {stamp}
```

### The date is served, never remembered

`{stamp}` comes from the connector — **`whoami`** (signed in) or **`start_here`** (not signed in).
Both return it in the form `14-Jul-2026, 13:06 CEST`.

**Call one of them before you stamp anything.**

A language model does not know what day it is. Ask it, and it will answer with the day it was trained,
in a confident tone, and be wrong by months. A report carrying a fabricated date is the quietest error
there is — **nothing on the page looks incorrect** — and it is exactly the kind of thing that makes a
reader stop trusting every other number on it, correctly.

**Never write a date you did not fetch.**

## 3 · The disclaimer — last line, verbatim

> Educational content, not investment advice. No buy/sell recommendations — observations for your own
> research.

## 4 · Two blocks per document. Not four.

Repeating a disclaimer does not protect twice as well. Readers stop seeing it, and a regulator reads
boilerplate stacked four deep as cover, not good faith. **One framing at the top, one line at the
bottom.** The source block rides with the framing.

This is also a brand rule, not only a legal one. The Design Philosophy lists the voices we are
**never**: *Referee (compliance vibes)* and *Flight instructor (compliance, liability risk)*. Four
disclaimers per page is that voice. One, written like a human, is not.

---

## Where it goes, by format

| Format | Framing + source | Disclaimer |
|--------|------------------|------------|
| Markdown / chat | First block | Last line |
| Word / PDF | Under the title, before any analysis | Footer of the last page |
| Excel | Cell A1 of the first sheet, and the top of the Inputs tab | Bottom of the first sheet |
| PowerPoint | Cover slide, under the title | Footer of the final slide |

### In chat the connector speaks. In a file, only you do.

The connector appends its own disclaimer to every tool response it returns. So in a chat answer that
line is **already on screen**, above whatever you write — and a second one underneath it is the
fourth-deep boilerplate §4 exists to prevent.

**A file is the opposite case. Nothing is appended to a `.docx`, an `.xlsx` or a `.pptx`.** You are
the only thing writing it. The blocks go in because you put them in, per the table above.

The distinction matters because of where the two end up. A chat answer is read once, in the
conversation that produced it, next to the connector's line. **A file travels** — it gets saved,
emailed, and opened months later by someone who never saw that conversation. It is the one that has
to carry its own context, and it is the one at risk of shipping without any.

> **Never reason "the connector already said it" about a file. The connector has never seen your
> file.**

---

## No verdict — and what replaces it

**No rating. No price target. No buy / sell / hold.** And no `BULLISH` / `BEARISH` as a verdict either
— a relabelled recommendation is still a recommendation, and the rules reach implicit ones. The
regulator reads the substance, not the adjective.

Where a verdict would sit, the deliverable carries three things instead:

1. **The implied value range under the reader's own assumptions** — a range, never a single figure.
2. **The sensitivity** — what moves the result, and by how much.
3. **The falsifier** — what would prove this read wrong. Specific, checkable, with a date on it.

This is not a compromise. **A price target is an opinion with decimals.** Showing the band, what drives
it, and what breaks it is the more useful lesson and the honest one — and it happens to be the thing
the brand already promised: *lost faith in gurus and in Wall Street*. A product with no rating, that
explains why no rating deserves trust, **is** that sentence made into a feature.

---

## When our own tools disagree

They do. `get_valuation_inputs` reported NVDA's net debt as −$423M while the balance sheet implied
−$3.14B; the two share counts differed by 1.2%. For a $4.9tn company that gap is immaterial and easy
to shrug at. **On a leveraged company it decides the answer.**

> **When two tools give different figures for the same thing: show both, say which one you used, and
> say why. Never average them. Never pick one silently.**

This is not an apology for the data. It is the product. *Do I believe these numbers?* is the question
the whole plugin exists to teach — and a tool that shows a reader where it disagrees with **itself**
has taught it better than any paragraph could.

---

## Never "Simulated"

The data is real — from the connector, with a fetch date. What is an exercise is the **analyst's
role**, not the figures. Calling the numbers simulated would be false, and would destroy the one thing
the analysis has going for it.

---

## Look and feel

**The palette, the type and the logo live in [`BRANDING.md`](BRANDING.md). Reference it. Never
hardcode a colour in a skill.**

The last catalogue is the argument for that rule: eight of fifty-five skills cited `BRANDING.md` — and
then restated the hex codes inline anyway, at which point the single source of truth was neither
single nor a source. Worse, several described the green palette as *"professional blue/grey"*,
inherited from an upstream fork, so the prose and the colours disagreed with each other in the same
file.

The three rules that get broken most often, restated here so a skill never has to guess:

1. **Never the banking palette.** No navy, no light blue. That is precisely the look this brand
   exists in opposition to.
2. **Never red for a negative.** Amber. Red is a supermarket telling you to panic; amber is a number
   telling you it went down.
3. **One accent per document** (emerald), and everything else muted. Warm oak, soft linen, Japanese
   paper — a calm workshop, not a trading floor.

**When the user brings their own template, their template wins.** Always.
