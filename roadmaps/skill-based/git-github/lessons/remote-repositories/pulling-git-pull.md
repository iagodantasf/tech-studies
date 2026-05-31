---
title: Pulling (git pull)
track: git-github
group: Remote repositories
tags: [git-github, syncing]
prerequisites: [fetching-git-fetch, merging-branches-git-merge]
see-also: [rebasing-git-rebase, tracking-branches-and-upstream]
---

# Pulling (git pull)

`git pull` is a convenience command that runs [[fetching-git-fetch|git fetch]] followed by an integrate step ([[merging-branches-git-merge|merge]] by default, or [[rebasing-git-rebase|rebase]]) of the upstream branch into your current branch.

## Why it matters

It is the everyday "get the latest" command, but unlike `fetch` it **edits your working tree** and can create merge commits or conflicts. Knowing it is `fetch + merge` (or `fetch + rebase`) is what lets you predict its outcome and choose a clean history over noisy merge bubbles on shared branches.

## How it works

`git pull` reads the current branch's [[tracking-branches-and-upstream|upstream]], fetches it, then integrates `FETCH_HEAD` into `HEAD`. The integrate mode is governed by `pull.rebase` and `pull.ff`.

| `pull.rebase` | `pull.ff` | Behavior when diverged |
|---|---|---|
| `false` (default) | `true` | fast-forward if possible, else **merge commit** |
| `false` | `only` | fast-forward or **abort** (no merge commit) |
| `true` | n/a | replay your local commits on top (linear) |
| `merges` | n/a | rebase but preserve real merge commits |

- **Fast-forward** — if you have no local commits, `main` just slides up to `origin/main`; no merge commit.
- **Diverged** — both sides committed: a merge creates a commit with two parents; a rebase rewrites your local commits onto the new tip.
- Since Git 2.27, pull warns until you pick a strategy; set it explicitly to avoid the prompt.

## Example

```
$ git config pull.rebase true     # team prefers linear history
$ git pull
From github.com:acme/api
   9f2c1ab..a71be09  main -> origin/main
First, rewinding head to replay your work on top of it...
Applying: feat: pagination          # your commit re-applied after theirs
$ git log --oneline -3
b9d4f02 feat: pagination            # rebased: new SHA, now atop a71be09
a71be09 fix: retry on 503
9f2c1ab feat: add health check
```

## Pitfalls

- **Accidental merge bubbles** — default merge mode on a shared branch litters history with "Merge branch 'main'" commits; prefer `pull.rebase=true` or `--ff-only`.
- **Rebasing pulled-then-pushed commits** — `pull --rebase` rewrites SHAs of *unpushed* local commits; never rebase commits already shared (see [[rebasing-git-rebase]]).
- **Dirty tree blocks pull** — uncommitted changes that conflict abort the operation; [[stashing-changes-git-stash|stash]] or commit first.
- **`pull` hides the fetch** — you lose the chance to inspect `origin/main` before integrating; `fetch` + review is safer on critical branches.

## See also

- [[rebasing-git-rebase]]
- [[tracking-branches-and-upstream]]
