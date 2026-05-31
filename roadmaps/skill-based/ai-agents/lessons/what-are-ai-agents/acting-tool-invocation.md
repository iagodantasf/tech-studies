---
title: Acting / Tool Invocation
track: ai-agents
group: What are AI Agents
tags: [ai-agents, tool-use]
prerequisites: [agent-loop]
see-also: [llm-native-function-calling, observation-reflection]
---

# Acting / Tool Invocation

Acting is the step where the agent leaves the model and touches the world — calling a function, query, or API the model picked — turning a decision into a real side effect or fetched fact.

## Why it matters

Tools are what give an LLM reach beyond its frozen weights: live data, math it can't do reliably, and the ability to change state ([[database-queries]], [[file-system-access]], [[email-slack-sms]]). This is also the most dangerous step — it's where a wrong call deletes a row or sends an email. The execution layer is plain engineering the model never sees: validation, auth, timeouts, and error shaping all live in your code.

## How it works

The model emits a structured request — a tool name plus JSON arguments validated against a schema — and your runtime dispatches it. Modern providers ([[anthropic-tool-use]], [[openai-functions-calling]], [[gemini-function-calling]]) constrain output to your declared schema, so you rarely parse free text anymore.

```
{ "tool": "create_ticket",
  "args": { "title": "Login bug", "priority": "high" } }
→ validate args  → authorize  → execute  → shape result/error → feed back
```

- **Schema is the contract** — terse names, typed params, and a one-line description per tool drive selection accuracy more than any prompt tweak.
- **Side-effecting vs read-only** — gate writes/spends behind confirmation or [[human-in-the-loop-evaluation|human approval]]; reads can run freely.
- **Parallel calls** — independent tools (two searches) can run concurrently; dependent ones must serialize.
- Standardize integrations via the [[model-context-protocol-mcp|MCP]] so one tool server serves many agents.

## Example

| # | Concern | Concrete handling |
|---|---|---|
| 1 | Bad args | schema rejects `priority:"urgent"` (not in enum) → ask model to retry |
| 2 | Auth | check caller may write to that project before executing |
| 3 | Timeout | 5s cap on the API; on timeout return a typed error, not a hang |
| 4 | Idempotency | pass a request key so a retried `charge` doesn't double-bill |

Each failure becomes a structured message the loop feeds back so the model can adjust.

## Pitfalls

- **Trusting model args blindly** — always validate and authorize server-side; the model's JSON is a suggestion, not a command.
- **No timeout/retry policy** — one slow tool stalls the whole loop; bound every call.
- **Unbounded write access** — handing an agent raw `DELETE` or `rm` without scoping invites disaster.
- **Too many / overlapping tools** — dozens of similar tools wreck selection; keep the set small and orthogonal.

## See also

- [[llm-native-function-calling]]
- [[observation-reflection]]
