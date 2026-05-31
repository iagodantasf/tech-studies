---
title: Merging branches (git merge)
track: git-github
group: Branching and merging
tags: [git-github, merging]
prerequisites: [creating-and-switching-branches-git-branch-git-switch-git-checkout, committing-git-commit]
see-also: [fast-forward-vs-three-way-merge, resolving-merge-conflicts]
---

# Merging branches (git merge)

`git merge` integrates the history of another branch into your current branch, usually by creating a **merge commit** with two parents.

## Why it matters

Merging is how parallel work converges: a reviewed feature branch lands on `main`, a release branch absorbs a hotfix, an upstream's changes flow into your fork. Unlike [[rebasing-git-rebase|rebase]], merge is **non-destructive** — it never rewrites existing commits, so it is safe on shared branches and preserves the true topology of who-branched-when.

## How it works

You merge *into* the checked-out branch: `git switch main && git merge feature`. Git finds the **merge base** (the best common ancestor via `git merge-base`) and the two tips, then takes one of two paths:

- **Fast-forward** — if `main` is an ancestor of `feature`, Git just slides the `main` pointer forward. No merge commit (see [[fast-forward-vs-three-way-merge]]).
- **Three-way merge** — if the branches diverged, Git combines base + both tips and records a merge commit with two parents.

| Flag | Effect |
|---|---|
| `--no-ff` | Always create a merge commit, even when FF is possible |
| `--ff-only` | Refuse to merge unless it's a clean fast-forward |
| `--squash` | Stage the combined diff as one commit, no merge link |
| `--abort` | Restore pre-merge state after a conflict |

`--no-ff` is common on `main` so each feature is a visible "bubble" in the graph; `--ff-only` is used in CI to guarantee linear history.

## Example

```
$ git switch main
$ git merge --no-ff feature
Merge made by the 'recursive' strategy.   # (Git ≥2.34 uses 'ort')
 src/auth.py | 12 ++++++++++++
 1 file changed, 12 insertions(+)
```

```
A---B---E-------M   main      (M = merge commit, parents E and D)
         \     /
          C---D    feature
```

## Pitfalls

- **Merging the wrong direction** — `git merge` pulls the *other* branch into the *current* one; check `git status` shows the intended target first.
- **Surprise fast-forward** — without `--no-ff`, merging a feature can leave no trace it was ever a branch; teams that want bubbles enforce `--no-ff`.
- **Conflicts mid-merge** — Git pauses with a half-done index; resolve and commit, or `git merge --abort` (see [[resolving-merge-conflicts]]).
- **Merging an unrelated tree** — needs `--allow-unrelated-histories`; usually a sign you cloned/initialized wrong.

## See also

- [[fast-forward-vs-three-way-merge]]
- [[resolving-merge-conflicts]]
