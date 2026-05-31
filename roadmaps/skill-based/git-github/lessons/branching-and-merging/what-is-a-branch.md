---
title: What is a branch?
track: git-github
group: Branching and merging
tags: [git-github, branching]
prerequisites: [committing-git-commit, viewing-history-git-log]
see-also: [creating-and-switching-branches-git-branch-git-switch-git-checkout, merging-branches-git-merge]
---

# What is a branch?

A branch is a **movable pointer to a commit** — a 41-byte file under `.git/refs/heads/`, not a copy of your files.

## Why it matters

Branches make parallel lines of work cheap, so they are the unit of nearly every workflow: feature work, hotfixes, release lines, and pull requests all live on branches. Because a branch is just a pointer, creating one is O(1) and uses no extra disk for the snapshot — this is why Git encourages many short-lived branches where older centralized tools (see [[centralized-vs-distributed-vcs]]) made branching expensive and rare.

## How it works

Each commit records its parent(s), so the commit graph is a DAG. A branch name simply points at one commit — its **tip** — and history is everything reachable by walking parents backward.

```
        C---D   feature   (refs/heads/feature → D)
       /
A---B---E---F   main      (refs/heads/main → F)
                          HEAD → main
```

- `HEAD` is a pointer to the *current* branch (`ref: refs/heads/main`), telling Git what the next commit's parent is.
- Committing moves the current branch tip forward by one and updates `HEAD` transitively.
- A "detached HEAD" is `HEAD` pointing straight at a commit SHA instead of a branch name — new commits then belong to no branch and can be lost (see [[reflog-and-recovery-git-reflog]]).

| Concept | What it is | Storage |
|---|---|---|
| Branch | Pointer to a commit | `.git/refs/heads/<name>` (one SHA) |
| HEAD | Pointer to current branch | `.git/HEAD` |
| Commit | Immutable snapshot + parent links | object database |

## Example

```
$ git rev-parse main
9f2c1ab...                      # the tip commit SHA
$ cat .git/refs/heads/main
9f2c1ab1d4e3...                 # the branch IS this line
$ git commit -m "x"            # main now points one commit further
$ cat .git/refs/heads/main
a71be09c5f8a...                 # same file, new SHA — no copy made
```

## Pitfalls

- **Thinking a branch holds files** — it holds one SHA. Deleting a branch (see [[deleting-branches]]) drops only the pointer; the commits survive until garbage-collected.
- **Committing on a detached HEAD** — those commits are unreferenced; reattach with a branch or recover via [[reflog-and-recovery-git-reflog]].
- **Confusing branch with [[lightweight-vs-annotated-tags|tag]]** — a tag is a *fixed* pointer; a branch *moves* as you commit.

## See also

- [[creating-and-switching-branches-git-branch-git-switch-git-checkout]]
- [[merging-branches-git-merge]]
