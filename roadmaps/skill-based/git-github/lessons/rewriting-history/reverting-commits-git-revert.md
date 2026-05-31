---
title: Reverting commits (git revert)
track: git-github
group: Rewriting history
tags: [git-github, history-rewriting]
prerequisites: [committing-git-commit, viewing-history-git-log]
see-also: [resetting-git-reset-soft-mixed-hard, cherry-picking-git-cherry-pick]
---

# Reverting commits (git revert)

`git revert <sha>` creates a **new** commit that applies the inverse of a given commit, undoing its changes without erasing history.

## Why it matters

When a bad commit is already on a shared branch, you cannot safely [[resetting-git-reset-soft-mixed-hard|reset]] or rebase it away — others have it. `git revert` is the *safe* undo: it moves history forward with a counter-commit, so the remote accepts a normal push and the audit trail shows both the mistake and its reversal. It is the standard "roll back the deploy" move on `main`.

## How it works

Git takes the target commit's diff, negates it (additions become deletions and vice versa), applies that to `HEAD`, and commits with a default message `Revert "<original subject>"`. The original commit stays in history.

| Action | reset | revert |
|---|---|---|
| Rewrites history | yes | no |
| Safe on shared branch | no | yes |
| Result | commit disappears | inverse commit added |
| Leaves audit trail | no | yes |

Useful flags: `-n` to stage the inverse without committing (combine several reverts), and `git revert A..B` to undo a range. Conflicts pause the operation; resolve, `git add`, `git revert --continue`.

## Example

```
$ git log --oneline
9f8e7d6 Add feature flag
3c2b1a0 Break checkout      <-- bad commit
...
$ git revert 3c2b1a0
[main a0b1c2d] Revert "Break checkout"
 1 file changed, 4 insertions(+), 4 deletions(-)
```

`3c2b1a0` remains; `a0b1c2d` cancels it out. A later `git revert a0b1c2d` re-applies the change ("revert the revert").

## Pitfalls

- **Reverting a merge commit** — requires `-m 1` to pick the mainline parent; it undoes the *merged* changes but Git then thinks they're permanently excluded, so re-merging that branch needs a revert-of-the-revert.
- **Revert isn't reset** — people expect the history to shrink; instead it grows by one commit. Use `git reset` only on private branches.
- **Partial-state reverts** — if the codebase moved on, the inverse patch may conflict and leave a half-reverted tree until resolved.
- **Reverting a range order** — `A..B` reverts oldest-to-newest by default; dependent changes may need `--no-commit` plus manual ordering.

## See also

- [[resetting-git-reset-soft-mixed-hard]]
- [[cherry-picking-git-cherry-pick]]
