---
title: Forking a repository
track: git-github
group: GitHub basics
tags: [git-github, collaboration]
prerequisites: [cloning-git-clone, what-is-a-remote]
see-also: [cloning-vs-forking, pull-requests]
---

# Forking a repository

A fork is a server-side copy of someone else's repository under *your* account, linked to the original — the standard way to contribute to projects you can't push to directly.

## How it works

Forking creates a new repo (`you/api`) that GitHub remembers was forked from `upstream/api`. You clone *your fork*, add the original as a second remote conventionally named `upstream`, and open [[pull-requests|PRs]] from your fork's branches back to upstream.

| Remote | Points to | You can push? |
|---|---|---|
| `origin` | `you/api` (your fork) | yes |
| `upstream` | `acme/api` (original) | no (read-only) |

- Forks share storage with the parent (GitHub dedups objects), so a fork of a huge repo is cheap and near-instant.
- Keep your fork current by fetching `upstream` and merging/rebasing, or click "Sync fork" in the UI.
- Fork PRs run the upstream's CI, but secrets are withheld from fork-based workflow runs by default — a deliberate security boundary against malicious PRs.

## Why it matters

The fork-and-PR model is how open source scales: maintainers grant zero write access yet still accept contributions, because review happens at the PR boundary. It also isolates experiments — you can rewrite history on your fork freely without affecting anyone.

## Example

```
# Fork acme/api on the web (or: gh repo fork acme/api --clone)
$ git clone git@github.com:you/api.git      # clone YOUR fork
$ cd api
$ git remote add upstream git@github.com:acme/api.git
$ git fetch upstream
$ git switch -c fix-typo upstream/main      # branch off upstream
# ...commit, push to origin, open PR to acme/api...
$ git push -u origin fix-typo
```

## Pitfalls

- **Cloning the original instead of your fork** — you then can't push; `origin` must be `you/api`, with the source as `upstream`.
- **Stale fork** — months later `main` lags far behind upstream and your branch conflicts badly; sync regularly.
- **PR from your `main`** — opening the PR from your fork's `main` blocks you from syncing it and muddies review; always branch.
- **Expecting secrets in fork CI** — `pull_request` runs on forks get no secrets and read-only tokens by design; use `pull_request_target` only with extreme care.

## See also

- [[cloning-vs-forking]]
- [[pull-requests]]
