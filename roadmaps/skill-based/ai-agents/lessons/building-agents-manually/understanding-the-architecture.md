---
title: Understanding the Architecture
track: ai-agents
group: Building Agents Manually
tags: [ai-agents, architecture]
prerequisites: [what-are-ai-agents, agent-loop]
see-also: [manual-from-scratch, planner-executor]
---

# Understanding the Architecture

The component map of an agent — model, loop driver, tools, memory, and guardrails — and how data flows between them, so you know what you're building before you write it.

## Why it matters

Most agent failures trace to a missing or misplaced component, not a bad prompt: state kept in the wrong place, no guardrail between the model and a destructive tool, memory that grows until it overflows the [[context-windows|window]]. Seeing the architecture as separable boxes tells you *where* a bug lives and *which* box to swap when requirements change — a different model, a vector [[rag-and-vector-databases|store]] for memory, a [[planner-executor]] in place of a free loop.

## How it works

Five components, each independently replaceable:

| Component | Role | Where it lives |
|---|---|---|
| Model | reasons, picks the next action | API call ([[closed-weight-models]] / [[open-weight-models]]) |
| Loop driver | runs perceive→reason→act→observe | your code ([[agent-loop]]) |
| Tools | the agent's hands on the world | functions + schemas ([[acting-tool-invocation]]) |
| Memory | state across turns and sessions | message list + store |
| Guardrails | filter inputs, gate dangerous acts | wrappers around model and tools |

- **Data flow** — user input → context assembly → model → either final text *or* a tool request → dispatch → observation appended → back to the model. The loop is the only stateful actor; the model itself is stateless and sees only what you put in the context.
- **State has two tiers** — [[short-term-memory]] (the live message list, bounded by the window) and [[long-term-memory]] (an external store queried via [[embeddings-and-vector-search|retrieval]] and injected per turn).
- **Control flow is a spectrum** — a fixed chain → [[planner-executor|planner-executor]] → free [[react-reason-act|ReAct]] loop. Push as much as you can to the deterministic end; only the truly open-ended steps need model-chosen control.
- **Guardrails sit on the boundaries**, not inside the model: validate tool args, sandbox [[code-execution-repl|code execution]], and screen for [[prompt-injection-jailbreaks|injection]] before the model ever sees tool output.

## Example

"Summarize today's support tickets and email me the top 3 issues":

```
context = system + memory.recall("ticket format") + user_goal
loop:
  model → call query_tickets()      # tool
        → observe 142 rows
  model → call summarize(rows)
  model → call send_email(...)      # GUARDRAIL: require confirm on send
  model → final answer
```

Swap the model and nothing else changes; swap the loop for a [[planner-executor]] and the tools/memory boxes stay identical — that separability is the whole point.

## Pitfalls

- **State in the wrong box** — stuffing long-term facts into the live prompt instead of a queried store blows the [[context-windows|window]] and inflates every call's cost.
- **No boundary guardrail** — letting raw tool output flow back unscreened is the main [[prompt-injection-jailbreaks|prompt-injection]] vector.
- **Monolithic loop** — fusing dispatch, memory, and model logic into one function makes any component impossible to swap or test in isolation.
- **Over-architecting** — five boxes is the *ceiling*; a one-tool assistant needs a model and a loop, not a vector DB and a planner.

## See also

- [[manual-from-scratch]]
- [[planner-executor]]
