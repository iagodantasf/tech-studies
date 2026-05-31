---
title: What are AI Agents
track: ai-agents
group: What are AI Agents
tags: [ai-agents, fundamentals]
prerequisites: [rest-api-knowledge, api-requests]
see-also: [agent-loop, llm-native-function-calling]
---

# What are AI Agents

An AI agent is an LLM placed inside a control loop that lets it observe state, decide on actions, call tools, and keep going until a goal is reached — not a single prompt-response.

## Why it matters

A bare LLM call is stateless and inert: it emits text and stops. Real tasks ("triage this inbox", "fix the failing test") need many steps, external data, and the ability to react to results. Wrapping the model in a loop with [[acting-tool-invocation|tool access]] turns a text predictor into something that can *act* on the world and self-correct. The cost is unpredictability — every loop iteration is another non-deterministic model call you must bound and observe.

## How it works

The minimal anatomy is a model, a tool set, a memory, and a loop driver (the [[agent-loop]]). The model is asked to either produce a final answer or request a tool; the driver executes the tool, feeds the result back, and re-asks. Three properties separate an agent from a pipeline:

| Property | Pipeline (workflow) | Agent |
|---|---|---|
| Control flow | Fixed by code | Chosen by the model at runtime |
| Step count | Known ahead | Open-ended, must be capped |
| Tool choice | Hard-coded | Model selects per step |

- **Autonomy** is a spectrum, not a switch — from "model fills one slot" up to "model runs unsupervised for 50 steps".
- Prefer the simplest thing that works: a deterministic [[planner-executor]] or even a plain chain often beats a free-running loop on reliability and cost.
- Agents are only as capable as their tools and only as safe as their guardrails ([[prompt-injection-jailbreaks]]).

## Example

Goal: "What's our MRR change vs last month?" A workflow would hard-code SQL. An agent instead: (1) calls a `list_tables` tool, (2) reads the schema, (3) writes and runs a query via [[database-queries]], (4) sees a NULL-handling bug in the result, (5) rewrites the query, (6) returns the number. Steps 4-5 — reacting to a bad observation — are what a fixed pipeline cannot do.

## Pitfalls

- **Agent-washing** — calling a fixed prompt chain an "agent"; if control flow is in your code, it's a workflow, and that's often fine.
- **Unbounded loops** — without a step cap and cost budget, a confused agent burns tokens forever; always set both.
- **Tooling as an afterthought** — agent quality is dominated by clear tool schemas and error messages, not prompt cleverness.

## See also

- [[agent-loop]]
- [[llm-native-function-calling]]
