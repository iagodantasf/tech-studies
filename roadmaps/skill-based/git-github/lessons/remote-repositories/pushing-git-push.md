---
title: Pushing (git push)
track: git-github
group: Remote repositories
tags: [git-github, syncing]
prerequisites: [committing-git-commit, tracking-branches-and-upstream]
see-also: [pulling-git-pull, branch-protection-rules]
---

# Pushing (git push)

`git push` uploads your local commits to a [[what-is-a-remote|remote]] and updates the remote's branch to point at them — the [[centralized-vs-distributed-vcs|publish step]] that makes local work visible to others.

## Why it matters

A [[committing-git-commit|commit]] is invisible to teammates and CI until pushed; "it's committed" is not "it's shared." Push enforces a key safety rule — it **refuses non-fast-forward updates by default** — which is what prevents you from silently clobbering commits someone else pushed while you were working.

## How it works

Push sends objects the remote lacks, then asks it to move `refs/heads/<branch>`. The move must be a **fast-forward** (old tip is an ancestor of new tip) unless you force it.

| Command | Effect |
|---|---|
| `git push` | push current branch to its configured upstream |
| `git push -u origin main` | push and **set** upstream for future bare pushes |
| `git push origin :old` | delete remote branch `old` (empty src) |
| `git push --force-with-lease` | force, but abort if remote moved unexpectedly |
| `git push --tags` | also push annotated and lightweight tags |
| `git push --dry-run` | show what would update, send nothing |

- **Rejected (non-fast-forward)** — the remote advanced; [[fetching-git-fetch|fetch]] + integrate, then push again.
- **`--force-with-lease` > `--force`** — plain `--force` overwrites blindly; lease checks the remote ref still matches what you last saw, so you don't erase a colleague's push.
- **`push.default=simple`** (modern default) pushes only the current branch to its upstream of the same name.

## Example

```
$ git push
To github.com:acme/api.git
 ! [rejected]    main -> main (fetch first)
error: failed to push some refs ... non-fast-forward
$ git fetch origin && git rebase origin/main   # take their commits first
$ git push                                      # now a clean fast-forward
   a71be09..b9d4f02  main -> main
```

## Pitfalls

- **`--force` on a shared branch** — discards others' commits irrecoverably for them; use `--force-with-lease`, and ideally never force shared branches.
- **Forgetting `-u`** — first push of a new branch needs `git push -u origin <branch>` or it errors with *"no upstream branch."*
- **Pushing to a non-bare repo's checked-out branch** — updating its current branch is rejected/dangerous; remotes should be bare (see [[adding-and-managing-remotes-git-remote]]).
- **[[branch-protection-rules|Protected branches]]** reject direct pushes — route changes through a [[pull-requests|PR]] instead.

## See also

- [[pulling-git-pull]]
- [[branch-protection-rules]]
