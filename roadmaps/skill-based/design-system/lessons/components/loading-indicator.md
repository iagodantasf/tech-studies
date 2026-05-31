---
title: Loading Indicator
track: design-system
group: Components
tags: [design-system, feedback]
prerequisites: [component]
see-also: [button, list, accessibility]
---

# Loading Indicator

A visual signal that the system is busy — spinner, progress bar, or skeleton — telling the user to wait and roughly how long.

## Why it matters

Latency is inevitable; perceived latency is designable. The right indicator at the right threshold makes an app feel responsive, while the wrong one (a spinner that flashes for 80ms, or none for a 4-second load) makes it feel broken. The component standardizes *which* indicator to use, *when* to show it, and how it's announced to assistive tech — decisions every async surface otherwise improvises.

## How it works

Match the indicator to what's known about duration, and gate it on a delay:

- **Spinner / indeterminate** — unknown duration, short-ish waits (a [[button]] submit, a panel fetch).
- **Progress bar** — known/measurable progress (uploads, multi-step jobs); show percent.
- **Skeleton** — content placeholders mirroring final layout; best for whole views/[[list]]s, prevents layout shift.
- **Delay threshold** — only show after ~150–300ms so fast responses don't flash a spinner.

| Indicator | When | Signal |
|---|---|---|
| Spinner | Unknown, short | "working" |
| Progress bar | Known progress | percent |
| Skeleton | View/list load | shape preview |
| Inline (button) | Action pending | disable + spin |

Accessibility: convey busy state non-visually — `aria-busy`, a live region, or `role="progressbar"` with value — and respect `prefers-reduced-motion` for spinners.

## Example

A dashboard fetch: instead of a centered spinner, the cards render as **skeletons** matching their real layout, so when data arrives nothing jumps. A submit [[button]] uses the inline pattern — label swaps to a spinner and the control disables, blocking double-submit. A file upload shows a determinate progress bar with "63%." A 90ms refetch shows nothing because it resolved before the 200ms threshold.

## Pitfalls

- **Spinner flash** — showing then instantly hiding for sub-200ms loads looks janky; gate on a delay.
- **Layout shift on resolve** — spinners that get replaced by taller content jump the page; prefer skeletons that reserve space.
- **Silent to screen readers** — a purely visual spinner leaves AT users guessing; use `aria-busy`/live regions. See [[accessibility]].
- **Indeterminate where progress is known** — a spinner for a measurable upload hides useful info; use a bar.

## See also

- [[button]]
- [[list]]
