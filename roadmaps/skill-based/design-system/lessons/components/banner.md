---
title: Banner
track: design-system
group: Components
tags: [design-system, feedback]
prerequisites: [component, functional-colors]
see-also: [badge, modal, accessibility]
---

# Banner

A prominent, full-width message that communicates a system-level state — info, success, warning, error — usually pinned to the top of a region or page.

## Why it matters

Banners are the system's loud channel: maintenance notices, payment failures, "changes saved," consent prompts. They differ from a toast (transient, corner) and a [[modal]] (blocking) by being persistent and inline. Because they interrupt, the severity-to-color mapping and the dismiss behavior must be consistent, or every team invents a yellow box that means something different.

## How it works

A banner is severity + content + optional actions:

- **Severity** — `info / success / warning / error`, each mapped to [[functional-colors]] with a matching leading [[icon]] (color is never the only cue).
- **Content** — a short title, optional body, optional link/[[button]] actions.
- **Dismissal** — `dismissible` (user closes) vs `persistent` (stays until the condition clears).
- **Scope** — global (app-wide, top of viewport) vs contextual (top of a card/section).

| Severity | Token | Use |
|---|---|---|
| Info | color.info | Neutral notice |
| Success | color.success | Confirmed action |
| Warning | color.warning | Reversible risk |
| Error | color.danger | Failure, action needed |

Accessibility: announce dynamically-inserted banners via a live region (`role="status"` for info, `role="alert"` for errors) so screen readers hear them. See [[accessibility]].

## Example

A billing page renders a persistent error banner: red `color.danger`, an alert icon, "Your card was declined," and a "Update payment" [[button]]. It is non-dismissible because dismissing wouldn't fix the state. Inserted via JS, it carries `role="alert"` so it's announced immediately. Once a valid card is saved, the app swaps it for a dismissible success banner.

## Pitfalls

- **Banner blindness** — too many persistent banners and users stop seeing them; reserve for real state.
- **Dismissible critical errors** — letting users close a blocking failure hides an unresolved problem; keep it persistent.
- **No live region** — dynamically added banners are silent to screen readers. See [[accessibility]].
- **Color-only severity** — pair each color with an icon and text; don't rely on hue. See [[functional-colors]].

## See also

- [[badge]]
- [[modal]]
