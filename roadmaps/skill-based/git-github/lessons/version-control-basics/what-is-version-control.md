---
title: What is version control?
track: git-github
group: Version control basics
tags: [git-github, fundamentals]
prerequisites: []
see-also: [centralized-vs-distributed-vcs, what-is-git]
---

# What is version control?

A version control system (VCS) records changes to files over time so you can recall any prior state, see who changed what and why, and let many people edit the same tree without overwriting each other.

## Why it matters

Without a VCS, history lives in `report_final_v2_REALLY_final.docx` copies and lost context. A VCS gives every change an author, timestamp, and message, makes any past revision reproducible, and turns "who broke this and when?" into a one-command answer. It is the substrate for code review, CI/CD, releases, and rollback — nearly every other engineering practice assumes it exists. It also enables parallel work via [[what-is-a-branch|branches]] that merge back cleanly.

## How it works

The core unit is a **commit** (a.k.a. revision/changeset): an immutable snapshot or delta of the tracked files plus metadata (author, time, message, parent). Commits chain into a history you can navigate.

| Capability | What it buys you |
|---|---|
| History | inspect/diff/restore any past state |
| Attribution | per-line author via [[git-blame]] |
| Branching | isolate features, fixes, experiments |
| Merging | recombine divergent work |
| Bisect | binary-search history for a regression with [[git-bisect]] |

Three broad generations: **local** (RCS, SCCS — one machine), **centralized** (CVS, SVN — one server), and **distributed** ([[what-is-git|Git]], Mercurial — every clone is a full repo). See [[centralized-vs-distributed-vcs]] for the trade-offs.

## Example

A regression ships. With history you run `git log --oneline` to scan recent commits, `git bisect` to pinpoint the offending one in ~log2(N) steps (1,000 commits → ~10 checkouts), read its message and diff, then `git revert <sha>` to undo just that change while preserving everything after it.

## Pitfalls

- **Committing build artifacts / secrets** — bloats history and leaks credentials; gate with [[ignoring-files-gitignore|.gitignore]].
- **Giant infrequent commits** — "EOD dump" commits destroy bisect and review value; commit small, logical units.
- **Treating a sync tool (Dropbox) as a VCS** — no atomic commits, no merge, no real history.
- **Vague messages** — `"fix"` tells future-you nothing; state the why, not the what.

## See also

- [[centralized-vs-distributed-vcs]]
- [[what-is-git]]
