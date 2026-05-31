---
title: Top-p / Top-k
track: ai-agents
group: Model Configuration / Tuning
tags: [ai-agents, sampling]
prerequisites: []
see-also: [temperature, frequency-penalty]
---

# Top-p / Top-k

Top-p (nucleus) and top-k are truncation samplers that restrict next-token choice to a shortlist of high-probability candidates before sampling, cutting off the unreliable tail of the distribution.

## Why it matters

Even a well-calibrated model assigns tiny probabilities to thousands of bad tokens; sampling from the full vocabulary occasionally picks one and derails generation. Truncation is the standard guard against that — it keeps outputs on-topic while still allowing variety, and it is usually a *better* diversity knob than raising [[temperature]] alone.

## How it works

Both operate on the sorted probability distribution after [[temperature]] scaling:

- **Top-k** — keep the `k` highest-probability tokens, renormalize, sample. Fixed-size shortlist.
- **Top-p (nucleus)** — keep the smallest set of tokens whose cumulative probability ≥ `p`, then sample. The shortlist size *adapts* to confidence.

| Param | Shortlist size | Behavior |
|---|---|---|
| top_k = 40 | Always 40 | Blunt; ignores how peaked the curve is |
| top_p = 0.9 | Varies | Few tokens when confident, many when uncertain |

Top-p is generally preferred because it adapts: on a confident token it might keep 2 candidates, on an ambiguous one 50. Many stacks apply both (`top_k` first as a hard cap, then `top_p`). Providers differ — OpenAI exposes only `top_p`; Anthropic and most open-weight runtimes ([[open-weight-models]]) expose both.

## Example

Sorted probs: `[0.5, 0.25, 0.13, 0.07, 0.03, 0.02]`.

```
top_k = 3  → keep [0.5, 0.25, 0.13]           → renormalize → sample
top_p = 0.9→ cumulative 0.5,0.75,0.88,0.95... → keep first 4 (crosses 0.9), drop tail
```

## Pitfalls

- **Tuning top_p *and* temperature together** — they interact non-obviously; the common advice is change one, hold the other at default (`temp=1` or `top_p=1`).
- **top_p = 1.0 disables it** — it keeps the entire vocabulary; if you wanted truncation you got none.
- **Aggressive top_k on agents** — a tiny `k` (e.g. 5) can starve valid-but-rare tokens like a specific function name, breaking [[llm-native-function-calling|tool calls]].

## See also

- [[temperature]]
- [[stopping-criteria]]
