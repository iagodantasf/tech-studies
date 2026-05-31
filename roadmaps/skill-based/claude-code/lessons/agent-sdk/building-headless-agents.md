---
title: Building Headless Agents
track: claude-code
group: Agent SDK
tags: [claude-code, automation]
prerequisites: [claude-agent-sdk-overview, permission-modes]
see-also: [headless-ci-usage, one-shot-print-mode-p, security-safe-tool-use]
---

# Building Headless Agents

A headless agent runs the SDK with no human in the loop, so permissions, turn limits, and budgets must be set up front rather than answered interactively.

## Why it matters

In CI, cron jobs, webhooks, and queue workers there is no terminal to approve a tool call — an agent that pauses on a permission prompt simply hangs the pipeline. Headless design is also where cost and safety bite hardest: an unbounded agent in a loop can burn dollars and touch production files unattended.

## How it works

The shift from interactive to headless is mostly about replacing prompts with policy, and a TTY with structured I/O.

- **Permissions become non-interactive.** Use `permissionMode: 'acceptEdits'` for write-capable jobs, or supply a `canUseTool` / `can_use_tool` callback to decide programmatically (allow/deny with a reason). `bypassPermissions` skips all checks — convenient and dangerous; see [[security-safe-tool-use]].
- **Bound the run.** Set `maxTurns` to cap agentic round-trips and `maxBudgetUsd` / `max_budget_usd` to stop at a dollar ceiling; the `result` message's `subtype` reports `error_max_turns` or `error_max_budget_usd`.
- **Isolate from local config.** Pass `settingSources: []` so a developer's `~/.claude` or stray `CLAUDE.md` can't leak into a deployed/multi-tenant agent.
- **Scope the toolset.** Prefer an explicit `allowedTools` allow-list over `bypassPermissions`. Read-only jobs get `["Read", "Glob", "Grep"]`.
- **Observe outcomes** by consuming the terminal message (`total_cost_usd`, `num_turns`, `is_error`) and logging it. This parallels the CLI's [[one-shot-print-mode-p]] and [[headless-ci-usage]].

## Example

A bounded, write-capable, isolated CI agent (TypeScript):

```typescript
const q = query({
  prompt: "Apply lint fixes and commit",
  options: {
    permissionMode: "acceptEdits",
    allowedTools: ["Read", "Edit", "Bash"],
    settingSources: [],          // ignore local ~/.claude config
    maxTurns: 12,
    maxBudgetUsd: 0.50,
  }
});
for await (const m of q)
  if (m.type === "result")
    process.exit(m.subtype === "success" ? 0 : 1);
```

## Pitfalls

- **Default mode blocks silently.** With `permissionMode: 'default'` a write tool waits for approval that never comes; the job appears to hang. Set an explicit mode.
- **No turn/budget cap = runaway.** A confused agent can loop until it exhausts the context or your balance. Always set `maxTurns` and a budget for unattended runs.
- **`bypassPermissions` in CI is a liability.** Combined with `Bash`, a prompt-injected instruction can run arbitrary commands. Allow-list specific tools instead.
- **Leaking local settings.** Forgetting `settingSources: []` means CI behavior depends on whatever happens to be in the runner's home dir — non-reproducible and a footgun.

## See also

- [[headless-ci-usage]]
- [[one-shot-print-mode-p]]
- [[security-safe-tool-use]]
