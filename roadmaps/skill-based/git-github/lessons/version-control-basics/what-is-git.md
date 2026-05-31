---
title: What is Git?
track: git-github
group: Version control basics
tags: [git-github, fundamentals]
prerequisites: [centralized-vs-distributed-vcs]
see-also: [git-vs-github, the-working-directory-staging-area-and-repository]
---

# What is Git?

Git is a distributed version control system that models history as a content-addressed directed acyclic graph (DAG) of immutable snapshots, created by Linus Torvalds in 2005 to manage Linux kernel development.

## Why it matters

Git is the de facto standard VCS (over 90% of professional developers use it). Its design — local-first operations, cryptographic integrity, and cheap [[what-is-a-branch|branching]] — makes it fast and trustworthy at scale (the Linux repo has 1M+ commits). Understanding that Git stores **snapshots, not diffs**, and addresses everything by hash demystifies most of its commands and recovery tools like [[reflog-and-recovery-git-reflog|reflog]].

## How it works

Git's object store has four object types, each named by the SHA-1 hash of its contents (migrating to SHA-256):

| Object | Holds | Points to |
|---|---|---|
| blob | file contents (no name) | — |
| tree | a directory listing | blobs + subtrees |
| commit | a snapshot + metadata | one tree + parent(s) |
| tag | annotated tag | usually a commit |

A **commit** references a full **tree** (the whole project state), so each commit is a complete snapshot; unchanged files simply reuse the same blob hash, so storage stays cheap. A [[what-is-a-branch|branch]] is just a movable pointer to a commit; `HEAD` points at your current branch. Identical content always yields the same hash, which dedupes storage and guarantees integrity — a single bit flip changes the SHA. Most work flows through the [[the-working-directory-staging-area-and-repository|working dir → staging → repo]] pipeline.

## Example

Inspect the plumbing on any repo:

```
git cat-file -t HEAD        → commit
git cat-file -p HEAD        → tree <sha>, parent <sha>, author ...
git rev-parse HEAD          → 9f2c1ab...   (full 40-hex commit id)
```

Two files with identical bytes (e.g. empty `__init__.py`) share one blob object — Git stores the content once and references it from every tree that needs it.

## Pitfalls

- **Thinking Git stores diffs** — it stores snapshots; diffs are computed on demand, which is why [[viewing-changes-git-diff|git diff]] is fast but unrelated to storage.
- **Confusing Git with [[git-vs-github|GitHub]]** — Git is the tool; GitHub is one host for it.
- **Editing history that's already pushed** — rewriting shared commits changes their hashes and breaks collaborators' clones.
- **Assuming SHA-1 collisions are a threat** — Git adds collision detection; the bigger risk is treating short hashes as unique forever.

## See also

- [[git-vs-github]]
- [[the-working-directory-staging-area-and-repository]]
