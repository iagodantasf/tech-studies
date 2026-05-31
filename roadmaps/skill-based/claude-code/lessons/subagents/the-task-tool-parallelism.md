---
title: The Task Tool & Parallelism
track: claude-code
group: Subagents
tags: [claude-code, subagents]
prerequisites: [delegating-tasks-to-subagents]
see-also: [what-are-subagents, concurrency-and-deadlocks, cost-context-optimization]
---

# The Task Tool & Parallelism

`Task` is the built-in tool that spawns a subagent; emitting several `Task` calls in one turn runs those subagents **concurrently**, fanning out independent work.

## How it works

The model passes `Task` a `subagent_type` (which agent) and a `prompt` (the job). Each call is an isolated child with its own context and tool loop; the parent blocks until results return, then continues.

| Param | Meaning |
|---|---|
| `subagent_type` | `general-purpose` or a custom agent's `name` |
| `prompt` | the full, self-contained instruction |
| `description` | a short label for the task (shown in UI) |

- **Parallelism comes from one turn, multiple calls.** When the model issues N `Task` calls together, Claude Code runs them at once and gathers all results — wall-clock ≈ the slowest child, not the sum.
- There's a concurrency cap (a handful run truly in parallel; extras queue), so fan-out scales sub-linearly past that limit.
- Children are **independent and isolated** — they don't share memory or see each other's output, which is exactly why parallelizing them is safe: no shared state, no [[concurrency-and-deadlocks|races]]. The classic map step of [[divide-and-conquer]].
- Results merge back into the parent as separate tool-result messages; the parent reconciles them.

## Why it matters

Three independent reviews (security, performance, tests) run in roughly the time of one instead of three sequential passes — and each in its own context, so none pollutes the others or the main thread. This is the highest-leverage pattern for breadth-first work: survey many areas fast, then drill in. The constraint is that tasks must be *genuinely independent* — fan-out only helps when children don't need each other's results.

## Example

```text
Main agent (one turn, three Task calls dispatched together):
  Task(security-reviewer,  "Audit src/api/** for authz/injection")
  Task(general-purpose,    "Find N+1 query patterns in src/db/**")
  Task(test-writer,        "List untested public funcs in src/core/**")

  ── all three run concurrently in separate contexts ──
  returns: 2 authz gaps │ 1 N+1 in orders.py │ 6 untested funcs

≈ time of the slowest child (not the sum); main context gains 3 short
summaries instead of three full investigations' worth of file reads.
```

Sequencing instead (security → then perf → then tests) would triple the latency and stack all the intermediate reads — though it's required when a later task *depends* on an earlier one's finding.

## Pitfalls

- **Faking parallelism with dependent tasks.** If task B needs A's output, they can't run together; the model must serialize them — forcing concurrency just makes B guess.
- **Expecting unlimited fan-out.** Past the concurrency cap, extra `Task` calls queue; 20 agents don't all run at once.
- **No shared scratch space.** Two children can't coordinate or dedupe work; if they overlap, you pay for the same reads twice.
- **Aggregation is on you (the parent).** Parallel children return raw summaries; reconciling conflicts or merging findings is the parent's job, not automatic.

## See also

- [[what-are-subagents]]
- [[concurrency-and-deadlocks]]
- [[cost-context-optimization]]
