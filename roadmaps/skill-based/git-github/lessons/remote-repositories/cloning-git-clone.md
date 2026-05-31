---
title: Cloning (git clone)
track: git-github
group: Remote repositories
tags: [git-github, remotes]
prerequisites: [what-is-a-remote, initializing-a-repository-git-init]
see-also: [fetching-git-fetch, tracking-branches-and-upstream]
---

# Cloning (git clone)

`git clone` copies a remote repository's full object database to a new local directory, then wires up `origin`, remote-tracking branches, and one checked-out local branch.

## Why it matters

It is the standard entry point to any existing project and the [[centralized-vs-distributed-vcs|distributed]] counterpart to [[initializing-a-repository-git-init|git init]]: instead of starting empty, you get the complete history (every commit, branch, and tag) plus a configured [[what-is-a-remote|remote]] so [[fetching-git-fetch|fetch]]/[[pushing-git-push|push]] work immediately.

## How it works

Clone is roughly: `init` → add remote `origin` → [[fetching-git-fetch|fetch]] all refs → create local `main` tracking `origin/main` → check it out.

- **`origin` is auto-created** with the source URL and the default fetch refspec `+refs/heads/*:refs/remotes/origin/*`.
- **One local branch** is created (the remote's `HEAD`, e.g. `main`); other branches exist only as `origin/*` until you [[creating-and-switching-branches-git-branch-git-switch-git-checkout|check them out]].
- **Upstream is set** so a bare `git pull`/`git push` just works (see [[tracking-branches-and-upstream]]).

| Flag | Effect | Use when |
|---|---|---|
| `--depth 1` | shallow: truncate history | CI, faster clone of huge repos |
| `--branch <b>` | check out `<b>` not default | need a specific branch/tag |
| `--single-branch` | fetch only one branch's history | bandwidth-limited, one-branch CI |
| `--bare` | no working tree, `.git` contents only | server-side push target / mirror |
| `--filter=blob:none` | partial clone, fetch blobs lazily | monorepos, modern alternative to depth |

## Example

```
$ git clone --depth 1 git@github.com:acme/api.git
Cloning into 'api'...
remote: Enumerating objects: 312, done.
Receiving objects: 100% (312/312), 1.4 MiB | 6.2 MiB/s, done.
$ cd api && git remote -v
origin  git@github.com:acme/api.git (fetch/push)
$ git branch -vv
* main 9f2c1ab [origin/main] feat: add health check
```

## Pitfalls

- **Shallow surprises** — `--depth 1` breaks `git log` deep history, `git blame` past the cutoff, and some merges; deepen with `git fetch --unshallow`.
- **Wrong protocol** — cloning a private repo over HTTPS without a token fails; pick the right URL form (see [[https-vs-ssh-authentication]]).
- **Nested clone** — cloning *into* an existing repo's working tree creates a confusing embedded repo, not a [[submodules-and-monorepos|submodule]].
- **`--single-branch` then needing another branch** — that branch isn't fetched; you must adjust the remote's fetch refspec first.

## See also

- [[fetching-git-fetch]]
- [[tracking-branches-and-upstream]]
