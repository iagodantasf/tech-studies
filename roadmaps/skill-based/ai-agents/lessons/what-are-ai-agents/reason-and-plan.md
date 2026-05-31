---
title: Reason and Plan
track: ai-agents
group: What are AI Agents
tags: [ai-agents, planning]
prerequisites: [agent-loop]
see-also: [chain-of-thought-cot, planner-executor]
---

# Reason and Plan

The reasoning step is where the model, given the current context, decides what to do next — break down the goal, pick a strategy, and choose the next action or tool.

## Why it matters

This is the agent's decision-making core: the quality of these choices sets the ceiling on the whole system. Good planning prevents the two dominant failure modes — flailing (random tool calls) and tunnel vision (committing to a doomed approach). How explicit the plan should be is a real design decision: too little structure and the agent wanders; too much and it can't adapt when an observation invalidates the plan.

## How it works

Reasoning ranges from implicit (model just emits the next tool call) to explicit step-by-step traces. Common patterns:

| Pattern | Idea | Best for |
|---|---|---|
| [[chain-of-thought-cot]] | think step-by-step before answering | arithmetic, logic |
| [[react-reason-act]] | interleave thought + action + observation | tool-using loops |
| [[planner-executor]] | plan all steps up front, then execute | known, decomposable tasks |
| [[tree-of-thought-tot]] | branch, evaluate, prune alternatives | search, hard problems |

- **Plan-then-act** is cheaper and auditable but brittle to surprises; **interleaved** (ReAct) adapts each step but costs more tokens.
- [[reasoning-vs-standard-models|Reasoning models]] do extended internal deliberation before answering — strong on planning, but slower and pricier, so reserve them for the hard decisions.
- A short scratchpad of "what I've tried and learned" curbs repetition far more cheaply than a longer system prompt.

## Example

Goal: "book the cheapest flight Fri-Sun". A planner-executor emits a plan — *search → compare → hold → confirm* — then runs it. But step 1 returns no Sunday flights, so a rigid planner fails; a ReAct agent instead **replans** on that observation, widening to Monday return and continuing. The difference is purely in how reasoning reacts to a failed assumption.

## Pitfalls

- **Overthinking simple tasks** — forcing a 6-step plan for a one-tool job wastes tokens and adds failure surface; match plan depth to task.
- **Plan rigidity** — executing a stale plan after an observation broke it; allow replanning.
- **Hallucinated steps** — the model invents a tool or capability that doesn't exist; constrain choices to the real tool list.
- **CoT ≠ truth** — a fluent rationale can still reach a wrong action; the trace explains, it doesn't guarantee.

## See also

- [[chain-of-thought-cot]]
- [[planner-executor]]
