---
title: Adding MCP Servers
track: claude-code
group: MCP (Model Context Protocol)
tags: [claude-code, mcp]
prerequisites: [what-is-mcp]
see-also: [stdio-vs-sse-http-servers, settings-json-hierarchy, mcp-authentication-scopes]
---

# Adding MCP Servers

How to register an [[what-is-mcp|MCP]] server with Claude Code — via `claude mcp add`, a JSON config, or project-shared `.mcp.json` — and pick the right scope so the right people get it.

## Why it matters

A server is useless until the client knows how to launch or reach it. Where you register it decides who gets it: a personal experiment shouldn't live in a committed file, and a team integration shouldn't be trapped on one laptop. Getting **scope** right is the difference between "works on my machine" and a reproducible, shared toolset that lands with the repo.

## How it works

The `claude mcp` subcommands manage servers; `--scope` controls persistence and sharing.

| Scope | Stored in | Visible to |
|---|---|---|
| `local` (default) | per-project user settings | you, this project |
| `user` | `~/.claude` | you, every project |
| `project` | `./.mcp.json` (committed) | the whole team |

- Add a local-command (stdio) server: `claude mcp add fs -- npx -y @modelcontextprotocol/server-filesystem ./` — everything after `--` is the launch command.
- Add a remote server: `claude mcp add --transport sse linear https://mcp.linear.app/sse` (or `--transport http`). See [[stdio-vs-sse-http-servers]].
- Pass secrets via `-e KEY=val` env flags or `--header "Authorization: Bearer …"`; prefer `${ENV_VAR}` expansion over literals (see [[mcp-authentication-scopes]]).
- Manage with `claude mcp list`, `claude mcp get <name>`, `claude mcp remove <name>`; the `/mcp` slash command shows live connection status inside a session.
- `project` scope writes `.mcp.json`; Claude **prompts for approval** the first time a repo's `.mcp.json` is seen, since it can launch arbitrary processes.

## Example

Register a team-shared GitHub server and a personal Postgres one:

```bash
# committed, whole team gets it
claude mcp add --scope project github \
  --transport http https://api.githubcopilot.com/mcp/

# personal, all your projects
claude mcp add --scope user pg \
  -e PGURL=$DATABASE_URL -- npx -y @bytebase/dbhub
```

The first lands in `.mcp.json` (review it in the PR); the second only ever touches your `~/.claude`.

## Pitfalls

- **Forgetting `--`.** Without the `--` separator, flags meant for the server get parsed by `claude` and the add fails or mis-binds.
- **Secrets in `.mcp.json`.** That file is committed — never inline a token; use `${VAR}` and document the env var. See [[settings-json-hierarchy]].
- **Approval fatigue / silent non-load.** A teammate who declines the `.mcp.json` trust prompt just won't have the server; "it's not showing up" is often an un-approved or crashed server — check `/mcp`.
- **Name collisions across scopes.** Two servers named `db` in different scopes are confusing; the more specific scope wins and the tools get one namespace.

## See also

- [[stdio-vs-sse-http-servers]]
- [[settings-json-hierarchy]]
- [[mcp-authentication-scopes]]
