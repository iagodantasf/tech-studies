---
title: Accessibility Testing
track: design-system
group: Quality
tags: [design-system, accessibility]
prerequisites: [accessibility]
see-also: [component, documentation, logging]
---

# Accessibility Testing

The layered checks — automated, keyboard, screen-reader, and assistive-tech — that verify a component actually meets the [[accessibility]] bar instead of merely claiming to.

## Why it matters

A claim of "accessible" decays the moment someone refactors markup. Automated tooling catches real defects but reaches only **~30–40%** of WCAG criteria (per Deque/axe): contrast, missing labels, ARIA misuse. The other 60% — does focus order make sense, is the live region announced, can you actually *complete* the flow — is only catchable by a human at the keyboard or in a screen reader. In a design system, testing the source components gates the defect for every consumer at once.

## How it works

Stack the cheap, broad checks under the expensive, deep ones:

| Layer | Tool / method | Catches | Cost |
|---|---|---|---|
| Lint | eslint-plugin-jsx-a11y | static markup smells | ~free |
| Unit / CI | axe-core, jest-axe | contrast, roles, names | seconds |
| Visual | Storybook a11y addon | per-state violations | low |
| Keyboard | manual Tab-through | focus order, traps | minutes |
| Screen reader | NVDA, JAWS, VoiceOver | announcements, names | hours |

- **Gate the pipeline** — `axe` runs against every component story in CI; a new violation fails the build, so regressions never merge.
- **Keyboard pass** — Tab through, confirm visible focus, operate with Enter/Space/Arrows, Esc dismisses, focus returns. No mouse.
- **Real AT, real combos** — test NVDA+Firefox and VoiceOver+Safari; bugs are pairing-specific.
- **Don't trust the score** — "0 axe violations" is a floor, never a pass. Pair it with the manual sweep.

## Example

A [[modal]]'s CI story asserts `expect(await axe(node)).toHaveNoViolations()` — green. But the keyboard pass reveals focus isn't trapped: Tab escapes to the page behind. Axe can't see that; a tester does in 20 seconds. Fix the trap, add a regression test that asserts focus stays within the dialog, and feed the miss back into [[component]] review.

## Pitfalls

- **Score as certification** — green axe ≠ accessible; it never covers focus order or whether the task is doable.
- **Testing the demo, not the states** — error, loading, and disabled states often break; test each via stories.
- **Chrome-only screen-reader checks** — JAWS/NVDA/VoiceOver differ; one engine hides the others' bugs.
- **No regression test after a fix** — the next refactor silently reintroduces it; encode every fix as a test.

## See also

- [[accessibility]]
- [[component]]
