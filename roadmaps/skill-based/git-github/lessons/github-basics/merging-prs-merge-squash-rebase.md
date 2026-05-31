---
title: Merging PRs (merge, squash, rebase)
track: git-github
group: GitHub basics
tags: [git-github, pull-requests]
prerequisites: [pull-requests, merging-branches-git-merge]
see-also: [rebasing-git-rebase, branch-protection-rules]
---

# Merging PRs (merge, squash, rebase)

The three ways GitHub can land a [[pull-requests|PR]] into the base branch — **merge commit**, **squash**, and **rebase** — each producing a different shape of history.

## Why it matters

The choice decides whether `main` reads as a clean one-line-per-feature log or preserves every WIP commit, and whether [[reverting-commits-git-revert|reverting]] a feature is one click or a hunt. Teams standardize on one (often squash) and disable the rest in repo settings, because mixing them yields an inconsistent, hard-to-bisect history.

## How it works

GitHub takes the head branch's commits and integrates them per the chosen strategy; the button reflects which options the repo allows.

| Strategy | Commits on base | New SHAs | Best when |
|---|---|---|---|
| Merge commit | all head commits + 1 merge | merge commit only | preserve full branch history |
| Squash | one combined commit | new single commit | tidy `main`, messy WIP |
| Rebase | head commits, replayed linear | every commit rewritten | linear history, meaningful commits |

- **Squash** is the common default: the PR becomes one commit titled from the PR; the body collects the squashed messages. Clean log, easy revert, but intra-PR granularity is lost.
- **Merge commit** keeps every commit and records a [[fast-forward-vs-three-way-merge|three-way merge]] node — full history, but a noisier graph.
- **Rebase** replays commits with new SHAs onto base for a linear history and *no* merge node (see [[rebasing-git-rebase|rebase]]); each commit must stand on its own.
- After merge, GitHub offers to delete the head branch; enabling auto-delete keeps the branch list clean.

## Example

```
# Squash via CLI, then drop the branch:
$ gh pr merge 377 --squash --delete-branch
✓ Squashed and merged pull request #377
✓ Deleted branch fix-login

# Result on main: one commit "Fix login 500 (#377)"
```

## Pitfalls

- **Squash then reusing the branch** — the original commits never reached `main`, so continuing on that branch creates confusing "already merged" diffs; branch fresh from `main`.
- **Rebase-merge on a shared head** — rewrites SHAs anyone who pulled the branch now diverges from; safe only because the branch is about to be deleted.
- **Mixed strategies across PRs** — some squashed, some merge-commits makes `git bisect` and changelog generation erratic; pick one in settings.
- **Squash loses co-author trailers** — `Co-authored-by` lines must survive into the squashed message or contributors lose credit; check the combined commit body.

## See also

- [[rebasing-git-rebase]]
- [[branch-protection-rules]]
