---
title: Managing Context (/clear, /compact)
track: claude-code
group: CLI usage
tags: [claude-code, context-window]
prerequisites: [interactive-mode]
see-also: [resuming-continuing-sessions, claude-md-project-memory, cost-context-optimization]
---

# Managing Context (/clear, /compact)

`/clear` and `/compact` are the two levers for the finite context window: one wipes it, the other summarises it to reclaim space while keeping the gist.

## Why it matters

The model sees a fixed token budget; every Read, Bash output, and turn consumes it. When the window fills, quality degrades and cost rises (each turn re-sends the whole transcript). Deliberate context hygiene — clearing between unrelated tasks, compacting within a long one — is the single biggest lever on both answer quality and spend (see [[cost-context-optimization]]).

## How it works

- **`/clear`** resets the conversation to empty: history and loaded files are dropped, the window returns to baseline (system prompt + [[claude-md-project-memory|CLAUDE.md]] only). Use it when switching to an unrelated task.
- **`/compact`** asks the model to replace the transcript with a compressed summary, freeing tokens while retaining decisions and state. Optionally steer it: `/compact focus on the API changes`.
- **Auto-compact** triggers automatically as the window nears full; it can fire at an inconvenient moment, so compacting manually at a clean boundary is preferable.
- `/context` shows current usage (a visual breakdown); `/cost` shows token/dollar spend so far.

| Tool | Keeps history? | Frees tokens? | When |
|---|---|---|---|
| `/clear` | no | fully | switching tasks |
| `/compact` | summarised | mostly | long single task |
| auto-compact | summarised | mostly | window near full |

## Example

```text
> [long debugging session, context at ~85%]
> /compact keep the repro steps and the fix, drop the dead-end logs
  …model summarises 60 turns into a short brief, window drops to ~20%…
> now write the regression test
  # continues with room to spare, still knows the repro + fix
> /clear
> review the unrelated billing PR    # fresh window, no stale debugging context
```

## Pitfalls

- **Compacting too late.** Past the limit, auto-compact picks the cut points for you and may drop something load-bearing — compact proactively.
- **`/clear` mid-task.** It is irreversible for that thread; you lose the live context (the saved session can be resumed, but the working state is gone).
- **Relying on compaction for facts.** Summaries lossily drop detail; durable project facts belong in [[claude-md-project-memory|CLAUDE.md]], not in a transcript you'll compact away.
- **Ignoring `/context`.** Flying blind on usage leads to surprise auto-compacts and bills — check it on long sessions.

## See also

- [[resuming-continuing-sessions]]
- [[claude-md-project-memory]]
- [[cost-context-optimization]]
