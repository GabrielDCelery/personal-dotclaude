# /draft command

Takes a topic and produces a first, reasoning-rich draft of a narrative mental-model note. Writes a new file — does not rewrite an existing one.

## Usage

```
/draft <topic> in <path>
```

Example: `/draft traefik ingress routing in 02_area/kubernetes/` → writes `02_area/kubernetes/03-traefik-and-ingress.md`

## What this is for

The thinking pass that has to happen *before* a note can be shaped. `/distill` and `/refine` both assume a draft already exists and reshape it — they cannot manufacture understanding that was never written down. This command is where that understanding gets built and put into words for the first time.

Use this before `/distill` for a brand new narrative/mental-model topic. Not for structured reference docs (requirements, decisions logs, entity lists) — those don't need this reasoning pass, go straight to `/refine`.

## What this is not

- **Not the final artifact.** No forced ASCII diagram, no forced table, no "Key Mental Models" section. Those are shaping decisions `/distill` makes once the reasoning already exists on the page.
- **Not compressed.** Prose can be longer and more exploratory than the final note. Thinking out loud on the page is fine here — it gets cut later, not now.
- **Not auto-chained into `/distill`.** Stop after the draft. The reasoning gets reviewed and corrected first — a note distilled from a draft with a wrong mental model just produces a tight, confident, wrong note. `/distill` is invoked manually, once the draft is actually right.

---

## Process

Work through these in order. Do not skip to writing prose before doing the reasoning — the note is a record of having already worked this out, not a place to work it out live.

### 1. State the tension

What's confusing, surprising, or broken without understanding this? Not a definition — a reason the topic exists at all. If you can't state what problem this solves or what goes wrong without it, you don't understand it well enough to draft it yet — go research first (read the actual code/config/docs involved, don't guess).

### 2. Trace the causal chain

Why does the thing behave the way it does — not just what it does. Each step should force the next: "X happens, which means Y, which is why Z." If the chain has a gap ("it just works this way"), that gap is exactly what needs more research before drafting continues.

### 3. Ground it in the real system

Pull concrete numbers, commands, file paths, and examples from the actual thing being documented — not generic tutorial filler. If this is documenting something already built (infra, a deployed service, a running system), read the actual manifests/config/code first. A note grounded in "here's what we actually run" is worth more than one grounded in "here's how this generally works."

### 4. Surface the failure mode

Where does this bite you in practice? Every mechanism worth documenting has a way it goes wrong, a limit, or a case where the default answer changes. If nothing comes to mind, the topic may not need its own note.

### 5. Write it as prose, reasoning visible

Full sentences, in the order the reasoning actually happened: tension → chain → grounding → failure mode. Diagrams and tables can appear if they're the clearest way to show something, but don't force the final shape yet — that's the next pass, and a different command.

---

## Output

Write the draft to the target path. Close with a one-line handoff note, not an automatic action:

```
Draft complete: 02_area/kubernetes/03-traefik-and-ingress.md
Review it — when the reasoning is right, run /distill on it.
```

Do not invoke `/distill` yourself. The person reviewing decides when the draft is ready.
