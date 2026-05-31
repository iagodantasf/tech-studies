---
title: Forgetting / Aging Strategies
track: ai-agents
group: Memory
tags: [ai-agents, long-term-memory]
prerequisites: [long-term-memory]
see-also: [summarization-compression, episodic-vs-semantic-memory]
---

# Forgetting / Aging Strategies

Forgetting is the deliberate eviction, decay, or merging of stored memories so an agent's [[long-term-memory]] stays small, current, and non-contradictory instead of growing without bound.

## Why it matters

Memory that only ever grows degrades retrieval: stale and duplicate entries dominate the top-k, contradictions surface together, and storage/latency creep up. A six-month-old "user is on the free plan" must not outrank today's "user upgraded to enterprise". Like a cache, a memory store needs an eviction and freshness policy — forgetting is a feature, not data loss.

## How it works

Score each memory by some mix of recency, frequency, and importance, then evict, decay, or consolidate the losers — the same instincts as cache eviction (LRU/LFU) plus relevance.

- **TTL / expiry.** Time-box volatile facts ("current task", session state); let them lapse automatically.
- **Recency decay.** Multiply the retrieval score by a decay term so old memories sink unless reinforced — `score = sim · e^(−λ·age)`.
- **LRU / LFU eviction.** Cap store size; drop least-recently or least-frequently retrieved memories first.
- **Consolidation/merge.** Collapse near-duplicates into one, and on contradiction keep the newest (or higher-confidence) and retire the rest — the [[episodic-vs-semantic-memory|consolidation]] step.
- **Importance pinning.** Mark some facts (name, allergies, hard constraints) exempt from aging.

| Strategy | Trigger | Acts on |
|---|---|---|
| TTL | wall-clock age | volatile facts |
| Recency decay | every retrieval | ranking score |
| LRU/LFU | store over cap | cold memories |
| Merge / supersede | new contradicts old | duplicates/conflicts |

## Example

Resolving a stale fact on update:

```
existing: {text:"user on FREE plan", ts:2025-11, hits:14}
new event: "I just upgraded to enterprise"  (2026-05)
  → extractor sees same slot (billing_plan), contradiction
  → supersede: mark old inactive, write
     {text:"user on ENTERPRISE plan", ts:2026-05}
query "what plan am I on?" → returns enterprise only
```

Without superseding, both plan facts would retrieve and the model would guess; aging makes the newest win.

## Pitfalls

- **Forgetting pinned facts.** Aging out allergies, names, or legal constraints is worse than a big store — exempt critical memories.
- **Decay too aggressive.** Over-tuned λ drops still-relevant context, recreating the amnesia you were fixing; tune on real recall.
- **Delete vs. supersede.** Hard-deleting loses audit trail and the ability to undo a wrong merge; prefer soft-retire with a tombstone.
- **No conflict detection.** Without slot/entity matching, contradictions coexist instead of one superseding the other.

## See also

- [[summarization-compression]]
- [[episodic-vs-semantic-memory]]
