# /refine command

Takes a structured reference document and improves its readability. Reads the source file, applies the rules below, and writes a `-refined.md` version alongside the original.

## Usage

```
/refine <filename>
```

Example: `/refine 01-requirements.md` → writes `01-requirements-refined.md`

## The goal

The output should read like a well-maintained reference document — clean, clear, and easy to navigate. The goal is not compression. It is removing noise that gets in the way of reading: unfilled scaffolding, template leftovers, redundant phrasing. A refined doc should feel like it was written intentionally, not generated from a template.

A reader should be able to open it and immediately find what they need. Flow matters. A sentence that helps a reader understand the purpose of a section earns its place — do not cut it in the name of brevity.

## Document types this applies to

Structured reference docs: requirements lists, decisions logs, entity definitions, data consumers, API endpoints, behaviours, tooling lists, audit findings, sequence plans.

For narrative learning notes (concepts, mental models, system explanations), use `/distill` instead.

---

## What to do

- **Strip unfilled placeholders** — remove bullet points, rows, or cells that still contain template text (`[TBD]`, `[Inferred from...]`, `[e.g. ...]`, `[Domain-specific question]`, `[Leave empty...]`). If a section is entirely unfilled after stripping, remove the section heading too.
- **Keep section-opening prose** — a sentence or two that frames what a section is for and why it matters must be kept. This is not filler — it gives context that the list items alone do not. Tighten only if clearly verbose, but do not cut.
- **Every table needs at least one framing sentence** — if the original has one, keep it. If the original has none and the table's purpose isn't obvious from the heading alone, add one sentence. Never more than one.
- **Preserve original structure** — if the source uses bullet points, keep bullet points. If it uses a table, keep a table. Do not convert lists to tables or tables to lists. Structure is part of the document's voice.
- **Shorten only where there is genuine bloat** — repeated words, filler phrases, restated context that adds nothing. If a sentence already reads cleanly and flows well, leave it alone. Do not compress for the sake of it.
- **Keep decision reasoning** — for decision logs, the "why" and "alternatives considered" are the value. Tighten the wording but do not cut the reasoning.
- **Keep inline precision notes** — parenthetical clarifications like `(host must match exactly)` or `(e.g. `crawlme.monzo.com`)` are not filler. They carry specificity that the main clause doesn't. Keep them.

## What to cut

- Template instructions left in the document (meta-comments addressed to the author, e.g. `[Leave empty — populated as decisions are made]`)
- Duplicate information repeated across sections
- Section headings with no content under them after stripping placeholders
- Rows in tables where every cell is empty or placeholder

## What not to do

- Do not reframe, restructure, or reorder sections
- Do not add a "Key Mental Models" section or anchor model — those belong in distilled narrative docs
- Do not convert the document into flowing prose if it was a list
- Do not add content that wasn't in the original
- Do not remove a sentence just because it could theoretically be shorter

## Code blocks

- Keep code blocks as-is — do not rewrite or summarise
- Tighten the prose around the block only if it is genuinely bloated
- Do not add code blocks that weren't in the original
