---
title: CLI Flags & Options
track: claude-code
group: CLI usage
tags: [claude-code, cli-flags]
prerequisites: [first-session-repl-basics]
see-also: [one-shot-print-mode-p, permission-modes, settings-json-hierarchy]
---

# CLI Flags & Options

The `claude` command takes a prompt plus a large set of flags that override session behaviour — model, permissions, tools, output format, and scope — for that invocation only.

## Why it matters

Flags are the per-run escape hatch above [[settings-json-hierarchy|settings.json]]: the same binary can be an interactive REPL, a locked-down CI worker, or a budget-capped batch job depending on the flags you pass. Knowing the real flag set keeps you from inventing options (a common failure) and lets you script precise, reproducible runs.

## How it works

Flags fall into a few families. `claude --help` is authoritative; the high-value ones:

| Flag | Purpose |
|---|---|
| `-p`, `--print` | one-shot headless output (see [[one-shot-print-mode-p]]) |
| `-c`, `--continue` | resume the latest session in this dir |
| `-r`, `--resume [id]` | resume a specific session / picker |
| `--model <m>` | pick model: `opus`, `sonnet`, or a full id |
| `--permission-mode <m>` | `default`, `plan`, `acceptEdits`, `bypassPermissions` |
| `--allowedTools` / `--disallowedTools` | grant/deny tools, e.g. `"Bash(git *)" Edit` |
| `--tools <list>` | restrict the built-in tool set (`""` = none) |
| `--add-dir <dirs...>` | extend filesystem reach beyond cwd |
| `--mcp-config <files...>` | load extra MCP servers ([[what-is-mcp]]) |
| `--output-format <fmt>` | `text` / `json` / `stream-json` (print mode) |
| `--max-budget-usd <n>` | dollar ceiling (print mode) |

- Subcommands sit alongside flags: `claude mcp`, `claude config`, `claude doctor`, `claude update`, `claude install`.
- `--settings <file-or-json>` and `--setting-sources user,project,local` control which config layers load.
- `--dangerously-skip-permissions` bypasses *all* gating — sandbox-only.

## Example

```bash
# CI: review a PR diff, read-only, JSON out, cheap model, hard budget
claude -p "Review this diff for security issues" \
  --model sonnet \
  --allowedTools "Read Grep Glob" \
  --permission-mode plan \
  --output-format json --max-budget-usd 0.50
```

Every behaviour the run needs is pinned on the command line, so it reproduces identically in any environment.

## Pitfalls

- **Inventing flags.** Options like `--temperature` don't exist; check `claude --help` rather than guessing.
- **`--dangerously-skip-permissions` outside a sandbox.** It removes every guardrail — easy to wreck a working tree or exfiltrate data.
- **Flag vs settings confusion.** A flag wins for that run but doesn't persist; durable policy belongs in [[settings-json-hierarchy]].
- **`--allowedTools` quoting.** Patterns like `Bash(git *)` must be quoted or the shell globs them; mistakes silently widen or break grants.

## See also

- [[one-shot-print-mode-p]]
- [[permission-modes]]
- [[settings-json-hierarchy]]
