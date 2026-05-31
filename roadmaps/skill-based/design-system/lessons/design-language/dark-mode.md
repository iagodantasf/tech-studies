---
title: Dark Mode
track: design-system
group: Design language
tags: [design-system, color]
prerequisites: [color, functional-colors]
see-also: [monochrome-version, accessibility, defining-design-tokens]
---

# Dark Mode

A second mapping of every color *role* onto a dark surface palette, switchable at runtime without touching component code.

## Why it matters

Dark mode is a stress test for whether your [[color]] system is actually semantic. If components reference `gray.900` directly, dark mode means rewriting every component; if they reference `color.text.default`, it means swapping one token set. Done right it's a theme; done wrong it's a fork. It also exposes accessibility gaps — naive inversion produces pure-white text on pure-black, which causes halation (smearing) for many readers and fails comfort even while passing contrast math.

## How it works

You do **not** invert hex values; you re-map semantic tokens to a dark ramp:

- **Surfaces lighten with elevation** — opposite of light mode. Base `#121212`, each raised layer slightly *lighter* (`#1E1E1E`, `#242424`) instead of using shadows, which barely show on dark.
- **Avoid the extremes** — text near `#E6E6E6` not `#FFFFFF`; background `#121212` not `#000000`, to cut halation.
- **Desaturate brand/functional hues** — saturated colors vibrate on dark; lower chroma and lighten so `danger` etc. stay legible.
- **Re-check contrast** — pairs that passed on light can fail on dark; both directions need ≥4.5:1 for body.

| Concern | Light | Dark |
|---|---|---|
| Base surface | `#FFFFFF` | `#121212` |
| Elevation cue | shadow | lighter surface |
| Body text | `#1A1A1A` | `#E6E6E6` |
| Brand fill | full chroma | desaturated |

Implement by toggling a token set (CSS `prefers-color-scheme` / a `data-theme` attribute) that rebinds the semantic layer from [[defining-design-tokens]].

## Example

Light: `color.text.default = gray.900` on `color.bg = white`. Dark: the *same role names* rebind → `gray.100` on `#121212`. A card "raised" in light via a shadow instead uses `surface.2 = #242424` in dark. Brand `indigo.600` (vivid) becomes `indigo.400` desaturated so a primary [[button]] doesn't glow. Components are unchanged — only the token map flips.

## Pitfalls

- **Pure black / pure white** — `#000`+`#FFF` maximizes halation; back off both ends.
- **Inverting hex literally** — flipping lightness wrecks brand hue relationships and saturation; remap intentionally.
- **Reusing light-mode shadows** — elevation must come from surface lightness, not shadows that vanish on dark.
- **Skipping re-contrast** — assuming light-mode passes carry over; many functional colors fail when the background flips.

## See also

- [[monochrome-version]]
- [[accessibility]]
