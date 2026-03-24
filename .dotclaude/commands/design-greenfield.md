# /design-greenfield command

Bootstraps a structured design documentation scaffold for a new greenfield project. Takes a brief description of the project and generates a `docs/` folder with pre-structured files and context-aware guiding questions.

## Usage

```
/design-greenfield <brief description of the project>
/design-greenfield <path/to/input.md>
```

Examples:

- `/design-greenfield A swing trading platform where users can track positions, set entry/exit rules, and execute trades via broker APIs`
- `/design-greenfield docs/brief.md`

If the argument is a file path (e.g. ends in `.md` or points to an existing file), read its contents and use that as the project description. Otherwise treat the argument as an inline description.

## What it does

1. Creates a `docs/` folder if it doesn't exist
2. Generates the following files with pre-filled structure and guiding questions tailored to the project description
3. Updates `CLAUDE.md` with the project description and links to the doc files

## Output files

### Always created

- `docs/01-requirements.md` — functional requirements, non-functional requirements, open questions
- `docs/02-decisions.md` — design decisions with reasoning and alternatives
- `docs/03-data-consumers.md` — who needs what view of the data and why
- `docs/04-entities.md` — entity definitions and field-level reasoning before any schema
- `docs/05-architecture.md` — infrastructure, scalability, and auth decisions informed by entities and data consumers
- `docs/06-testing.md` — what to test, testing strategy, and key scenarios

### Created only if relevant to the description

- `docs/07-behaviours.md` — if the system has multiple actors with distinct roles or entities with lifecycle states
- `docs/08-api.md` — if the system exposes an API

## Process

Read the project description carefully. Use it to:

- Infer the likely **actors** (who uses the system and in what role)
- Infer the likely **entities** (what things exist in the system)
- Infer whether entities have **lifecycle states** or multiple actors with distinct roles (if so, create `07-behaviours.md`)
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

### `docs/03-data-consumers.md`

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

### `docs/04-entities.md`

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

### `docs/05-architecture.md`

```markdown
# Architecture

Infrastructure-level decisions — separate from domain/workflow decisions in `02-decisions.md`. Informed by data consumers and entities.

---

## Infrastructure

### [Protocol / Transport — e.g. REST, WebSockets, SSE, gRPC]

**Decision:** TBD

**Alternatives considered:**

**Why:**

---

### [Caching strategy — if applicable]

**Decision:** TBD

**Why:**

---

### [Messaging / async — if applicable]

**Decision:** TBD

**Why:**

---

## Scalability

### Read/Write Split

[Infer from data consumers — which reads are high-frequency? which writes are contended?]

- **Reads:** ...
- **Writes:** ...

### Known Hotspots

[Infer from entities and behaviours — what operations touch many rows or many connections at once?]

- [e.g. cascade on state change, fan-out on event]

### What Is Not Addressed Yet

[Flag what cannot be sized without NFR answers — concurrent users, peak throughput, acceptable latency]

---

## Auth

### Authentication — who are you?

**Decision:** TBD

**Alternatives considered:**

**Why:**

---

### Authorisation — what can you do?

[Infer from actors — how many roles? is ownership a concern? are there relationship/agency constraints?]

- **Role:** [what each role can attempt]
- **Ownership:** [which entities are scoped to the requesting actor]
- **Relationship:** [if actors can act on behalf of others — compliance boundary]
```

---

### `docs/06-testing.md`

```markdown
# Testing

## What to Test

[Infer from the description — critical paths, invariants, and failure modes worth protecting]

- [e.g. for a trading platform: order execution must never partially apply]
- ...

---

## Testing Strategy

### Unit Testing

- [What logic is isolated enough to test in pure unit tests]

### Integration Testing

- [What requires real dependencies — DB, external APIs, message queues]

### End-to-End Testing

- [What needs to be validated as a full user journey]

---

## Key Scenarios

| Scenario                                    | Type        | Why it matters |
| ------------------------------------------- | ----------- | -------------- |
| [Happy path for core actor action]          | E2E         |                |
| [Failure mode — e.g. external service down] | Integration |                |
| [Concurrency or consistency edge case]      | Integration |                |

---

## Open Questions

- [Domain-specific testing concerns — e.g. how do we test time-sensitive logic? how do we simulate broker API failures?]
```

---

### `docs/07-behaviours.md` (if applicable)

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

| Entity | Actor | From | To  | Trigger |
| ------ | ----- | ---- | --- | ------- |

Any transition not listed above is invalid and must be rejected by the system.
```

---

### `docs/08-api.md` (if applicable)

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

- `docs/01-requirements.md` — functional and non-functional requirements, design clarifications, open questions
- `docs/02-decisions.md` — reasoning behind design choices and alternatives considered
- `docs/03-data-consumers.md` — who needs what view of which data and why
- `docs/04-entities.md` — entity definitions and field reasoning (intermediate step before schema)
- `docs/05-architecture.md` — infrastructure, scalability, and auth decisions
- `docs/06-testing.md` — what to test, testing strategy, and key scenarios
- `docs/07-behaviours.md` — actors, actions, and state transitions (if applicable)
- `docs/08-api.md` — prioritised endpoints and contracts (if applicable)
```

## Rules

- Tailor guiding questions to the domain — generic placeholders have low value
- Do not invent decisions — leave them as TBD with the right question framed
- Keep each file focused — cross-reference rather than duplicate
- If the description is too vague to infer actors or entities, ask one clarifying question before generating
