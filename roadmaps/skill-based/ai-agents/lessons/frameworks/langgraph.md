---
title: LangGraph
track: ai-agents
group: Frameworks
tags: [ai-agents, framework]
prerequisites: [agent-loop, langchain]
see-also: [planner-executor, short-term-memory]
---

# LangGraph

A library for building agents as an explicit **stateful graph** of nodes and edges, so control flow — including loops and branches — is data you define rather than logic hidden in a loop.

## Why it matters

[[langchain|LangChain]]'s linear chains can't naturally express "loop until done", "branch on a check", or "pause for a human". LangGraph models the agent as a state machine: you see every transition, can add cycles, and can checkpoint and resume. This is the backbone behind durable, human-in-the-loop, and multi-agent systems where you need the [[agent-loop]] to be inspectable and recoverable, not a black box.

## How it works

You define a typed **state** object, register **nodes** (functions that read state and return partial updates), and wire **edges** between them.

| Concept | Meaning |
|---|---|
| State | shared dict; updates **merge** via reducers |
| Node | fn `state -> partial state` |
| Edge | fixed next node |
| Conditional edge | fn `state -> next node name` |
| Checkpointer | persists state per step for resume |

- **Reducers** control merging — the common `messages` channel uses an append reducer so each node adds rather than overwrites.
- A **conditional edge** is how you build the loop: after the model node, route to `tools` if it requested a call, else to `END`.
- **`interrupt`** pauses the graph (e.g. for approval); a checkpointer lets you resume the exact same run later — this is how [[human-in-the-loop-evaluation|human-in-the-loop]] is implemented.
- `create_react_agent` ships a prebuilt [[react-reason-act|ReAct]] graph for the common case.

## Example

The canonical agent is a 2-node cycle:

```
state = {messages: [...]}        # append-reducer channel

START → [agent] ──has tool_calls?──→ [tools] ─┐
           ↑                                   │
           └───────────────────────────────────┘
        (else) → END

agent: call model, return {messages:[ai_msg]}
tools: run each call, return {messages:[tool_msgs]}
```

The edge `agent → tools → agent` *is* the loop; checkpointing means a crash at step 7 resumes at step 7, not step 0.

## Pitfalls

- **Mutating state in place.** Nodes must *return* updates; editing the passed dict bypasses reducers and corrupts checkpoints.
- **Unbounded cycles.** A loop with no exit condition runs forever — set a `recursion_limit` and a clear `END` route.
- **Wrong reducer.** Overwriting the `messages` channel instead of appending silently drops history (see [[short-term-memory]]).
- **Over-engineering.** A purely linear flow doesn't need a graph; reach for LangGraph only when you have real branching or loops.

## See also

- [[planner-executor]]
- [[short-term-memory]]
