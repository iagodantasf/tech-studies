---
title: List
track: design-system
group: Components
tags: [design-system, components]
prerequisites: [component]
see-also: [card, loading-indicator, accessibility]
---

# List

A vertical sequence of related items rendered with consistent structure — each row a composable line of text, [[avatar]], [[badge]], or actions.

## Why it matters

Lists are the backbone of settings, inboxes, search results, and navigation — wherever uniform rows repeat. The component standardizes row anatomy, dividers, density, and empty/loading states so every list in the product reads the same and stays accessible. It also sits at the boundary of two concerns: *layout* (the row) and *data* (selection, pagination, virtualization) — keeping those separate is what keeps lists maintainable.

## How it works

A list is a container of rows with a shared item anatomy:

- **Item anatomy** — optional leading visual ([[avatar]]/[[icon]]) + primary/secondary text + optional trailing meta/[[badge]]/action.
- **Dividers & density** — token-driven separators and row padding; pick one density per context.
- **Interaction** — static, navigable (whole row links), or selectable (multi-select with [[input-checkbox]]); don't mix a row link with inner buttons ambiguously.
- **States** — loading (skeleton), **empty** (a real empty state, not a blank), and error.

| Variant | Row behavior | Example |
|---|---|---|
| Static | Read-only | A spec sheet |
| Navigable | Row → detail | Inbox threads |
| Selectable | Checkbox per row | Bulk actions |

For large datasets, **virtualize** (render only visible rows) and paginate; keep semantics as a real `<ul>`/`<li>` so screen readers announce item counts.

## Example

A message inbox: each row = sender [[avatar]] + name (primary) + preview (secondary) + a time and unread [[badge]] (trailing). Rows are navigable — clicking opens the thread. With 10,000 messages, only ~20 rows render at a time (virtualized); scrolling recycles nodes. While loading, the list shows skeleton rows; with no messages, it shows an "Inbox zero" empty state, never a blank panel.

## Pitfalls

- **Blank instead of an empty state** — design the zero-item case explicitly. See [[loading-indicator]].
- **Rendering thousands of rows** — kills scroll performance; virtualize. See [[performance]].
- **Ambiguous row vs inner action** — a navigable row containing buttons confuses activation; make targets distinct.
- **Non-semantic markup** — `<div>` soup loses list semantics and item counts for screen readers. See [[accessibility]].

## See also

- [[card]]
- [[loading-indicator]]
