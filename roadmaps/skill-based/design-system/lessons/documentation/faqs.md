---
title: FAQs
track: design-system
group: Documentation
tags: [design-system, documentation]
prerequisites: [documentation]
see-also: [contribution-guidelines, governance, communication-channel]
---

# FAQs

A curated page of the questions teams actually ask — adoption, contribution, theming, escape hatches — answered once so the design system team isn't the answer service for every team.

## Why it matters

A design system serving 30+ teams generates the same dozen questions on repeat: "how do I install it?", "my brand color isn't a token — now what?", "you don't have a date picker, can I build my own?". Each unanswered instance lands in Slack and costs a context switch for a maintainer; a good FAQ converts that recurring O(teams) support load into a single page read on demand. It's also where you publish the *uncomfortable* answers — the deliberate non-goals and escape-hatch policy — that you don't want buried in a thread.

## How it works

An FAQ is a maintained artifact, not a dumping ground. Treat it like a cache over your support channels:

- **Source from real traffic** — mine the [[communication-channel]] and issue tracker; if a question is asked three times, it earns an entry. Don't invent questions you wish people asked.
- **Answer, then link** — each entry is a 2-3 sentence direct answer plus a link to the canonical page; the FAQ routes, the deep page teaches.
- **Group by intent**, not alphabetically, so people scan to their situation.
- **Date and own entries** — a stale "we don't support dark mode" answer is worse than none once [[dark-mode]] ships.

| Cluster | Representative question | Routes to |
|---|---|---|
| Getting started | how do I install / import? | [[documentation]] on-ramp |
| Contribution | I need a component you lack | [[contribution-guidelines]] |
| Theming | my brand color isn't a token | [[defining-design-tokens]] |
| Scope / governance | why no date picker? | [[governance]] non-goals |
| Escape hatch | can I override a component? | override policy |

## Example

A high-traffic entry that prevents both a fork and a support thread:

```
Q: The component I need doesn't exist yet. What do I do?
A: First check the catalog and roadmap — it may be planned. If not,
   open a request (link). For an urgent gap, build it locally using
   our tokens and primitives, and tag #ds-help so we can fold it
   back in. Don't hardcode hex/px — that breaks theming.
   → contribution-guidelines · component-catalog
```

This one answer redirects a team away from an off-system one-off, points them at the request flow, and still unblocks them today.

## Pitfalls

- **Write-once, rot-forever** — an FAQ nobody prunes accumulates answers that contradict the current system; schedule a review each release.
- **FAQ as a docs substitute** — long tutorials crammed into "answers" belong on a real page the entry links to.
- **Aspirational questions** — entries for things no one asked add noise and bury the dozen that matter.
- **Hidden non-goals** — if the only place "we will never ship X" lives is a thread, teams keep asking; surface scope decisions from [[governance]] here.

## See also

- [[contribution-guidelines]]
- [[governance]]
