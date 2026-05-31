---
title: Contribution Guidelines
track: design-system
group: Content & guidelines
tags: [design-system, governance]
prerequisites: [code-style, commit-guidelines]
see-also: [governance, code-style, open-hours]
---

# Contribution Guidelines

Contribution guidelines define how someone proposes, builds, and lands a change to the design system — the documented path that lets a centralized team scale without becoming a bottleneck.

## Why it matters

A small core team can't build every component every consumer wants; without a contribution path, the backlog becomes the ceiling and teams fork the library out of frustration. Clear guidelines turn outside energy into reviewed, on-system contributions instead of one-off pull requests that stall for weeks. They are the operational arm of [[governance]]: who can change what, by which process, and what "accepted" requires. The aim is a federated model with a guarded bar, not an open free-for-all.

## How it works

Define a staged path with a checklist gate before merge:

| Stage | Who | Output |
|---|---|---|
| Propose | anyone | issue/RFC: problem, not solution |
| Triage | core team | accept / decline / needs-design |
| Build | contributor | PR meeting the DoD checklist |
| Review | core + a11y | approval against the bar |
| Release | core team | versioned, changelogged |

Standing rules:

- **Propose before building** — a short RFC ("we keep rebuilding a [[badge]]") prevents wasted PRs the team will reject on scope.
- **Definition of Done is a checklist** — tokenized, all states, keyboard-operable, [[accessibility]]-tested, documented, in design *and* code, tests pass.
- **Follow the standards** — [[code-style]] and [[commit-guidelines]] are non-negotiable and CI-enforced, so review is about design, not formatting.
- **Two-key merge** — at least one core maintainer approves; the [[component]] bar doesn't bend for velocity.
- **Provide a venue** — [[open-hours]] or a channel where contributors get help before a PR, not after rejection.

## Example

A product team needs a [[carousel]]. They file an RFC; triage accepts but scopes it to one variant. They build to the DoD checklist — tokens, 7 states, keyboard + ARIA, stories, docs — and open a PR with `feat(carousel): add basic carousel`. A maintainer and the a11y reviewer approve; it releases as a minor bump. The component lands *on-system* instead of as a private fork that drifts.

## Pitfalls

- **No proposal step** — contributors build first, get rejected on scope, and stop contributing; gate ideas before effort.
- **Lowering the bar for throughput** — accepting an untested, inaccessible component imports debt the core team owns forever.
- **Bottleneck reviews** — one overloaded maintainer stalls every PR; spread review and hold [[open-hours]].
- **Undocumented "no"** — declining without a reason or alternative breeds shadow forks; always say why and what instead.

## See also

- [[governance]]
- [[code-style]]
