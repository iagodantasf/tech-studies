---
title: GitHub Issues
track: git-github
group: GitHub basics
tags: [git-github, issue-tracking]
prerequisites: [creating-a-github-account-and-repository]
see-also: [labels-and-assignees, pull-requests]
---

# GitHub Issues

Issues are GitHub's built-in tracker for bugs, features, and tasks — threaded discussions tied to a repo, with labels, assignees, and cross-references that link directly to the code and [[pull-requests|PRs]] that resolve them.

## Why it matters

Issues are the unit of work most teams plan around; their tight coupling to commits and PRs means a fix is traceable from report to merged code. The "closing keyword" mechanic auto-closes issues when a PR merges, keeping the backlog honest without manual bookkeeping — a major reason teams keep tracking inside GitHub rather than a separate tool.

## How it works

Each issue gets a repo-unique number (shared sequence with PRs). Issue templates (`.github/ISSUE_TEMPLATE/*.yml`) shape what reporters must provide.

| Mechanism | Syntax | Effect |
|---|---|---|
| Cross-reference | `#142` | Links and back-links the item |
| Closing keyword | `Fixes #142` in a PR | Auto-closes on merge |
| Assignee | `@octocat` | Shows in their dashboard |
| Mention | `@team` | Notifies, no assignment |

- Closing keywords (`close`/`closes`/`closed`, `fix(es/ed)`, `resolve(s/d)`) only auto-close when on the **default branch** via a merged PR — not from a feature branch.
- [[labels-and-assignees|Labels]] (`bug`, `good first issue`) drive triage and filtering; `is:open label:bug` in search narrows fast.
- Issues can be converted into discussions, pinned, or grouped under Projects and Milestones for planning.

## Example

```
# Issue #142: "Login throws 500 on empty password"
# A PR body contains:
Fixes #142

# On merge to main, GitHub auto-closes #142 and links the commit.
# Reference (no close) from another issue's comment:
Same root cause as #98 — see stack trace there.
```

## Pitfalls

- **Closing keyword on a non-default branch** — merging a `Fixes #142` PR into `develop` does *not* close the issue until it reaches the default branch.
- **`#142` inside a code block or backticks** — not linked; the autolink only fires in rendered prose.
- **Mention vs assign confusion** — `@user` in text only notifies; you must set the Assignees field for it to appear in their work queue.
- **Templates ignored on quick create** — the blank-issue escape hatch lets reporters skip your template; disable it in config if you require structured reports.

## See also

- [[labels-and-assignees]]
- [[pull-requests]]
