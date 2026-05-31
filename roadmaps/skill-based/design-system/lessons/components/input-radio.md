---
title: Input — Radio
track: design-system
group: Components
tags: [design-system, forms]
prerequisites: [component]
see-also: [input-checkbox, input-switch, forms]
---

# Input — Radio

A control for picking **exactly one option from a mutually exclusive set** — selecting one deselects the rest within the group.

## Why it matters

Radios encode "one and only one," and the value is in the *group* semantics, not the dot. The classic bug is building radios as independent controls so two can be selected, or as a [[input-checkbox]] when the choice is exclusive. Radios also have a distinct keyboard model — arrow keys move *and* select within the group, and the group is a single Tab stop — that hand-rolled versions routinely get wrong.

## How it works

A radio is meaningless alone; it lives in a named group sharing one `name`:

- **Grouping** — same `name` makes selection exclusive; wrap in `<fieldset>`/`<legend>` for an accessible group name.
- **Keyboard** — the group is **one** Tab stop; Up/Left and Down/Right move to the prev/next option *and* select it; no "unselect" by design.
- **Default** — pre-select a sensible default when one exists; avoid an empty group if a choice is required.
- **States** — unselected / selected / focus-visible / disabled, token-driven.

| Aspect | Radio | Checkbox |
|---|---|---|
| Selection | One per group | Independent |
| Group required | Yes | No |
| Tab stops | One per group | One per box |
| Arrow keys | Move + select | n/a |

Rule of thumb: 2–5 visible exclusive options → radios; more, or space-constrained → a [[dropdown]] select.

## Example

A shipping selector — Standard / Express / Overnight — shares `name="shipping"` inside a `<fieldset><legend>Shipping</legend>`. "Standard" is pre-selected as the default. Tab lands once on the group; pressing Down moves to and selects "Express." Only one is ever checked, and the submitted value is the single chosen option. Focus shows a visible ring on the active radio.

## Pitfalls

- **Radios that allow multiple** — a missing shared `name` breaks exclusivity; verify the group.
- **Radio vs checkbox mismatch** — exclusive → radio, independent → [[input-checkbox]]; choosing wrong misleads.
- **Per-radio Tab stops** — the group must be a single stop with arrow navigation. See [[accessibility]].
- **No default + required** — forces an extra interaction; pre-select when sensible.

## See also

- [[input-checkbox]]
- [[input-switch]]
