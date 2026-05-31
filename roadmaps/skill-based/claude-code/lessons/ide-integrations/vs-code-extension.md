---
title: VS Code Extension
track: claude-code
group: IDE integrations
tags: [claude-code, vs-code]
prerequisites: [installation-setup]
see-also: [diff-viewing-inline-edits, terminal-vs-ide-workflow, jetbrains-integration]
---

# VS Code Extension

The native graphical Claude Code panel for VS Code (and its forks), giving you @-mentions, inline diffs, plan review, and checkpoints without leaving the editor.

## Why it matters

For most VS Code users the extension — not the bare terminal — is the recommended way to run Claude Code: it surfaces proposed edits as real side-by-side diffs you can edit before accepting, auto-feeds your selection as context, and keeps multiple conversations in tabs. It ships the CLI inside it, so anything graphical can't do (`!` bash shortcut, tab completion, full slash-command set) is still one integrated terminal away. Knowing which half you're in saves a lot of "why doesn't this command exist" confusion.

## How it works

Install from the Extensions view (`Cmd/Ctrl+Shift+X`, search "Claude Code", publisher `anthropic.claude-code`), via `vscode:extension/anthropic.claude-code`, or from Open VSX for Cursor/Windsurf/Kiro. Requires VS Code **1.98.0+**. The Spark icon (editor toolbar, Activity Bar, status bar) opens the panel; sign in via browser on first launch.

- The panel is a real graphical chat — drag it to the secondary sidebar, primary sidebar, or editor area; it is not a terminal. Flip `claudeCode.useTerminal` to `true` for the CLI-style UI instead.
- Selection is shared automatically (footer shows "N lines"); `Option+K` / `Alt+K` inserts an @-mention like `@app.ts#5-10`. The eye-slash toggle hides a selection from Claude.
- `Cmd+Esc` / `Ctrl+Esc` toggles focus between editor and prompt box — it does not launch a new session.
- Extension and CLI share one history: continue a panel session in the terminal with `claude --resume`.
- Shared config lives in `~/.claude/settings.json` (permissions, hooks, MCP); VS-Code-only behavior lives under Extensions -> Claude Code. See [[settings-json-hierarchy]].

Key extension settings:

| Setting | Default | Effect |
|---|---|---|
| `useTerminal` | `false` | CLI mode instead of the panel |
| `initialPermissionMode` | `default` | `default`/`plan`/`acceptEdits`/`bypassPermissions` |
| `preferredLocation` | `panel` | `sidebar` (right) vs `panel` (tab) |
| `autosave` | `true` | save files before Claude reads/writes |

## Example

Select lines 2-3 in `auth.py`, press `Option+K`, and ask "tighten this". The prompt carries `@auth.py#2-3`; Claude proposes an edit shown as a side-by-side diff with a permission prompt. You tweak the proposed side directly, hit accept — Claude is told you modified it, so it won't assume the file matches its original draft. Later you hover an earlier message and pick "Rewind code to here" to revert the file while keeping the chat (see [[diff-viewing-inline-edits]]).

## Pitfalls

- **Expecting full CLI parity.** The panel exposes a *subset* of `/` commands; `!` bash shortcut and tab completion are CLI-only. Open the integrated terminal and run `claude` for those.
- **Spark icon missing.** It only shows in the editor toolbar when a *file* is open (a folder alone isn't enough), and never in Restricted Mode — use the status-bar "✱ Claude Code" instead.
- **`ANTHROPIC_API_KEY` ignored.** GUI-launched VS Code may not inherit your shell env; start it with `code .` from a terminal or sign in with your account.
- **`Cmd+Esc` dead on macOS Tahoe+.** The system Game Overlay grabs it; clear that shortcut or rebind `Claude Code: Focus input`.

## See also

- [[diff-viewing-inline-edits]]
- [[terminal-vs-ide-workflow]]
- [[jetbrains-integration]]
