---
title: Centralized vs distributed VCS
track: git-github
group: Version control basics
tags: [git-github, architecture]
prerequisites: [what-is-version-control]
see-also: [what-is-git, what-is-a-remote]
---

# Centralized vs distributed VCS

The two dominant VCS architectures differ in where history lives: a **centralized** VCS (CVCS) keeps the single authoritative history on one server; a **distributed** VCS (DVCS) gives every clone a full copy of that history.

## Why it matters

The model dictates your offline story, failure domain, and branching cost. In a CVCS (SVN, CVS, Perforce), the server is a single point of failure and most operations need a network round-trip. In a DVCS ([[what-is-git|Git]], Mercurial), commit/diff/log/branch are local and instant, every clone is a backup, and you only touch the network to sync. This is why Git won open source: contributors work offline and share via [[what-is-a-remote|remotes]] rather than a shared lock.

## How it works

| Aspect | Centralized (SVN) | Distributed (Git) |
|---|---|---|
| History location | server only | every clone |
| Commit | needs server | local, offline |
| Branch cost | server-side, heavy | a 40-byte pointer |
| Single point of failure | yes (the server) | no (N full copies) |
| Backup | separate concern | every clone is one |
| Common failure | offline = blocked | merge conflicts |

DVCS decouples *commit* (record locally) from *publish* ([[pushing-git-push|push]] to a shared remote). A CVCS fuses them: a commit is a server write. Note "distributed" does not mean serverless in practice — teams still designate a canonical remote (e.g. on [[git-vs-github|GitHub]]) as the source of truth.

## Example

Plane with no Wi-Fi. In SVN you can edit but cannot commit, branch, or diff against history — you're stuck. In Git you `commit` ten times, create two [[what-is-a-branch|branches]], `rebase`, and read full `log`; on landing you run one [[pushing-git-push|git push]] to publish everything. The only thing requiring the network was the final sync.

## Pitfalls

- **Assuming DVCS = no server** — you still need a canonical remote and access control around it.
- **CVCS lock-step on big binaries** — Git stores full-tree history in every clone, so huge binaries bloat all clones (use LFS).
- **"It's committed" ≠ "it's shared"** in DVCS — a local commit is invisible until pushed; teammates can't see or build it.
- **Pull-before-push discipline** — DVCS lets you diverge silently, so you must integrate others' work before publishing.

## See also

- [[what-is-git]]
- [[what-is-a-remote]]
