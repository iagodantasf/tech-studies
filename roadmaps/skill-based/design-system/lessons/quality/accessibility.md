---
title: Accessibility
track: design-system
group: Quality
tags: [design-system, accessibility]
prerequisites: [component]
see-also: [accessibility-testing, color, functional-colors]
---

# Accessibility

Building components so that people using keyboards, screen readers, magnification, or reduced motion can complete every task — encoded once in the system so consumers inherit it for free.

## Why it matters

Accessibility is the single highest-leverage thing a design system does: fix a [[modal]]'s focus trap once and every product gets it, versus 40 teams each reinventing (and re-breaking) it. It's also a legal floor — WCAG 2.1 AA is the reference for the ADA, Section 508, and the EU EN 301 549 / European Accessibility Act (enforced June 2025). Roughly 15% of users have a disability, and far more hit the same edges temporarily (bright sun, a broken mouse, one-handed on a phone).

## How it works

WCAG is organized as **POUR** — Perceivable, Operable, Understandable, Robust. The system encodes the mechanical parts so consumers can't easily get them wrong:

- **Semantics over `div`** — a [[button]] renders `<button>`, not a clickable `<div>`; role, focusability, and Enter/Space come for free. Custom widgets need explicit ARIA `role` + state.
- **Keyboard-complete** — every interactive element reachable by Tab, operable by Enter/Space/Arrows, with a *visible* focus ring (the [[color]] ramp reserves a 3:1 token for it).
- **Contrast baked into tokens** — text pairs clear **4.5:1** (3:1 for large/UI); see [[functional-colors]]. The semantic layer is where you guarantee this, not per-screen.
- **Names and live regions** — icon-only controls carry `aria-label`; async updates announce via `aria-live`.

| WCAG criterion | Threshold | Where it lives |
|---|---|---|
| 1.4.3 Contrast (text) | 4.5:1 | Color tokens |
| 1.4.11 Non-text contrast | 3:1 | Focus ring, borders |
| 2.1.1 Keyboard | all functionality | Component behavior |
| 2.4.7 Focus visible | visible indicator | Focus styles |
| 2.5.5 Target size (AAA) | 44x44 px | Spacing tokens |

## Example

A custom [[dropdown]] (`role="listbox"`): button toggles `aria-expanded`, Arrow keys move `aria-activedescendant`, Enter selects, Esc closes and returns focus to the trigger. Selected option text is exposed as the button's accessible name. Shipped once, it replaces dozens of inaccessible bespoke selects — and it's the reference [[accessibility-testing]] runs against.

## Pitfalls

- **`div` with a click handler** — no role, not Tab-reachable, ignores Enter; the most common failure. Use the native element.
- **Removing `outline` for looks** — kills keyboard focus visibility (2.4.7). Restyle it, never delete it.
- **Color as the only signal** — a red border with no icon/text fails colorblind users (1.4.1).
- **Placeholder as label** — vanishes on input and often fails contrast; use a real `<label>`.

## See also

- [[accessibility-testing]]
- [[functional-colors]]
