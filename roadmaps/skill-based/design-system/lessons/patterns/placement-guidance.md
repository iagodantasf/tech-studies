---
title: Placement Guidance
track: design-system
group: Patterns
tags: [design-system, guidelines]
prerequisites: [component]
see-also: [pattern, guidelines, documentation]
---

# Placement Guidance

The "when and where to use it" half of a component or pattern page — the usage rules that sit opposite the API and anatomy, telling a consumer whether to reach for this part at all.

## How it works

The API documents *how to call* a [[component]]; placement guidance documents *whether you should*. A page that ships only props leaves the hardest question — "is this the right control here?" — to taste, and consumers guess wrong. This is where a design system stops being a parts bin and starts encoding judgment: which control for which job, the cheaper alternative to prefer, and the contexts where this part is simply wrong. Without it, [[dropdown]] gets used for 3-option choices that should be [[input-radio]], and every screen drifts.

## Why it matters

Good guidance is **paired and decisive**: do *this*, not *that*, with the boundary stated.

- **Use-when / don't-use-when** — both halves; the negative is the load-bearing one.
- **Alternatives named** — point to the better control for the rejected case, not a dead end.
- **Thresholds, not vibes** — "use a [[dropdown]] above ~7 options; below, prefer [[input-radio]]".
- **Placement and density** — where on the page, one-per-view vs. many, spacing from neighbors.

| Control | Use when | Prefer instead when |
|---|---|---|
| [[dropdown]] | 7+ options, space-constrained | <=6 visible options |
| [[input-radio]] | 2–6 mutually exclusive, all worth showing | many options |
| [[input-switch]] | instant binary toggle, no Save | needs explicit submit |
| [[modal]] | must interrupt for one decision | non-blocking info |

Pair every "do" image with a "don't"; a single happy-path screenshot teaches nothing about boundaries.

## Example

**Primary [[button]] per view.** Guidance: at most one `primary` button visible at a time — it marks *the* expected action. Two primaries on a form ("Save" and "Publish") create a tie the user must break; demote one to `secondary`. Don't-use-when: destructive actions never take `primary`; route them through the confirm [[pattern]] with a `danger` style. This rule alone resolves the most common review comment on submitted forms.

## Pitfalls

- **Only the happy path** — documenting use-when without don't-use-when is half a page; the negatives prevent misuse.
- **Vibes over thresholds** — "use when there are many options" invites argument; give a number.
- **Dead-end "don't"** — saying *not* to use X without naming the right alternative just blocks the consumer.
- **Guidance divorced from the part** — placement rules belong on the component's own page in [[documentation]], not a separate forgotten wiki.

## See also

- [[pattern]]
- [[guidelines]]
