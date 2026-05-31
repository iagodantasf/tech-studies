---
title: Pattern
track: design-system
group: Patterns
tags: [design-system, patterns]
prerequisites: [component]
see-also: [placement-guidance, guidelines, documentation]
---

# Pattern

A reusable, documented arrangement of several components that solves a recurring user task the same way every time — the system's unit of *behavior*, not of UI.

## Why it matters

A [[component]] answers "what does a button look like"; a pattern answers "how do we ask a user to confirm a destructive action." The hard, expensive decisions in a product live at the pattern level — empty states, form validation, pagination, destructive-confirm — and teams re-solve them badly when there is no canon. Patterns are where consistency is actually felt: users learn one "delete flow" and trust it everywhere. They also keep the [[component-catalog]] honest, since a layout solving a task is a pattern, not a new component to build.

## How it works

A pattern is a *recipe*: which components, in what arrangement, with which copy and rules — usually no new code, just composition plus guidance.

- **Composition over invention** — assemble [[modal]], [[button]], [[forms]] you already have; new code is a smell.
- **Names a problem, not a shape** — "Confirm destructive action", "Empty state", not "two-column box".
- **Carries rules** — required [[microcopy-guidelines]], focus order, error handling, [[accessibility]] obligations.
- **Has [[placement-guidance]]** — when to reach for it, and the cheaper alternative to prefer.

| Aspect | Component | Pattern |
|---|---|---|
| Unit of | UI | Behavior / task |
| Ships as | Code + API | Recipe + guidance |
| Example | [[button]], [[card]] | confirm-delete, empty state |
| New code | Usually yes | Usually no |

A pattern graduates from a [[guidelines]] recommendation once it appears in 3+ places and is worth standardizing.

## Example

**Destructive confirmation.** Trigger → [[modal]] titled by the object ("Delete *Q3 report*?"), body stating the irreversible consequence, a `danger` [[button]] labeled with the verb ("Delete") plus a `secondary` Cancel that holds initial focus. Rules: never label the action "OK"; require typed confirmation only above a risk threshold (e.g. deleting >100 rows or a shared resource). Documented once, this replaces ~12 divergent delete dialogs found in an audit.

## Pitfalls

- **Pattern as component** — building `<ConfirmDeleteModal>` as bespoke code when composition would do bloats the [[component-library]].
- **Shape-named, not task-named** — "card grid" describes pixels and gets misapplied; name the job.
- **No anti-pattern** — a pattern that never says *when not* to use it gets reached for everywhere.
- **Undocumented** — a pattern living only in one team's Figma isn't a pattern; it must sit in [[documentation]].

## See also

- [[placement-guidance]]
- [[guidelines]]
