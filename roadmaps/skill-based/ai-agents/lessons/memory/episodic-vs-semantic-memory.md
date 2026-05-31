---
title: Episodic vs Semantic Memory
track: ai-agents
group: Memory
tags: [ai-agents, long-term-memory]
prerequisites: [long-term-memory]
see-also: [rag-and-vector-databases, forgetting-aging-strategies]
---

# Episodic vs Semantic Memory

Two complementary kinds of [[long-term-memory]]: episodic memory stores *specific past events* ("on May 3 the user asked to deploy to staging"), while semantic memory stores *distilled facts* ("the user deploys to staging, not prod").

## Why it matters

Conflating them produces a bad agent. If you only keep episodes, every recall drags in timestamps and noise and the model must re-derive facts each turn; if you only keep facts, you lose the ability to answer "what did we decide last Tuesday?" or to learn from a specific failure. Borrowed from cognitive science (Tulving), the split lets an agent both *recall what happened* and *know what's true*.

## How it works

Episodes are append-only records of interactions; semantic memories are facts *consolidated* from many episodes, usually by an LLM extractor run async.

- **Episodic.** Timestamped, event-shaped, immutable. "User U12 reported login bug at 14:02; agent escalated to tier-2." Good for audit, recency, and few-shot "here's how a similar case went".
- **Semantic.** Generalized, deduplicated, mutable. "U12 is on the enterprise plan." Good for grounding every response.
- **Consolidation.** A background job reads recent episodes and writes/updates semantic facts — the agent's version of sleep turning experience into knowledge.
- **Retrieval mix.** Ground with semantic facts (always), augment with the top-k *similar episodes* when the task is case-based.

| Axis | Episodic | Semantic |
|---|---|---|
| Unit | an event | a fact |
| Time | timestamped | timeless |
| Mutability | immutable log | updated/merged |
| Recall cue | recency + similarity | similarity |

## Example

A personal assistant after several chats:

```
EPISODES (raw):
  2026-05-03  "book me a flight to Lisbon, window seat"
  2026-05-20  "the Lisbon trip got cancelled"
SEMANTIC (consolidated):
  prefers: window seat        (still true)
  travel:  Lisbon trip        (marked cancelled, not deleted)

query "any upcoming trips?" → semantic says none active
query "what seat do I like?" → semantic: window
```

The window-seat preference generalizes; the trip stays as a dated episode but its semantic status is updated to cancelled.

## Pitfalls

- **Episodes as facts.** Treating one event as a standing truth ("asked about refunds once" → "wants refunds") over-generalizes; consolidate across multiple episodes.
- **Never consolidating.** A pile of raw episodes with no semantic layer makes the agent slow and noisy at grounding.
- **Stale semantics.** Facts derived from old episodes go wrong when reality changes; re-consolidate and age out (see [[forgetting-aging-strategies]]).
- **No provenance.** Semantic facts with no link back to source episodes can't be audited or corrected when disputed.

## See also

- [[rag-and-vector-databases]]
- [[forgetting-aging-strategies]]
