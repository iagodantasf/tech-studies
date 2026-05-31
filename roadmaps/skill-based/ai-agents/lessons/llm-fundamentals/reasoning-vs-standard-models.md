---
title: Reasoning vs Standard Models
track: ai-agents
group: LLM Fundamentals
tags: [ai-agents, reasoning-models]
prerequisites: []
see-also: [chain-of-thought-cot, token-based-pricing]
---

# Reasoning vs Standard Models

Reasoning models (o3, Claude with extended thinking, Gemini Thinking, DeepSeek-R1) spend extra hidden "thinking" tokens before answering; standard models answer in one shot.

## Why it matters

For an agent, picking the wrong class wastes money or fails the task. Reasoning models trade latency and cost for accuracy on multi-step problems — math, code, planning, tricky tool orchestration — where a standard model guesses. But they are slow and expensive, so routing every step through one is a common, costly mistake; most agent turns (a tool call, a format fix) want a fast standard model.

## How it works

A reasoning model is RL-trained to emit a long internal [[chain-of-thought-cot]] before its final answer. That scratchpad is billed (often as output/"reasoning" tokens) but usually hidden from you.

- **Test-time compute.** Quality scales with thinking budget — more reasoning tokens, better answers, up to a point. Many APIs expose an effort/budget knob (`low`/`medium`/`high`).
- **Different controls.** Reasoning endpoints often ignore `temperature`/`top_p` and instead take a reasoning-effort or thinking-token budget.
- **Prompt them less.** They self-decompose, so "think step by step" and elaborate CoT scaffolding add little and can hurt; give the goal, not the method.

| Dimension | Standard | Reasoning |
|---|---|---|
| Latency | ~1× | 3–10× slower |
| Cost/answer | low | high (thinking tokens) |
| Best at | retrieval, formatting, chat | math, code, planning |
| Knob | temperature, top_p | reasoning effort/budget |

## Example

A research agent routes by step difficulty:

```
classify intent          → standard  (~0.4s, cheap)
plan a 6-step research    → reasoning (high effort, ~8s)
call search tool, parse   → standard
synthesize final report   → reasoning (medium effort)
```

Hybrid routing cut cost ~5× versus running the whole loop on a reasoning model, with no measured quality loss on the easy steps.

## Pitfalls

- **Reasoning-by-default.** Wrapping every tool call in an o-series model burns budget and latency for no gain; route by difficulty.
- **Double-prompting CoT.** Adding manual step-by-step prompts to a reasoning model can degrade it — let it reason on its own.
- **Counting only visible tokens.** Hidden reasoning tokens are billed; an "empty" answer can still cost thousands of tokens.
- **Tight timeouts.** A 10s budget can truncate the scratchpad and force a worse answer; size timeouts to the effort level.

## See also

- [[chain-of-thought-cot]]
- [[token-based-pricing]]
