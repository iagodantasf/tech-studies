---
title: Deleting branches
track: git-github
group: Branching and merging
tags: [git-github, branching]
prerequisites: [creating-and-switching-branches-git-branch-git-switch-git-checkout, merging-branches-git-merge]
see-also: [reflog-and-recovery-git-reflog, pushing-git-push]
---

# Deleting branches

Removing a branch deletes only the **pointer**; the commits persist until garbage collection, and the operation has a safe variant and a forced one.

## Why it matters

Stale branches accumulate fast — after every merged PR there's a dead feature branch locally and on the remote. Pruning them keeps `git branch` and the GitHub branch list readable and prevents accidental re-use of abandoned work. Crucially, deletion is *low-risk*: because a branch is just a ref (see [[what-is-a-branch]]), a wrongly deleted branch is recoverable from the [[reflog-and-recovery-git-reflog|reflog]].

## How it works

| Command | Scope | Behavior |
|---|---|---|
| `git branch -d feat` | Local | Safe — refuses if not merged into HEAD/upstream |
| `git branch -D feat` | Local | Force — deletes even unmerged work |
| `git push origin --delete feat` | Remote | Deletes the branch on the remote |
| `git fetch -p` / `--prune` | Local refs | Drops local `origin/*` refs that no longer exist remotely |

- `-d` is a guardrail: Git checks the tip is reachable from the current branch (or its upstream) and aborts with *"not fully merged"* otherwise — so you can't silently lose commits.
- `-D` (= `--delete --force`) bypasses that check; use only when you mean to discard.
- Deleting a remote branch does **not** remove your local copy of it, and vice versa — they are independent refs.
- You cannot delete the branch you're currently on; switch away first.

## Example

```
$ git switch main
$ git branch -d feature-login          # merged → clean delete
Deleted branch feature-login (was a71be09).
$ git branch -d spike-idea
error: the branch 'spike-idea' is not fully merged.   # guardrail fired
$ git branch -D spike-idea              # really discard it
Deleted branch spike-idea (was 4c1f0e2).
$ git push origin --delete feature-login   # tidy the remote too
```

## Pitfalls

- **Deleting the remote ≠ deleting local** — and `git fetch -p` is what clears the stale `origin/feature` tracking refs others' clones keep showing.
- **`-D` on unpushed work** — those commits become unreferenced; recover within the gc window (~90 days) via `git reflog`, not after.
- **"Branch already exists" on push** — your delete didn't propagate; someone may have re-pushed it, or you deleted only locally.
- **Default-branch protection** — you can't delete `main` if it's the repo's default or [[branch-protection-rules|protected]]; change the default first.

## See also

- [[reflog-and-recovery-git-reflog]]
- [[pushing-git-push]]
