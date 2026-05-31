---
title: Semantic versioning
track: git-github
group: Stashing and tags
tags: [git-github, versioning]
prerequisites: [creating-and-pushing-tags]
see-also: [lightweight-vs-annotated-tags, dependabot-and-security-alerts]
---

# Semantic versioning

SemVer is a `MAJOR.MINOR.PATCH` contract where the number you bump encodes whether a release breaks callers, adds features, or just fixes bugs.

## Why it matters

Dependency resolvers and humans both rely on version numbers to mean something. SemVer lets a manifest say "any `1.x` is safe" via ranges like `^1.4.0`, so tooling such as [[dependabot-and-security-alerts|Dependabot]] can auto-upgrade patches while pinning across majors. Cutting these versions as [[creating-and-pushing-tags|git tags]] (`v1.4.0`) ties the contract to an immutable commit.

## How it works

Given `MAJOR.MINOR.PATCH`, increment the leftmost field that applies and reset the ones to its right:

| Change | Bump | `1.4.2` → |
|---|---|---|
| Backward-incompatible API break | MAJOR | `2.0.0` |
| New feature, still compatible | MINOR | `1.5.0` |
| Backward-compatible bug fix | PATCH | `1.4.3` |

Suffixes refine it: `-beta.1` is a **pre-release** (lower precedence than `1.4.2`), and `+build.42` is **build metadata** (ignored in precedence). Ranges in manifests lean on this: `^1.4.0` allows `<2.0.0`, `~1.4.0` allows `<1.5.0`, and `0.y.z` is special — anything may break, so `^0.2.3` only allows `<0.3.0`.

## Example

```
1.0.0  → 1.0.1   patch: fix a null check, no API change
1.0.1  → 1.1.0   minor: add an optional parameter
1.1.0  → 2.0.0   major: remove a deprecated function (breaking)

precedence:  1.0.0-alpha < 1.0.0-beta < 1.0.0-rc.1 < 1.0.0
```

A consumer pinned to `^1.0.1` rides `1.1.0` automatically but is held back from `2.0.0`.

## Pitfalls

- **0.y.z is not "stable-minus-a-bit"** — pre-1.0, minor bumps may break freely; `^0.2.0` deliberately won't cross to `0.3.0`.
- **"Just a refactor" that changes behavior is a MAJOR** — SemVer is about the *observable* contract, not your intent or diff size.
- **Pre-release tags sort lower** — `1.0.0-rc.1` precedes `1.0.0`, and `rc.2` precedes `rc.10` numerically only because identifiers are compared as numbers when all-digit.
- **Tag string vs version string** — the git tag is conventionally `v1.4.0` but the SemVer value is `1.4.0`; mixing them breaks parsers that expect one or the other.

## See also

- [[creating-and-pushing-tags]]
- [[lightweight-vs-annotated-tags]]
