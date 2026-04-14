# /ticker-repo-triage

Produces a structured triage document for an unfamiliar repo.
Discovers the shape of the repo from whatever is present — do not assume language, runtime, or deployment method.
Write the output to `docs/triage.md`. If the file already exists, overwrite it — this is a fresh snapshot.

## Discovery phase

Scan the repo root first. Identify what is present before reading anything in depth:

- Package managers: `package.json`, `go.mod`, `pyproject.toml`, `requirements.txt`, `Cargo.toml`
- IaC: `serverless.yml`, `cdk/`, `terraform/`, `*.tf`, `cloudformation/`
- CI/CD: `buildspec.yml`, `.circleci/`, `.github/workflows/`, `Jenkinsfile`
- Containers: `Dockerfile`, `docker-compose.yml`, `*.dockerfile`
- Config: `.env.example`, `config/`, `app.yml`, `*.config.*`

From what you find, determine the language, runtime, and likely deployment method before reading further.
If multiple languages or runtimes are present, note all of them.

## What to read

Read only what is needed to answer each output section.
Do not read business logic. Do not read test files.
Start with metadata and config — go into `src/` only to identify entry points, not to understand logic.

## Output format

Write `docs/triage.md` with the following sections:

### What this service does
2–3 sentences. What problem does it solve and who uses it.
This is a hypothesis based on what you read — label it as such so the developer can confirm or correct it.

### Why it exists
One sentence on the business reason, if determinable from README, config names, or folder structure.
If not determinable, say so — do not infer.

### Key building blocks
A short list of the main components — not a full file tree, just the meaningful units.
For each one: name, what it is (Lambda handler, ECS service, worker, scheduler, etc.), and the file to start reading.

Keep table width under 120 characters. Use short values — truncate paths to filename only.

| Component | Type | Start here |
| --------- | ---- | ---------- |

### Connections

How this service connects to the world. Populate only the sections that apply — omit sections with nothing to put in them.
All information must come from IaC and config, not inferred from code.
Keep table width under 120 characters.

#### Inbound
What invokes this service.

| Caller | How it invokes this service | Source |
| ------ | --------------------------- | ------ |

#### Platform
Other internal services this service calls or publishes to.

| Service | How invoked | Source |
| ------- | ----------- | ------ |

#### External
Third-party APIs and external systems.

| Service | How invoked | Source |
| ------- | ----------- | ------ |

#### Storage
Databases, queues, object storage.

| Resource | How invoked | Source |
| -------- | ----------- | ------ |

### Stack
A quick orientation — not a deployment guide.

| | |
| --- | --- |
| Language | |
| Runtime | |
| IaC | |
| Private packages | |

List only what is visible from package manifests and config. If private packages are not present, omit that row.

### What is unclear
Anything you could not determine from the available metadata.
This section is mandatory — a short "nothing unclear" is fine, but do not omit it.
A partial answer with visible gaps is more useful than a confident but incomplete summary.
