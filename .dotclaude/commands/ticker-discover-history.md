# /ticker-discover-history

Produces a git history summary for a repo you need to understand over time.
Summarises activity patterns, what was being worked on, and whether infrastructure and CI/CD kept pace with application code.
Do not read file contents. Do not read diffs. Work only from git metadata.
Write the output to `docs/discovery-history.md`. If the file already exists, overwrite it.

## Discovery phase

Run the following git commands:

- `git rev-list --count HEAD` — total commit count; use this to decide scope before running the full log
- If total commits is 500 or fewer, run `git log --stat --stat-graph-width=1 --date=short --pretty=format:"%h %ad %s"` — full history
- If total commits exceeds 500, run `git log -n 500 --stat --stat-graph-width=1 --date=short --pretty=format:"%h %ad %s"` — capped at 500; flag this as a partial analysis in the output
- `git log --pretty=format:"%ad" --date=format:"%Y-%m" | sort | uniq -c` — commit volume per month to identify activity periods
- `git tag --sort=-creatordate | head -20` — recent tags and release patterns if present

Do not read any file contents. All analysis must come from commit messages, dates, and file change lists.

## Output format

Keep all table widths under 120 characters — this is a maximum, not a target. Table cells should be as short as the content requires. Do not pad table cells. Use short values — filenames not paths, brief descriptions not full sentences. If a value is too long to fit, truncate and add a note below the table.
Order all tables with the most recent entries first.

For normal rows and bullet points you do not have to follow the 120 character limit.

Write `docs/discovery-history.md` with the following sections:

### Activity summary

A short paragraph on the overall activity pattern — when the repo was most active, whether it is currently active or dormant, and any obvious shifts in focus over time.
Do not judge whether dormancy means abandoned or stable — that is a human call.
If the analysis is based on a capped commit range, state this explicitly: "This analysis covers the most recent 500 of X total commits. Older history was not analysed."

### Activity by period

| Period | Commits | Notes |
| ------ | ------- | ----- |

Group by month or quarter depending on the length of the history. Flag periods of unusually high or low activity.

### Key contributors

2–4 sentences. Identify who likely understands how this codebase works, based on the nature of their contributions — not commit count, lines changed, or files touched alone, as these are all misleading. Use commit messages alongside what files changed to distinguish substantive work (new functionality, bug fixes, architectural changes) from mechanical changes (renames, reformatting, dependency bumps). For each person name the areas they were doing substantive work in. Order by who is most likely to still have working knowledge, weighting recency.

### What was being worked on

A short list of the main themes visible from commit messages — what problems were being solved, what areas of the codebase were touched most.
If commit messages are too sparse to summarise ("fix", "wip", "update"), say so explicitly.

### Infrastructure vs application cadence

When were CI/CD and IaC files last changed relative to application code? A large gap here is a risk signal — the deployment config may not reflect how the service currently works.

| Area | Last changed | Notes |
| ---- | ------------ | ----- |

### Commits requiring attention

Any commits that stand out — flagged as temporary, unsafe for production, or explicitly marked as needing follow-up.
If none are found, omit this section.

| Commit | Message | Date |
| ------ | ------- | ---- |

### What is unclear

Anything that could not be determined from git metadata alone.
This section is mandatory. Do not omit it.
