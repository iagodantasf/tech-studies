---
title: Checking status (git status)
track: git-github
group: Git fundamentals
tags: [git-github, inspection]
prerequisites: [the-working-directory-staging-area-and-repository]
see-also: [tracking-changes-git-add, viewing-changes-git-diff, ignoring-files-gitignore]
---

# Checking status (git status)

`git status` reports the state of the working tree and [[the-working-directory-staging-area-and-repository|index]] relative to `HEAD`: what is staged, what is modified, and what is untracked.

## Why it matters

It is the most-run Git command and the safety check before every commit, merge, or branch switch — it tells you exactly what will go into the next [[committing-git-commit|commit]] and warns about in-progress operations. Reading it correctly prevents the two classic mistakes: committing the wrong files and clobbering uncommitted work.

## How it works

Output is grouped by area; the short form `git status -s` prints two status columns per file (left = index/staged, right = working tree).

```text
XY   X = staged (index), Y = working tree;  _ marks a space (no change there)
M_   staged modification
_M   unstaged modification
MM   staged, then modified again in the tree
A_   newly added (staged) file
??   untracked
D_   staged deletion        _D   unstaged deletion
```

- **Branch line** — full output names the branch and its position vs upstream (`ahead 2`, `behind 1`, `diverged`) when a [[tracking-branches-and-upstream|tracking branch]] is set.
- **`-uno` / `-uall`** — control untracked-file reporting; `-uno` hides them (faster in huge repos), `-uall` lists files inside untracked dirs.
- **`--ignored`** lists files excluded by [[ignoring-files-gitignore|.gitignore]], useful for debugging why a file won't stage.
- **Operation banners** — during a merge/rebase/cherry-pick, status shows "fix conflicts and run `git commit`" plus the conflicted paths.

## Example

```
git status -s -b
## feature/login...origin/feature/login [ahead 1]
M  auth.py        # staged fix
 M README.md      # edited, not staged
?? .env           # untracked — should this be in .gitignore?
```

Here a commit now would include `auth.py` only; `README.md` and `.env` would be left behind.

## Pitfalls

- **Trusting status to show content** — it lists *which* files changed, not *what* changed; use [[viewing-changes-git-diff|git diff]] to see the actual hunks.
- **Untracked secrets hiding in plain sight** — `??` files like `.env` are easy to scan past and then sweep in with `git add .`.
- **Slow status in monorepos** — millions of files make it crawl; enable `core.fsmonitor` and `untrackedCache`, or scope with a pathspec.

## See also

- [[viewing-changes-git-diff]]
- [[tracking-changes-git-add]]
