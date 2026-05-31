---
title: Built-in Tools (Read, Edit, Bash, etc.)
track: claude-code
group: Tools & permissions
tags: [claude-code, tools]
prerequisites: [first-session-repl-basics]
see-also: [permission-modes, allow-deny-rules, frontmatter-allowed-tools]
---

# Built-in Tools (Read, Edit, Bash, etc.)

The fixed set of native capabilities — file I/O, shell, search, web, task delegation — that Claude Code invokes to actually *do* things rather than just describe them.

## Why it matters

A language model alone can only emit text; the built-in tools are what let it read your repo, patch a file, run your tests, and report back. Every permission rule, hook, and subagent config is ultimately about *which of these tools* may fire and on *what arguments* — so knowing the exact tool names (the ones [[allow-deny-rules]] and [[frontmatter-allowed-tools]] match against) is foundational. Get the names wrong and your allowlist silently matches nothing.

## How it works

Each turn the model may emit one or more tool calls; Claude Code checks them against [[permission-modes]] and rules, runs the allowed ones, and feeds results back. The core tools:

| Tool | Does | Gated by default? |
|---|---|---|
| `Read` | read a file (text, images, PDFs, notebooks) | no |
| `Edit` / `MultiEdit` | exact-string / batched edits to a file | yes |
| `Write` | create or overwrite a file | yes |
| `Bash` | run a shell command in a persistent session | yes |
| `Glob` | filename pattern match (`src/**/*.ts`) | no |
| `Grep` | content search (ripgrep under the hood) | no |
| `WebFetch` / `WebSearch` | fetch a URL / search the web | yes / yes |
| `Task` | spawn a subagent (see below) | yes |
| `TodoWrite` | maintain the in-session task list | no |

- Read-only tools (`Read`, `Glob`, `Grep`) generally run without prompting; mutating ones (`Edit`, `Write`, `Bash`) prompt unless pre-approved.
- `Bash` reuses one shell, so `cd` and exported vars persist across calls within a session.
- `Task` hands a scoped sub-job to a [[what-are-subagents]] agent with its own context window, keeping the main thread lean.
- Rules can scope by argument, not just tool: `Bash(git push:*)` differs from `Bash(rm:*)`. See [[allow-deny-rules]].
- `/permissions` lists the current tool set and active allow/deny rules; MCP adds more tools as `mcp__<server>__<tool>`.

## Example

A single "add a test and run it" request might fan out to:

```text
Glob  tests/**/*_test.py        → finds test layout      (no prompt)
Read  tests/test_auth.py        → reads existing style    (no prompt)
Write tests/test_login.py       → PROMPT: create file?
Bash  pytest tests/test_login.py -q → PROMPT: run command?
```

Three reads/searches run free; the two mutations ask once each — or run silently if `Write` and `Bash(pytest:*)` are already on the allowlist.

## Pitfalls

- **Wrong tool name in a rule.** It's `Bash`, `Edit`, `WebFetch` — case-sensitive. `bash` or `Shell` matches nothing and your prompt is never suppressed.
- **Forgetting MCP namespacing.** External tools are `mcp__github__create_pr`, not `create_pr`; allowlisting the bare name fails.
- **Assuming `Edit` can create files.** `Edit` needs the file to exist (and to have been Read); use `Write` for new files.
- **`Bash` is the wide door.** Almost anything is reachable through a shell, so a broad `Bash(*)` allow effectively undoes finer rules — gate it narrowly.

## See also

- [[permission-modes]]
- [[allow-deny-rules]]
- [[frontmatter-allowed-tools]]
