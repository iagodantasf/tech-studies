---
title: Stashing changes (git stash)
track: git-github
group: Stashing and tags
tags: [git-github, stashing]
prerequisites: [tracking-changes-git-add, the-working-directory-staging-area-and-repository]
see-also: [applying-and-dropping-stashes, resetting-git-reset-soft-mixed-hard]
---

# Stashing changes (git stash)

`git stash` shelves your uncommitted changes onto a hidden stack and reverts the working tree to a clean `HEAD`, so you can switch context without committing half-done work.

## Why it matters

The classic trigger: you are mid-feature when a hotfix lands and `git switch` refuses because changes would be overwritten. Stash parks the mess in seconds, lets you fix the fire on a clean tree, then restores it. It also unblocks `git pull` on a dirty tree and rescues edits made on the wrong branch — far lighter than a throwaway commit you'd later have to [[resetting-git-reset-soft-mixed-hard|reset]].

## How it works

A stash is stored as real commits under `refs/stash`: a commit for the working tree, a parent for the index, and (with `-u`) a third for untracked files. The stack is addressed `stash@{0}` (newest) downward.

| Flag | Effect |
|---|---|
| `-u` / `--include-untracked` | also stash untracked files |
| `-a` / `--all` | include ignored files too |
| `-k` / `--keep-index` | leave staged changes in the tree |
| `-p` / `--patch` | choose hunks interactively |
| `-m "<msg>"` | label the entry instead of the default |
| `push -- <path>` | stash only specific pathspecs |

By default tracked-but-unstaged and staged changes go in; **untracked and ignored files are left behind** unless you pass `-u`/`-a`. `git stash` is shorthand for `git stash push`.

## Example

```
$ git status -s
 M  src/api.ts        # staged
 M  src/util.ts       # unstaged
?? scratch.log        # untracked

$ git stash push -u -m "wip: retry logic"
Saved working directory and index state On feature: wip: retry logic

$ git status -s        # clean — even scratch.log is gone
$ git stash list
stash@{0}: On feature: wip: retry logic
```

## Pitfalls

- **`-u` is not the default** — a plain `git stash` then `git clean -fd` will *delete* the untracked files the stash never captured. Data loss.
- **`--keep-index` misleads** — it keeps staged content in the tree but still *stashes* it; a test run then sees both copies.
- **Stash is per-repo, not per-branch** — `stash@{0}` is visible from any branch and applies wherever you stand, which is easy to get wrong.
- **Reordering shifts indices** — dropping `stash@{1}` renumbers everything above it mid-session.

## See also

- [[applying-and-dropping-stashes]]
- [[resetting-git-reset-soft-mixed-hard]]
