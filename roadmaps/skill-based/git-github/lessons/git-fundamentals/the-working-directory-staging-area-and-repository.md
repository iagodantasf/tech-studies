---
title: The working directory, staging area, and repository
track: git-github
group: Git fundamentals
tags: [git-github, git-internals]
prerequisites: [initializing-a-repository-git-init]
see-also: [tracking-changes-git-add, committing-git-commit, checking-status-git-status]
---

# The working directory, staging area, and repository

Git models your project as three states a file moves through — the working directory, the staging area (index), and the committed repository.

## Why it matters

Almost every Git command is really a move between these three areas, so the mental model demystifies what [[tracking-changes-git-add|add]], [[committing-git-commit|commit]], [[resetting-git-reset-soft-mixed-hard|reset]], and [[restoring-files-git-restore-git-checkout|restore]] actually do. Understanding the staging area is what lets you craft small, reviewable commits instead of dumping every change at once.

## How it works

A file lives in one or more areas; commands shuttle its content between them. The staging area is a real file, `.git/index`, that records the exact tree of your *next* commit.

| Area | Backing store | "Where you are" |
|---|---|---|
| Working directory | Files on disk | Your edits, uncommitted |
| Staging area (index) | `.git/index` | Snapshot queued for commit |
| Repository | `.git/objects` | Immutable committed history |

- `git add` copies working-dir content **into** the index (modified → staged).
- `git commit` snapshots the **index** into a new commit object (staged → committed).
- `git restore --staged <f>` unstages (index ← `HEAD`); `git restore <f>` discards working-dir edits (working ← index).
- A file can be staged *and* further modified — the index holds the old content, the working dir the new; [[checking-status-git-status|git status]] shows it in **both** sections.

## Example

```
echo "v1" > config.txt
git add config.txt          # working → index (v1 staged)
echo "v2" >> config.txt     # working dir now has v1+v2, index still v1
git status                  # "Changes to be committed" AND "Changes not staged"
git commit -m "add config"  # commits ONLY v1 (the indexed snapshot)
```

## Pitfalls

- **Assuming `commit` grabs your latest edits** — it commits the *index*, not the disk; edits made after `git add` are excluded unless re-added (or you use `git commit -a`).
- **"Unstaged" vs "untracked" confusion** — a brand-new file is *untracked* (never added); a known file with edits is *modified/unstaged*. Different status sections, different remedies.
- **Editing while a `merge`/`rebase` is mid-flight** — the index may already hold conflict markers; check status before adding.

## See also

- [[tracking-changes-git-add]]
- [[committing-git-commit]]
