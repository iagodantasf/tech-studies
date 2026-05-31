---
title: Stopping Criteria
track: ai-agents
group: Model Configuration / Tuning
tags: [ai-agents, generation-limits]
prerequisites: []
see-also: [max-length-max-tokens, streamed-vs-unstreamed-responses]
---

# Stopping Criteria

Stopping criteria are the conditions that end token generation — the model's own end-of-sequence token, an explicit stop string, the [[max-length-max-tokens|max_tokens]] cap, or a custom predicate.

## Why it matters

Where generation stops decides whether you get a clean, parseable result or a half-finished one. Agents lean on **stop sequences** constantly: to cut a [[react-reason-act|ReAct]] loop the instant the model emits `Observation:`, to halt at a closing delimiter, or to prevent the model from hallucinating the *tool's* output. Get the stop wrong and the model either runs on or chops the answer early.

## How it works

Generation halts on the first condition met:

- **EOS token** — the model predicts its end-of-sequence token (a natural finish). Reported as `finish_reason: "stop"` / `stop_reason: "end_turn"`.
- **Stop sequences** — caller-supplied strings (e.g. `["\nObservation:", "```"]`); the API stops *before* emitting the match and the stop text is excluded from the output.
- **Token limit** — the [[max-length-max-tokens|max_tokens]] ceiling (`finish_reason: "length"`).
- **Custom predicate** — in local runtimes, a `StoppingCriteria` callback (timeout, regex on the running string, logit threshold).

| Trigger | finish_reason / stop_reason |
|---|---|
| EOS / natural end | stop / end_turn |
| Stop sequence hit | stop / stop_sequence |
| max_tokens reached | length / max_tokens |
| Tool call emitted | tool_calls / tool_use |

Limits are typically 4 stop sequences per request; longer ones are matched on the decoded string, not token-by-token, so a stop string spanning an odd token boundary can occasionally be missed.

## Example

Forcing one ReAct step at a time:

```
prompt: "...Thought:"
stop:   ["\nObservation:"]
→ model emits  Thought: search docs\nAction: web_search("...")
→ generation stops right before "\nObservation:"; you run the tool and feed the real result back
```

## Pitfalls

- **Always check the finish reason** — treating a `length`-truncated reply as complete corrupts downstream parsing.
- **Stop string inside valid output** — a stop of `"\n"` will kill any multi-line answer at the first newline.
- **Excluded stop text** — the matched stop string is *not* returned; if you needed that delimiter in the output, append it yourself.

## See also

- [[max-length-max-tokens]]
- [[react-reason-act]]
