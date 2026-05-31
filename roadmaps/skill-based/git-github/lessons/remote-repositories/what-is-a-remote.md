---
title: What is a remote?
track: git-github
group: Remote repositories
tags: [git-github, remotes]
prerequisites: [centralized-vs-distributed-vcs, what-is-a-branch]
see-also: [adding-and-managing-remotes-git-remote, cloning-git-clone]
---

# What is a remote?

A remote is a **named bookmark for another copy of the repository** (a URL plus a fetch/push refspec), letting you sync history with it without typing the URL each time.

## Why it matters

In a [[centralized-vs-distributed-vcs|distributed VCS]] every clone is complete, so there is no built-in "the server" — teams *agree* on a canonical remote (usually `origin` on [[git-vs-github|GitHub]]) as the source of truth. Remotes are how [[fetching-git-fetch|fetch]], [[pulling-git-pull|pull]], and [[pushing-git-push|push]] know where to go, and how remote-tracking branches mirror what the other side last advertised.

## How it works

A remote is pure config under `[remote "<name>"]` in `.git/config`; it stores no objects itself. Each remote owns a slice of the ref namespace: `refs/remotes/<remote>/*`.

- **Remote-tracking branch** — a read-only local pointer like `origin/main` (`refs/remotes/origin/main`) recording where `main` was on the remote *at last sync*. You never commit onto it directly.
- **Refspec** — the `+src:dst` mapping; the default fetch refspec `+refs/heads/*:refs/remotes/origin/*` copies every remote branch into your `origin/*` namespace. The leading `+` allows non-fast-forward updates of tracking refs.
- A remote can have a different **fetch URL and push URL** (e.g. read over HTTPS, write over SSH).

| Ref type | Example | Writable | Path |
|---|---|---|---|
| Local branch | `main` | yes | `refs/heads/main` |
| Remote-tracking | `origin/main` | no (sync only) | `refs/remotes/origin/main` |
| Remote config | `origin` | n/a | `.git/config` |

## Example

```
$ git remote -v
origin  git@github.com:acme/api.git (fetch)
origin  git@github.com:acme/api.git (push)
$ git branch -r                 # remote-tracking branches
  origin/HEAD -> origin/main
  origin/main
  origin/release-2.4
$ git log origin/main..main     # local commits not yet on origin
a71be09 feat: pagination
```

## Pitfalls

- **Confusing `origin/main` with `main`** — `origin/main` only moves on [[fetching-git-fetch|fetch]]/push; it can be stale and is *not* live.
- **Assuming `origin` is special** — it is just the default clone name; nothing in Git privileges it.
- **Editing a tracking ref** — you cannot commit on `origin/main`; doing so detaches HEAD (see [[reflog-and-recovery-git-reflog]]).
- **Stale remotes after deletes** — branches deleted upstream linger locally until `git fetch --prune`.

## See also

- [[adding-and-managing-remotes-git-remote]]
- [[cloning-git-clone]]
