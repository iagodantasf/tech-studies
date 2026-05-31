---
title: Cleaning untracked files (git clean)
track: git-github
group: Inspecting and undoing
tags: [git-github, undoing]
prerequisites: [the-working-directory-staging-area-and-repository, ignoring-files-gitignore]
see-also: [restoring-files-git-restore-git-checkout, resetting-git-reset-soft-mixed-hard]
---

# Cleaning untracked files (git clean)

`git clean` deletes **untracked** files (and optionally directories) from the working tree — the one undo command that targets files Git isn't yet versioning.

## Why it matters

Build artifacts, generated code, downloaded fixtures, and stray scratch files accumulate as untracked clutter that no `restore` or `reset` will remove. `git clean` returns the tree to a pristine, just-cloned state — essential before a clean rebuild, when reproducing a "works on my machine" bug, or in CI to guarantee no leftover output skews the next run.

## How it works

`git clean` operates *only* on untracked paths; tracked files (even modified) are never touched. Because it permanently deletes, Git refuses to run without a force flag unless `clean.requireForce=false`.

| Flag | Effect |
|---|---|
| `-n` | **dry run** — list what *would* be deleted, delete nothing |
| `-f` | force the deletion (required to actually remove) |
| `-d` | also remove untracked **directories** |
| `-x` | also remove **ignored** files (.gitignore no longer protects) |
| `-X` | remove *only* ignored files, keep other untracked ones |

- **Always `-n` first** — `git clean -nd` previews every path; only then swap to `-fd`. This is the single habit that prevents disasters.
- **`-x` vs `-X`** — lowercase `-x` ignores your ignore-rules and nukes `node_modules/`, `target/`, `.env`; uppercase `-X` deletes *only* ignored files (handy to clear build output while keeping new source). See [[ignoring-files-gitignore|.gitignore]].
- **Scoping** — `git clean -fd path/` confines it to a subtree; `-e <pattern>` spares matching paths.
- Pairs with [[resetting-git-reset-soft-mixed-hard|git reset --hard]]: reset reverts *tracked* files, clean removes *untracked* ones — together they fully reset a worktree.

## Example

```
$ git clean -nd
Would remove build/
Would remove debug.log
Would remove tmp/cache.bin
$ git clean -fd          # ok, do it (directories included)
$ git clean -fdx         # nuke ignored stuff too: node_modules/, .env, dist/
```

## Pitfalls

- **It is irreversible** — untracked files were never in Git, so there is no [[reflog-and-recovery-git-reflog|reflog]] or [[stashing-changes-git-stash|stash]] to recover them. Skipping the `-n` preview has cost people their `.env` and local config.
- **`-x` deletes your secrets** — because it ignores `.gitignore`, `-x` happily removes uncommitted `.env` and credentials; reach for `-X` or `-e` when you only want build junk gone.
- **Forgetting `-d`** — without it, untracked *directories* are left behind and the tree isn't actually clean.
- **Nested repos are spared** — untracked subdirectories that contain their own `.git` need `-ff` to remove; plain `-f` skips them by design.

## See also

- [[restoring-files-git-restore-git-checkout]]
- [[resetting-git-reset-soft-mixed-hard]]
