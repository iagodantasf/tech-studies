---
title: Creating and switching branches (git branch, git switch, git checkout)
track: git-github
group: Branching and merging
tags: [git-github, branching]
prerequisites: [what-is-a-branch, checking-status-git-status]
see-also: [merging-branches-git-merge, restoring-files-git-restore-git-checkout]
---

# Creating and switching branches (git branch, git switch, git checkout)

How to make, list, rename, and move between branches — and why `git switch` exists to split the overloaded `git checkout`.

## Why it matters

Switching branches is the single most frequent navigation operation in Git, done dozens of times a day. `git checkout` historically did *two unrelated jobs* — move between branches and restore files — which caused destructive accidents. Git 2.23 (2019) introduced `git switch` and `git restore` to separate them, and every guide now prefers the focused commands.

## How it works

| Task | Modern (2.23+) | Legacy `checkout` |
|---|---|---|
| Create + switch | `git switch -c feat` | `git checkout -b feat` |
| Switch existing | `git switch feat` | `git checkout feat` |
| Create only, no switch | `git branch feat` | `git branch feat` |
| Switch to a SHA (detach) | `git switch --detach <sha>` | `git checkout <sha>` |
| Restore a file | `git restore path` | `git checkout -- path` |

- `git branch feat [start-point]` creates a pointer at `start-point` (default `HEAD`) but leaves `HEAD` where it is.
- `git switch feat` repoints `HEAD`, then rewrites the working tree to match that tip; uncommitted changes that don't conflict are carried along.
- `git switch -c feat origin/main` creates `feat` *and* sets `origin/main` as upstream (see [[tracking-branches-and-upstream]]).
- `git branch -m old new` renames; `git branch -d feat` deletes (see [[deleting-branches]]).
- `git branch -vv` lists branches with their tip and upstream tracking.

## Example

```
$ git switch -c hotfix-501 main      # branch off the tip of main
Switched to a new branch 'hotfix-501'
$ git branch -vv
* hotfix-501 a71be09 fix null deref
  main       a71be09 [origin/main] release 2.4
$ git switch -                       # jump back to previous branch
Switched to branch 'main'
```

## Pitfalls

- **`git branch feat` then forgetting to switch** — it only creates the pointer; your next commit still lands on the old branch. Use `switch -c` to do both.
- **`git checkout <file>` muscle memory** — the legacy form silently overwrites local edits with no undo. Prefer [[restoring-files-git-restore-git-checkout|git restore]].
- **Dirty tree blocking a switch** — if a tracked file would be clobbered, Git aborts; commit or [[stashing-changes-git-stash|stash]] first.
- **Branching off a stale local main** — `git fetch` first, or branch off `origin/main`, so you don't fork old history.

## See also

- [[merging-branches-git-merge]]
- [[stashing-changes-git-stash]]
