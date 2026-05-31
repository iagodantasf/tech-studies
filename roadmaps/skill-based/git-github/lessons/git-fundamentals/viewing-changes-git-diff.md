---
title: Viewing changes (git diff)
track: git-github
group: Git fundamentals
tags: [git-github, diffing]
prerequisites: [the-working-directory-staging-area-and-repository]
see-also: [checking-status-git-status, viewing-history-git-log, tracking-changes-git-add]
---

# Viewing changes (git diff)

`git diff` shows line-level differences between two trees — most often the working directory, the [[the-working-directory-staging-area-and-repository|index]], and `HEAD` — as a unified patch.

## Why it matters

It is the review step before staging or committing: you see exactly what changed, catch stray edits and secrets, and confirm a fix is minimal. The *same* command compares branches, tags, and commits, so it is the engine behind every code review and [[pull-requests|PR]] diff.

## How it works

The trick is knowing which two endpoints each invocation compares. By default `git diff` is **working vs index** — it deliberately hides already-staged changes.

| Command | Compares |
|---|---|
| `git diff` | Working dir vs index (unstaged) |
| `git diff --staged` | Index vs `HEAD` (what will commit) |
| `git diff HEAD` | Working dir vs last commit (all changes) |
| `git diff A B` | Commit/branch A vs B |
| `git diff A...B` | B vs the merge-base of A and B |

- **Reading a hunk** — `@@ -12,6 +12,7 @@` means: old file from line 12 spanning 6 lines, new from line 12 spanning 7; `-` lines removed, `+` added.
- **Word-level** — `--word-diff` (or `--color-words`) highlights intra-line changes, far clearer for prose/config than whole-line diffs.
- **Scope & noise control** — `-- <path>` limits to a file; `-w` ignores whitespace-only changes; `--stat` gives a summary instead of the patch.
- **`...` for PR review** — `git diff main...feature` shows what the branch added since it forked, ignoring changes that landed on `main` meanwhile (matches what GitHub shows).

## Example

```
git diff --stat                 # quick overview of unstaged edits
git add -p && git diff --staged # confirm ONLY the intended hunk is staged
git diff main...feature -- src/ # review a branch's src changes like the PR will
```

## Pitfalls

- **"diff shows nothing" after `git add`** — bare `git diff` excludes staged changes; you need `git diff --staged` (or `git diff HEAD`).
- **`A..B` vs `A...B`** — two dots is a direct A→B comparison; three dots diffs against the *merge base*. Using the wrong one over-reports changes that came from the base branch.
- **Whitespace/CRLF storms** — line-ending or reformat changes produce huge noisy diffs; `-w` and a `.gitattributes` normalization tame them.
- **Binary files** — Git reports "Binary files differ" with no content; configure a textconv (e.g. for docx/png) to get a meaningful diff.

## See also

- [[checking-status-git-status]]
- [[viewing-history-git-log]]
