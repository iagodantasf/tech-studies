---
title: Amending commits (git commit --amend)
track: git-github
group: Rewriting history
tags: [git-github, history-rewriting]
prerequisites: [committing-git-commit, the-working-directory-staging-area-and-repository]
see-also: [rebasing-git-rebase, interactive-rebase-squash-fixup-reword-drop]
---

# Amending commits (git commit --amend)

`git commit --amend` replaces the most recent commit with a new one, letting you fix its message or contents without adding a separate "oops" commit.

## Why it matters

The last commit is wrong more often than any other: a typo in the message, a forgotten file, a stray debug line. Amending keeps history clean so reviewers see one coherent commit instead of `fix typo` noise. It is the simplest form of [[interactive-rebase-squash-fixup-reword-drop|history rewriting]] — only `HEAD` changes — and a daily-use tool before pushing.

## How it works

Amend does **not** edit the old commit; Git is immutable. It builds a *new* commit from the current index plus whatever you change, then moves the branch tip to it. The old commit becomes unreferenced (recoverable via [[reflog-and-recovery-git-reflog|reflog]]).

- `git commit --amend` — opens the editor; folds staged changes into `HEAD`.
- `git commit --amend --no-edit` — keep the old message; just absorb new staged files.
- `git commit --amend -m "new msg"` — rewrite the message only.

| Property | Old commit | Amended commit |
|---|---|---|
| SHA | `a1b2c3d` | `f9e8d7c` (new) |
| Author date | preserved | preserved |
| Committer date | original | now |
| Parent | unchanged | unchanged |

Because the SHA changes, the amended commit is a different object even if the tree is identical.

## Example

```
$ git commit -m "Add login endpoint"
$ git add forgot_this.py            # left a file out
$ git commit --amend --no-edit      # fold it in, keep message
[main f9e8d7c] Add login endpoint
 2 files changed, 31 insertions(+)
```

The branch now points at `f9e8d7c`; `a1b2c3d` is gone from the graph but findable in `git reflog`.

## Pitfalls

- **Amending after push** — the SHA changes, so the remote rejects it; you must `git push --force-with-lease`, which is dangerous on shared branches.
- **Accidentally absorbing staged work** — `--amend` pulls in *everything* staged, not just your intended fix; check `git diff --cached` first.
- **Committer-date drift** — amending bumps the committer date; release tooling that sorts by date can reorder things unexpectedly.
- **Losing the original** — only the reflog holds it, and reflog entries expire (default 90 days) and aren't pushed.

## See also

- [[interactive-rebase-squash-fixup-reword-drop]]
- [[reflog-and-recovery-git-reflog]]
