---
title: Cherry-picking (git cherry-pick)
track: git-github
group: Rewriting history
tags: [git-github, history-rewriting]
prerequisites: [committing-git-commit, what-is-a-branch]
see-also: [reverting-commits-git-revert, rebasing-git-rebase]
---

# Cherry-picking (git cherry-pick)

`git cherry-pick <sha>` copies the changes from one or more specific commits and re-applies them as new commits on your current branch.

## Why it matters

You frequently need *one* commit, not a whole branch: backporting a security fix from `main` to a `release/2.x` branch, pulling a single bug fix off a teammate's feature branch, or moving a commit you made on the wrong branch. Cherry-pick is surgical where [[merging-branches-git-merge|merge]] and [[rebasing-git-rebase|rebase]] are wholesale.

## How it works

Git computes the diff of the target commit against *its* parent, then applies that patch to your `HEAD` and records a **new commit** (new SHA, your branch as parent). The original commit is untouched.

| Flag | Effect |
|---|---|
| `-x` | append `(cherry picked from commit <sha>)` to the message |
| `-n` / `--no-commit` | apply to the index but don't commit (stack several) |
| `-e` | edit the message before committing |
| `--continue` / `--abort` | resume or bail after a conflict |

Ranges work too: `git cherry-pick A..B` applies every commit after `A` through `B`. On conflict it pauses exactly like a rebase: resolve, `git add`, `git cherry-pick --continue`.

## Example

```
   X---Y---Z   main          (Z = "Fix null deref", sha abc123)
        \
         R---S   release/2.x

$ git switch release/2.x
$ git cherry-pick -x abc123
[release/2.x def456] Fix null deref
 (cherry picked from commit abc123)
```

The fix now lives on both branches as two *different* commits (`abc123` and `def456`) with identical diffs.

## Pitfalls

- **Duplicate commits confuse merges** — later merging the two branches can replay the "same" change twice or conflict; `git cherry` / `git rebase` detect dups by patch-id, but it's fragile.
- **Context dependence** — a commit cherry-picked away from the code it assumed will conflict or, worse, apply cleanly but be subtly wrong.
- **Forgetting `-x`** — without it there's no audit trail linking the copy to its origin, making backport tracking painful.
- **Cherry-picking a merge commit** — needs `-m <parent-number>` to pick a side; omitting it errors out.

## See also

- [[reverting-commits-git-revert]]
- [[rebasing-git-rebase]]
