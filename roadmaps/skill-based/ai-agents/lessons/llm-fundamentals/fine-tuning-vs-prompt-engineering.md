---
title: Fine-tuning vs Prompt Engineering
track: ai-agents
group: LLM Fundamentals
tags: [ai-agents, fine-tuning]
prerequisites: []
see-also: [provide-additional-context, rag-and-vector-databases]
---

# Fine-tuning vs Prompt Engineering

Two ways to steer an LLM without training from scratch: change the *input* at inference time (prompting) or change the *weights* on your data (fine-tuning).

## Why it matters

It's a build-vs-buy decision for behavior. Prompting is instant, free of training infra, and easy to iterate — the right first move for almost every agent. Fine-tuning earns its keep only when prompting plateaus: you need a consistent style/format, a narrow skill, lower latency, or shorter prompts at scale. Reaching for a fine-tune to add *facts* is the classic mistake — that's a retrieval problem, not a weights problem.

## How it works

Order of escalation, cheapest first: prompt → few-shot → [[rag-and-vector-databases]] → fine-tune. Climb only when the rung below stops improving.

- **Prompt engineering** shapes one request: clear instructions, [[provide-additional-context]], few-shot examples, output schema. Zero training cost; changes ship instantly.
- **RAG** injects fresh, source-grounded facts at query time — the right tool for knowledge that changes.
- **Fine-tuning** (usually LoRA/PEFT — train a small adapter, not all weights) bakes in *behavior*: tone, a domain's jargon, reliable JSON, a tool-call dialect. Needs a labeled dataset and an eval set.

| Concern | Prompting | Fine-tuning |
|---|---|---|
| Adds knowledge | weak (use RAG) | weak, goes stale |
| Adds behavior/format | moderate | strong |
| Iteration speed | seconds | hours–days |
| Up-front cost | ~0 | data + GPU time |
| Per-call cost | higher (long prompts) | lower (short prompts) |

## Example

A support agent must always answer in a strict JSON triage schema.

```
v1 prompt + 3 examples  → ~88% schema-valid, ~1.5K-token prompt
v2 RAG for policy facts → accurate, still 88% format
v3 LoRA on 2K labeled   → ~99% valid, prompt shrinks to ~200 tokens
                          (lower latency + cost per call)
```

Facts came from RAG; *format reliability* came from the fine-tune — each fixed what the other couldn't.

## Pitfalls

- **Fine-tuning for facts.** Weights freeze at train time and go stale; use RAG for knowledge, fine-tuning for behavior.
- **Skipping prompt work first.** Many "we need a fine-tune" problems vanish with a clear instruction and two examples.
- **No eval set.** Without a held-out benchmark you can't tell a fine-tune helped or quietly regressed other tasks (catastrophic forgetting).
- **Tiny or dirty datasets.** A few hundred noisy examples overfit; quality and coverage beat volume.

## See also

- [[provide-additional-context]]
- [[rag-and-vector-databases]]
