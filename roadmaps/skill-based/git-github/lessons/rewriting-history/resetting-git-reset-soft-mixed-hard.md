---
title: Resetting (git reset --soft / --mixed / --hard)
track: git-github
group: Rewriting history
tags: [git-github, history-rewriting]
prerequisites: [the-working-directory-staging-area-and-repository, committing-git-commit]
see-also: [reflog-and-recovery-git-reflog, reverting-commits-git-revert]
---

# Resetting (git reset --soft / --mixed / --hard)

`git reset` moves the current branch pointer to another commit and, depending on the mode, optionally rewinds the staging area and working tree to match.

## Why it matters

Reset is how you undo *locally*: uncommit but keep the changes, unstage files, or nuke everything back to a known commit. Understanding the three modes is the difference between safely reshaping unpushed work and accidentally deleting a day's edits. It targets the three trees Git tracks — `HEAD`, index, working tree (see [[the-working-directory-staging-area-and-repository]]).

## How it works

`git reset [mode] <commit>` always moves `HEAD`/branch; the mode controls how far the change propagates:

| Mode | HEAD moves | Index reset | Working tree | Common use |
|---|---|---|---|---|
| `--soft` | yes | no | no | uncommit, keep changes staged |
| `--mixed` (default) | yes | yes | no | uncommit + unstage |
| `--hard` | yes | yes | yes | discard everything to that commit |

`git reset <commit> -- <path>` (no mode) is a different operation: it unstages a path without moving `HEAD` — the classic "undo `git add`". Only `--hard` destroys uncommitted work; `--soft`/`--mixed` are recoverable because edits remain on disk.

## Example

```
$ git reset --soft HEAD~1     # last commit's changes return to the index
$ git reset HEAD~1            # (--mixed) changes return, now unstaged
$ git reset --hard HEAD~1     # last commit AND its changes gone from tree
```

Squash-by-reset: `git reset --soft HEAD~3 && git commit -m "One commit"` collapses 3 commits into 1 while keeping the combined diff staged.

## Pitfalls

- **`--hard` is irreversible for uncommitted work** — it overwrites the working tree with no copy anywhere; un-committed but un-staged edits are simply gone (the [[reflog-and-recovery-git-reflog|reflog]] only recovers *committed* states).
- **Resetting a pushed branch** — rewinding past commits others have requires a force push and rewrites shared history; prefer [[reverting-commits-git-revert|revert]] there.
- **`--hard` leaves untracked files** — it resets tracked files only; stray build output survives. Pair with `git clean` to fully reset.
- **Confusing reset with checkout/restore** — modern Git splits "move branch" (`reset`) from "restore file" (`git restore`); reaching for `reset --hard` to revert one file is overkill.

## See also

- [[reflog-and-recovery-git-reflog]]
- [[reverting-commits-git-revert]]
