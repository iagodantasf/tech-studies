---
title: Commit Guidelines
track: design-system
group: Content & guidelines
tags: [design-system, git]
prerequisites: [code-style]
see-also: [contribution-guidelines, milestones, code-style]
---

# Commit Guidelines

Commit guidelines standardize commit message structure so a design system's history is machine-readable — driving automated versioning, changelogs, and release notes for the teams that consume it.

## Why it matters

A design system is a versioned package other teams depend on, so "what changed and is it breaking?" must be answerable from history, not archaeology. Structured commits let tooling derive the next semver bump and generate the changelog automatically — the consumer reads "BREAKING: Button `type` renamed to `variant`" instead of diffing two tags. Unstructured commits ("fix stuff", "wip") make every release a manual triage. This is the git-history sibling of [[code-style]].

## How it works

The widely-used grammar is **Conventional Commits**: `type(scope): subject`.

| Type | Triggers | Example |
|---|---|---|
| `feat` | minor bump | `feat(button): add ghost variant` |
| `fix` | patch bump | `fix(modal): restore focus trap` |
| `docs` | no release | `docs(card): add usage guideline` |
| `refactor` / `chore` | no release | `chore: bump deps` |
| `feat!` or `BREAKING CHANGE:` | major bump | renamed/removed public prop |

Standing rules:

- **Subject: imperative, ≤ ~50 chars, no period** — "add ghost variant", not "added a new ghost variant.".
- **Scope is the component or area** — `button`, `tokens`, `docs`; lets the changelog group by surface.
- **Breaking changes are loud** — a `!` or a `BREAKING CHANGE:` footer is the contract for a major bump; never hide an API break in a `fix`.
- **Body explains *why*** — the diff shows what; the body captures the reason a reviewer would ask about.
- **Enforce in CI** — `commitlint` rejects non-conforming messages so the format is guaranteed, not hoped-for.

## Example

A PR renames the prop `type` to `variant` on [[button]]. Commit: `feat(button)!: rename type prop to variant` with footer `BREAKING CHANGE: button "type" is now "variant"`. On merge, semantic-release reads the `!`, bumps `2.4.1 → 3.0.0`, and writes a changelog entry under "Breaking Changes" — consumers get an actionable upgrade note with zero manual release work.

## Pitfalls

- **Mislabeling a breaking change as `fix`** — ships an API break in a patch release and breaks every consumer silently; the worst commit error.
- **Noise commits** — `wip`, `asdf`, "address review" pollute the changelog; squash before merge.
- **Convention without enforcement** — a guideline nobody lints decays in a week; gate it with `commitlint`.
- **Subject that needs the diff** — "update button" tells the changelog reader nothing; name the actual change.

## See also

- [[contribution-guidelines]]
- [[milestones]]
