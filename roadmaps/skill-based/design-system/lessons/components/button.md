---
title: Button
track: design-system
group: Components
tags: [design-system, components]
prerequisites: [defining-design-tokens, functional-colors]
see-also: [forms, icon, accessibility]
---

# Button

The primary action trigger — a labeled, interactive control with a fixed set of variants, sizes, and states, sourced entirely from tokens.

## Why it matters

The button is the most-placed, most-copied component in any product, so it's the canary for the whole system: if it hardcodes a blue, skips a focus ring, or lacks a loading state, that defect propagates everywhere. It also sets the hierarchy contract — exactly one primary action per view — that keeps interfaces decisive. Nailing the button proves the token pipeline and the state model work.

## How it works

Three axes: **variant** (visual weight / intent), **size**, **state**.

- **Variants** — `primary / secondary / tertiary(ghost) / danger`; intent colors from [[functional-colors]], not literals.
- **Sizes** — `sm / md / lg`, padding and type from [[defining-design-tokens]].
- **States** — default / hover / focus-visible / active / disabled / **loading**; loading shows a [[loading-indicator]] and blocks repeat clicks.
- **Semantics** — render a real `<button>` (or `<a>` if it navigates); never a clickable `<div>`.

| Variant | Weight | Use |
|---|---|---|
| Primary | Highest | The main action |
| Secondary | Medium | Alternative action |
| Ghost | Low | Tertiary / toolbar |
| Danger | High + red | Destructive action |

Hit target ≥ 44×44px for touch. An icon-only button **must** have an accessible name (`aria-label`). See [[accessibility]].

## Example

`<Button variant="primary" size="md" loading={saving}>Save</Button>`. It reads `color.action`, `space.3`, `radius.md` from tokens. On submit, `loading` swaps the label for a spinner and disables the click so a double-tap can't fire two requests. Focus shows a visible 2px ring. A sibling `variant="ghost"` "Cancel" sits beside it — only one primary in the view.

## Pitfalls

- **`<div>` buttons** — lose keyboard, focus, and role; use a real `<button>`. See [[accessibility]].
- **Two primaries in one view** — destroys hierarchy; demote one to secondary/ghost.
- **No loading guard** — double-clicks fire duplicate submits; disable while pending.
- **Removing the focus ring** — kills keyboard usability; restyle `:focus-visible`, don't delete it.

## See also

- [[forms]]
- [[icon]]
