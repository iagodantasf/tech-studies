---
title: Choosing a Model
track: claude-code
group: Getting started
tags: [claude-code, models]
prerequisites: [first-session-repl-basics]
see-also: [pricing-token-usage, model-output-configuration, cost-context-optimization]
---

# Choosing a Model

Claude Code lets you pick which Claude model handles a session — trading raw capability against speed and per-token cost.

## Why it matters

The model is the single biggest lever on both quality and bill. A frontier model reasons through a gnarly refactor that a small one bungles; a small, fast model answers "what does this function do" for a fraction of the cost and latency. Picking deliberately — and using the **largest for planning, a cheaper one for grunt work** — is the core of [[cost-context-optimization|cost optimization]] in practice.

## How it works

The family spans three tiers; the exact version names advance over time, so prefer the tier alias.

| Tier | Strength | Trade-off | Typical use |
|---|---|---|---|
| Opus | deepest reasoning | slowest, priciest | hard refactors, architecture, planning |
| Sonnet | strong + balanced | mid cost/speed | everyday coding default |
| Haiku | fast + cheap | weaker on hard tasks | quick edits, search, summaries |

- Set the model at launch with `claude --model <name>` (e.g. an Opus or Sonnet identifier) or switch mid-session with `/model`.
- A default can be pinned via `settings.json` or the `ANTHROPIC_MODEL` env var — see [[model-output-configuration]] and [[environment-variables]].
- Some configurations run a **fast model for subagents** ([[the-task-tool-parallelism]]) while the main thread uses a stronger one — a built-in cost/quality split.
- `/status` shows the currently active model; subscription tiers may gate which models are available.

## Example

A pragmatic split on one feature:

```bash
# Plan the change with the strongest model
claude --model opus
> outline how to migrate the auth module to the new token format

# Execute the mechanical edits cheaper/faster
/model sonnet
> apply the plan file by file and run the tests
```

You paid Opus rates only for the thinking, and the bulk edit ran on a cheaper, quicker model — without leaving the session.

## Pitfalls

- **Defaulting to the biggest model for everything.** Running Opus on trivial edits burns money and adds latency for no quality gain.
- **Hard-coding a dated version string.** Specific model IDs get superseded; an old pin can silently fall behind — prefer the tier alias or update it deliberately.
- **Under-powering a hard task.** Forcing a cheap model through a complex multi-file refactor often costs *more* via retries and wrong turns than one Opus pass.
- **Forgetting `/model` persists.** Switching mid-session changes every later turn's cost until you switch back; check `/status`.

## See also

- [[pricing-token-usage]]
- [[model-output-configuration]]
- [[cost-context-optimization]]
