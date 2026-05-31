---
title: Tracking changes (git add)
track: git-github
group: Git fundamentals
tags: [git-github, staging]
prerequisites: [the-working-directory-staging-area-and-repository]
see-also: [committing-git-commit, checking-status-git-status, ignoring-files-gitignore]
---

# Tracking changes (git add)

`git add` copies the current content of files from the working directory into the [[the-working-directory-staging-area-and-repository|staging area]], queuing exactly what the next commit will contain.

## Why it matters

It is the deliberate gate between "I edited stuff" and "this belongs in history." Because Git stages a *snapshot of content* (not a file reference), `git add` is also how you split one messy working tree into several focused, reviewable [[committing-git-commit|commits]] — the foundation of a clean history and clean [[pull-requests|PRs]].

## How it works

`git add` writes blob objects for the named content into `.git/objects` and updates `.git/index` to point at them. It both **tracks** new files and **stages** modifications to known ones.

| Invocation | Stages |
|---|---|
| `git add file.txt` | One specific file |
| `git add .` | Everything under the current dir (respects ignore rules) |
| `git add -A` | All changes repo-wide, **including deletions** |
| `git add -u` | Modifications + deletions of *already-tracked* files only |
| `git add -p` | Interactively, hunk by hunk |

- **`-p` (patch mode)** lets you stage part of a file: `y`/`n` per hunk, `s` to split a hunk, `e` to edit it. This is how you keep an unrelated debug print out of a feature commit.
- **`-A` vs `.`** — `.` historically ignored deletions in old Git and is path-scoped; `-A` is whole-tree and catches removes. Prefer `-A` when you mean "all".
- **Re-adding** — staging a file, then editing it again, requires another `git add` to capture the newer content.

## Example

```
git status -s
 M api.py          # modified, not staged
?? notes.txt       # untracked
git add -p api.py  # stage only the bugfix hunk, skip the debug print
git add notes.txt  # start tracking the new file
git status -s
M  api.py          # left column = staged
A  notes.txt
 M api.py          # still unstaged remainder (debug print)
```

## Pitfalls

- **`git add .` sweeping in junk** — secrets, build output, or `.env` get staged when [[ignoring-files-gitignore|.gitignore]] is missing an entry; check `git status` before committing.
- **Staging then forgetting later edits** — the commit reflects the moment of `add`, not your final save; re-`add` after each change or use `git commit -a` for tracked files.
- **`git add -A` from a subdir surprise** — it stages the *entire* repo, not just your folder; scope with an explicit pathspec if that is not intended.

## See also

- [[committing-git-commit]]
- [[checking-status-git-status]]
