---
title: Making It from Existing Design
track: design-system
group: Approach
tags: [design-system, extraction]
prerequisites: [making-a-design-system]
see-also: [existing-design-analysis, performing-a-visual-audit, making-it-from-scratch]
---

# Making It from Existing Design

Extracting a design system *out of* a product that already ships — inventory the live UI, converge its variants, then codify the survivors as tokens and components.

## Why it matters

Most real systems are born this way: the product exists, customers use it, and you cannot pause feature work to rebuild. The job is **convergence under constraint** — find the unintended variation (every product has it), pick winners, and migrate without a big-bang rewrite. Done well, the first quarter produces visible consistency wins that buy political capital; done badly, you cement the existing mess into "official" tokens.

## How it works

A bottom-up loop, the mirror image of [[making-it-from-scratch]]:

1. **Inventory** via an [[existing-design-analysis]] and a [[performing-a-visual-audit]] — screenshot every screen, extract every color/size/spacing actually rendered.
2. **Cluster and converge** — collapse near-duplicates to a canonical value:

| Found in product | Converged to |
|---|---|
| 11 greys (#333…#3a3a3a…) | 6-step neutral ramp |
| 14 button styles | 1 button, 5 variants |
| 6 corner radii (3-10px) | 3 (`sm/md/lg`) |
| 5 shadows | 2 elevation tokens |

3. **Codify** the survivors as primitive → semantic [[defining-design-tokens|tokens]], so the audit becomes a single source of truth.
4. **Migrate incrementally** — adopt token-by-token behind the existing markup; replace whole components later. The strangler pattern, not a rewrite.

The key artifact is a **decision log**: for every collapsed variant, record what won and why, so "why isn't *my* shade supported" has an answer.

## Example

A 6-year SaaS app: audit surfaces 23 distinct background colors and 9 font sizes. Convergence yields 8 semantic surface tokens and a 6-step type scale; ~70% of found values map cleanly, the other 30% are flagged as intentional exceptions or bugs. Rollout swaps CSS values to the new tokens first (zero visual change where they already matched), then ships canonical components team-by-team — measured as variants eliminated per release.

## Pitfalls

- **Paving the cow paths** — codifying all existing variants instead of converging them produces a "system" with 11 official greys. Reduce *first*.
- **Big-bang rewrite** — pausing features to rebuild from scratch almost always overruns and gets cancelled. Strangle, don't replace.
- **No exception channel** — convergence creates legitimate edge cases; without a path to request one, teams fork and the system loses authority.
- **Audit goes stale** — the product keeps shipping during extraction; re-audit changed areas or you converge against last quarter's UI.

## See also

- [[existing-design-analysis]]
- [[performing-a-visual-audit]]
- [[making-it-from-scratch]]
