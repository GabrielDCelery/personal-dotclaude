# /ticker-discover-deployment

Produces a deployment reference for a repo you need to deploy.
Discovers how deployment actually works from CI/CD config, IaC, and pipeline definitions.
Do not guess. Do not infer from code. If something is not determinable from config, say so explicitly.
Write the output to `docs/discovery-deployment.md`. If the file already exists, overwrite it.

## Discovery phase

Scan for deployment-related files:

- CI/CD: `buildspec.yml`, `.circleci/`, `.github/workflows/`, `Jenkinsfile`
- IaC: `serverless.yml`, `cdk/`, `*.tf`, `cloudformation/`
- Pipeline: CDK pipeline stacks, `pipeline/` directories
- Scripts: `build.sh`, `deploy.sh`, `Makefile`, `mise.toml`, `Taskfile.yml`
- Config: `.env.example`, `config/`, SSM parameter references in IaC

## Output format

Keep all table widths under 120 characters — this is a maximum, not a target. Table cells should be as short as the content requires. Do not pad table cells. Use short values — filenames not paths, service names not ARNs, brief descriptions not full commands. If a value is too long to fit, truncate and add a note below the table.

For normal rows and bullet points you do not have to follow the 120 character limit.

Write `docs/discovery-deployment.md` with the following sections:

### Deployment mechanism

How this service is deployed — CI/CD pipeline, Service Catalog, manual CLI, or other.
One paragraph. State what triggers a deployment and what actually runs it.
If multiple mechanisms exist, list all of them.

### Environments

Which environments exist and how they differ.

| Environment | AWS Account | How to deploy | Notes |
| ----------- | ----------- | ------------- | ----- |

If the AWS account is not determinable, leave it blank — do not guess.

### Pre-deployment checklist

What must exist before the deployment itself will succeed.
Credentials, SSM parameters, S3 buckets, pipeline setup, manual steps.

| What | Where it lives |
| ---- | -------------- |

### Runtime dependencies

What must be deployed and running for this service to function after deployment.
Other services, SNS topics, DynamoDB tables, external APIs.

| What | Where it lives |
| ---- | -------------- |

### Oddities

Anything unusual, non-standard, or that a developer would not expect.
Manual approval gates, commented-out steps, environment-specific overrides, deprecated mechanisms still in use.

### What is unclear

Anything that could not be determined from the available config.
This section is mandatory. Do not omit it.
A wrong assumption about deployment can cause real damage — gaps are better than guesses.
