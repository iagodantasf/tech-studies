---
title: Design Language
track: design-system
group: Design language
tags: [design-system, foundations]
prerequisites: [creating-the-design-language]
see-also: [design-principles, defining-design-tokens, component]
---

# Design Language

The shared vocabulary of visual and interaction decisions — color, type, space, shape, motion, and voice — that makes independently built screens read as one coherent product.

## Why it matters

It is the *why* behind every token and component. Two teams can both use a `Button` component yet ship incoherent UI if one thinks "bold and dense" and the other "calm and airy" — the language is what aligns them before code. It is also the asset that survives reimplementation: you can migrate React → SwiftUI and keep the same language. A system without an articulated language is just a parts bin; the language is the grammar that says how parts combine.

## How it works

The language is a set of foundations, each a constrained, named scale rather than free choice:

- **[[color]]** — hue ramps plus semantic [[functional-colors]] (success/danger/warning).
- **Typography** — families, a modular type scale, weights, line-height rules.
- **Spacing** — one base unit (4/8px) and a closed step scale.
- **[[grid]]** — columns, gutters, and [[breakpoints]] that govern layout.
- **Shape & elevation** — radius scale, shadow/elevation levels.
- **Motion** — duration and easing tokens.
- **Voice & tone** — content rules; see [[microcopy-guidelines]].

These get frozen as [[defining-design-tokens]], which is what makes the language *enforceable* in code. The language sits above tokens (it's the intent) and above [[component]]s (which consume it). [[design-principles]] sit one level higher and resolve conflicts between foundations.

| Term | Scope |
|---|---|
| Principles | Decision rules |
| Design language | The vocabulary itself |
| Tokens | The language encoded as values |
| Components | The vocabulary applied |

## Example

Stripe, Material, and Polaris each ship a distinct language: Material leans on elevation + bold color; Polaris on dense, neutral, data-first surfaces. Same component *names* (button, card, modal), entirely different feel — because the underlying ramps, spacing density, and motion differ. See [[design-system-examples]].

## Pitfalls

- **Conflating language with components** — swapping `Button` styles doesn't change a language built on the wrong spacing density.
- **Undocumented language** — if it lives only in senior designers' heads, new hires guess and the language fragments.
- **Language without enforcement** — not encoded as tokens, it's advisory; engineers hardcode and it rots.

## See also

- [[design-principles]]
- [[defining-design-tokens]]
