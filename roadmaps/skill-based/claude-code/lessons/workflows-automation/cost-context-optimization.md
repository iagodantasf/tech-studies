---
title: Cost & Context Optimization
track: claude-code
group: Workflows & automation
tags: [claude-code, cost]
prerequisites: [pricing-token-usage, managing-context-clear-compact]
see-also: [choosing-a-model, multi-step-agentic-tasks, claudeignore-file-scoping]
---

# Cost & Context Optimization

Keeping token spend and context usage low — through model choice, prompt caching, scoping, and clearing — so long sessions stay cheap and sharp instead of bloated and expensive.

## Why it matters

Cost and context are the same problem: every token in the window is paid for on every turn, and a stuffed window also degrades reasoning. A careless session re-reads huge files, never clears, and runs Opus for trivial edits; a disciplined one caches the stable prefix, scopes reads, and picks the model per task. The difference is routinely an order of magnitude on the bill — and noticeably better output.

## How it works

Pull the levers in roughly this priority order:

| Lever | Mechanism | Typical win |
|---|---|---|
| prompt caching | reuse stable prefix (`CLAUDE.md`, tools) | up to ~90% off cached input |
| right model | Haiku/Sonnet for routine, Opus for hard | large per-token cost gap |
| scope context | `.claudeignore`, targeted reads | fewer input tokens per turn |
| `/clear` | drop stale history between tasks | resets window to ~0 |
| `/compact` | summarize history, keep the thread | shrinks without full reset |

- Caching keys on an identical leading prefix, so a stable [[claude-md-project-memory]] and tool set pays off across turns; volatile content at the *front* breaks the cache and quietly raises cost.
- Cached reads are billed far below fresh input; the loss leader is the first uncached turn, so longer sessions amortize better — until the window fills.
- Scope what enters context: [[claudeignore-file-scoping]] keeps `node_modules`/build dirs out, and asking for specific files beats "read the whole src tree."
- `/clear` between unrelated tasks is the highest-leverage habit — it both cuts cost and removes distractor context; `/compact` preserves continuity when you can't fully reset. See [[managing-context-clear-compact]].
- In headless runs, enforce ceilings with `--max-budget-usd` and `--max-turns`; pin `--model` so an upstream default change can't inflate spend.

## Example

```text
Expensive habit:  one Opus session, never cleared, re-reads the 4k-line module every turn.
Cheaper pattern:
  - Sonnet for the implementation, Opus only for the gnarly design step
  - .claudeignore excludes dist/ and vendor/
  - /clear after each feature so history doesn't compound
  - cached CLAUDE.md prefix reused across the whole session
```

Same task, a fraction of the tokens — and the model isn't wading through stale context.

## Pitfalls

- **Cache-busting prefix.** Putting timestamps or per-turn data at the *start* of context invalidates the cache every turn, erasing the discount.
- **Never clearing.** A day-long session accumulates dead context you keep paying for and that dilutes attention — `/clear` aggressively.
- **Opus for everything.** Defaulting to the top model on trivial edits wastes money; match the model to task difficulty (see [[choosing-a-model]]).
- **Compact at the wrong time.** `/compact` mid-task can summarize away a detail the next step needed; clear *between* tasks, compact *within* a long one.

## See also

- [[choosing-a-model]]
- [[multi-step-agentic-tasks]]
- [[claudeignore-file-scoping]]
