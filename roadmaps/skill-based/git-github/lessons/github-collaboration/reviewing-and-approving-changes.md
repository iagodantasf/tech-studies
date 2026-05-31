---
title: Reviewing and approving changes
track: git-github
group: GitHub collaboration
tags: [git-github, code-review]
prerequisites: [pull-requests]
see-also: [branch-protection-rules, code-review-and-comments]
---

# Reviewing and approving changes

The formal review workflow on a [[pull-requests|pull request]] — line comments batched into a review that ends in Approve, Request changes, or Comment.

## Why it matters

Code review is where most defects and design problems get caught before they ship, and a recorded **Approve** is the gate that [[branch-protection-rules|protection rules]] count toward "N approvals required." The state you submit has teeth: a single **Request changes** blocks the merge until you (or the rule's dismissal logic) clear it. Done well it spreads knowledge; done as a rubber-stamp it's pure overhead, so the mechanics of *who must review what* matter.

## How it works

Individual remarks are **pending** until you finish the review and submit a final verdict. **CODEOWNERS** auto-requests the right people based on changed paths.

| Review verdict | Meaning | Effect on merge |
|---|---|---|
| Comment | Feedback, no judgment | None |
| Approve | Looks good to merge | Counts toward required approvals |
| Request changes | Must address before merge | Blocks until resolved/dismissed |

- `CODEOWNERS` lives in `.github/`, root, or `docs/`; a glob like `/api/ @acme/backend` requires that team's approval on any matching file when made a required reviewer.
- **Last matching pattern wins** in CODEOWNERS (like [[ignoring-files-gitignore|.gitignore]]), not the most specific — ordering is load-bearing.
- "Dismiss stale approvals" (a protection setting) voids prior approvals when a new commit lands, forcing re-review of the change.
- Suggested changes (a fenced ```suggestion``` block) let the author commit a reviewer's edit with one click.

## Example

```
# CODEOWNERS — order matters, last match wins
*               @acme/maintainers
/frontend/      @acme/web
/frontend/i18n/ @acme/localization   # this overrides @acme/web for i18n
```

A PR touching `/frontend/i18n/en.json` requires `@acme/localization`, not `@acme/web`.

## Pitfalls

- **Self-approval expectation** — you cannot approve your own PR; a 1-approval rule on a solo task still needs a second person.
- **CODEOWNERS not enforced** — the file only *requests* owners; without "Require review from Code Owners" in protection, their approval is optional.
- **Pending comments never submitted** — comments left in the "pending" state are invisible to the author until you click Submit review.
- **Approving stale** — approving, then the author force-pushes a rewrite; if stale-dismissal is off, the old approval still satisfies the gate.

## See also

- [[pull-requests]]
- [[branch-protection-rules]]
