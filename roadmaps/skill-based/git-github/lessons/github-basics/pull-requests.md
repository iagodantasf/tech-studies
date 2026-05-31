---
title: Pull Requests
track: git-github
group: GitHub basics
tags: [git-github, pull-requests]
prerequisites: [pushing-git-push, what-is-a-branch]
see-also: [code-review-and-comments, merging-prs-merge-squash-rebase]
---

# Pull Requests

A pull request (PR) proposes merging one branch into another, wrapping the diff in a reviewable thread with comments, CI checks, and merge controls — the heart of collaboration on GitHub.

## Why it matters

The PR is where review, [[github-actions-and-ci-cd|CI]], and [[branch-protection-rules|branch protection]] converge: it is the gate that stops unreviewed or failing code from reaching `main`. It also creates a durable record of *why* a change was made (description, discussion, linked [[github-issues|issues]]) that outlives the people who wrote it.

## How it works

A PR is defined by a **base** branch (where it merges *to*) and a **head** branch (where the work *is*); GitHub continuously diffs head against the merge base and re-runs checks as you push.

| Concept | Meaning |
|---|---|
| base | branch you merge into (e.g. `main`) |
| head | your feature branch (or `fork:branch`) |
| draft | PR not yet ready; blocks merge, signals WIP |
| checks | CI status that gates merge |
| Fixes #N | links and auto-closes an issue on merge |

- New commits pushed to head update the **same** PR — no need to reopen; review and CI re-trigger automatically.
- Open as a **draft** while WIP to invite early feedback without requesting formal review or allowing merge.
- A PR from a [[forking-a-repository|fork]] sets head to `fork-owner:branch`; maintainers can optionally push to it if "allow edits from maintainers" is on.
- Merge readiness combines required reviews + passing checks + up-to-date base, all enforced by [[branch-protection-rules|protection rules]].

## Example

```
$ git switch -c fix-login && git commit -am "Fix 500 on empty password"
$ git push -u origin fix-login
$ gh pr create --base main --title "Fix login 500" --body "Fixes #142"
https://github.com/acme/api/pull/377
# Address review → push more commits → same PR #377 updates → merge when green
```

## Pitfalls

- **Wrong base branch** — opening against `main` when the team merges into `develop` shows a huge or empty diff; switch the base, don't reopen.
- **Force-pushing the head mid-review** — rewrites history reviewers already read; prefer adding commits, or warn the team and use `--force-with-lease`.
- **Giant PRs** — 1000-line PRs get rubber-stamped; aim for small, focused diffs that a reviewer can actually reason about.
- **Stale base** — green checks can hide a conflict with newly merged `main`; require "branch up to date" so CI tests the real result.

## See also

- [[code-review-and-comments]]
- [[merging-prs-merge-squash-rebase]]
