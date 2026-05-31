---
title: README, LICENSE, and repository structure
track: git-github
group: GitHub basics
tags: [git-github, repo-structure]
prerequisites: [creating-a-github-account-and-repository]
see-also: [github-issues, semantic-versioning]
---

# README, LICENSE, and repository structure

The conventional top-level files GitHub recognizes — `README`, `LICENSE`, and a set of community health files — that tell humans and the platform how to use, reuse, and contribute to a repo.

## Why it matters

GitHub renders `README.md` as the landing page and surfaces `LICENSE` as a badge; without a license, default copyright applies and **nobody may legally reuse your code**, even if it's public. Community health files (`CONTRIBUTING`, `CODE_OF_CONDUCT`, issue/PR templates) drive the prompts contributors see, cutting low-quality issues and PRs.

## How it works

GitHub special-cases certain filenames and looks for them in the repo root, `.github/`, or `docs/` (in that order).

| File | Purpose | Where GitHub looks |
|---|---|---|
| `README.md` | Landing page / overview | root, `.github/`, `docs/` |
| `LICENSE` | Legal reuse terms | root |
| `CONTRIBUTING.md` | How to contribute | root or `.github/` |
| `.github/ISSUE_TEMPLATE/` | Pre-filled issue forms | `.github/` only |
| `CODEOWNERS` | Auto-assign reviewers | `.github/` or root |

- A profile-level README lives in a repo named the same as your username (e.g. `iagodantasf/iagodantasf`) and shows on your profile.
- Pick a license at [[creating-a-github-account-and-repository|creation]] or via "Add file to Choose a license template"; permissive (MIT, Apache-2.0) vs copyleft (GPL-3.0) is the key axis.
- Keep source under `src/`, tests under `tests/`, CI under `.github/workflows/` — conventional layout that tooling expects.

## Example

```
my-lib/
├── README.md           # rendered on landing page
├── LICENSE             # MIT → "License: MIT" badge appears
├── CHANGELOG.md        # human-readable, often SemVer-keyed
├── .github/
│   ├── CODEOWNERS      # @acme/api-team owns src/api/
│   └── workflows/ci.yml
├── src/
└── tests/
```

## Pitfalls

- **No LICENSE** — "open source" without one is *not* legally reusable; default exclusive copyright applies.
- **Wrong license for dependencies** — shipping GPL code inside an MIT project can force the whole work to GPL; check transitive license compatibility.
- **README with absolute/branch URLs to images** — break on forks or after a default-branch rename; use repo-relative paths.
- **CODEOWNERS in the wrong path** — only `.github/`, root, or `docs/` are honored; elsewhere it silently does nothing.

## See also

- [[creating-a-github-account-and-repository]]
- [[semantic-versioning]]
