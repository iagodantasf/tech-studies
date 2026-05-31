---
title: Carousel
track: design-system
group: Components
tags: [design-system, components]
prerequisites: [component]
see-also: [card, loading-indicator, accessibility]
---

# Carousel

A horizontally scrolling, paginated set of items — slides or [[card]]s — that shows a subset at a time with controls to advance.

## Why it matters

Carousels are requested constantly (hero banners, "related products," onboarding) and are one of the most accessibility- and UX-fraught components a system ships. They hide content behind interaction, auto-advance past readers, and trap keyboard users. A system either provides one *correct* carousel or watches every team build a broken one. Including it forces the team to encode the hard rules once.

## How it works

A carousel is a viewport over a track of items plus navigation:

- **Navigation** — prev/next [[button]]s, pagination dots, and native swipe/drag; all three should stay in sync.
- **Auto-play** — if used, pause on hover/focus and expose a visible pause control (WCAG requires a way to stop motion).
- **Looping** — infinite vs clamped at the ends; decide and signal disabled arrows at bounds.
- **Items per view** — responsive count tied to [[breakpoints]] (e.g. 1 mobile → 3 desktop).

| Control | Purpose | A11y note |
|---|---|---|
| Prev/Next | Step one item | Disable at clamp ends |
| Dots | Jump + position | Label "slide N of M" |
| Swipe | Touch advance | Mirror with keys |
| Pause | Stop auto-play | Mandatory if auto |

Accessibility: arrow-key navigation, a labeled region (`aria-roledescription="carousel"`), and never auto-advancing without a stop control. See [[accessibility]].

## Example

A product shelf shows 4 cards on desktop, 1.2 on mobile (the partial peek hints at more). Prev/Next [[button]]s plus dots labeled "3 of 9." No auto-play — the team chose manual after testing showed users couldn't read auto-advancing slides. Keyboard arrows move focus through items; swipe works on touch. Off-screen items are still in the DOM and focusable in order.

## Pitfalls

- **Auto-advance with no pause** — fails WCAG 2.2.2 and frustrates readers; always offer a stop.
- **Keyboard trap / no key support** — users can't navigate; wire arrow keys and a clear tab order.
- **Hiding primary content** — anything important behind a carousel is often missed; don't bury key info.
- **Layout shift on load** — reserve slide dimensions so the page doesn't jump. See [[loading-indicator]].

## See also

- [[card]]
- [[accessibility]]
