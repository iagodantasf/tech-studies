---
title: Design Principles
track: design-system
group: Design language
tags: [design-system, principles]
prerequisites: [design-language]
see-also: [creating-the-design-language, guidelines, governance]
---

# Design Principles

A short set of opinionated, prioritized statements that resolve design trade-offs — the tie-breakers a team reaches for when two good options conflict.

## Why it matters

Principles earn their keep at the moment of disagreement. "Should this dialog block the user or warn inline?" is unanswerable from taste alone, but trivial under *"Respect the user's flow over system convenience."* Without them, decisions get re-litigated per feature and the loudest voice wins, which is how a product loses coherence. Good principles are **prioritized**, so when two collide you know which yields — unranked principles just move the argument up a level. They also feed [[governance]]: contribution reviews cite principles, not opinions.

## How it works

A usable principle is specific, has a clear opposite, and implies an action:

- **Testable, not a platitude** — "Be simple" applies to everything and decides nothing. "Default to fewer options; reveal advanced settings progressively" is testable.
- **Prioritized** — order them so conflicts resolve top-down.
- **Tied to consequences** — each names what it sacrifices.

| Weak (platitude) | Strong (decides ties) |
|---|---|
| "Be consistent" | "Match platform conventions over brand expression" |
| "Delight users" | "Speed of task completion beats visual flourish" |
| "Be accessible" | "No information conveyed by color alone" |

Keep it to **3–5**. More than ~5 and nobody recalls them under deadline, so they stop functioning as tie-breakers. They sit above the [[design-language]] foundations and shape concrete rules in [[guidelines]] and [[microcopy-guidelines]].

## Example

A data-heavy analytics product adopts: (1) *Density before whitespace*, (2) *Show the data, chrome second*, (3) *Keyboard-first*. When a designer proposes large card padding for "breathing room," principle 1 outranks it — padding tightens. The principle did the deciding, not seniority. Contrast a consumer app whose principle 1 is the inverse; same question, opposite answer.

## Pitfalls

- **Generic values everyone agrees with** — "intuitive, beautiful, fast" decide nothing because nobody argues the opposite.
- **Too many** — a list of 12 is a wishlist, not a ranked decision tool.
- **Never invoked** — principles that don't appear in real design-review comments are decoration; cite them in [[contribution-guidelines]] reviews.
- **No priority order** — when "delight" and "speed" both apply, an unranked list just relocates the fight.

## See also

- [[creating-the-design-language]]
- [[guidelines]]
