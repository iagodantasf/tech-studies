---
title: What is Claude Code
track: claude-code
group: Getting started
tags: [claude-code, overview]
prerequisites: []
see-also: [installation-setup, first-session-repl-basics, built-in-tools-read-edit-bash-etc]
---

# What is Claude Code

Claude Code is Anthropic's agentic coding tool that runs in your terminal, reads and edits files in your repo, runs shell commands, and drives multi-step tasks under your control.

## Why it matters

Most "AI coding" lives inside an editor's autocomplete and only sees the open file. Claude Code instead operates on the *whole working tree* like a junior engineer at a keyboard: it greps the codebase, opens files, edits them, runs the test suite, reads the failure, and iterates — all in one loop. It is unopinionated about your stack and composable (pipe to it, script it, run it in CI), so it fits Makefiles, git hooks, and existing tooling rather than replacing them.

## How it works

You install one CLI, `claude`, and run it from a project root. It speaks to Anthropic's models (Claude Opus / Sonnet / Haiku) over the API and acts through a fixed set of **built-in tools** (see [[built-in-tools-read-edit-bash-etc]]):

- **Read / Edit / Write** — view and modify files on disk.
- **Bash** — run shell commands (tests, builds, git), gated by permissions.
- **Grep / Glob** — search code without you naming the file.
- **Task** — spin up [[what-are-subagents|subagents]] for parallel sub-jobs.

Surrounding the core loop are the features the rest of this track covers:

| Layer | What it gives you | Lesson |
|---|---|---|
| Memory | persistent project context | [[claude-md-project-memory]] |
| Slash commands | reusable prompts | [[built-in-slash-commands]] |
| Permissions | which tools may run unattended | [[permission-modes]] |
| Hooks | shell callbacks on lifecycle events | [[hooks-overview-lifecycle]] |
| MCP | external tools/data servers | [[what-is-mcp]] |
| Agent SDK | embed the same loop in your code | [[claude-agent-sdk-overview]] |

It runs interactively (a REPL) or headless (`-p` for one-shot/print, scriptable into pipelines).

## Example

In a repo with a failing test you type: `fix the failing test in payments`. Claude greps for the test, Reads it and the source, proposes an Edit, asks permission to run `pytest`, sees the traceback, patches again, and re-runs until green — pausing for your approval on each Bash call unless you've granted it. You reviewed every change; you never left the terminal.

## Pitfalls

- **It is not an autocomplete.** Treating it like Copilot (one file, one suggestion) wastes its main strength: repo-wide, multi-step work.
- **It acts on your real filesystem and shell.** Without thoughtful [[allow-deny-rules]] it can run destructive commands; review permissions before unattended use.
- **Context is finite.** Large repos overflow the window; lean on [[claude-md-project-memory]], [[claudeignore-file-scoping]], and `/compact` instead of dumping everything.
- **Output is non-deterministic.** The same prompt can yield different edits run to run — always review the diff, never blind-merge.

## See also

- [[installation-setup]]
- [[first-session-repl-basics]]
- [[built-in-tools-read-edit-bash-etc]]
