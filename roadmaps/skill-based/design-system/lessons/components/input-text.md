---
title: Input — Text
track: design-system
group: Components
tags: [design-system, forms]
prerequisites: [component]
see-also: [forms, input-checkbox, accessibility]
---

# Input — Text

A single-line text field — the most common form control — with label, states, validation hooks, and optional affordances like prefixes or clear buttons.

## Why it matters

Text inputs are everywhere a form is, so their states and accessibility set the baseline for the whole [[forms]] experience. The visible part is trivial; the value is in the states (focus, error, disabled, read-only), the label wiring, and the keyboard/mobile behavior (correct `type` and `inputmode` so phones show the right keyboard). One solid input prevents a swarm of bespoke `<input>`s with missing focus rings and orphaned labels.

## How it works

An input is a labeled control with a state machine and semantic typing:

- **Always-visible label** linked by `for`/`id`; help text and errors linked via `aria-describedby`.
- **States** — default / focus-visible / filled / error / disabled / read-only, each token-driven.
- **Type & inputmode** — `email`, `tel`, `url`, numeric `inputmode` so mobile keyboards and validation match the data.
- **Affordances** — optional leading [[icon]]/prefix, trailing clear or reveal button, character counter.

| State | Signal | Token |
|---|---|---|
| Focus | Visible ring | color.focus |
| Error | Border + message + icon | color.danger |
| Disabled | Dimmed, not focusable | color.disabled |
| Read-only | Selectable, not editable | neutral |

Distinguish **disabled** (not submitted, not focusable) from **read-only** (submitted, selectable) — they are different semantics, not styles.

## Example

An email field: `<label>` "Email", `<input type="email" inputmode="email">`. On a phone it shows the email keyboard (with `@`). The user blurs an invalid value; the border turns `color.danger`, an alert [[icon]] and "Enter a valid email" appear, and `aria-describedby` points the screen reader at that message. Focus always shows a 2px ring. A read-only confirmation reuses the same input with `readonly`, keeping the value copyable.

## Pitfalls

- **Placeholder as the only label** — disappears on input and breaks screen readers; keep a real label. See [[accessibility]].
- **Wrong `type`/`inputmode`** — `type=text` for a phone number shows the wrong mobile keyboard and skips validation.
- **Disabled vs read-only confusion** — disabled drops the value from submission; choose deliberately.
- **Invisible focus** — never remove the ring; restyle `:focus-visible`.

## See also

- [[forms]]
- [[input-checkbox]]
