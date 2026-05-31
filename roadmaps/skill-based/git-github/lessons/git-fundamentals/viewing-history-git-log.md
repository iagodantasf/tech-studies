---
title: Viewing history (git log)
track: git-github
group: Git fundamentals
tags: [git-github, history]
prerequisites: [committing-git-commit]
see-also: [viewing-changes-git-diff, git-blame, git-show]
---

# Viewing history (git log)

`git log` walks the commit graph backward from a starting point (default `HEAD`), printing commits in reverse-chronological order with flexible formatting and filters.

## Why it matters

It is how you reconstruct *why* the code is the way it is — finding the commit that introduced a behavior, auditing a release, or generating a changelog. Because Git history is a DAG, `log` is also a graph-traversal tool: the right flags turn a wall of commits into a precise answer.

## How it works

`log` traverses parent links starting from one or more refs; filters prune the walk, formatting controls the output.

| Flag | Effect |
|---|---|
| `--oneline` | One line per commit (short SHA + subject) |
| `--graph` | ASCII branch/merge topology |
| `-p` | Show each commit's diff (patch) |
| `--stat` | Per-file insertion/deletion counts |
| `-n 5` / `-5` | Limit to N commits |
| `-- <path>` | Only commits touching that path |

- **Range syntax** — `main..feature` shows commits on `feature` not yet in `main` (what a [[pull-requests|PR]] would add); `A...B` shows the symmetric difference.
- **Filters** — `--author=`, `--since="2 weeks ago"`, `--grep=` (message regex), and `-S"text"` (a *pickaxe*: commits that changed the count of a string — the fastest way to find when a line appeared or vanished).
- **First-parent view** — `--first-parent` follows only mainline commits, hiding the noise of merged feature branches.
- **Custom format** — `--pretty=format:"%h %an %s"` for scripting/changelogs.

## Example

```
# When did the string "MAX_RETRIES" enter the codebase, and in what commit?
git log -S"MAX_RETRIES" --oneline -- src/
# 4b2e9f1 feat: add retry with backoff to http client

git log --oneline --graph main..feature   # what this branch adds over main
```

## Pitfalls

- **Date order ≠ topological order** — committer dates can be out of order after a [[rebasing-git-rebase|rebase]] or cherry-pick; use `--topo-order` for a graph-consistent walk.
- **`--` ambiguity** — `git log main` vs `git log -- main`: without `--`, Git may treat `main` as a ref; with it, as a path. Always separate paths with `--`.
- **Author vs committer** — a rebase keeps the original *author* date but updates the *committer*; `%ad` and `%cd` can differ, surprising changelog scripts.
- **Forgetting it stops at the start ref** — `git log feature` won't show commits unique to other branches; pass the refs (or `--all`) you actually want.

## See also

- [[viewing-changes-git-diff]]
- [[git-show]]
