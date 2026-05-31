---
title: Continuous Integration for C++
track: openclaw
group: Tooling, Build & Distribution
tags: [openclaw, ci]
prerequisites: [build-systems-cmake, cross-platform-compilation-gcc-clang-msvc]
see-also: [build-systems-cmake, cross-platform-compilation-gcc-clang-msvc, packaging-for-windows-linux-macos]
---

# Continuous Integration for C++

An automated pipeline that configures, compiles, and tests OpenClaw on every push across the three target toolchains — catching breakage the moment it lands, not at release.

## Why it matters

OpenClaw must build on GCC, Clang, and MSVC (see [[compilers-gcc-clang-msvc]]), and a change that compiles cleanly on one routinely fails another — MSVC is stricter about templates, GCC about unused-variable warnings, Clang about narrowing. Without CI, "works on my machine" ships a broken Windows build to contributors who can't bisect it. A matrix pipeline compiles all three on every PR so a portability break is a red X on the commit that caused it, keeping the [[contributing-to-the-openclaw-repo|contribution]] flow sane.

## How it works

A CI job is the same [[build-systems-cmake-make]] sequence a developer runs, pinned and reproducible, fanned across a platform matrix.

| OS | Compiler | SDL2 source | Typical gotcha |
|---|---|---|---|
| ubuntu | GCC / Clang | apt packages | stale lib versions |
| windows | MSVC | vcpkg / prebuilt | path + DLL layout |
| macos | AppleClang | brew | `@rpath` framework paths |

- **Matrix fan-out.** One workflow spawns N jobs `(os x compiler)`; each runs configure -> build -> test independently and reports its own status.
- **Cache the deps.** SDL2/Box2D/vcpkg builds are slow; cache them keyed on a lockfile hash so a green run is minutes, not the ~20+ a cold dependency build costs.
- **Warnings as errors.** `-Werror` / `/WX` in CI turns a sloppy warning into a hard failure, so the warning is fixed at the PR, not accumulated.
- **Fail fast vs full matrix.** During dev, stop the matrix on first failure; on `main`, run the whole matrix so you see *every* platform's status at once.
- **Required checks.** Gate merges on CI green so the default branch always builds on all three.

## Example

```yaml
# .github/workflows/ci.yml (shape)
strategy:
  matrix:
    include:
      - { os: ubuntu-latest,  cc: clang }
      - { os: windows-latest, cc: cl }
      - { os: macos-latest,   cc: clang }
steps:
  - uses: actions/cache@v4        # cache vcpkg / deps
  - run: cmake -B build -DCMAKE_BUILD_TYPE=Release
  - run: cmake --build build --parallel
  - run: ctest --test-dir build --output-on-failure
```

A push that compiles on the author's Linux box but uses a non-standard `std::` extension fails the `windows-latest / cl` job within minutes — the break is attributed to that exact commit, not discovered weeks later.

## Pitfalls

- **No dependency cache.** Rebuilding SDL2/vcpkg from scratch every run makes CI so slow contributors stop waiting for it; cache on a lockfile key.
- **Only testing one compiler.** A Linux-only pipeline lets MSVC-specific breakage merge freely; the matrix is the whole point.
- **Ignoring warnings.** Without `-Werror` in CI, warnings pile up until a real bug hides in the noise.
- **Floating action/runner versions.** `ubuntu-latest` silently bumps its toolchain; a pin or lockfile keeps a green build reproducible next month.

## See also

- [[build-systems-cmake-make]]
- [[compilers-gcc-clang-msvc]]
- [[packaging-for-windows-linux-macos]]
