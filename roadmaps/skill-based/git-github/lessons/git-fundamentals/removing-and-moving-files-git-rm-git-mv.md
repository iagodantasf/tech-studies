---
title: Removing and moving files (git rm, git mv)
track: git-github
group: Git fundamentals
tags: [git-github, file-operations]
prerequisites: [tracking-changes-git-add]
see-also: [ignoring-files-gitignore, committing-git-commit, restoring-files-git-restore-git-checkout]
---

# Removing and moving files (git rm, git mv)

`git rm` and `git mv` delete and rename tracked files while **staging** that change in one step, keeping the [[the-working-directory-staging-area-and-repository|index]] and disk in sync.

## Why it matters

Deleting or renaming with the OS leaves the change unstaged, so it is easy to forget half of a rename in the next [[committing-git-commit|commit]]. These commands do the filesystem action *and* the staging together, and `git rm --cached` is the standard way to stop tracking a file (e.g. a leaked config) without deleting it locally.

## How it works

Git does not store renames; it stores snapshots and *detects* renames at diff time by content similarity. `git mv old new` is just shorthand for `rm old` + add `new`.

| Command | On disk | In index |
|---|---|---|
| `git rm f` | Deletes `f` | Stages deletion |
| `git rm --cached f` | **Keeps** `f` | Untracks it (now `??`) |
| `git rm -r dir/` | Deletes dir tree | Stages all deletions |
| `git mv a b` | Renames a→b | Stages rename |

- **`--cached`** — the key flag for "stop tracking but keep the file"; pair it with a [[ignoring-files-gitignore|.gitignore]] entry so it does not get re-added.
- **Safety guard** — `git rm` refuses if the file has staged or working-tree changes you'd lose; override with `-f`, or use `--cached` to be safe.
- **Rename detection** — `git log --follow <file>` and `git diff -M` reconstruct history across renames using the similarity index; a rename + heavy edit in one commit may not be detected as a rename.

## Example

```
git rm --cached .env       # stop tracking a committed secret, keep it locally
echo ".env" >> .gitignore
git commit -m "chore: stop tracking .env, add to gitignore"

git mv src/util.py src/helpers.py
git status -s              # R  src/util.py -> src/helpers.py
```

## Pitfalls

- **OS `rm`/`mv` instead of `git`** — the deletion/rename shows as unstaged; you must still `git add` (or `git add -A`) it, and a forgotten half-rename breaks the build.
- **`--cached` does not scrub history** — the file's old contents remain in every prior commit; for a real secret you must rewrite history and rotate the credential.
- **Rename + big edit looks like delete+add** — drops `blame`/`--follow` continuity; split the rename and the edit into two commits to preserve history.
- **`git rm -r` is staged immediately** — recovering means `git restore --staged` + `git restore` before committing; after commit, use `git revert` or checkout from `HEAD~1`.

## See also

- [[ignoring-files-gitignore]]
- [[restoring-files-git-restore-git-checkout]]
