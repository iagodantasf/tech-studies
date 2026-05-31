---
title: Card
track: design-system
group: Components
tags: [design-system, layout]
prerequisites: [component, grid]
see-also: [list, button, grid]
---

# Card

A surface that groups related content and actions into a single, self-contained, rectangular unit — media, text, and controls bounded by elevation or a border.

## Why it matters

Cards are the workhorse of dashboards, feeds, and catalogs: they chunk information into scannable units and tile cleanly into a [[grid]]. The risk is that "card" becomes a dumping ground — a flexible box that every team stuffs differently, so 12 screens show 12 inconsistent layouts. Defining a card's *anatomy* and slots turns a vague container into a predictable, composable surface.

## How it works

A card is a slotted container, not a fixed layout:

- **Anatomy** — optional *media*, *header* (title/subtitle), *body*, *actions* footer. Callers fill slots; the card owns padding and elevation.
- **Elevation vs outline** — a token-driven shadow *or* a 1px border denotes the surface; pick one system-wide.
- **Interactivity** — a whole-card link/click is fine, but a clickable card containing buttons creates nested targets — choose one.
- **Density** — padding from [[defining-design-tokens]]; sizing flows from the [[grid]], so cards reflow at [[breakpoints]].

| Slot | Holds | Optional? |
|---|---|---|
| Media | Image/illustration | Yes |
| Header | Title, subtitle | Often |
| Body | Primary content | No |
| Actions | [[button]]s, links | Yes |

Keep cards composable from existing parts ([[avatar]], [[badge]], [[button]]) rather than baking variants for every content type.

## Example

A product card: media slot = photo, header = name + price, body = a one-line description, actions = an "Add to cart" [[button]] and a wishlist [[icon]]. It uses `radius.md`, `space.4` padding, and `elevation.1`. In a [[grid]], 4 per row on desktop reflow to 1 per row under the `sm` [[breakpoints]] — the card itself is unaware, it just fills its column.

## Pitfalls

- **Card as a god-box** — unbounded freeform content yields inconsistent screens; define slots.
- **Nested click targets** — a clickable card *and* inner buttons confuse activation and screen readers; pick one.
- **Mixing elevation and borders** — choose one surface convention or surfaces look arbitrary.
- **Per-content variants** — a `ProductCard`, `UserCard`, `StatCard` explosion; compose one card from slots instead.

## See also

- [[list]]
- [[grid]]
