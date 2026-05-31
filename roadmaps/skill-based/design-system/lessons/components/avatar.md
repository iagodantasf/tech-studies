---
title: Avatar
track: design-system
group: Components
tags: [design-system, components]
prerequisites: [component]
see-also: [badge, icon, accessibility]
---

# Avatar

A small graphic that represents a user or entity — a photo, initials, or icon fallback — usually circular, in a fixed set of sizes.

## Why it matters

Avatars appear in nav bars, comment threads, member lists, and chat at high density, so a single robust component prevents dozens of one-off `<img>` tags with broken fallbacks and inconsistent sizes. The hard part isn't the circle; it's graceful degradation (image fails, no photo, long name) and stacking many without layout thrash. Get it right once and every surface looks coherent.

## How it works

An avatar resolves a *source chain* and renders at a token-defined size:

- **Fallback chain** — image → initials → generic [[icon]]. Never a blank box.
- **Initials** — derive from name; cap at 2 chars; pick a deterministic background from a token ramp so the same user is always the same color.
- **Sizes** — discrete scale (`xs/sm/md/lg/xl`), each a token; never arbitrary px.
- **Shape & status** — circle by default; optional presence dot or [[badge]] overlay.

| Prop | Values | Note |
|---|---|---|
| size | xs–xl | Token-mapped |
| src | url | Falls back on error |
| name | string | Drives initials + alt |
| status | online/away/offline | Optional dot |

Stacking: render an avatar **group** with negative margin overlap and a `+N` overflow chip; cap the visible count (commonly 3–5).

## Example

`<Avatar size="md" name="Ada Lovelace" src="…" />` renders a 40px circle. The image 404s, so it shows "AL" on a background hashed from the name (deterministic, not random). `alt="Ada Lovelace"` is set for screen readers. A group of 8 reviewers shows 4 overlapped avatars plus a `+4` chip.

## Pitfalls

- **Blank box on image failure** — always fall through to initials or [[icon]]; handle `onError`.
- **Random fallback color per render** — flickers and looks broken; hash from a stable key.
- **Decorative but unlabeled** — set meaningful `alt`, or `alt=""` if purely decorative beside the name. See [[accessibility]].
- **Distorted photos** — non-square images squash; use `object-fit: cover`.

## See also

- [[badge]]
- [[icon]]
