---
title: Built-in Slash Commands
track: claude-code
group: Slash commands
tags: [claude-code, repl]
prerequisites: [first-session-repl-basics]
see-also: [custom-slash-commands, managing-context-clear-compact, settings-json-hierarchy]
---

# Built-in Slash Commands

Built-in slash commands are REPL meta-commands (typed `/name` at the prompt) that control the *session itself* — context, model, auth, config — instead of sending text to the model.

## Why it matters

A slash command is intercepted by the client and never costs a model round-trip the way a prose request does, so `/clear` or `/model` is instant and free. They are the control plane of a session: without `/compact` and `/clear` your context window silently fills (see [[managing-context-clear-compact]]); without `/permissions` and `/model` you can't change how the agent behaves mid-task. Knowing the built-ins is the difference between fighting the REPL and steering it.

## How it works

Any line whose first non-space char is `/` is parsed locally; type `/` alone to open a fuzzy-searchable menu of every command (built-in + custom). Built-ins are grouped roughly by concern:

| Command | Effect |
|---|---|
| `/help` | list commands; `/status` shows version, model, account |
| `/clear` | wipe conversation context (fresh start) |
| `/compact` | summarize history to reclaim window space |
| `/context` | visualize token usage of the window; `/cost` shows $ |
| `/model` | switch model (see [[choosing-a-model]]) |
| `/config` | open settings TUI (see [[settings-json-hierarchy]]) |
| `/init` | scaffold a `CLAUDE.md` from the repo |
| `/memory` | edit memory files (see [[claude-md-project-memory]]) |
| `/permissions` | view/edit allow-deny rules ([[allow-deny-rules]]) |
| `/agents` | manage subagents ([[what-are-subagents]]) |
| `/mcp` | manage MCP servers ([[adding-mcp-servers]]) |
| `/hooks` | configure lifecycle hooks ([[hooks-overview-lifecycle]]) |
| `/add-dir` | grant access to another directory |
| `/resume` | reopen a past session ([[resuming-continuing-sessions]]) |

Others: `/login` `/logout`, `/vim`, `/doctor`, `/terminal-setup`, `/bug`, `/pr-comments`, `/review`. The exact set grows by version — `/help` is the source of truth.

## Example

```text
> /context        # 78k / 200k used — getting full
> /compact        # summarizes thread → drops to ~12k
> /model sonnet   # downshift for cheap bulk edits
> /clear          # done with this task, start clean
```

Four free, instant actions that would otherwise need a restart or burn tokens.

## Pitfalls

- **`/clear` is irreversible** — it discards context with no undo; use `/compact` if you might still need the history.
- **`/compact` is lossy.** The summary can drop a detail the agent needed; for a hard pivot prefer `/clear` plus a crisp re-brief.
- **Slash only at line start.** A `/` mid-sentence is literal text, not a command — handy, but easy to misjudge.
- **Built-in vs custom name clash.** A custom command can't shadow a built-in; pick distinct names (see [[custom-slash-commands]]).

## See also

- [[custom-slash-commands]]
- [[managing-context-clear-compact]]
- [[settings-json-hierarchy]]
