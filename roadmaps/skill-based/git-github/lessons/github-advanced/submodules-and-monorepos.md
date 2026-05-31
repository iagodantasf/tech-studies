---
title: Submodules and monorepos
track: git-github
group: GitHub advanced
tags: [git-github, repo-structure]
prerequisites: [cloning-git-clone, what-is-a-remote]
see-also: [branching-strategies-git-flow-github-flow-trunk-based, github-actions-and-ci-cd]
---

# Submodules and monorepos

Two opposite answers to "how do I structure many components": **submodules** nest separate repos inside one (multi-repo), while a **monorepo** keeps everything in a single repo.

## Why it matters

This is an architecture decision that shapes every clone, build, and release. Submodules give independent versioning and access control at the cost of coordination overhead; monorepos give atomic cross-component changes and one history at the cost of scale and tooling demands. Google, Meta, and Microsoft run massive monorepos; many OSS projects vendor dependencies as submodules — the trade-off is real, not stylistic.

## How it works

A submodule records a *pinned commit SHA* of another repo as a gitlink; a monorepo just stores all code together and slices it with paths.

| Dimension | Submodules (multi-repo) | Monorepo |
|---|---|---|
| Versioning | per-repo, pinned SHA | one commit spans all |
| Cross-cutting change | N PRs, N repos | 1 atomic PR |
| Clone cost | small; deps on demand | grows with everything |
| Access control | per-repo | all-or-nothing (mostly) |
| CI | per-repo pipelines | needs path filters |

- **Submodule mechanics** — `.gitmodules` lists URLs; the parent stores a commit pointer, *not* the files. Clone with `--recurse-submodules`, update with `git submodule update --remote`. The parent only moves when you commit the new pointer.
- **Detached HEAD** — a submodule checks out a specific commit, so it sits in [[reflog-and-recovery-git-reflog|detached]] state; edits there need a branch or they're easy to lose.
- **Monorepo tooling** — scale needs sparse-checkout / partial clone, a build graph (Bazel, Nx, Turborepo), and [[github-actions-and-ci-cd|CI]] path filters so a docs change doesn't rebuild the world.
- **`CODEOWNERS`** gives per-directory review in a monorepo, recovering some of the access boundaries submodules give for free.

## Example

```
# Add and pin a submodule
$ git submodule add https://github.com/acme/proto.git vendor/proto
$ git commit -m "pin proto submodule"     # records vendor/proto @ <sha>

# A teammate gets the actual files:
$ git clone --recurse-submodules https://github.com/acme/app.git
# Later, bump the pinned commit:
$ git submodule update --remote vendor/proto && git add vendor/proto && git commit
```

## Pitfalls

- **Forgetting `--recurse-submodules`** — a plain clone leaves submodule dirs *empty*; builds fail mysteriously until `git submodule update --init`.
- **Pointer not committed** — updating a submodule's files without committing the new gitlink in the parent means teammates still get the old SHA.
- **Detached-HEAD edits lost** — committing inside a submodule without a branch strands the work; CI pins the old commit anyway.
- **Monorepo without path-filtered CI** — every push runs every test; a one-line README change triggers a 40-minute build. Filter by changed paths.

## See also

- [[branching-strategies-git-flow-github-flow-trunk-based]]
- [[github-actions-and-ci-cd]]
