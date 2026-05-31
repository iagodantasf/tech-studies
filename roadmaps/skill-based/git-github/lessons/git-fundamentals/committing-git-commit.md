---
title: Committing (git commit)
track: git-github
group: Git fundamentals
tags: [git-github, commits]
prerequisites: [tracking-changes-git-add]
see-also: [viewing-history-git-log, amending-commits-git-commit-amend, the-working-directory-staging-area-and-repository]
---

# Committing (git commit)

`git commit` records the staged snapshot as a new, immutable commit object linked to its parent, advancing the current branch to point at it.

## Why it matters

Commits are the atoms of history — every `log`, `diff`, `blame`, `revert`, and `bisect` operates on them. A commit is a permanent, content-addressed checkpoint you can return to, so the discipline of small, well-described commits directly determines how debuggable and reviewable a codebase is months later.

## How it works

A commit stores a pointer to a *tree* (the full directory snapshot), one or more *parent* SHAs, author/committer identity + timestamps, and the message. Its 40-hex SHA-1 (or SHA-256) is the hash of all that, so any change yields a different commit.

- **Identity** comes from [[git-config-user-name-user-email-core-editor|user.name / user.email]]; it is baked in at commit time and cannot be edited without rewriting the commit.
- **Message convention** — a ≤ ~50-char imperative subject, blank line, then a wrapped body explaining *why*. This is what `git log --oneline` and GitHub show.
- **Snapshots, not diffs** — each commit references a full tree; Git derives diffs on demand by comparing trees.

| Flag | Effect |
|---|---|
| `-m "msg"` | Inline message, skip editor |
| `-a` | Auto-stage tracked, modified files (not new ones) |
| `--amend` | Replace the last commit (new SHA) |
| `--no-verify` | Skip pre-commit hooks |

## Example

```
git add -A
git commit -m "fix: reject negative quantities in cart"
# [main 9f3c1ab] fix: reject negative quantities in cart
#  1 file changed, 4 insertions(+), 1 deletion(-)
git log --oneline -1   # 9f3c1ab fix: reject negative quantities in cart
```

The SHA `9f3c1ab` is now a permanent handle for that exact tree state.

## Pitfalls

- **Empty commit by accident** — `git commit` with nothing staged aborts ("nothing to commit"); add first, or use `--allow-empty` deliberately (e.g. to trigger CI).
- **`git commit -a` misses new files** — it only stages *tracked* modifications; untracked files still need explicit [[tracking-changes-git-add|git add]].
- **Amending shared commits** — [[amending-commits-git-commit-amend|--amend]] rewrites the SHA; if the original was pushed, you create a divergent history and a forced push.
- **Wrong author** — a misconfigured email commits under the wrong identity; fix the config *before* committing, since it is embedded.

## See also

- [[viewing-history-git-log]]
- [[amending-commits-git-commit-amend]]
