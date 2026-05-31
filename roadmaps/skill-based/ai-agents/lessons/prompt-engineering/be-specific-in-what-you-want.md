---
title: Be Specific in What You Want
track: ai-agents
group: Prompt Engineering
tags: [ai-agents, prompt-design]
prerequisites: [what-are-ai-agents]
see-also: [provide-additional-context, specify-length-format-etc]
---

# Be Specific in What You Want

Specificity is the practice of replacing vague intent with explicit task, audience, constraints, and success criteria so the model has nothing left to guess.

## Why it matters

An LLM fills ambiguity with the *most probable* completion, not the one you meant — "summarize this" yields a different length, tone, and focus on every call. In an agent loop, that variance compounds: a fuzzy [[reason-and-plan]] step picks the wrong tool, and the error propagates through every later [[acting-tool-invocation]]. Specific prompts cut retries, shrink output variance, and make failures reproducible instead of random.

## How it works

Pin down the dimensions the model would otherwise sample over:

| Dimension | Vague | Specific |
|---|---|---|
| Task verb | "look at this code" | "find the null-pointer bug" |
| Audience | "explain X" | "explain X to a junior dev" |
| Scope | "list issues" | "list the top 3 by severity" |
| Done-when | (none) | "stop after the function compiles" |

Three reliable techniques: **constrain the output** ("answer in one word: yes or no"), **assign a role** that biases vocabulary and rigor ("act as a security reviewer"), and **state negatives** explicitly ("do not include explanations"). Positive instructions beat negative ones — "respond only with JSON" steers better than "don't write prose," because the model has a target to hit rather than a region to avoid. This pairs with [[provide-additional-context]] (the facts) and [[specify-length-format-etc]] (the shape).

## Example

Tightening one prompt across three revisions:

```
v1: "Review this PR."
    → rambling prose, misses the actual bug

v2: "Review this PR for bugs."
    → finds bugs but also nitpicks style, no priority

v3: "You are a senior reviewer. List up to 3 correctness
     bugs in this diff, ordered by severity. For each: file,
     line, one-sentence fix. No style comments. No preamble."
    → 3 ranked, actionable items — parseable downstream
```

The v3 output is short enough to feed straight into the next agent step.

## Pitfalls

- **Compound asks in one sentence** — "fix and refactor and document" gives a shallow pass at each; split into ordered steps.
- **Negative-only instructions** — "don't be verbose" without a target length still drifts; state the positive constraint.
- **Over-constraining** — listing 20 rules can make the model rigidly satisfy the letter and miss the intent; keep constraints to what matters.
- **Specifying ungrounded facts** — being precise about data the model lacks invites confident hallucination; supply it via [[provide-additional-context]].

## See also

- [[provide-additional-context]]
- [[specify-length-format-etc]]
