---
title: Long-term Memory
track: ai-agents
group: Memory
tags: [ai-agents, long-term-memory]
prerequisites: [short-term-memory, embeddings-and-vector-search]
see-also: [rag-and-vector-databases, episodic-vs-semantic-memory]
---

# Long-term Memory

Long-term memory is the agent's durable store that survives across sessions — facts, preferences, and past events kept in an external database and retrieved back into context only when relevant.

## Why it matters

[[short-term-memory|Short-term memory]] dies when the session ends and is capped by the [[context-windows|window]]; long-term memory is how an assistant remembers your name, your stack, and a decision made three weeks ago. It decouples *total* knowledge (unbounded, on disk) from *active* knowledge (the small slice retrieved per turn), so the agent can "know" gigabytes while only ever paying for a few thousand tokens of context.

## How it works

The pattern is **write on the way out, retrieve on the way in**: extract durable facts from a session, persist them, and pull the top-k relevant ones into the next prompt.

- **Storage backends.** A [[rag-and-vector-databases|vector DB]] for fuzzy semantic recall; a key-value/SQL store for exact lookups (user settings); a knowledge graph for linked entities.
- **Write path.** Summarize or run an LLM "extractor" over the transcript → emit atomic memories (`user prefers dark mode`) → embed + upsert with metadata (timestamp, source, user_id).
- **Read path.** Embed the current query → ANN search → inject top-k memories as a pinned block in the system prompt.
- **Dedup + update.** New memories that near-duplicate or contradict old ones should merge/overwrite, not pile up (see [[forgetting-aging-strategies]]).

| Memory kind | Backend | Retrieval |
|---|---|---|
| Semantic facts | vector DB | similarity top-k |
| Exact prefs / state | key-value / SQL | direct lookup by key |
| Linked entities | graph DB | traversal |

## Example

A coding assistant across two sessions:

```
session 1: user says "we use pnpm, never yarn"
  → extractor writes memory{text:"project uses pnpm, not yarn",
                            user:u_12, ts:...} → embed → upsert
session 2 (days later): "add the axios dependency"
  → query embed → recalls the pnpm memory
  → agent runs `pnpm add axios`  (not yarn/npm)
```

Nothing from session 1 is in the live history; the right command comes purely from retrieved long-term memory.

## Pitfalls

- **Storing raw transcripts.** Dumping whole chats makes retrieval noisy; store distilled atomic facts, not logs.
- **Unbounded accumulation.** Without dedup/aging, contradictory memories ("uses yarn" vs "uses pnpm") both surface — apply [[forgetting-aging-strategies]].
- **Retrieval ≠ truth.** A high cosine score isn't relevance; threshold and re-rank or you inject confidently wrong "memories".
- **PII leakage.** Long-term stores accumulate sensitive data across users; scope by `user_id` and redact, or you cross-contaminate.

## See also

- [[rag-and-vector-databases]]
- [[episodic-vs-semantic-memory]]
