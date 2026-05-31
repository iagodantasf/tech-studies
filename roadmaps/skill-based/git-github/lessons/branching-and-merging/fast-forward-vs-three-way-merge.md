---
title: Fast-forward vs three-way merge
track: git-github
group: Branching and merging
tags: [git-github, merging]
prerequisites: [merging-branches-git-merge, what-is-a-branch]
see-also: [resolving-merge-conflicts, rebasing-git-rebase]
---

# Fast-forward vs three-way merge

The two outcomes of `git merge`: sliding a pointer forward (fast-forward) versus synthesizing a new commit from a common ancestor (three-way).

## Why it matters

Whether a merge fast-forwards decides the *shape of your history* — linear and flat, or branched with merge bubbles. This drives team policy: `--ff-only` on `main` keeps `git log` a straight line that bisects cleanly (see [[git-bisect]]), while `--no-ff` preserves an audit trail of every feature. Knowing which case applies also tells you whether to expect a merge commit and a possible conflict.

## How it works

Git compares the **merge base** B (common ancestor) with the two branch tips:

- **Fast-forward** — possible only when the target's tip *is* the merge base, i.e. the target has no commits the source lacks. Git moves the pointer; nothing is created, no conflict is possible.
- **Three-way merge** — when both branches added commits after B, Git runs a 3-way diff over `{B, ours, theirs}` and writes a 2-parent merge commit. Conflicts can occur here.

| | Fast-forward | Three-way |
|---|---|---|
| Precondition | Target is ancestor of source | Branches diverged |
| New commit | None | Merge commit (2 parents) |
| Conflicts possible | No | Yes |
| History shape | Linear | Branched bubble |
| Force one way | `--ff-only` | `--no-ff` |

The name "three-way" is literal: comparing only ours-vs-theirs can't tell an *addition* from a *deletion*, so the base is the third input that disambiguates each hunk.

## Example

Fast-forward — `main` has nothing `feature` lacks:
```
before:  A---B          main → B
              \
               C---D     feature
after  :  A---B---C---D  main → D   (pointer moved; no new commit)
```

Three-way — both moved after the base `B`:
```
A---B---E-------M   main      (M synthesized from base B + tips E,D)
         \     /
          C---D    feature
```

## Pitfalls

- **Assuming a merge always makes a merge commit** — a fast-forward leaves *zero* trace of the branch; enforce `--no-ff` if you need the bubble.
- **`--ff-only` failing in automation** — if the base branch moved (someone else pushed), the FF precondition breaks and the merge aborts; rebase or re-merge.
- **Conflicts only in three-way** — a clean fast-forward can still ship a *semantic* break (two correct hunks that interact badly); FF safety is textual, not logical.
- **Fast-forward hides review history** — squash-then-FF can erase the PR's branch topology entirely.

## See also

- [[resolving-merge-conflicts]]
- [[rebasing-git-rebase]]
