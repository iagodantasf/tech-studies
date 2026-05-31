---
title: Headless / CI Usage
track: claude-code
group: Workflows & automation
tags: [claude-code, headless]
prerequisites: [one-shot-print-mode-p, allow-deny-rules]
see-also: [github-actions-integration, cost-context-optimization, security-safe-tool-use]
---

# Headless / CI Usage

Running Claude Code non-interactively — `claude -p` driven by a script, pipeline, or CI runner — so an agent can do real work with no human at the keyboard.

## Why it matters

CI runners, cron jobs, and git hooks have no TTY to approve prompts or read a TUI. Headless mode is how you wire Claude into automated triage, codegen, doc updates, and PR review at scale. The hard parts aren't the prompt — they're auth, permissions, determinism, cost ceilings, and exit codes, because a stalled or runaway agent in CI is invisible until the bill or the timeout arrives.

## How it works

Build on [[one-shot-print-mode-p]] and make every non-deterministic edge explicit:

| Concern | Lever |
|---|---|
| auth | `ANTHROPIC_API_KEY` env (not interactive login) |
| permissions | `--allowedTools` / `--permission-mode` (no prompts in CI) |
| parse-ability | `--output-format json`, read `.result` with `jq` |
| cost cap | `--max-budget-usd <n>` |
| resilience | `--fallback-model <m>` on overload |
| failure signal | non-zero exit on error (works under `set -e`) |

- No TTY means the workspace-trust dialog is skipped and tool prompts cannot be answered — an ungranted tool call stalls or is refused, so pre-grant with [[allow-deny-rules]] or pass `--dangerously-skip-permissions` only inside a sandbox.
- `--output-format stream-json` plus `--verbose` emits per-event JSON for live log streaming and post-hoc cost auditing.
- Persisted sessions accumulate on the runner; add `--no-session-persistence` for clean, stateless jobs.
- Pin `--model` explicitly so a default change upstream can't silently alter cost or behavior.

## Example

```bash
#!/usr/bin/env bash
set -euo pipefail
result=$(git diff --cached | claude -p \
  "Review this staged diff. If it leaks secrets or breaks the build, reply BLOCK:<reason>, else OK." \
  --model claude-sonnet-4-5 --allowedTools "Read,Grep,Glob" \
  --max-budget-usd 0.50 --output-format json | jq -r '.result')
case "$result" in BLOCK:*) echo "$result" >&2; exit 1 ;; esac
```

Read-only tools, a 50-cent ceiling, machine-readable output, and a non-zero exit that fails the pipeline on BLOCK.

## Pitfalls

- **Interactive login in CI.** OAuth needs a browser; CI must use `ANTHROPIC_API_KEY` (or a gateway var) or the run hangs.
- **No budget guard.** An agentic loop with tools can iterate for minutes — always set `--max-budget-usd` and a runner timeout.
- **Trusting prose exit semantics.** Don't grep stdout to decide pass/fail beyond a stable token; rely on the process exit code and JSON fields.
- **Secrets in logs.** `--verbose`/`stream-json` can echo tool inputs; mask the API key and avoid dumping env into prompts.

## See also

- [[github-actions-integration]]
- [[cost-context-optimization]]
- [[security-safe-tool-use]]
