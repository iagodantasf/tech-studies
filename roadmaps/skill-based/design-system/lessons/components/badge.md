---
title: Badge
track: design-system
group: Components
tags: [design-system, components]
prerequisites: [component, functional-colors]
see-also: [banner, avatar, functional-colors]
---

# Badge

A small, non-interactive label that annotates another element — a count, a status, or a category — typically a pill or a dot.

## Why it matters

Badges carry dense, glanceable signal: an unread count on a nav item, a "New" tag on a feature, a status pill in a table row. Because they encode meaning by color, they live or die on the [[functional-colors]] contract — a green/red badge that doesn't also carry text or shape fails colorblind users. One component keeps counts, dots, and status pills visually consistent instead of three home-grown variants.

## How it works

Distinguish three jobs, each a variant:

- **Count badge** — a number, often overlaid on an [[icon]] or [[avatar]]; clamp large values to `99+`.
- **Status badge** — text + semantic color from [[functional-colors]] (`success / warning / danger / info / neutral`).
- **Dot badge** — a colored dot signalling presence/unread with no number.

| Variant | Carries | Example |
|---|---|---|
| Count | Number | `12`, `99+` |
| Status | Word + color | Active, Failed |
| Dot | Presence only | unread indicator |

Rules: badges are **not** interactive (no click target — that's a chip or button). Color must never be the *only* signal; pair it with a label or icon shape. Size is fixed by token, not free-form.

## Example

An inbox icon shows a count badge clamped to `99+` when 412 messages are unread. A deploy table uses status badges: "Passed" on `color.success`, "Failed" on `color.danger`, each with the word visible — so the meaning survives a grayscale screenshot or a red-green colorblind viewer. A presence dot on an [[avatar]] uses the same success token, no number.

## Pitfalls

- **Color-only meaning** — green vs red dot with no text fails ~8% of male users; add a label or shape. See [[functional-colors]].
- **Making badges clickable** — if it has an action it's a chip/button; keep badges inert.
- **Unbounded counts** — `1247` blows the layout; clamp to `99+`.
- **Too many semantic colors** — five status hues dilute meaning; map to one [[functional-colors]] set.

## See also

- [[banner]]
- [[functional-colors]]
