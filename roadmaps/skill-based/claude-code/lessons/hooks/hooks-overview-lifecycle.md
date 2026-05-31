---
title: Hooks Overview & Lifecycle
track: claude-code
group: Hooks
tags: [claude-code, hooks]
prerequisites: [settings-json-hierarchy]
see-also: [pretooluse-posttooluse-hooks, userpromptsubmit-stop-hooks, writing-debugging-hook-scripts]
---

# Hooks Overview & Lifecycle

Hooks are user-defined shell commands that Claude Code runs automatically at fixed lifecycle events, turning "please always do X" into deterministic, non-LLM enforcement.

## Why it matters

Asking the model in [[claude-md-project-memory]] to "always run the linter" is a *suggestion* it may skip; a PostToolUse hook *guarantees* it. Hooks are how teams enforce formatting, block edits to protected files, inject context, gate dangerous commands, and emit notifications — all outside the model's discretion. Because they execute as your own shell user with your full permissions, they are powerful and a real security surface.

## How it works

Hooks live in `settings.json` (see [[settings-json-hierarchy]]) keyed by event, then matched by tool name. Each event fires its hooks; Claude Code feeds them JSON on **stdin** and reads their **exit code** and optional **JSON on stdout**.

| Event | Fires | Can block? |
|---|---|---|
| `PreToolUse` | before a tool runs | yes (deny the call) |
| `PostToolUse` | after a tool succeeds | no (feedback only) |
| `UserPromptSubmit` | when you submit a prompt | yes (reject prompt) |
| `Stop` | when the agent finishes replying | yes (force continue) |
| `SubagentStop` | when a subagent finishes | yes |
| `Notification` | on a permission/idle notice | no |
| `SessionStart` | session opens / resumes | no (inject context) |
| `PreCompact` | before context compaction | no |

- Control flow uses two channels: **exit code** (`0` ok, `2` = block with stderr shown to the model, other = non-blocking error) and **structured stdout JSON** (`{"decision": ...}`, `hookSpecificOutput`, `continue`, `systemMessage`).
- `matcher` selects which tools trigger a tool-scoped hook (e.g. `Edit|Write`, `Bash`, or `*`); non-tool events ignore it.
- Hooks at user / project / local tiers all run — they are additive, not overriding.
- Config is snapshotted at session start; edit `settings.json`, then `/hooks` or restart to reload.

## Example

A minimal `settings.json` that logs every Bash command before it runs:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{ "type": "command",
        "command": "jq -r '.tool_input.command' >> ~/.claude/bash.log" }]
    }]
  }
}
```

Each Bash call now appends its command line to a log file — zero model involvement, fires every time.

## Pitfalls

- **Hooks run with your privileges.** A malicious or buggy hook can delete files or exfiltrate data; review every hook before trusting a repo's settings.
- **Exit `2` is the only "block".** Returning `1` logs an error but lets the action proceed — a frequent surprise.
- **Stale config.** Editing `settings.json` mid-session has no effect until reload; the snapshot is taken once.
- **Slow hooks stall the turn.** Hooks run synchronously and share a 60 s default timeout; a hanging script blocks the agent.

## See also

- [[pretooluse-posttooluse-hooks]]
- [[writing-debugging-hook-scripts]]
- [[settings-json-hierarchy]]
