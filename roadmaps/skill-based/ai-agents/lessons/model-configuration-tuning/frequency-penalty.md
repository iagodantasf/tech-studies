---
title: Frequency Penalty
track: ai-agents
group: Model Configuration / Tuning
tags: [ai-agents, sampling]
prerequisites: []
see-also: [presence-penalty, temperature]
---

# Frequency Penalty

Frequency penalty subtracts from a token's logit in proportion to how many times it has *already appeared* in the generated text, discouraging verbatim repetition that scales with overuse.

## Why it matters

LLMs are prone to repetition loops — the same phrase, list item, or sentence echoed until the output degrades. Frequency penalty is the targeted fix: the more a token recurs, the harder it is pushed down, so it self-corrects runaway loops without globally flattening the distribution the way high [[temperature]] would. It pairs with [[presence-penalty]], which is the *binary* "have I used this at all" sibling.

## How it works

For each candidate token, the logit is adjusted by a term that grows with its running count:

```
adjusted_logit = logit - (count_in_output × frequency_penalty)
```

- `count_in_output` is how many times that token already appeared in the completion.
- The penalty is **cumulative**: a token used 5 times is penalized 5× harder than one used once.
- Range is typically `-2.0 … 2.0`; `0` disables it. Negative values *encourage* repetition.

| frequency_penalty | Effect |
|---|---|
| 0.0 | No penalty (default) |
| 0.1–0.6 | Gently reduces repeated phrasing |
| 1.0–2.0 | Strongly varies vocabulary; can hurt coherence |

Contrast with [[presence-penalty]]: presence applies a *flat* one-time penalty the moment a token appears once, regardless of count, so it nudges topic breadth; frequency scales with count, so it fights *repetition intensity*. Counts reset every request — there is no memory across calls.

## Example

The token `great` has logit `3.0`, `frequency_penalty = 0.5`:

```
1st use: appeared 0× → 3.0 - 0×0.5 = 3.0   (freely available)
4th use: appeared 3× → 3.0 - 3×0.5 = 1.5   (much less likely)
6th use: appeared 5× → 3.0 - 5×0.5 = 0.5   (strongly suppressed)
```

## Pitfalls

- **Penalizes necessary tokens** — code keywords, a recurring entity name, or required JSON keys get suppressed too; high values can break [[llm-native-function-calling|structured output]].
- **Not a loop cure-all** — deterministic loops at low [[temperature]] may persist; combine with sampling changes.
- **Provider-specific** — OpenAI exposes it directly; Anthropic does not surface `frequency_penalty`, so don't assume portability.

## See also

- [[presence-penalty]]
- [[temperature]]
