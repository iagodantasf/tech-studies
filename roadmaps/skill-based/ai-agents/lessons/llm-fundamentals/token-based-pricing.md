---
title: Token-based Pricing
track: ai-agents
group: LLM Fundamentals
tags: [ai-agents, llm-cost]
prerequisites: []
see-also: [pricing-of-common-models, context-windows]
---

# Token-based Pricing

LLM APIs bill per token, not per request, and almost always charge **output** tokens several times more than **input** — so cost scales with how much text flows through the agent.

## Why it matters

An agent loop re-sends its growing history every turn, so naive cost grows quadratically with conversation length even if each new message is small. Output is the expensive half, which is why verbose or reasoning-heavy responses dominate the bill. Understanding the meter is what lets you cut spend 5–10× with caching, routing, and budget control rather than just hoping.

## How it works

Cost per call ≈ `input_tokens × in_rate + output_tokens × out_rate`, quoted per 1M tokens. Output typically costs 3–5× input.

- **Re-billed context.** Turn N pays for all prior turns again as input; a 20-turn chat can spend more on resent history than on new content.
- **Prompt caching** discounts repeated prefixes (system prompt, tools, few-shot) by ~50–90% on a cache hit — order stable content first.
- **Batch APIs** offer ~50% off for async, non-urgent jobs (evals, backfills).
- **Reasoning tokens count.** Hidden thinking is billed as output; an o-series step can cost far more than its visible reply.

| Lever | Effect on cost |
|---|---|
| Cap `max_tokens` | bounds the pricey output side |
| Prompt caching | −50–90% on repeated prefix |
| Cheaper model for easy steps | often −5–10× |
| Summarize old turns | shrinks re-billed input |
| Batch endpoint | ~−50% (async) |

## Example

Per-call math at $3 / $15 per 1M (in/out):

```
input  4,000 tok × $3 /1M  = $0.012
output   800 tok × $15/1M  = $0.012
per call ≈ $0.024
agent does 6 LLM calls/task → ~$0.14/task → ~$14 per 100 tasks
```

Add prompt caching on a 3K-token static prefix (90% off) and route 3 of 6 calls to a cheap model: same task drops to roughly $0.04 — a ~3–4× cut with no quality loss on the easy steps.

## Pitfalls

- **Ignoring re-billed history.** Long loops blow the budget on resent context; cap turns and summarize (see [[context-windows]]).
- **Optimizing input, ignoring output.** Output is the costly side — trimming a verbose prompt saves little if replies stay long; cap `max_tokens`.
- **Cache-busting prefixes.** A timestamp or per-user token at the *start* of the prompt voids the cache; put volatile content last.
- **No per-user/run budget cap.** A runaway agent can loop and spend thousands; enforce hard token and call ceilings.

## See also

- [[pricing-of-common-models]]
- [[context-windows]]
