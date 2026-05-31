---
title: Planner-Executor
track: ai-agents
group: Agent Architectures
tags: [ai-agents, agent-architecture]
prerequisites: [agent-loop, react-reason-act]
see-also: [dag-agents, reason-and-plan]
---

# Planner-Executor

A two-role architecture that splits an agent into a **planner** that writes the whole plan up front and an **executor** that carries out each step.

## Why it matters

Flat [[react-reason-act|ReAct]] decides one step at a time, so on long tasks it drifts: it forgets the goal, repeats steps, or loops. Planner-Executor front-loads a full plan, giving the run a stable backbone the executor follows even after 20 noisy [[observation-reflection|observations]]. It also cuts cost — you can plan with an expensive [[reasoning-vs-standard-models|reasoning model]] once and execute the cheap steps with a small model. This is the shape behind BabyAGI, Plan-and-Solve, and LangChain's `plan_and_execute`.

## How it works

Two LLM roles with distinct prompts and often distinct models:

| Role | Model | Runs | Output |
|---|---|---|---|
| Planner | strong/reasoning | once (or on replan) | ordered step list |
| Executor | cheap/fast | per step | tool call + result |

The flow is plan-then-loop:

1. Planner reads the goal, emits steps `[s1, s2, … sn]` (often as JSON).
2. Executor takes `s1`, runs the [[acting-tool-invocation|tool]], appends the [[observation-reflection|observation]].
3. Repeat for each step; the executor only sees the current step plus accumulated results, keeping its [[context-windows|context]] small.
4. **Replan trigger**: if a step fails or an observation invalidates the plan, hand control back to the planner to rewrite the remaining steps.

The hard part is the replan loop — a static plan that never adapts is brittle, but replanning every step collapses back into ReAct.

## Example

Goal: "Email me last quarter's top-selling product."

```
PLAN (planner, 1 call):
  1. query_db: top product by revenue, last 90 days
  2. format result as one line
  3. send_email to user

EXECUTE (executor, per step):
  s1 -> query_db(...) -> "Widget-X, $48,210"
  s2 -> "Top seller last quarter: Widget-X ($48,210)"
  s3 -> send_email(to=user, body=...) -> 200 OK
```

One $0.03 planner call + three cheap executor calls, versus ReAct re-reasoning the whole goal on every turn.

## Pitfalls

- **Stale plans.** Step 4 assumed step 2's output; reality differed and no replan fired — the agent marches off a cliff. Always allow replanning on failure.
- **Over-planning.** A 15-step plan for a task that needed 3 wastes tokens and multiplies failure points; cap plan length.
- **Lost context between roles.** The executor can't see the planner's reasoning, only the step text; vague steps like "handle the data" are unexecutable. Make steps self-contained.
- **No cross-step state.** If `s3` needs `s1`'s output, you must thread results forward explicitly — see [[dag-agents]] for a structured way to model those dependencies.

## See also

- [[dag-agents]]
- [[reason-and-plan]]
