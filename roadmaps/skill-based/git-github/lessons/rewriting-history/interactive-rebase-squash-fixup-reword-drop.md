---
title: Interactive rebase (squash, fixup, reword, drop)
track: git-github
group: Rewriting history
tags: [git-github, history-rewriting]
prerequisites: [rebasing-git-rebase, amending-commits-git-commit-amend]
see-also: [reflog-and-recovery-git-reflog, cherry-picking-git-cherry-pick]
---

# Interactive rebase (squash, fixup, reword, drop)

`git rebase -i` opens an editable to-do list of commits so you can reorder, combine, reword, or delete them before sharing your branch.

## Why it matters

Work-in-progress history is messy: `wip`, `fix typo`, `actually fix it`. Interactive rebase lets you curate that into a few logical, reviewable commits — the polish step before opening a [[pull-requests|PR]]. It is the everyday workhorse of [[rebasing-git-rebase|history rewriting]] and what GitHub's "rebase and merge" button does under the hood.

## How it works

`git rebase -i HEAD~5` lists the last 5 commits **oldest-first**, each prefixed with an action you edit:

| Command | Short | Effect |
|---|---|---|
| `pick` | `p` | keep the commit as-is |
| `reword` | `r` | keep changes, edit the message |
| `edit` | `e` | pause to amend contents or split |
| `squash` | `s` | merge into previous, combine messages |
| `fixup` | `f` | merge into previous, **discard** this message |
| `drop` | `d` | delete the commit entirely |

Reordering lines reorders commits. Save and Git replays them top-to-bottom, minting new SHAs. The companion `git commit --fixup=<sha>` plus `git rebase -i --autosquash` auto-arranges fixups against their targets — the idiomatic clean-up loop.

## Example

```
pick   a1b2c3d Add parser
fixup  4d5e6f7 fix typo          # folds silently into a1b2c3d
reword 7a8b9c0 Add validation    # editor reopens for new message
drop   0c1d2e3 debug logging     # removed from history
```

Five commits become three; the `fix typo` and `debug logging` messages vanish from the log entirely.

## Pitfalls

- **First squash has nothing above it** — `squash`/`fixup` fold *upward*; you can't squash the top (oldest) line, only into a preceding `pick`.
- **Deleting a line ≠ drop in old Git** — pre-2.x removing a line silently dropped the commit, causing accidental data loss; always use explicit `drop`.
- **Rewriting shared history** — same hazard as any rebase: forces a `--force-with-lease` push and breaks teammates' clones.
- **Long replays and conflicts** — every commit can re-conflict; `git rerere` and small batches (`HEAD~3`, not `HEAD~50`) keep it sane.

## See also

- [[rebasing-git-rebase]]
- [[reflog-and-recovery-git-reflog]]
