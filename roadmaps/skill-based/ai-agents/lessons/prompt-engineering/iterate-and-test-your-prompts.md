---
title: Iterate and Test Your Prompts
track: ai-agents
group: Prompt Engineering
tags: [ai-agents, prompt-evaluation]
prerequisites: [be-specific-in-what-you-want]
see-also: [metrics-to-track, temperature]
---

# Iterate and Test Your Prompts

Prompt iteration is treating a prompt as code under test: version it, run it against a fixed example set, measure outcomes, and change one thing at a time.

## Why it matters

A prompt that "looks good" on one input fails silently on the next — and unlike code, an LLM's behavior shifts with [[temperature]], model versions, and phrasing you'd think were equivalent. Without a test set you optimize for vibes and ship regressions; a tweak that fixes case A quietly breaks case B. Treating prompts as evaluable artifacts is what separates a demo from a production agent, and it feeds the same [[metrics-to-track]] you watch in the live system.

## How it works

Build a tight feedback loop around a frozen evaluation set:

| Step | Action |
|---|---|
| 1. Dataset | 10-50 inputs with expected outputs / pass criteria |
| 2. Baseline | Run current prompt, record score + failures |
| 3. One change | Edit a single variable (wording, example, order) |
| 4. Compare | Re-run *the whole set*, not just the failing case |
| 5. Keep/revert | Accept only if aggregate score rises |

Pin [[temperature]] to 0 while iterating so output is near-deterministic and a score change is attributable to your edit, not sampling noise. **Grade automatically** where possible: exact-match or regex for structured output, a code assertion for "is valid JSON," or an **LLM-as-judge** for open-ended quality (a second model scores the answer against a rubric). Keep prompts in version control with the eval results, so a regression shows up as a failing run on a diff — the same discipline as [[unit-testing|unit tests]] for flows.

## Example

A/B-testing one change on a 20-case extraction set:

```
v4  "Extract the date."                    → 14/20 pass
       failures: relative dates ("next Fri") missed

v5  "Extract the date as YYYY-MM-DD.
     Resolve relative dates from {today}."  → 19/20 pass
       remaining failure: ambiguous "5/6" (locale)

v6  "...assume DD/MM/YYYY for slashes."     → 20/20  ✓ adopt
```

Each step changed one instruction and was scored on all 20 inputs — so the gain is real, not a lucky single example.

## Pitfalls

- **Testing on the example you just fixed** — re-run the full set; local fixes routinely regress other cases.
- **Iterating at temperature > 0** — sampling noise masquerades as improvement; pin it to 0 until you compare candidates.
- **No held-out set** — tuning on the same inputs you grade overfits the prompt to them; reserve unseen cases.
- **Changing two things at once** — when the score moves you can't tell which edit did it; vary one variable per run.

## See also

- [[metrics-to-track]]
- [[temperature]]
