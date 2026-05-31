---
title: One-Shot / Print Mode (-p)
track: claude-code
group: CLI usage
tags: [claude-code, headless]
prerequisites: [interactive-mode]
see-also: [piping-input-output, cli-flags-options, headless-ci-usage]
---

# One-Shot / Print Mode (-p)

`claude -p "<prompt>"` runs a single non-interactive turn, prints the result to stdout, and exits — the headless mode that makes Claude Code scriptable.

## Why it matters

CI jobs, git hooks, cron, and shell pipelines can't sit at a REPL approving prompts. Print mode turns `claude` into a normal Unix filter: stdin → answer → stdout, with a clean exit code. It is the foundation for [[headless-ci-usage]], [[github-actions-integration]], and any glue script that needs a model in the loop without a human.

## How it works

`-p` / `--print` suppresses the TUI and emits only the final response. Key companions:

| Flag | Effect |
|---|---|
| `--output-format text` | plain text (default) |
| `--output-format json` | one JSON result object (cost, usage, session_id) |
| `--output-format stream-json` | newline-delimited events as they arrive |
| `--input-format stream-json` | feed turns in as a JSON stream |
| `--max-budget-usd <n>` | hard dollar cap (print mode only) |
| `--fallback-model <m>` | switch model if primary is overloaded (print mode only) |

- The workspace-trust dialog is **skipped** in `-p` (and whenever stdout isn't a TTY), so only run it in directories you trust.
- Tools still obey [[permission-modes]]; with no human to approve, pair `-p` with explicit [[allow-deny-rules]] (`--allowedTools`) or it will refuse gated actions.
- Sessions still persist by default (resumable with `-r`); add `--no-session-persistence` for stateless runs.

## Example

```bash
# Generate a commit message from the staged diff, machine-readable
git diff --cached | claude -p "Write a conventional-commit subject line" \
  --output-format json --allowedTools "" \
  | jq -r '.result'
```

`--allowedTools ""` disables tools (pure text task, no shell access needed); `jq` extracts just the text from the JSON envelope. Exit code is non-zero on failure, so it's safe in a `set -e` script.

## Pitfalls

- **Expecting tool actions without permissions.** Headless + default permissions = the agent asks, gets no answer, and stalls or skips. Grant tools explicitly.
- **Parsing `text` output in scripts.** Prose format drifts; use `--output-format json` and `jq` for anything programmatic.
- **No budget guard.** A runaway agentic loop in CI burns tokens — set `--max-budget-usd`.
- **Trust dialog silently off.** `-p` skips the safety prompt; never point it at an untrusted checkout.

## See also

- [[piping-input-output]]
- [[cli-flags-options]]
- [[headless-ci-usage]]
