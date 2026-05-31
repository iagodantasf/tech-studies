---
title: JetBrains Integration
track: claude-code
group: IDE integrations
tags: [claude-code, jetbrains]
prerequisites: [installation-setup]
see-also: [terminal-vs-ide-workflow, diff-viewing-inline-edits, vs-code-extension]
---

# JetBrains Integration

A dedicated plugin that connects the Claude Code CLI to IntelliJ-family IDEs, adding IDE-native diffs, selection context, and live diagnostic sharing.

## Why it matters

JetBrains users get Claude Code's terminal-driven workflow plus the IDE's strengths: edits render in the real diff viewer, your current selection/tab is auto-shared, and the language server's lint and syntax errors stream to Claude as you type — so it sees the same red squiggles you do. Unlike VS Code there is no graphical chat panel; the plugin augments `claude` running in the integrated terminal, which makes the connection model (and its remote-dev caveat) the thing to get right.

## How it works

Install "Claude Code [Beta]" (plugin id `27310`) from the JetBrains Marketplace and fully restart the IDE. Supported across IntelliJ IDEA, PyCharm, WebStorm, PhpStorm, GoLand, Android Studio, and most other JetBrains IDEs. Then run `claude` in the IDE's integrated terminal and all integration features activate.

- **Quick launch / focus**: `Cmd+Esc` (Mac) or `Ctrl+Esc` (Win/Linux), or the Claude Code toolbar button.
- **File reference**: `Cmd+Option+K` (Mac) / `Alt+Ctrl+K` (Win/Linux) inserts a reference like `@src/auth.ts#L1-99`.
- **Diff viewing**: edits can render in the IDE's diff viewer instead of the terminal — toggled by Claude Code's diff-tool config, not a plugin setting. See [[diff-viewing-inline-edits]].
- **Selection & diagnostics**: the active selection/tab and lint/syntax errors are shared automatically; a `Read` deny rule blocks sharing for matching files (e.g. `.env`).
- **External terminal**: run `/ide` to attach a separately launched `claude` to the IDE.

Plugin settings live under **Settings -> Tools -> Claude Code [Beta]** — notably the **Claude command** (e.g. `claude`, an absolute path, or `npx @anthropic-ai/claude-code`) used to spawn the process.

## Example

In GoLand, select a function, press `Cmd+Option+K`, and ask "add table-driven tests". The prompt carries `@handler.go#L40-72`; the plugin renders Claude's new file in GoLand's diff viewer, and any `go vet` errors the IDE flags are passed back so Claude can self-correct. WSL2 users who hit "No available IDEs detected" must open WSL2 traffic through Windows Firewall (or switch to mirrored networking) — NAT blocks the IDE-to-CLI socket.

## Pitfalls

- **Remote Development installs in the wrong place.** The plugin must live on the **remote host** (Settings -> Plugin (Host)), not the local thin client, or nothing connects.
- **ESC won't interrupt Claude.** JetBrains terminals bind Escape to "move focus to editor"; uncheck that under Settings -> Tools -> Terminal so Esc cancels Claude instead.
- **Wrong working directory.** Launch `claude` from the project root, or it sees a different file set than the IDE and integration looks broken.
- **"command not found" on the icon.** The plugin can't locate `claude`; set its full path in plugin settings (for WSL, `wsl -d Ubuntu -- bash -lic "claude"`).

## See also

- [[terminal-vs-ide-workflow]]
- [[diff-viewing-inline-edits]]
- [[vs-code-extension]]
