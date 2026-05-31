---
title: Code review and comments
track: git-github
group: GitHub basics
tags: [git-github, code-review]
prerequisites: [pull-requests]
see-also: [reviewing-and-approving-changes, branch-protection-rules]
---

# Code review and comments

The review layer on a [[pull-requests|PR]]: inline line comments, batched reviews with a verdict, and suggested edits — the workflow teams use to catch defects and share knowledge before code lands.

## Why it matters

Review is the cheapest place to catch bugs and the primary way knowledge spreads across a team; [[branch-protection-rules|branch protection]] can *require* an approving review before merge. Doing it well (small batches, actionable suggestions) speeds delivery; doing it poorly (one comment at a time, vague nits) generates notification spam and stalls PRs for days.

## How it works

GitHub distinguishes a **single comment** (sent immediately) from a **review** (a batch of comments submitted together with one verdict), which avoids drip-notifying the author per line.

| Review verdict | Meaning | Blocks merge? |
|---|---|---|
| Comment | Feedback, no judgment | no |
| Approve | LGTM, ready to merge | no (unblocks) |
| Request changes | Must address before merge | yes, under protection |

- **Suggestions** use a ```` ```suggestion ```` block; the author applies them with one click and they become a commit — great for small fixes.
- Comment on a **range** of lines by click-dragging the gutter; thread replies keep discussion attached to the code, and threads can be marked **Resolved**.
- Use "Start a review" to batch, then "Finish review" with a verdict — not "Add single comment" per line.
- A **Request changes** verdict from a required reviewer hard-blocks merge until that same reviewer re-reviews and dismisses it.

## Example

A suggested change in a review comment:
````
```suggestion
    if not password:
        raise ValueError("password required")
```
````
The author clicks **Commit suggestion** → it's applied as a commit on the PR, no local edit needed.

## Pitfalls

- **Single comments instead of a batched review** — fires a notification per line and gives no overall verdict; always Start to Finish a review.
- **`Request changes` then going on PTO** — only that reviewer (or an admin) can clear it, so the PR is wedged; agree on dismissal norms.
- **Suggestions spanning unshown context** — multi-line suggestions can apply incorrectly if the surrounding code shifted; verify the resulting diff.
- **Nit-only reviews** — blocking on style a [[github-actions-and-ci-cd|linter]] should enforce wastes human review; automate formatting and review for logic.

## See also

- [[reviewing-and-approving-changes]]
- [[branch-protection-rules]]
