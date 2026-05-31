---
title: DAG Agents
track: ai-agents
group: Agent Architectures
tags: [ai-agents, agent-architecture]
prerequisites: [planner-executor, graphs]
see-also: [langgraph, planner-executor]
---

# DAG Agents

An agent whose plan is a **directed acyclic graph** of tasks — nodes are steps, edges are data/ordering dependencies — so independent branches run in parallel and the structure forbids loops.

## How it works

Where [[planner-executor]] produces a linear list, a DAG agent produces a [[graphs|graph]]: each node declares which upstream nodes it depends on. A scheduler then runs nodes in [[graph-algorithms|topological order]], executing any node whose dependencies are all complete — which lets sibling branches run concurrently.

- **Nodes**: a tool call, an LLM step, or a sub-agent. Each has typed inputs/outputs.
- **Edges**: `B depends on A` means A's output feeds B; the [[graph-algorithms|topo sort]] gives a legal execution order.
- **Acyclic**: no cycles, so the run is guaranteed to terminate — no infinite [[react-reason-act|ReAct]] loops. (Frameworks like [[langgraph]] allow cycles + a recursion cap; a *pure* DAG forbids them.)
- **Fan-out / fan-in**: independent nodes execute in parallel; a join node waits for all parents, e.g. map over 5 docs, then reduce.

| Property | Linear plan | DAG plan |
|---|---|---|
| Parallelism | none | independent nodes concurrent |
| Dependencies | implicit, by order | explicit edges |
| Termination | step count | guaranteed (acyclic) |
| Wall-clock | sum of steps | longest path (critical path) |

## Why it matters

Many agent tasks are embarrassingly parallel — research 5 subtopics, scrape 10 pages, summarize each — and a linear executor does them one slow step at a time. A DAG runs the independent work at once, so latency drops from the *sum* of step times to the *critical path*. Explicit edges also make the run inspectable and resumable: re-run only the failed node and its descendants, not the whole plan. This backs LLMCompiler, DSPy pipelines, and graph runtimes like [[langgraph]].

## Example

"Compare the pricing pages of Stripe, Adyen, and Braintree."

```
        fetch_stripe ─┐
        fetch_adyen  ─┼─> compare ─> write_report
        fetch_braintree┘
```

The three fetches have no edges between them, so they run concurrently (~2s total, not 6s). `compare` is a join node: it waits for all three, then the report node depends only on `compare`. Critical path = fetch + compare + write, not the sum of all five nodes.

## Pitfalls

- **Accidental cycles.** A planner that emits "A needs B, B needs A" yields no valid topo order; validate acyclicity before executing.
- **Static graph, dynamic need.** A fixed DAG can't add a node mid-run when an observation demands it; you need dynamic re-planning or a runtime that supports conditional edges.
- **Fan-out blowup.** Mapping a node over 500 items fires 500 parallel LLM calls — rate limits, cost spikes; bound concurrency.
- **Unbounded with cycles.** The moment you allow cycles (loop-until-done), you lose the termination guarantee — add an explicit step/recursion cap.

## See also

- [[langgraph]]
- [[planner-executor]]
