---
title: Contributing to the OpenClaw Repo
track: openclaw
group: Tooling, Build & Distribution
tags: [openclaw, open-source]
prerequisites: [build-systems-cmake, reading-an-existing-c-game-codebase]
see-also: [continuous-integration-for-c, build-systems-cmake, legal-boundaries-code-vs-original-game-assets]
---

# Contributing to the OpenClaw Repo

The practical workflow for landing a change in `pjasicek/OpenClaw` — building from source, matching the project's conventions, and getting a PR through review and [[continuous-integration-for-c|CI]].

## Why it matters

OpenClaw is a community reimplementation; it advances only through outside contributions, and a PR that ignores the project's structure or legal boundaries wastes the maintainer's time and your own. Knowing how to build it locally, where a given system lives, and what the reviewers care about (portability, no bundled assets, clean diffs) is the difference between a merged fix and a stale branch. This is the on-ramp that the rest of the track builds toward.

## How it works

The loop is the standard fork-PR cycle, with project-specific build and review gates.

| Step | Action | Gate it must pass |
|---|---|---|
| Build | CMake configure + build | compiles on your toolchain |
| Run | point at your own `CLAW.REZ` | game launches, asset path set |
| Branch | feature branch off `master` | not committing to default |
| PR | open against upstream | CI matrix green |
| Review | address comments | maintainer approval |

- **Build before you change.** Clone, `cmake -B build`, build, and run against *your own* extracted assets first — a contribution starts from a working tree, and you need a baseline to compare against.
- **Find the system.** Use the [[reading-an-existing-c-game-codebase|codebase-reading]] approach: actors live under the logic/components dirs, rendering and resource code are separated; locate the owning file before editing.
- **Small, focused diffs.** One PR = one concern. A 2000-line refactor mixed with a bug fix is unreviewable; split them.
- **Keep it portable.** Your change must still build on all three toolchains — CI enforces it, so don't lean on GCC-only or MSVC-only behaviour ([[compilers-gcc-clang-msvc]]).
- **Never add game data.** Sprites, levels, music, or a `CLAW.REZ` in a PR is an instant reject — only *code* and tooling are in scope (see [[legal-boundaries-code-vs-original-game-assets]]).

## Example

```text
git clone https://github.com/<you>/OpenClaw && cd OpenClaw
cmake -B build -DCMAKE_BUILD_TYPE=Debug && cmake --build build
git switch -c fix/jump-arc          # branch off master
# ... edit one system, build, test against YOUR CLAW.REZ ...
git commit -am "Fix Claw jump arc desync on high-refresh displays"
gh pr create --base master          # CI matrix runs; address review
```

A tight PR — one logical fix, builds on all three platforms, no assets, clear message — is the kind a maintainer can review and merge in one pass.

## Pitfalls

- **PR off the default branch.** Committing on `master` and opening a same-branch PR makes rebases painful; always branch.
- **Including extracted assets or a save of `CLAW.REZ`.** Copyrighted data in the diff gets the PR closed regardless of the code quality.
- **Platform-specific code.** A change that only builds on your compiler fails CI and stalls; test portability or at least read the CI matrix result.
- **Unscoped mega-diff.** Bundling formatting, refactor, and fix together hides the real change and stretches review for weeks.

## See also

- [[continuous-integration-for-c]]
- [[build-systems-cmake-make]]
- [[legal-boundaries-code-vs-original-game-assets]]
