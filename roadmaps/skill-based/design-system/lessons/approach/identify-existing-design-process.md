---
title: Identify Existing Design Process
track: design-system
group: Approach
tags: [design-system, process]
prerequisites: [existing-design-analysis]
see-also: [performing-a-visual-audit, governance, contribution-guidelines]
---

# Identify Existing Design Process

Mapping *how* UI decisions get made today — who designs, who reviews, what tools and handoffs exist — so the new system plugs into reality instead of fighting it.

## Why it matters

A design system is adopted by people inside an existing workflow; if you don't know that workflow, you'll build a system that nobody's process has room for. The [[existing-design-analysis]] tells you what the UI *is*; this tells you why it became that way — usually "no shared source, three designers, copy-paste handoff." Naming the process gaps is how you predict where consistency will keep leaking after launch, and it directly shapes [[governance]] and [[contribution-guidelines]].

## How it works

Interview and observe, then map the current pipeline from idea to shipped pixel:

- **Roles** — who actually decides color/spacing? A lead, every designer, or engineers at code time? Diffuse authority is the root cause of variant sprawl.
- **Tools & source of truth** — Figma, Sketch, or "in the code." Is there *one* file, or per-feature files that diverge?
- **Handoff** — how does a design reach an engineer: redlines, inspect panel, or guesswork? Where is intent lost?
- **Review** — is there a design/UI review gate, or does anything mergeable ship?

| Maturity signal | Immature | Mature |
|---|---|---|
| Source of truth | per-designer files | one shared library |
| New UI value | invented per feature | reuses a token |
| Review gate | none / ad hoc | design + a11y check |
| Handoff | screenshots | linked component specs |

The output is a **current-state process map** plus a short list of gaps, each tied to a future [[governance]] mechanism (e.g. "no review gate → add a UI review step").

## Example

Discovery at one company: 3 designers, no shared Figma library, handoff via exported PNGs, no UI review on PRs. That fully explains the 14 button variants — each feature reinvented one. The fix list writes itself: one component library, an inspect-based handoff, and a lightweight PR check that new colors come from tokens. Adopting the system *without* these would let drift regenerate within months.

## Pitfalls

- **Auditing pixels, not process** — fixing the output while leaving the broken workflow means the variants grow back.
- **Assuming a process exists** — small teams often have none; "informal" is the finding, not a failure to find one.
- **Skipping engineers** — much UI is decided at code time, not in design tools; interview both sides of the handoff.
- **Mapping without acting** — a process diagram that doesn't feed concrete [[governance]] changes is decoration.

## See also

- [[performing-a-visual-audit]]
- [[governance]]
- [[contribution-guidelines]]
