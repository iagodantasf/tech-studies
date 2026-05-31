---
title: Streamed vs Unstreamed Responses
track: ai-agents
group: Model Configuration / Tuning
tags: [ai-agents, streaming]
prerequisites: []
see-also: [stopping-criteria, acting-tool-invocation]
---

# Streamed vs Unstreamed Responses

A response is either **unstreamed** (the API buffers the whole completion and returns it once) or **streamed** (tokens are pushed incrementally as they're generated, usually over Server-Sent Events).

## Why it matters

Streaming transforms *perceived* latency: time-to-first-token (TTFT) can be a few hundred ms even when the full answer takes 20s, so a chat UI feels instant. The total wall-clock time is roughly the same — streaming doesn't make generation faster — but for long outputs, [[agent-loop|agentic]] flows, and any human-facing surface it's the difference between "responsive" and "spinner of death."

## How it works

- **Unstreamed** — one request, one JSON response after the model finishes. Simple to parse; you get usage counts and the full [[stopping-criteria|finish reason]] in one object.
- **Streamed** — server emits a sequence of **chunks/deltas**; you concatenate the partial token fragments. The stream ends with a terminal marker (OpenAI `data: [DONE]`, Anthropic a `message_stop` event).

| Aspect | Unstreamed | Streamed |
|---|---|---|
| TTFT | After full generation | After first token |
| Total latency | Same | Same |
| Parsing | One JSON object | Reassemble deltas + handle event types |
| Cancellation | Wastes done work | Abort connection, save tokens/cost |
| Token usage | In the response | Often only in a final event |

Two metrics define the experience: **TTFT** and **inter-token latency** (tokens/sec). Streaming also lets you **cancel** mid-generation — closing the connection stops billing for unsent tokens, useful when an [[stopping-criteria|stop condition]] is detected client-side.

## Example

OpenAI-style SSE chunks reassembled into text:

```
data: {"choices":[{"delta":{"content":"Hel"}}]}
data: {"choices":[{"delta":{"content":"lo"}}]}
data: {"choices":[{"delta":{}, "finish_reason":"stop"}]}
data: [DONE]
→ accumulate deltas → "Hello"
```

## Pitfalls

- **Streaming tool calls** — function arguments arrive as JSON *fragments* across deltas; you must buffer and only parse once complete, or [[acting-tool-invocation|tool invocation]] breaks on partial JSON.
- **Errors mid-stream** — a failure after the first chunk can leave a truncated body with HTTP 200 already sent; handle it explicitly, don't assume success.
- **Aggregating usage** — many providers only report token counts in the final event; code that reads usage from chunk one sees nothing.

## See also

- [[stopping-criteria]]
- [[acting-tool-invocation]]
