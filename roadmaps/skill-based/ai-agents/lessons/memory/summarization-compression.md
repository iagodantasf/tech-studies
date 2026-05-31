---
title: Summarization / Compression
track: ai-agents
group: Memory
tags: [ai-agents, context-window]
prerequisites: [context-windows]
see-also: [short-term-memory, forgetting-aging-strategies]
---

# Summarization / Compression

Summarization compresses old conversation history into a shorter representation so a long-running agent stays under its [[context-windows|context window]] without forgetting the gist of what happened.

## Why it matters

Agent loops are append-only — every tool result and turn grows [[short-term-memory|short-term memory]] until it overflows. The naive fix (drop old turns) loses facts; the better fix is to *compress* them: a rolling summary keeps a 50-turn chat coherent in 2K tokens instead of 40K, cutting per-turn cost and latency while preserving decisions, constraints, and entities the model still needs.

## How it works

Replace a span of verbose messages with a dense summary, then keep appending — the summary itself rolls forward as new turns arrive.

- **Rolling / recursive summary.** When history crosses a threshold, summarize the oldest turns into a running synopsis; new turns append after it. The summary is re-summarized as it grows.
- **Buffer + summary (hybrid).** Keep the last K turns verbatim (recency matters) plus a summary of everything older — LangChain's `ConversationSummaryBufferMemory` pattern.
- **Structured compression.** Extract a typed scratchpad (`decisions`, `open_questions`, `entities`) instead of prose — denser and less lossy than free text.
- **Tool-output trimming.** Summarize or truncate large observations *before* they enter history, not after they've already bloated it.

| Technique | Keeps | Tradeoff |
|---|---|---|
| Truncate (drop) | recent only | cheap, lossy |
| Rolling summary | gist of all | LLM call cost, lossy |
| Buffer + summary | recent + gist | best recall/cost balance |

## Example

A 200K-window agent that summarizes every 10 turns:

```
turns 1–10 (≈18K tokens of back-and-forth)
  → summary call → 600 tokens:
    "User U7 debugging a 502 on /checkout. Ruled out DNS and
     the LB. Suspect the payment service. Has prod log access."
history now = [summary 600t] + turns 11–14 verbatim
per-turn input: ~190K → ~14K
```

The 502 context, the ruled-out causes, and the current hypothesis all survive in 600 tokens; the verbose transcript is gone.

## Pitfalls

- **Lossy on specifics.** Summaries drop exact IDs, numbers, and code; extract those to [[long-term-memory]] before compressing, don't trust prose to keep them.
- **Error compounding.** Recursively summarizing a summary amplifies omissions and hallucinations — anchor on the original where you can.
- **Summarizing too eagerly.** Compressing the last few turns hurts recency; keep a verbatim recent buffer.
- **Cache invalidation.** Rewriting history to insert a summary busts the [[token-based-pricing|prompt cache]] for that prefix — summarize at stable boundaries.

## See also

- [[short-term-memory]]
- [[forgetting-aging-strategies]]
