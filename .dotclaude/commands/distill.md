# /distill command

Takes a verbose note and rewrites it as a distilled mental model reference. Reads the source file, applies the rules below, and writes a `-distilled.md` version alongside the original.

## Usage

```
/distill <filename>
```

Example: `/distill 05-queues-and-async.md` → writes `05-queues-and-async-distilled.md`

## Document types

Identify which type the source document is before applying any rules. Different types get different treatment.

**Narrative / learning notes** — prose-heavy, explains concepts, builds intuition. Apply the full rules below (anchor model, prose → visual → table, Key Mental Models).

**Structured reference docs** — tables, lists, decision logs, entity definitions, requirements. Apply the structured rules section instead. Do not convert tables into prose or force a "Key Mental Models" section onto a reference document.

**Mixed docs** — contains both prose sections and structured sections (e.g. a doc with an explanation followed by a decisions table, or prose with embedded code blocks). Apply narrative rules to prose sections and structured rules to table/code sections independently. Do not flatten one into the other.

When in doubt: if the document's primary value is lookup and reference, treat it as structured. If its primary value is understanding and intuition, treat it as narrative.

---

## The goal

The output should feel like a well-written chapter, not a bullet dump. A reader should be able to work through it top to bottom and come away with a mental model — not just a set of facts to memorise. Flow matters. Prose earns its place by building intuition; tables and charts are the reference anchors that follow.

## Structure

### 1. Open with a one-sentence frame

State what this topic is _for_ and why it matters. Not a definition — a reason to care.

> "Knowing where time goes in a request tells you what to optimise — and what to leave alone."

### 2. Anchor model up front

Every good distilled note has one core mental model that everything else hangs off. State it early, name it explicitly, and return to it when later sections connect back.

> "The Core Mental Model: 0 / 1 / 5 / 50"

### 3. Prose → visual → table (in that order)

For each concept:

1. **One to three sentences of prose** — explain _why_ this is the way it is, not just what it is. This is what makes the rule stick.
2. **ASCII visualization** — show magnitude, not just categories. A reader should be able to _see_ the difference between options.
3. **Table** — the lookup reference, for when you already understand the model and need the number.

Never lead with a table and no prose — every table needs at least one framing sentence before it. Never use a table where an ASCII chart would show the difference more viscerally.

### 4. End with Key Mental Models

A numbered cheat sheet — one line per model. These should be the things a reader would say out loud to explain the topic to someone else.

## What to keep

- **Explanatory prose that builds intuition** — "This is why caching works." "The operation itself is rarely the bottleneck — the journey to and from it is." Keep any sentence that earns its place by making the rule make sense.
- **ASCII magnitude charts** — proportional bars that let you _see_ the difference. A latency chart where JWT is 0.1 ms and OAuth is 100 ms should look like one is 1000× the other.
- **The "why" behind a trade-off** — "JWT can't be revoked until expiry. Handle with short expiry + refresh tokens." The constraint and its mitigation belong together.
- **Worked examples that show reasoning** — keep the walkthrough, compress the narration.
- **Decision rules with context** — "use X when Y" is only useful if you understand what Y implies.
- **Negative cases** — when NOT to use something is as important as when to use it.

## What to cut

- **Recap introductions** — paragraphs that restate what the previous section or lesson covered.
- **Transition filler** — "Now that we understand X, let's look at Y."
- **Proofs without payoff** — derivations where the conclusion is already stated clearly elsewhere. Cut the proof, keep the conclusion _and_ the one-sentence intuition for why it's true.
- **Duplicate coverage** — if a concept is explained well in another note in the series, one line and a reference is enough.
- **Redundant tables** — if an ASCII chart already shows the comparison visually, a table of the same data is noise unless it adds precision the chart can't.
- **Do not cut clean sentences** — only shorten where there is genuine bloat. If a sentence reads well and flows naturally, leave it. Over-compression kills readability and turns a document into a checklist.

## ASCII visualization guidelines

- **Show magnitude, not just order** — bars should be proportional to the actual values. A 10× difference should look like 10×.
- Use log scale when the range spans 3+ orders of magnitude.
- Use proportional bars for budget/breakdown charts (e.g. latency budget where DB = 77%).
- Use dots (·) as grid fill on rows that have data — they show the scale without implying a bar. Leave rows with no data empty or omit them.
- Keep scale markers on the opening and closing rule lines only.
- For good/bad comparisons, show both in the same chart so the difference is immediate.

## Format guidelines

- Prose comes before the rule, not after — earn the conclusion.
- **Bold the default choice** or the single most important rule in each section.
- Target 150–250 lines. Long enough to flow, short enough to read in one sitting.
- Keep the "Key Mental Models" section at the end — numbered, one line each.

---

## Structured reference docs

Apply these rules instead of the narrative rules when the document is a reference structure (decisions log, entity definitions, requirements list, data consumers, API endpoints, etc.).

### Goal

Remove scaffolding noise and tighten content without changing the structure. The output should be the same shape as the input — tables stay tables, lists stay lists — but cleaner and denser.

### What to do

- **Strip unfilled placeholders** — remove rows, cells, or bullet points that still contain template text (`[TBD]`, `[Inferred from...]`, `[e.g. ...]`, `[Domain-specific question]`). If a section is entirely unfilled, remove the section heading too.
- **Keep section-opening prose** — a sentence or two that frames what a section is for and why it matters must be kept. This is not filler — it gives context that the list items alone do not. Tighten if verbose, but do not cut.
- **Tighten prose descriptions** — shorten field descriptions, decision rationale, and inline notes. Cut filler words. Keep the meaning.
- **Consolidate thin sections** — if a section has only one item and no real content, fold it into a neighbouring section or remove it.
- **Preserve original structure** — if the source uses bullet points, keep bullet points. If it uses a table, keep a table. Do not convert lists to tables or tables to lists. Structure is part of the document's voice — changing it is not distillation.
- **Keep all table structure** — do not flatten tables into prose.
- **Every table needs at least one framing sentence** — if the original has one, keep it (tighten if verbose). If the original has none and the table's purpose isn't obvious from the heading alone, add one sentence. Never more than one — the table speaks for itself after that.
- **Shorten only where there is genuine bloat** — repeated words, filler phrases, restated context. If a sentence already reads cleanly and flows well, leave it alone. Do not compress for the sake of it — density is not the goal, clarity is. A checklist is not a distilled doc.
- **Keep decision reasoning** — for decisions logs, the "why" and "alternatives considered" are the value. Tighten the wording but do not cut the reasoning.
- **Do not add** a "Key Mental Models" section or an anchor model frame — these belong to narrative docs only.

### What to cut

- Template instructions left in the document (meta-comments addressed to the author)
- Duplicate information across sections
- Section headings with no content under them
- Rows in tables where every cell is empty or placeholder

---

## Code blocks

Code blocks appear in both narrative and structured docs. In both cases:

- **Keep code blocks as-is** — do not rewrite, summarise, or convert to prose. Code is already dense.
- **Tighten the prose around the code block** — the explanation before/after should be shorter than the block itself. If the code is self-explanatory, cut the explanation entirely.
- **Do not add code blocks that weren't in the original** — distillation is not augmentation.
