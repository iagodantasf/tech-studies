---
title: Modal
track: design-system
group: Components
tags: [design-system, components]
prerequisites: [component]
see-also: [banner, dropdown, accessibility]
---

# Modal

A layer that opens above the page, blocks interaction with everything behind it, and demands focus until dismissed — used for focused tasks or confirmations.

## Why it matters

Modals interrupt, so they're easy to abuse and famously hard to build accessibly. The defining behavior — a **focus trap**, a backdrop, scroll lock, and Escape-to-close — is exactly what hand-rolled versions get wrong, leaving keyboard users stranded behind the overlay. A system that ships one correct modal (with the trap and restore handled) saves every team from reimplementing the most bug-prone interaction pattern.

## How it works

A modal is a dialog with a managed focus lifecycle:

- **Focus trap** — on open, move focus into the dialog; Tab cycles *within* it; on close, **restore** focus to the trigger.
- **Backdrop & blocking** — a scrim blocks clicks behind; lock background scroll so the page doesn't scroll under it.
- **Dismissal** — Escape closes; backdrop click closes *non-destructive* modals; destructive ones require an explicit choice.
- **Semantics** — `role="dialog"`, `aria-modal="true"`, labelled by its title; render in a portal/top layer so stacking is reliable.

| Concern | Requirement |
|---|---|
| Focus | Trap in, restore out |
| Background | Scrim + scroll lock |
| Escape | Closes (non-destructive) |
| Naming | aria-labelledby title |

Reserve modals for genuinely blocking tasks; for non-blocking status use a [[banner]] or toast, and for option pickers prefer a [[dropdown]].

## Example

A "Delete project" confirm dialog opens; focus jumps to the modal heading, Tab cycles only between "Cancel" and "Delete," and the background scrolls/clicks are blocked. Because the action is destructive, a backdrop click does *not* close it — the user must pick. On either choice, the modal closes and focus returns to the "Delete project" [[button]] that opened it. It carries `role="dialog" aria-modal="true"` labelled by the heading.

## Pitfalls

- **No focus trap / no restore** — keyboard users tab out behind the overlay and lose their place; trap on open, restore on close.
- **Backdrop-dismiss on destructive actions** — an accidental click discards work; require an explicit choice.
- **Background scroll bleed** — the page scrolls under the modal; lock scroll while open.
- **Modal for non-blocking info** — overusing modals trains users to dismiss reflexively; use a [[banner]] instead.

## See also

- [[banner]]
- [[dropdown]]
