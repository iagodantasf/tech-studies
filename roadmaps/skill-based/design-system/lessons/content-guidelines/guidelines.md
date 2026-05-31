---
title: Guidelines
track: design-system
group: Content & guidelines
tags: [design-system, guidelines]
prerequisites: [component]
see-also: [documentation, placement-guidance, microcopy-guidelines]
---

# Guidelines

Guidelines are the prose rules that tell consumers *when*, *where*, and *how* to use a component or pattern — the usage layer that the API and the token table cannot express.

## Why it matters

A component's props describe what it *can* do; guidelines describe what it *should* do. Without them, two teams use the same [[banner]] for an inline error and a marketing promo, and the meaning of "banner" erodes. Guidelines are how a system scales decisions it can't enforce in code: the difference between a library people copy correctly and one they misuse into incoherence. They live next to the component in [[documentation]], not in a wiki nobody reads.

## How it works

The reliable shape is **do / don't pairs** plus a usage section, written per component:

| Section | Answers | Example for a [[modal]] |
|---|---|---|
| When to use | the right job | a decision that blocks the task |
| When not to use | the wrong job | non-critical info → use a [[banner]] |
| Do | correct usage, shown | one primary action, right-aligned |
| Don't | a real misuse, shown | stacking two modals |
| Related | the alternative | [[dropdown]], [[card]] |

Rules of the form:

- **Show, don't just tell** — every "don't" pairs with a rendered wrong example, not a sentence. People copy pictures.
- **Prescriptive, not exhaustive** — cover the 3–5 decisions people actually get wrong, not every theoretical case.
- **Placement is its own concern** — *where* on screen a component sits belongs in [[placement-guidance]]; *when* to use it belongs here.
- **One source** — guidelines version with the component; a separate doc drifts within a release.

## Example

The [[button]] page: "Use **one** primary button per view — it marks the single most likely action." Do: primary `Save` + secondary `Cancel`. Don't: three primary buttons competing (shown greyed with an X). When-not: a navigation action → use a link. This one rule prevents the most common real misuse — primary-button inflation — far more effectively than any prop constraint could.

## Pitfalls

- **Guidelines as decoration** — beautiful do/don't art for rules nobody breaks, while the actual confusions go undocumented.
- **Telling without showing** — a wall of prose; the wrong example must be *rendered* to land.
- **Enforceable rules left to prose** — if "primary button must be right-aligned" can be a token or lint rule, encode it; reserve prose for genuine judgment.
- **Stale after a redesign** — guidelines outlive the screenshots; re-shoot examples when the component changes.

## See also

- [[documentation]]
- [[placement-guidance]]
