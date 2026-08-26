---
name: branch-diff-review
description: This skill should be used when the user asks to "review this branch", "review my changes before I open a PR", "compare current branch against main/master/target", "diff review", or wants a narrative pre-review pass over local git changes before submitting or reviewing a pull request. Works in any locally-cloned git repository; produces a prose walkthrough (why the branch changed and why that way, correctness/risk/missing-consideration analysis, test coverage, reading order) with file:line references throughout, to give a reviewer real understanding rather than a mechanical diff summary.
---

# Branch Diff Review

Produce a narrative review of the changes between the current branch and a target branch in a local git repository — explaining why the branch changed and why it was done that way, not just cataloging what changed — to give a human reviewer real understanding instead of reading a raw diff cold.

## Step 1: Resolve the target branch

Determine which branch to compare against, in this order:
1. Use the branch the user names explicitly.
2. If none is given, detect the repository's default branch: `git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'`. Fall back to checking for `main` then `master` locally if that fails.
3. If detection is ambiguous (e.g. no origin/HEAD and both main and master exist), ask the user which to use rather than guessing.

## Step 2: Get a fresh, accurate diff

Run in order:
```
git fetch origin <target> --quiet
git merge-base origin/<target> HEAD
```
Use the merge-base commit as the diff base — not `<target>` directly — so the diff only shows what the current branch actually changed, not unrelated commits that landed on target since branching.

```
git log <merge-base>..HEAD --oneline
git diff --stat <merge-base>..HEAD
git diff <merge-base>..HEAD
```

If the working tree has uncommitted changes, note that separately and include them (`git diff HEAD`) — review in-progress work too, not only committed history.

## Step 3: Analyze, don't just relay

Read the full diff and commit log. Read further files within reason: reserve full-file reads for changes where a specific question can't be answered from the diff alone (e.g. "does this still match its caller's expectations," "does this duplicate a sibling function"). Skip it for mechanical, test, and config/infra changes — diff context is normally sufficient for those. Skip it for new files too — the diff already contains the whole thing. Don't read a file just because it appeared in the diff; read it because something specific about its correctness is unresolvable without it.

Before writing anything, work out for yourself:
- Which changes are mechanical (formatting, renames, generated/lockfiles, import reordering, dependency bumps with no code touching them) versus logic (new/changed functions, control flow, business rules) versus test versus config/infra (CI, env, IaC, migrations).
- For every logic change, three separate questions, not one blended "risk" judgment:
  - **Incorrect** — is anything actually wrong: a bug, an off-by-one, a broken assumption, a case the code visibly mishandles?
  - **Can go wrong** — under what runtime conditions could this fail or degrade even if it's correct today? Give extra scrutiny to anything touching auth, payments, migrations, error handling, concurrency, or otherwise security-sensitive.
  - **Worth considering / missing** — what's absent that probably should be there: an unhandled edge case, missing validation, an alternative approach that would have been safer or simpler.
- What tests exist for each piece of changed logic, and which changed logic has none — file by file, not a single yes/no.
- Whether anything here is scope creep (large, unrelated changes bundled into one branch), leftover debug/commented-out code, a fresh TODO/FIXME, or contradicts the stated intent in the commit messages.

This classification is analysis input, not the deliverable — it decides what earns a paragraph of explanation in Step 4 and what gets a single dismissive clause. Don't surface it as a bucketed list in the final report.

## Step 4: Report

Write a narrative walkthrough, not a checklist. The goal is understanding *why* a change happened and *why it was done that way* — not just cataloging that it happened. Reference the actual file (and line, when it sharpens the point) as each change is discussed, so the reader can jump straight to what's being described instead of hunting for it.

```markdown
## What this branch is doing, and why
<Prose. Open with the problem this branch exists to solve — inferred from commits + diff,
not restated from commit messages. Walk through the meaningful changes, naming the file
(and line) as each is discussed — e.g. "the retry logic in `src/auth/session.ts:84` exists
because..." — and explain the mechanism behind why it changed that way: what constraint,
bug, or tradeoff drove this particular approach. Skip past purely mechanical changes with
a line naming them, don't itemize them.>

## Analysis
<Prose, not a bullet list, same file:line convention. Cover, wherever they apply: things
that are actually incorrect (bugs, broken assumptions, mishandled cases), scenarios where
this could go wrong even though it's correct today (concurrency, auth, error handling,
security), and things worth considering or missing (an unhandled edge case, missing
validation, a safer or simpler alternative). Name the file and explain the mechanism, not
just the label — why what this specific code does, at that specific location, could go
wrong or is wrong.>

## Test coverage
<Prose. What's actually covered today — name the test file and what it exercises — and
which changed logic has no accompanying test, tied to the file/line it's missing coverage
for. "None found" if every changed piece of logic that needs coverage has it.>

## Reading order
<Short — a sentence or two naming which file to read first and why, not a list.>
```

Do not soften findings to be agreeable — flag anything that would come up in a real review, including "this diff doesn't match its own commit message."

## Notes

Works identically across any locally-cloned repository since it depends only on `git`, no repo-specific config or GitHub API access.
