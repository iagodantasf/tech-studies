---
title: Context Windows
track: ai-agents
group: LLM Fundamentals
tags: [ai-agents, context-window]
prerequisites: []
see-also: [summarization-compression, rag-and-vector-databases]
---

# Context Windows

The context window is the maximum number of tokens a model can attend to at once — system prompt, history, tool results, and the reply all share one fixed budget.

## Why it matters

It is the hard ceiling on agent memory. Every loop appends tool outputs and observations, so a long-running agent fills the window fast and then must drop, summarize, or retrieve. The window also splits into **input** and **output**: a 128K model with a 4K max-output cap leaves ~124K for everything you send. Blow the budget and the API errors or silently truncates — usually the *middle*, where your instructions hide.

## How it works

Tokens are sub-word pieces (~4 chars / ~0.75 words in English). The window counts the full request plus the generated completion against one limit.

- **It's not free RAM.** Attention is roughly O(n²); doubling context can more than double latency and cost, and the KV cache grows with every token.
- **Lost in the middle.** Recall is U-shaped — facts at the very start and very end are retrieved far better than the same fact buried mid-context.
- **Budget engineering.** Keep the window lean with [[summarization-compression]] of old turns and [[rag-and-vector-databases]] to pull only relevant chunks instead of dumping whole documents.

| Model class | Context | Rough capacity |
|---|---|---|
| GPT-4o / Claude 3.5 | 128K–200K | a long book |
| Gemini 1.5 Pro | up to 2M | a small codebase |
| Older 8K models | 8K | ~6K words |

## Example

A 200K-window agent that pasted whole PDFs each turn:

```
system + tools         2K
3 full PDFs           150K
12 turns of history    40K
room left for reply     8K   ← near the ceiling, costs spike
```

Switching to RAG (retrieve top-5 chunks ≈ 6K) plus a rolling summary dropped per-turn input from ~190K to ~25K, cutting latency and cost ~7×.

## Pitfalls

- **Equating a big window with good recall.** A 1M window still loses the middle; placement and retrieval beat brute-force stuffing.
- **Forgetting the output reserve.** If `max_tokens` + input exceeds the window the call fails — always leave headroom for the reply.
- **Unbounded history growth.** Append-only loops overflow; cap turns and summarize or you hit a wall mid-task.
- **Token ≠ word.** Code, JSON, and non-English inflate token counts; measure with the model's tokenizer, not character length.

## See also

- [[summarization-compression]]
- [[rag-and-vector-databases]]
