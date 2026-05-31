---
title: Resuming & Continuing Sessions
track: claude-code
group: CLI usage
tags: [claude-code, sessions]
prerequisites: [interactive-mode]
see-also: [managing-context-clear-compact, cli-flags-options, one-shot-print-mode-p]
---

# Resuming & Continuing Sessions

`--continue` and `--resume` reopen a previous conversation with its full history and context intact, instead of starting cold.

## Why it matters

A session holds the expensive part of any task: the codebase loaded into context, prior reasoning, and the thread of what you were doing. Closing the terminal or stepping away shouldn't discard it. Resume lets you pick a task back up tomorrow, recover after a crash, or branch an experiment from a known-good point — and in scripts it threads multi-step headless work across separate `-p` invocations.

## How it works

Claude Code persists each session to disk (under `~/.claude/`) keyed by a UUID and scoped to the project directory.

| Flag | Behaviour |
|---|---|
| `-c`, `--continue` | reopen the **most recent** session in this cwd |
| `-r`, `--resume` | open an interactive picker of past sessions |
| `-r <session-id>` | resume one specific session directly |
| `--fork-session` | resume but branch to a **new** id (original untouched) |
| `--session-id <uuid>` | start/attach a session with a chosen UUID |

- Resume restores the prior context window, so it counts against tokens immediately — a long history reloads as a large prompt.
- `--continue` is directory-scoped: run it from the same repo you started in, or it finds nothing.
- Works in print mode too: `claude -p --continue "next step"` chains scripted turns; `--fork-session` keeps a script from mutating a shared baseline.
- `--no-session-persistence` (print mode) opts out entirely for one-off stateless runs.

## Example

```bash
claude                      # session A: refactor auth, get halfway, quit
# …next morning, same repo…
claude --continue           # picks up A with all context restored
# explore a risky alternative without losing A:
claude --resume <id-of-A> --fork-session
```

The fork branches from A's exact state; if the experiment fails, A is still pristine.

## Pitfalls

- **Resuming stale context.** Old history may reference code that has since changed — the agent can act on an outdated mental model; `/clear` and re-orient if drift is large.
- **`--continue` from the wrong directory.** It's cwd-scoped; launching elsewhere silently starts fresh instead of resuming.
- **Token cost of long histories.** A huge transcript reloads as a huge prompt — prune with [[managing-context-clear-compact|/compact]] before resuming, or fork.
- **Forgetting `--fork-session`.** Resuming and continuing mutates that session; to keep a clean checkpoint, fork instead of editing in place.

## See also

- [[managing-context-clear-compact]]
- [[cli-flags-options]]
- [[one-shot-print-mode-p]]
