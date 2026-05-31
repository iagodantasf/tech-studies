---
title: Branching strategies (Git Flow, GitHub Flow, trunk-based)
track: git-github
group: Branching and merging
tags: [git-github, workflows]
prerequisites: [merging-branches-git-merge, creating-and-switching-branches-git-branch-git-switch-git-checkout]
see-also: [pull-requests, semantic-versioning]
---

# Branching strategies (Git Flow, GitHub Flow, trunk-based)

A branching strategy is the team convention for *which* long-lived branches exist and *how* work flows into a release — the three canonical models trade isolation against integration speed.

## Why it matters

The model dictates merge frequency, release cadence, and how painful conflicts get. Pick wrong and you get either chaos (no structure) or weeks-long divergent branches with brutal merges. The industry trend (DORA research) is decisively toward short-lived branches and frequent integration, because long-lived branches are the leading cause of merge hell and slow delivery.

## How it works

| Strategy | Long-lived branches | Branch lifetime | Best for | Release |
|---|---|---|---|---|
| Git Flow | main, develop, release/*, hotfix/* | Days–weeks | Versioned products, scheduled releases | Cut from `release/*`, tagged |
| GitHub Flow | main only | Hours–days | Web apps, continuous deploy | Deploy `main` after PR merge |
| Trunk-based | main (trunk) | < 1 day | High-velocity CI/CD teams | Continuous; gate with flags |

- **Git Flow** (Driessen, 2010): features branch off `develop`, releases stabilize on `release/*`, urgent fixes go via `hotfix/*` straight off `main`. Powerful but heavy; often overkill today.
- **GitHub Flow**: one rule — branch off `main`, open a [[pull-requests|PR]], merge back, deploy. Simple, review-centric.
- **Trunk-based**: everyone commits to `main` many times a day behind short branches or directly; incomplete work hides behind **feature flags** rather than long branches.

The deciding variable is *branch age*: the longer a branch lives, the more it diverges, so trunk-based minimizes it on purpose.

## Example

GitHub Flow lifecycle:
```
main ──●──────────────●──  (deploy on each merge)
        \            /
         ●──●──●────/   feature/checkout  → PR #142 → squash-merge
```

Trunk-based with a flag — ship dark, enable later:
```python
if flags.enabled("new_checkout"):   # merged to main today, off in prod
    return new_checkout()
return legacy_checkout()
```

## Pitfalls

- **Cargo-culting Git Flow** — its `develop`/`release` overhead hurts teams doing continuous deploy; the author later noted it's wrong for web apps.
- **Long-lived feature branches** — the universal anti-pattern; a 3-week branch guarantees conflict pain regardless of model.
- **Trunk-based without flags or CI** — committing unfinished work to `main` with no flag gate or strong test suite breaks everyone.
- **Mixing models** — `develop` plus continuous deploy plus ad-hoc hotfixes confuses everyone; pick one and document it.

## See also

- [[pull-requests]]
- [[semantic-versioning]]
