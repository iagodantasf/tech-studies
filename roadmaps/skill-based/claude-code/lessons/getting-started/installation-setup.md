---
title: Installation & Setup
track: claude-code
group: Getting started
tags: [claude-code, setup]
prerequisites: [what-is-claude-code]
see-also: [authentication-api-keys, first-session-repl-basics, settings-json-hierarchy]
---

# Installation & Setup

Installing Claude Code means putting the `claude` CLI on your PATH, authenticating once, and running it from a project directory.

## Why it matters

Claude Code is a single local binary, not a service you point at a URL — so the install step also decides *where it can act*. Getting the working directory, Node version, and auth right up front avoids the two classic failures: "command not found" and an agent that can read your whole home folder because you launched it from `~`. A clean setup also makes the tool reproducible across a team and a CI runner.

## How it works

The recommended path is the native installer; npm is the cross-platform fallback.

| Method | Command | Notes |
|---|---|---|
| Native install | `curl -fsSL https://claude.ai/install.sh \| bash` | self-contained binary, auto-update |
| npm (global) | `npm install -g @anthropic-ai/claude-code` | needs Node.js 18+ |
| Windows | install script via PowerShell / WSL | WSL behaves like Linux |

- Verify with `claude --version` and `claude doctor` — the latter checks Node, PATH, install method, and auth health.
- **Run from the project root.** Claude treats the launch directory as the workspace; that directory and its subtree are what it reads and edits.
- First launch walks you through auth (see [[authentication-api-keys]]) and writes config under `~/.claude/`.
- Per-project state lives in `.claude/` (settings, commands) and a project [[claude-md-project-memory|CLAUDE.md]]; user-global config and `settings.json` sit in `~/.claude/` (see [[settings-json-hierarchy]]).
- `claude update` (native) pulls the latest version; npm installs update via npm.

## Example

A typical first run on macOS:

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude doctor          # green checks for Node, PATH, auth
cd ~/code/my-service   # the repo you want to work in
claude                 # opens the interactive REPL here
```

Because you `cd`'d into the repo first, Claude's Read/Edit/Bash all scope to `my-service`, not your entire home directory.

## Pitfalls

- **Launching from `~` or `/`.** The agent's filesystem reach is the launch directory's subtree — start it in the actual project, not your home folder.
- **`sudo npm install -g`.** Installing globally as root causes permission errors on update; fix npm's global prefix or use the native installer instead.
- **Stale Node.** npm installs silently misbehave on Node < 18; `claude doctor` flags it.
- **Expecting a background daemon.** There is none — `claude` is a foreground process per terminal; closing the terminal ends the session (resume it later, see [[resuming-continuing-sessions]]).

## See also

- [[authentication-api-keys]]
- [[first-session-repl-basics]]
- [[settings-json-hierarchy]]
