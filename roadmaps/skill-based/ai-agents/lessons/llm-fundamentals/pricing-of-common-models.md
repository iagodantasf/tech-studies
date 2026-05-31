---
title: Pricing of Common Models
track: ai-agents
group: LLM Fundamentals
tags: [ai-agents, llm-cost]
prerequisites: []
see-also: [token-based-pricing, reasoning-vs-standard-models]
---

# Pricing of Common Models

A practical map of what the major LLM tiers cost per million tokens, and how to pick a tier so an agent isn't paying frontier rates for trivial steps.

## Why it matters

Across a model family, prices span ~100× from the cheapest small model to the top reasoning model — so *which* model runs each step dwarfs almost every other optimization. Agents make many calls per task, and most are easy (routing, formatting, a tool call). Matching tier to difficulty is the single biggest lever on the bill, ahead of prompt trimming. (See the meter mechanics in [[token-based-pricing]].)

## How it works

Vendors stratify a family into small / mid / large (frontier or reasoning) tiers. Output is the costly side, so reasoning models — which emit many hidden thinking tokens — are pricey even when the visible answer is short.

- Treat all numbers as **order-of-magnitude**; published rates change often, so verify against the vendor's live pricing page.
- **Default to a small/mid model**, escalate to a large or [[reasoning-vs-standard-models]] tier only on hard steps.
- Stack discounts: prompt caching, batch (~−50%), and shorter outputs apply on top of the per-token rate.

| Tier (typical) | ~Input $/1M | ~Output $/1M | Use in an agent |
|---|---|---|---|
| Small (Haiku, GPT-4o-mini, Flash) | $0.15–0.50 | $0.60–2 | routing, parsing, tool calls |
| Mid (Sonnet, GPT-4o) | $2.5–5 | $10–15 | main reasoning, drafting |
| Large/reasoning (Opus, o-series) | $10–20 | $40–75 | hard planning, math, code |

## Example

A task makes 6 calls; compare all-frontier vs tiered routing (rates above):

```
all on mid ($3/$15):   6 calls × ~$0.024  ≈ $0.14/task
tiered:
  4 easy calls → small (~$0.002 each)     ≈ $0.008
  2 hard calls → mid    (~$0.024 each)    ≈ $0.048
  total                                   ≈ $0.056/task  (~2.5× cheaper)
```

Push the 4 easy calls onto a small model and most of the spend evaporates while the hard reasoning still runs on the capable tier.

## Pitfalls

- **Hard-coding stale prices.** Rates and tiers shift monthly; read live pages and re-check before forecasting spend.
- **One model for everything.** Running an entire loop on a frontier/reasoning tier overpays 5–20× for steps a small model nails.
- **Comparing input rates only.** Output and hidden reasoning tokens drive cost; a "cheap input" reasoning model can be the most expensive overall.
- **Ignoring caching/batch in estimates.** Forecasting at list price overstates spend ~2× when a stable prefix or async batch applies.

## See also

- [[token-based-pricing]]
- [[reasoning-vs-standard-models]]
