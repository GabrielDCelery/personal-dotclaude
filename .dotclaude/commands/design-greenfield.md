# /design-greenfield command

Bootstraps a structured design documentation scaffold for a new greenfield project. Takes a brief description of the project and generates a `docs/` folder with pre-structured files and context-aware guiding questions.

## Usage

```
/design-greenfield <brief description of the project>
```

Example: `/design-greenfield A swing trading platform where users can track positions, set entry/exit rules, and execute trades via broker APIs`

## What it does

1. Creates a `docs/` folder if it doesn't exist
2. Generates the following files with pre-filled structure and guiding questions tailored to the project description
3. Updates `CLAUDE.md` with the project description and links to the doc files

## Output files

### Always created

- `docs/requirements.md` — functional requirements, non-functional requirements, open questions
- `docs/decisions.md` — design decisions with reasoning and alternatives
- `docs/behaviours.md` — how the system behaves at runtime per actor
- `docs/data-consumers.md` — who needs what view of the data and why
- `docs/entities.md` — entity definitions and field-level reasoning before any schema

### Created only if relevant to the description

- `docs/api.md` — if the system exposes an API
- `docs/schema.sql` — placeholder only, to be filled in after entities.md is complete

## Process

Read the project description carefully. Use it to:

- Infer the likely **actors** (who uses the system and in what role)
- Infer the likely **entities** (what things exist in the system)
- Infer whether entities have **lifecycle states** (if so, behaviours.md needs a state machine section)
- Identify **domain-specific concerns** to surface as guiding questions (e.g. compliance for finance, latency for trading, consistency for payments)

Then generate each file as follows.

---

### `docs/requirements.md`

```markdown
# Requirements

## Functional Requirements

### [Section name — group by feature area, infer from description]

[One paragraph describing this area and why it matters in this domain]

- FR1: [Inferred from description — or placeholder: what can Actor X do?]
- FR2: ...

---

## Non-Functional Requirements

### Performance

- [Domain-specific question — e.g. for trading: what is the acceptable latency for order execution?]

### Scalability

- [Domain-specific question]

### Availability

- [Domain-specific question]

### Data Retention

- [Domain-specific question — especially if regulated domain]

---

## Design Clarifications

[Leave empty — populated as decisions are made and their implications become clear]

---

## Open Questions

[Domain-specific open questions inferred from the description — things that require business context to answer]

- OQ1: ...
```

---

### `docs/decisions.md`

```markdown
# Design Decisions

## Summary

**Domain Model**

| #   | Question                                        | Decision |
| --- | ----------------------------------------------- | -------- |
| D1  | [Infer first obvious decision from description] | TBD      |

**Workflow Behaviour**

| #   | Question | Decision |
| --- | -------- | -------- |

**System Boundaries**

| #   | Question | Decision |
| --- | -------- | -------- |

---

## Domain Model

## D1: [First decision]

**Decision:** TBD

**Alternatives considered:**

**Why:**

---
```

---

### `docs/behaviours.md`

```markdown
# Behaviours

## Actors and their actions

[For each inferred actor, list what they can do]

| Actor   | Actions                |
| ------- | ---------------------- |
| [Actor] | [action 1], [action 2] |

---

## [Only if entities have lifecycle states] Turn-Based or Event Model

[Describe who acts when — if the system has entities with states and transitions, model them here]

---

## Valid Transitions by Actor

[If applicable]

| Entity | Actor | From | To  | Trigger |
| ------ | ----- | ---- | --- | ------- |

Any transition not listed above is invalid and must be rejected by the system.
```

---

### `docs/data-consumers.md`

```markdown
# Data Consumers

Who needs what view of the data and why. This drives entity design and query strategy.

## [Actor or system — inferred from description]

**What they need:**
**Why:**
**Freshness requirement:** real-time / near-real-time / historical
**Key queries:**

---
```

---

### `docs/entities.md`

```markdown
# Entities

Entity definitions, fields, and relationships. This is the intermediate step between requirements and schema — reason through what needs to exist and why before committing to SQL.

## [Entity — inferred from description]

[One sentence on what this entity represents and why it exists]

| Field        | Type        | Notes       |
| ------------ | ----------- | ----------- |
| `id`         | UUID        |             |
| `created_at` | TIMESTAMPTZ | DB-assigned |

**Open:** [Domain-specific question about this entity]

---
```

---

### `docs/api.md` (if applicable)

```markdown
# API

Prioritised endpoints — most critical to least. Contracts to be expanded.

## Priority 1 — [Core feature area]

### [METHOD] /[path]

**Actor:**
**Purpose:**
**Request:**
**Response:**
**Notes:**

---
```

---

### `CLAUDE.md` additions

Append to the existing `CLAUDE.md` (or create if missing):

```markdown
## What This Is

[Project description as provided]

## Key Files

- `docs/requirements.md` — functional and non-functional requirements, design clarifications, open questions
- `docs/decisions.md` — reasoning behind design choices and alternatives considered
- `docs/behaviours.md` — how the system behaves at runtime per actor
- `docs/data-consumers.md` — who needs what view of which data and why
- `docs/entities.md` — entity definitions and field reasoning (intermediate step before schema)
- `docs/api.md` — prioritised endpoints and contracts
- `docs/schema.sql` — canonical DB schema (to be created after entities.md is complete)
```

## Rules

- Tailor guiding questions to the domain — generic placeholders have low value
- Do not invent decisions — leave them as TBD with the right question framed
- Do not create `schema.sql` with content — it is a placeholder only
- Keep each file focused — cross-reference rather than duplicate
- If the description is too vague to infer actors or entities, ask one clarifying question before generating
