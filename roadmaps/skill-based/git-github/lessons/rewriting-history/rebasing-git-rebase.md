---
title: Rebasing (git rebase)
track: git-github
group: Rewriting history
tags: [git-github, history-rewriting]
prerequisites: [merging-branches-git-merge, what-is-a-branch]
see-also: [interactive-rebase-squash-fixup-reword-drop, fast-forward-vs-three-way-merge]
---

# Rebasing (git rebase)

`git rebase` replays the commits of your branch on top of a new base, producing a linear history instead of a merge commit.

## Why it matters

Rebasing keeps feature branches up to date with `main` without littering history with "Merge branch main" commits, and it gives a clean, linear log that `git bisect` and `git log --graph` love. Many teams require `git pull --rebase` and rebase-before-merge so `main` reads as a straight line. The cost: it **rewrites commits**, so it is unsafe on branches others have pulled (contrast [[merging-branches-git-merge|merge]], which never rewrites).

## How it works

`git rebase main` finds the merge base of your branch and `main`, takes each of your commits *after* that base, and re-creates them one by one onto `main`'s tip. Each replayed commit is a **new object** with a new SHA (new parent ⇒ new hash), even if the diff is identical.

| Concept | Merge | Rebase |
|---|---|---|
| History | preserves topology | linearizes it |
| New SHAs | only the merge commit | every replayed commit |
| Conflicts | resolved once | possibly once *per commit* |
| Safe on shared branch | yes | no |

Mechanics: `git switch feature && git rebase main`. On conflict, fix files, `git add`, then `git rebase --continue`; bail with `git rebase --abort`. Use `--onto` to transplant a range onto an unrelated base.

## Example

```
before:  A---B---C  main
              \
               D---E  feature

$ git switch feature && git rebase main
# replays D,E onto C as D',E'

after:   A---B---C  main
                  \
                   D'---E'  feature   (D'≠D, E'≠E)
```

`feature` can now fast-forward onto `main` with no merge commit.

## Pitfalls

- **Rebasing pushed/shared commits** — everyone else's history diverges; the cardinal rule is *never rebase commits you've shared* unless the team agrees and uses `--force-with-lease`.
- **Repeated conflict resolution** — a long branch can conflict on every commit; enable `git rerere` to auto-reuse recorded resolutions.
- **Lost merge commits** — plain rebase flattens merges; use `--rebase-merges` to preserve topology if it matters.
- **Mid-rebase confusion** — a stuck rebase leaves a detached `HEAD`; always finish with `--continue`/`--abort` rather than checking out away.

## See also

- [[interactive-rebase-squash-fixup-reword-drop]]
- [[merging-branches-git-merge]]
