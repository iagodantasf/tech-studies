---
title: Observation / Reflection
track: ai-agents
group: What are AI Agents
tags: [ai-agents, reflection]
prerequisites: [acting-tool-invocation]
see-also: [agent-loop, long-term-memory]
---

# Observation / Reflection

Observation is taking a tool's result back into context; reflection is the model judging that result — did it work, what did I learn, what next — and using it to adjust the plan.

## Why it matters

This closes the loop: without it an agent acts blind, never noticing a failed call or a wrong answer. Reflection is exactly what separates an agent from a fixed pipeline — the capacity to react to results it couldn't predict, recover from errors, and stop when actually done. It's also the cheapest reliability lever: a single "check your work" pass catches a large share of hallucinated or malformed outputs before they reach the user.

## How it works

The raw tool output is first **observed** (normalized and appended to context), then optionally **reflected on** (the model critiques it and decides to continue, retry, or finish).

- **Observe**: trim and shape the result — a 404, a 10K-row table, or a stack trace — into a compact message; never dump megabytes back verbatim.
- **Reflect**: ask "does this satisfy the goal? is it correct? what's the next step?" — implicit each turn in [[react-reason-act|ReAct]], or an explicit self-critique pass.
- **Verify against ground truth** when possible — re-run the test, re-read the file, diff the value — far more reliable than the model grading itself.
- Promote durable lessons ("API X needs ISO dates") into [[long-term-memory]] or a scratchpad so they survive the turn.

| Observation | Reflection → action |
|---|---|
| Tool returned 404 | URL wrong → try the search tool instead |
| Test still failing | fix incomplete → read the error, patch again |
| Result matches goal | done → emit final answer, exit loop |

## Example

A coding agent runs the test suite (action), observes `2 failed` (observation), reflects that its patch missed a null case, edits again, re-runs, and observes `0 failed` — only then does it stop. The verify-by-re-running step is what makes the stop trustworthy; self-assessment alone would often declare victory early.

## Pitfalls

- **Skipping verification** — trusting the model's "looks correct" instead of re-checking against reality lets errors through.
- **Reflection loops** — endless self-critique with no progress; cap reflection passes and require a concrete next action.
- **Over-trusting self-grading** — a model that wrote the answer is a biased judge of it; prefer external checks.
- **Echoing raw output** — appending huge unfiltered results blows the [[context-windows|window]] and buries the signal.

## See also

- [[agent-loop]]
- [[long-term-memory]]
