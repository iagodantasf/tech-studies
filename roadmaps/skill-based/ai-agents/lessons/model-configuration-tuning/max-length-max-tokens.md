---
title: Max Length / Max Tokens
track: ai-agents
group: Model Configuration / Tuning
tags: [ai-agents, generation-limits]
prerequisites: []
see-also: [context-windows, stopping-criteria]
---

# Max Length / Max Tokens

`max_tokens` caps how many tokens the model is allowed to *generate* in one response — a hard upper bound on output length, distinct from the model's total [[context-windows|context window]].

## Why it matters

It is the primary lever on latency and cost-per-call, and a safety rail against runaway generation. An [[agent-loop|agent]] that loops on tool calls can otherwise emit thousands of tokens of rambling; a tight cap forces concision and bounds the bill. Set it too low, though, and you truncate the answer mid-sentence — or worse, mid-JSON — and the [[acting-tool-invocation|tool call]] fails to parse.

## How it works

The token budget splits into two halves that share one [[context-windows|window]]:

```
context_window = input_tokens (prompt) + max_tokens (completion)
```

- The output portion is billed at the (higher) **output** rate — see [[token-based-pricing]].
- If `input + max_tokens` exceeds the window, the API errors *before* generating.
- Hitting the cap is a [[stopping-criteria|stop condition]]: generation halts and the response is flagged (OpenAI `finish_reason: "length"`, Anthropic `stop_reason: "max_tokens"`).

| Provider | Field | Counts |
|---|---|---|
| OpenAI | max_completion_tokens | Output only |
| Anthropic | max_tokens | Output only |
| Many OSS runtimes | max_new_tokens | Output only |

A useful rule: `max_tokens` is a *ceiling*, not a target — the model stops naturally at its own end-of-sequence token well before the cap in most turns.

## Example

A `gpt-class` model with a 128k window, prompt of 120k tokens:

```
max_tokens = 8000  → 120k + 8k = 128k  ✓ fits exactly
max_tokens = 10000 → 120k + 10k > 128k ✗ API rejects the request
```

Lower the cap or trim the prompt (summarize history, drop old turns).

## Pitfalls

- **Truncated structured output** — JSON or code cut at the limit won't parse; size the cap to the worst-case output, and check the finish reason.
- **Reasoning tokens count** — for [[reasoning-vs-standard-models|reasoning models]], hidden chain-of-thought consumes the output budget, so a small `max_tokens` can leave no room for the visible answer.
- **Confusing it with the context window** — `max_tokens` never raises the model's total capacity; it only partitions it.

## See also

- [[context-windows]]
- [[stopping-criteria]]
