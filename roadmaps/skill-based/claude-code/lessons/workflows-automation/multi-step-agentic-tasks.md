---
title: Multi-Step Agentic Tasks
track: claude-code
group: Workflows & automation
tags: [claude-code, agentic]
prerequisites: [plan-mode, built-in-tools-read-edit-bash-etc]
see-also: [delegating-tasks-to-subagents, cost-context-optimization, managing-context-clear-compact]
---

# Multi-Step Agentic Tasks

Driving a long task — explore, plan, edit across many files, run tests, fix, repeat — as one coherent agentic loop rather than a string of disconnected one-shots.

## How it works

The loop is: gather context → act with a tool → observe the result → decide the next action, until the goal is met or a limit is hit. Three forces govern whether it succeeds:

| Force | Failure mode | Lever |
|---|---|---|
| context window | early facts fall out / get compacted | scope the task, `/clear` between phases |
| feedback signal | edits drift with no ground truth | wire tests/types so failures loop back |
| autonomy budget | endless retries, runaway cost | `--max-turns`, `--max-budget-usd` |

- Start hard tasks in [[plan-mode]]: the agent investigates read-only and proposes a plan you approve before any edit, which front-loads the architecture decision while context is freshest.
- Self-correction needs a closed loop — a `PostToolUse` hook or an explicit "run the tests after each change" instruction turns a failing build into a new observation the model fixes, instead of silent drift.
- For long jobs, decompose: do step 1 to completion, `/clear`, then step 2, so each phase keeps a clean window — see [[managing-context-clear-compact]] and [[cost-context-optimization]].
- Parallelizable, independent sub-problems are a fit for [[delegating-tasks-to-subagents]] via the Task tool; each subagent gets its own context and reports back a summary.

## Why it matters

The agentic loop is what separates Claude Code from autocomplete: "migrate this service to the new client, fix every call site, make the suite green" is dozens of coupled steps no single completion can do. But the same loop fails quietly — it forgets, it hallucinates progress, it burns tokens spinning — unless you give it a ground-truth signal and hard limits. Engineering the loop *is* the work.

## Example

A migration, run as phases instead of one mega-prompt:

```text
1. plan mode: "Map every call to OldClient; output a migration plan."  → approve
2. "Phase 1: add the adapter; run `npm test -- adapter`; fix until green."
3. /clear
4. "Phase 2: replace call sites file-by-file; after each, run the suite."
```

Each phase has a verifiable exit (tests pass) and a fresh-ish window, so the agent self-corrects per step rather than losing the thread at file 30.

## Pitfalls

- **One giant prompt for a 40-file change.** Context fills, early decisions get compacted, quality craters — phase it and clear between phases.
- **No ground truth.** Without tests/types in the loop, the model believes its own edits; it will report "done" on broken code.
- **Unbounded retries.** A failing step with no turn/budget cap loops indefinitely; always set `--max-turns` and a budget in headless runs.
- **Over-delegation.** Spawning subagents for tightly coupled steps loses shared context and adds coordination cost; delegate only genuinely independent work.

## See also

- [[delegating-tasks-to-subagents]]
- [[cost-context-optimization]]
- [[managing-context-clear-compact]]
