---
title: Reflog and recovery (git reflog)
track: git-github
group: Rewriting history
tags: [git-github, recovery]
prerequisites: [resetting-git-reset-soft-mixed-hard, committing-git-commit]
see-also: [rebasing-git-rebase, amending-commits-git-commit-amend]
---

# Reflog and recovery (git reflog)

`git reflog` is a local journal of everywhere `HEAD` (and each branch) has pointed, making "lost" commits from a bad reset, rebase, or amend recoverable.

## Why it matters

Almost nothing in Git is truly deleted on the spot — when [[resetting-git-reset-soft-mixed-hard|reset --hard]] or a botched [[rebasing-git-rebase|rebase]] "loses" commits, they become unreferenced but still in the object store. The reflog remembers the SHAs you abandoned, so recovery is usually a one-line copy-paste. It is the single most reassuring safety net in Git and the first thing to reach for after an "oh no".

## How it works

Every move of a ref (commit, checkout, reset, rebase, merge, amend) appends an entry. `git reflog` shows `HEAD`'s history; `git reflog show <branch>` shows a specific branch's.

```
$ git reflog
f9e8d7c HEAD@{0}: reset: moving to HEAD~2
a1b2c3d HEAD@{1}: commit: Add validation     <-- the "lost" work
7766554 HEAD@{2}: commit: Add parser
```

| Syntax | Meaning |
|---|---|
| `HEAD@{2}` | where HEAD was 2 moves ago |
| `HEAD@{1.hour.ago}` | time-based selector |
| `main@{yesterday}` | that branch, yesterday |

To recover: `git branch rescue a1b2c3d` or `git reset --hard HEAD@{1}`. The reflog is **per-clone and never pushed**; entries expire (`gc.reflogExpire`, default 90 days; 30 for unreachable).

## Example

```
$ git reset --hard HEAD~2        # oops, dropped 2 commits
$ git reflog                     # find them
a1b2c3d HEAD@{1}: commit: Add validation
$ git reset --hard HEAD@{1}      # back to safety
HEAD is now at a1b2c3d Add validation
```

## Pitfalls

- **Not a remote backup** — the reflog lives only in your local `.git`; a deleted clone or a fresh `git clone` has none of it. Push or back up real work.
- **Expiry + `gc`** — unreachable commits past `gc.reflogExpireUnreachable` (30 days) can be pruned by garbage collection and become unrecoverable.
- **Detached-HEAD commits vanish from `branch -d` view** — work done on a detached `HEAD` is only findable via reflog; name it with a branch promptly.
- **`reflog expire --expire=now` is destructive** — combined with `git gc --prune=now` it deliberately discards the safety net; never run it to "clean up" carelessly.

## See also

- [[resetting-git-reset-soft-mixed-hard]]
- [[rebasing-git-rebase]]
