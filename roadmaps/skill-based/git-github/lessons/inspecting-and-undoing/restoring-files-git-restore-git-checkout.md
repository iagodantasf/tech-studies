---
title: Restoring files (git restore, git checkout --)
track: git-github
group: Inspecting and undoing
tags: [git-github, undoing]
prerequisites: [the-working-directory-staging-area-and-repository, tracking-changes-git-add]
see-also: [resetting-git-reset-soft-mixed-hard, cleaning-untracked-files-git-clean]
---

# Restoring files (git restore, git checkout --)

`git restore` (Git 2.23+) discards changes or unstages files at the *file* level, replacing the overloaded `git checkout -- <file>` with a clearer, safer verb.

## Why it matters

The two most common "undo" needs are "throw away my edits to this file" and "unstage this file" — and for years both were spelled `git checkout`, the same word used to switch branches. `git restore` (and its sibling [[creating-and-switching-branches-git-branch-git-switch-git-checkout|git switch]]) split those jobs into dedicated commands, removing a notorious footgun where a stray argument blew away work or detached HEAD.

## How it works

`git restore` copies content *from a source* (default: the index) *into a destination* (default: the working tree). The flags choose source and destination.

| Goal | restore | old checkout |
|---|---|---|
| Discard unstaged edits to a file | `git restore <f>` | `git checkout -- <f>` |
| Unstage (keep edits) | `git restore --staged <f>` | `git reset HEAD <f>` |
| Discard staged *and* unstaged | `git restore -SW <f>` | `git checkout HEAD -- <f>` |
| Get a file from another commit | `git restore -s <rev> <f>` | `git checkout <rev> -- <f>` |

- **Destinations** — `--worktree`/`-W` (default) hits your files; `--staged`/`-S` hits the index. Combine `-SW` to reset both to the source.
- **Source** — `--source`/`-s <tree>` pulls from any commit/tree; without it, `-S` defaults to `HEAD` and `-W` defaults to the index.
- **Interactive/partial** — `git restore -p <f>` discards hunk-by-hunk, the inverse of `git add -p`.
- `git checkout -- <f>` still works and is identical to `git restore -W`; new scripts should prefer `restore` for clarity.

## Example

```
$ git restore config.yml            # drop unstaged edits to one file
$ git restore --staged secret.env   # unstage, but keep my edits
$ git restore -s HEAD~1 -- app.js   # bring back yesterday's app.js into the tree
$ git restore .                     # discard ALL unstaged changes (no undo!)
```

## Pitfalls

- **Working-tree restore is unrecoverable** — discarded unstaged edits were never committed, so [[reflog-and-recovery-git-reflog|reflog]] can't bring them back. Confirm with `git diff` first.
- **`git restore .` is silent and total** — no prompt, no [[stashing-changes-git-stash|stash]]; it wipes every unstaged change in the path. Many people `git stash` instead as a safety net.
- **`--staged` alone keeps file edits** — it only unstages; to *also* revert the file content you need `-SW` (or a second `git restore <f>`).
- **It won't touch untracked files** — restore only knows tracked content; brand-new files need [[cleaning-untracked-files-git-clean|git clean]].

## See also

- [[resetting-git-reset-soft-mixed-hard]]
- [[cleaning-untracked-files-git-clean]]
