---
title: Presence Penalty
track: ai-agents
group: Model Configuration / Tuning
tags: [ai-agents, sampling]
prerequisites: []
see-also: [frequency-penalty, temperature]
---

# Presence Penalty

Presence penalty subtracts a flat, one-time amount from a token's logit as soon as it has appeared *at all* in the output, nudging the model toward new tokens and broader topics.

## Why it matters

Where [[frequency-penalty]] fights *how often* something repeats, presence penalty fights *whether the model keeps circling the same ground*. It encourages the model to introduce fresh vocabulary and explore new subtopics — handy for brainstorming, varied [[npc-game-ai|NPC dialogue]], or stopping an answer from re-stating the same point in new words. The penalty is binary in trigger: used once or used ten times, the deduction is identical.

## How it works

Every token that has appeared one or more times gets the same fixed deduction:

```
adjusted_logit = logit - (1 if token_seen else 0) × presence_penalty
```

- The multiplier is a step function: `0` if the token is unseen, `1` if it has appeared *any* number of times.
- Range is typically `-2.0 … 2.0`; `0` disables it; negative values *reward* reusing seen tokens.

| | Trigger | Scales with count? | Best for |
|---|---|---|---|
| presence_penalty | First appearance | No (flat) | Topic / vocabulary breadth |
| frequency_penalty | Each appearance | Yes (cumulative) | Suppressing repetition intensity |

The two are independent and stack additively; OpenAI recommends nudging one at a time in small steps (~0.1–0.5). Like [[frequency-penalty]], the "seen" set is per-request only.

## Example

Token `ocean`, logit `2.5`, `presence_penalty = 0.8`:

```
before any use: seen=0 → 2.5 - 0×0.8 = 2.5
after 1st use:  seen=1 → 2.5 - 1×0.8 = 1.7
after 5th use:  seen=1 → 2.5 - 1×0.8 = 1.7   (same as after 1st — flat)
```

## Pitfalls

- **Drifts off-topic** — push it too high and the model abandons the subject to chase novelty, hurting focused tasks.
- **Confused with frequency penalty** — they sound alike but have different math; use frequency for repetition loops, presence for breadth.
- **Portability** — exposed by OpenAI; not a standard Anthropic parameter, so cross-provider [[agent-loop|agent]] code shouldn't depend on it.

## See also

- [[frequency-penalty]]
- [[temperature]]
