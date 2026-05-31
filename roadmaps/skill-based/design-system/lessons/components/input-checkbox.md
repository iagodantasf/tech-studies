---
title: Input — Checkbox
track: design-system
group: Components
tags: [design-system, forms]
prerequisites: [component]
see-also: [input-radio, input-switch, forms]
---

# Input — Checkbox

A control for **independent on/off choices** — zero, one, or many selected from a set — plus a third indeterminate state for parent/child groups.

## Why it matters

The checkbox/radio/switch trio is constantly mis-chosen, and picking wrong sends the wrong mental model. A checkbox means "select any number, independently"; if choices are mutually exclusive you want a [[input-radio]], and if it's an immediate system toggle you want a [[input-switch]]. Checkboxes also own the **indeterminate** state that makes "select all" trees work — a detail home-grown versions almost always miss.

## How it works

Build on the native `<input type="checkbox">` for free semantics and keyboard support:

- **Three states** — unchecked / checked / **indeterminate** (a parent whose children are partially selected; visual dash, not a value).
- **Label** — clickable and associated; the whole label toggles the box.
- **Grouping** — wrap a set in `<fieldset>`/`<legend>` so the group has an accessible name.
- **States × visuals** — default / hover / focus-visible / disabled, all token-driven.

| State | Meaning | Submitted value |
|---|---|---|
| Unchecked | Not selected | absent/false |
| Checked | Selected | true |
| Indeterminate | Partial (parent) | n/a — visual only |

Indeterminate is set in JS (`el.indeterminate = true`); it isn't an HTML attribute and isn't a submitted value.

## Example

A permissions tree: a parent "All notifications" checkbox over Email / SMS / Push. Checking 2 of 3 children flips the parent to **indeterminate** (a dash). Checking the parent selects all three; unchecking clears all. Each label is fully clickable, the group sits in a `<fieldset><legend>Notifications</legend>`, and focus shows a visible ring. The submitted payload contains only the checked children.

## Pitfalls

- **Checkbox where radio belongs** — mutually exclusive options as checkboxes mislead users; use [[input-radio]].
- **Forgetting indeterminate** — "select all" without the partial state looks broken on mixed selections.
- **Custom box with no native input** — a styled `<div>` loses keyboard and screen-reader support; style the real input or use its semantics. See [[accessibility]].
- **Unlabeled or tiny target** — make the whole label clickable and ≥ 24px.

## See also

- [[input-radio]]
- [[input-switch]]
