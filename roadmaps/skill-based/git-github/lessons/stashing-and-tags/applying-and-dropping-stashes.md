---
title: Applying and dropping stashes
track: git-github
group: Stashing and tags
tags: [git-github, stashing]
prerequisites: [stashing-changes-git-stash]
see-also: [resolving-merge-conflicts, reflog-and-recovery-git-reflog]
---

# Applying and dropping stashes

The other half of stashing: replaying shelved changes back onto a working tree with `apply` or `pop`, and pruning the stack with `drop`/`clear`.

## Why it matters

Saving work is only useful if you can restore it cleanly — and the choice between `apply` (keeps the entry) and `pop` (removes it) routinely bites people who lose a stash to a botched merge. Knowing how to branch off a stash, or recover a dropped one via the [[reflog-and-recovery-git-reflog|reflog]], turns the stash from a scary black box into a reliable scratch buffer.

## How it works

Re-applying does a merge of the stash commit into the current tree, so [[resolving-merge-conflicts|conflicts]] are possible. The key commands:

| Command | Removes entry? | Notes |
|---|---|---|
| `stash apply [id]` | no | safe; replay again or elsewhere |
| `stash pop [id]` | yes, *only if clean* | apply then drop |
| `stash drop [id]` | yes | delete one entry |
| `stash clear` | yes, all | wipe the whole stack |
| `stash branch <name> [id]` | yes, if clean | new branch off the stash's base commit |
| `stash show -p [id]` | no | view the diff first |

By default the index is restored as *unstaged*; pass `--index` to `apply`/`pop` to also re-stage what was staged. Omitting an id targets `stash@{0}`.

## Example

```
$ git stash pop
Auto-merging src/api.ts
CONFLICT (content): Merge conflict in src/api.ts
The stash entry is kept in case you need it again.

# pop did NOT drop it because the merge failed — fix, then:
$ git add src/api.ts
$ git stash drop          # now remove it manually
Dropped stash@{0} (3f9a1c2...)
```

## Pitfalls

- **`pop` keeps the entry on conflict** — people assume it's gone, re-edit, and end up with a duplicate stash they later re-apply by accident.
- **A dropped stash isn't truly lost — yet** — `git fsck --unreachable | grep commit` or `git stash apply <sha>` from the reflog recovers it until GC (~2 weeks default).
- **`stash branch` is the conflict escape hatch** — when a stash won't apply because the base moved, it recreates the original commit, so the replay is conflict-free.
- **No `--index` ⇒ flattened state** — staged vs unstaged distinction is silently merged into all-unstaged.

## See also

- [[stashing-changes-git-stash]]
- [[reflog-and-recovery-git-reflog]]
