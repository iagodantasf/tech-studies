---
title: Tracking branches and upstream
track: git-github
group: Remote repositories
tags: [git-github, branching]
prerequisites: [what-is-a-remote, creating-and-switching-branches-git-branch-git-switch-git-checkout]
see-also: [pushing-git-push, pulling-git-pull]
---

# Tracking branches and upstream

An **upstream** is the link between a local branch and a remote-tracking branch (e.g. `main` → `origin/main`), letting bare [[pulling-git-pull|pull]]/[[pushing-git-push|push]] know where to sync and enabling ahead/behind counts.

## Why it matters

Upstream is what makes `git pull` and `git push` work with no arguments and what powers the "ahead 2, behind 1" status that tells you whether to push or integrate first. Forgetting to set it is the cause of the classic *"There is no tracking information for the current branch"* and *"no upstream branch"* errors.

## How it works

The link is stored in `.git/config` as two keys per branch: `branch.<name>.remote` and `branch.<name>.merge`. It points at a [[what-is-a-remote|remote-tracking branch]], not the remote directly.

- **Set on push** — `git push -u origin feature` records upstream as part of the first push (most common).
- **Set without pushing** — `git branch --set-upstream-to=origin/feature` or `git branch -u origin/feature`.
- **Auto-set** — [[cloning-git-clone|clone]] sets `main`'s upstream; new branches off a tracking branch inherit it if `branch.autoSetupMerge` is on.
- **Ahead/behind** — computed by counting commits in `@{upstream}..HEAD` and `HEAD..@{upstream}`.

| Symbol / status | Meaning |
|---|---|
| `[origin/main]` | upstream is set, in sync |
| `[origin/main: ahead 2]` | 2 local commits to push |
| `[origin/main: behind 1]` | 1 upstream commit to pull |
| `[origin/main: gone]` | upstream branch was deleted remotely |

## Example

```
$ git switch -c feature
$ git push                       # error: no upstream for 'feature'
$ git push -u origin feature     # set upstream + push in one step
   * [new branch]  feature -> feature
$ git branch -vv
* feature 3c0d8e1 [origin/feature] feat: filters
  main    9f2c1ab [origin/main: behind 4] add health check
```

## Pitfalls

- **No upstream set** — bare `git push`/`git pull` errors until you `-u`; the message names the exact fix.
- **`[gone]` upstream** — branch deleted on the remote; `git fetch --prune` then delete the local branch or repoint it.
- **Tracking the wrong branch** — `-u origin/main` on a feature makes `pull` merge `main` into it unexpectedly; verify with `git branch -vv`.
- **Renamed remote branch** — local `merge` config still names the old ref; reset upstream after a remote rename.

## See also

- [[pushing-git-push]]
- [[pulling-git-pull]]
