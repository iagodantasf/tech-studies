---
title: Labels and assignees
track: git-github
group: GitHub collaboration
tags: [git-github, planning]
prerequisites: [github-issues]
see-also: [projects-and-milestones, notifications-and-watching]
---

# Labels and assignees

The two lightweight metadata controls on every [[github-issues|issue]] and [[pull-requests|PR]]: labels (categorical tags for filtering and automation) and assignees (the people accountable for the work).

## Why it matters

At any real volume, an unlabeled issue tracker is unsearchable — `is:open label:bug label:priority:high` is how triage, dashboards, and SLAs actually work. Labels are also the trigger surface for automation: bots, [[github-actions-and-ci-cd|Actions]], and stale-issue closers key off label names. Assignees make ownership unambiguous, which is the difference between "someone should look at this" and a named person who gets notified and shows up in their assigned queue.

## How it works

Labels are repo-scoped name + color + description; assignees are accounts with at least read access (up to 10 per item).

| Control | Cardinality | Scope | Drives |
|---|---|---|---|
| Label | Many per item | Repo (org can sync) | Search, automation, board grouping |
| Assignee | Up to 10 | Repo collaborators | Ownership, "Assigned to me" queue |

- Conventional schemes prefix for grouping: `priority:high`, `type:bug`, `area:auth` — colors give instant visual scan.
- GitHub ships defaults (`bug`, `enhancement`, `good first issue`, `help wanted`); the last two are special — they surface the repo in GitHub's contributor-discovery pages.
- Labels power **search and automation**, not assignment; mentioning a [[collaborators-and-teams|team]] in a comment notifies it but does **not** assign it (only individuals are assignees).
- Renaming a label updates it everywhere, but **automation matching the old name silently stops firing**.

## Example

```bash
# Bulk-triage with the gh CLI: label and assign in one call
$ gh issue edit 913 --add-label "type:bug,priority:high" --add-assignee jdoe

# Then the team's triage view:
$ gh issue list --label "priority:high" --assignee "@me" --state open
```

## Pitfalls

- **Label sprawl** — 60 ad-hoc labels with overlapping meaning are worse than 10 disciplined ones; standardize a scheme and prune.
- **Renaming breaks automation** — a workflow filtering `label == "bug"` goes silent after you rename it to `type:bug`; grep workflows before renaming.
- **Assignee ≠ reviewer** — assigning a PR sets ownership, not a review request; reviewers are a separate field that gates the merge.
- **Teams aren't assignable** — you can request a team's *review* but only individuals can be *assignees*; assigning a whole team isn't possible.

## See also

- [[github-issues]]
- [[projects-and-milestones]]
