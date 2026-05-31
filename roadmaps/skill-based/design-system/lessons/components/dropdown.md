---
title: Dropdown
track: design-system
group: Components
tags: [design-system, components]
prerequisites: [component]
see-also: [forms, modal, accessibility]
---

# Dropdown

A control that reveals a floating list of options or actions on demand — a menu, a select, or a combobox — anchored to a trigger.

## Why it matters

"Dropdown" hides three different ARIA patterns behind one visual, and conflating them is the most common a11y bug in design systems. A menu of *actions*, a *select* of one value, and a typeahead *combobox* have different keyboard contracts and roles. A system that ships one honest dropdown per pattern saves every team from rebuilding a `<div>` that breaks screen readers and keyboards.

## How it works

Pick the pattern by job, then implement its contract:

| Pattern | Job | Role |
|---|---|---|
| Menu | Trigger actions | `menu` / `menuitem` |
| Select | Pick one value | `listbox` / `option` |
| Combobox | Filter then pick | `combobox` + listbox |
| Multi-select | Pick several | listbox + checkboxes |

Shared mechanics:

- **Trigger** — a real [[button]]; toggles `aria-expanded`.
- **Floating panel** — positioned with collision handling so it flips up/over when it would clip the viewport.
- **Keyboard** — Up/Down to move, Enter/Space to select, Esc to close, type-ahead to jump; focus returns to the trigger on close.
- **Dismiss** — outside click and Esc both close; focus is managed, not lost.

For long option sets, virtualize; for huge or touch-first cases, a [[modal]] sheet often beats a floating menu.

## Example

A native-feeling country picker uses the **combobox** pattern: a [[button]]/input with `aria-expanded`, a filterable `listbox` of 195 options (virtualized), type-ahead jumping to "Ger…", Up/Down to traverse, Enter to commit, Esc to cancel. The panel detects it's near the viewport bottom and opens upward. On select, focus snaps back to the trigger showing "Germany."

## Pitfalls

- **Wrong role for the job** — a `menu` used as a form select (or vice versa) misleads assistive tech; match pattern to role.
- **No keyboard support** — mouse-only dropdowns exclude many users; implement the full key map. See [[accessibility]].
- **Clipping at viewport edges** — fixed-position panels get cut off; add collision/flip logic.
- **Losing focus on close** — always return focus to the trigger.

## See also

- [[forms]]
- [[modal]]
