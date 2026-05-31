---
title: Fetching (git fetch)
track: git-github
group: Remote repositories
tags: [git-github, syncing]
prerequisites: [what-is-a-remote]
see-also: [pulling-git-pull, tracking-branches-and-upstream]
---

# Fetching (git fetch)

`git fetch` downloads new objects and updates remote-tracking branches (`origin/*`) from a [[what-is-a-remote|remote]] **without touching your working tree or current branch**.

## Why it matters

Fetch is the safe, read-only way to learn what changed upstream. Because it never merges, it can never cause a conflict or surprise edit — you inspect `origin/main` first, then decide to [[merging-branches-git-merge|merge]] or [[rebasing-git-rebase|rebase]]. It is exactly the half of [[pulling-git-pull|git pull]] that carries no risk, which is why many engineers prefer `fetch` + manual integrate over `pull`.

## How it works

Fetch negotiates which commits you lack, transfers them into `.git/objects`, then advances `refs/remotes/<remote>/*` per the remote's fetch refspec. Your `HEAD`, index, and files are untouched.

- **What moves** — only remote-tracking refs (`origin/main`, `origin/feature`). Your local `main` does **not** move.
- **`--prune` (`-p`)** — delete tracking refs for branches removed upstream; pair with config `fetch.prune=true` to make it automatic.
- **Tags** — fetched automatically when they point into fetched history; `--tags` forces all tags.
- **`FETCH_HEAD`** — a scratch ref recording what was just fetched, used by `pull`.

| Command | Updates `origin/*` | Moves local branch | Edits files |
|---|---|---|---|
| `git fetch` | yes | no | no |
| `git pull` | yes | yes | yes |
| `git merge origin/main` | no | yes | yes |

## Example

```
$ git fetch origin
From github.com:acme/api
   9f2c1ab..a71be09  main       -> origin/main
 * [new branch]      hotfix-503 -> origin/hotfix-503
$ git log --oneline main..origin/main   # what they added, I lack
a71be09 fix: retry on 503
$ git log --oneline origin/main..main   # what I have, they lack
3c0d8e1 feat: pagination
$ git merge origin/main                  # integrate when ready
```

## Pitfalls

- **Expecting files to change** — fetch never updates the working tree; new code lives only in `origin/*` until you merge/rebase.
- **Stale view without fetching** — `origin/main` is frozen at last fetch; comparisons mislead if you forgot to fetch first.
- **Deleted branches linger** — without `--prune`, gone-upstream branches stay as tracking refs.
- **`git fetch` (no remote) is per-config** — fetches the *current branch's* remote, not necessarily all remotes; use `--all` for every remote.

## See also

- [[pulling-git-pull]]
- [[tracking-branches-and-upstream]]
