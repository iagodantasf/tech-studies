---
title: Cloning vs forking
track: git-github
group: GitHub basics
tags: [git-github, collaboration]
prerequisites: [cloning-git-clone, forking-a-repository]
see-also: [forking-a-repository, collaborators-and-teams]
---

# Cloning vs forking

Two operations that are constantly confused: **cloning** copies a repo to your *local machine*; **forking** copies it to *your account on GitHub*. They operate at different layers and are usually combined.

## Why it matters

Choosing wrong wastes effort and blocks contribution: fork when you lack write access, clone-only when you're a collaborator. Beginners often fork a repo they already have push rights to (adding a needless layer) or clone a repo they can't push to (then can't open a PR cleanly). Knowing the boundary makes the contribution path obvious.

## How it works

A clone is a full local copy with an `origin` remote and all history; a fork is a *server-side* clone under your namespace that GitHub tracks as derived from the parent.

| | Clone | Fork |
|---|---|---|
| Where the copy lives | your laptop | your GitHub account |
| Creates a new GitHub repo | no | yes |
| Needs write access | only to push | no |
| Typical command | `git clone` | `gh repo fork` / web button |
| Used for | everyday work | contributing without push rights |

- **Collaborator path**: you have write access to a [[collaborators-and-teams|team]] repo, so just [[cloning-git-clone|clone]] and push branches directly.
- **Outside-contributor path**: no write access, so [[forking-a-repository|fork]] first, then clone the fork.
- A fork without a clone is read-only on the web; a clone is where you actually edit — the two compose.

## Example

```
# Collaborator (write access) — no fork needed:
$ git clone git@github.com:acme/api.git && git switch -c feature

# Outside contributor (no write access) — fork, then clone the fork:
$ gh repo fork acme/api --clone   # forks to you/api AND clones it locally
```

## Pitfalls

- **Forking your own team's repo** — adds a pointless layer and splits CI/issues; if you can push, just branch in place.
- **Cloning upstream then trying to push** — `403` permission denied; you needed a fork to host your branch.
- **Thinking a fork updates automatically** — it's a snapshot; it diverges from upstream until you explicitly sync.

## See also

- [[forking-a-repository]]
- [[collaborators-and-teams]]
