---
title: Short-term Memory
track: ai-agents
group: Memory
tags: [ai-agents, short-term-memory]
prerequisites: [context-windows]
see-also: [long-term-memory, summarization-compression]
---

# Short-term Memory

Short-term memory is the agent's working context for the current task — the running message list (history, tool results, scratchpad) that lives entirely inside the model's [[context-windows|context window]] and vanishes when the session ends.

## Why it matters

It is what makes a chat coherent: without it the model forgets your name three turns ago. Every loop iteration appends the latest observation, so short-term memory grows monotonically and competes for the same fixed token budget as the system prompt and the reply. Mismanage it and you either truncate instructions or pay for re-sending 40K tokens of stale history on every single call.

## How it works

The transport is just the `messages` array you resend each turn — the model is stateless, so "memory" is whatever you choose to replay into the prompt.

- **Append-only buffer.** Each turn pushes `user`, `assistant`, and `tool` messages; the list is the entire memory.
- **Windowing.** Keep only the last N turns or last N tokens; older turns are dropped or pushed to [[long-term-memory]].
- **Scratchpad.** Intermediate reasoning / plans held in-context (the [[react-reason-act|ReAct]] Thought/Observation trace) so the model sees its own prior steps.
- **Prompt caching.** Mark the stable prefix (system + tools + early history) as cacheable so repeated turns skip re-encoding it.

| Strategy | Keeps | Cost behavior |
|---|---|---|
| Full history | everything | O(n) growth, hits ceiling |
| Sliding window (last K) | recent K turns | bounded, drops old facts |
| Summary + window | summary + recent | bounded, lossy |

## Example

A support agent capped at a 12-turn sliding window:

```
turn 14: window holds turns 3–14 (turns 1–2 evicted)
  → user gave order #4471 in turn 1  ← now GONE from context
  → agent: "What's your order number?"  (re-asks, looks broken)
fix: on eviction, write {order: 4471} to long-term memory,
     inject it back as a pinned fact each turn (~8 tokens)
```

The naive window saved tokens but lost a load-bearing fact; pinning the extracted entity fixes it cheaply.

## Pitfalls

- **Unbounded growth.** Append-only loops silently approach the window limit, then error or truncate the middle mid-task.
- **Evicting load-bearing facts.** A blind sliding window drops IDs, constraints, and decisions — extract them to [[long-term-memory]] before dropping.
- **Cache-busting edits.** Rewriting or reordering early messages invalidates the [[token-based-pricing|prompt cache]], turning a cheap turn expensive.
- **Tool-output bloat.** One 5K-token API dump can dominate the window; truncate or summarize observations before appending.

## See also

- [[long-term-memory]]
- [[summarization-compression]]
