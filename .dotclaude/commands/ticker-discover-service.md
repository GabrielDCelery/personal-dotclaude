# /ticker-discover-service

Produces a structured triage document for an unfamiliar repo.
Discovers the shape of the repo from whatever is present — do not assume language, runtime, or deployment method.
Write the output to `docs/discovery-service.md`. If the file already exists, overwrite it — this is a fresh snapshot.

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
Start with metadata and config — go into source directories only to identify entry points, not to understand logic.

## Output format

Keep all table widths under 120 characters — this is a maximum, not a target. Table cells should be as short as the content requires. Do not pad table cells. Use short values — filenames not paths, service names not ARNs, brief descriptions not full commands. If a value is too long to fit, truncate and add a note below the table.

For normal rows and bullet points you do not have to follow the 120 character limit.

Write `docs/discovery-service.md` with the following sections:

### What this service does

2–3 sentences. What problem does it solve and who uses it.
This is a hypothesis based on what you read — label it as such so the developer can confirm or correct it.

### Why it exists

One sentence on the business reason, if determinable from README, config names, or folder structure.
If not determinable, say so — do not infer.

### Stack

A quick orientation — not a deployment guide.

- **Language**:
- **Runtime**:
- **IaC**:

List only what is visible from package manifests and config.

### Entry points

Invokable units only — Lambda handlers, ECS services, workers, schedulers, HTTP routes.
Do not include internal directories, connectors, utilities, or infrastructure stacks.
For each one: name, what it is, and the file to start reading.

| Component | Type | Start here |
| --------- | ---- | ---------- |

### Connections

How this service connects to the world. Populate only the sections that apply — omit sections with nothing to put in them.
All information must come from IaC and config, not inferred from code.

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

### Private packages

List any private packages this service depends on — scoped packages (e.g. `@ticker/*`), internal registries, or GitHub Packages references.
If none are present, omit this section.

| Package | Registry | Where referenced |
| ------- | -------- | ---------------- |

### What is unclear

Anything you could not determine from the available metadata.
This section is mandatory — a short "nothing unclear" is fine, but do not omit it.
A partial answer with visible gaps is more useful than a confident but incomplete summary.
