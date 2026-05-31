---
title: MCP Authentication & Scopes
track: claude-code
group: MCP (Model Context Protocol)
tags: [claude-code, security]
prerequisites: [adding-mcp-servers, stdio-vs-sse-http-servers]
see-also: [security-safe-tool-use, allow-deny-rules, environment-variables]
---

# MCP Authentication & Scopes

How remote [[what-is-mcp|MCP]] servers authenticate Claude Code — env-injected tokens, custom headers, or interactive OAuth 2.0 — and how the OAuth **scopes** you grant cap what the server's tools may do.

## Why it matters

An MCP tool acts *as you* against a real backend; a query tool with a write scope can mutate production. Authentication proves who's connecting; scopes bound what that connection may do. The two combine with [[allow-deny-rules|local permission rules]] to form defense in depth: even an authenticated, broadly-scoped server should be locally allow-listed to specific tools. See [[security-safe-tool-use]].

## How it works

Local `stdio` servers inherit process credentials; remote servers authenticate per request.

| Method | Carried via | Best for |
|---|---|---|
| Env var | `-e KEY=${VAR}` at launch | stdio, static API keys |
| Header | `--header "Authorization: Bearer …"` | HTTP/SSE with a PAT |
| OAuth 2.0 | interactive browser flow + token store | hosted SaaS servers |

- **OAuth flow**: connecting (or running `/mcp` and choosing authenticate) opens a browser consent screen; Claude Code stores the resulting access/refresh tokens and refreshes them transparently. Use `/mcp` to re-auth or clear.
- **Scopes** are the permission strings the OAuth consent grants (e.g. `repo:read`, `issues:write`). The server can only do what the token's scopes allow — request the *minimum*.
- **Secrets hygiene**: prefer `${ENV_VAR}` expansion in config over literals; never commit tokens in `.mcp.json` (see [[environment-variables]]).
- Tools still pass through your permission mode and [[allow-deny-rules]] — auth ≠ auto-approve.

## Example

Least-privilege wiring of a hosted issue tracker:

```bash
# header-based PAT, read-only scope granted on the token itself
claude mcp add --transport http tracker \
  --header "Authorization: Bearer ${TRACKER_RO_TOKEN}" \
  https://mcp.tracker.example/mcp
```

Even with the token valid, you'd still `deny` any `mcp__tracker__delete_*` tool locally — so a leaked-broad token can't be weaponized through this client.

## Pitfalls

- **Over-broad scopes.** Granting `admin`/write when the task only reads is the classic foot-gun; an over-scoped token plus a confused-deputy prompt is real risk.
- **Tokens in committed config.** Literals in `.mcp.json` leak to everyone with repo access — use env expansion and rotate on exposure.
- **Assuming OAuth gates per-call.** OAuth authorizes the *connection*; per-action control is your local allow/deny rules, not the consent screen.
- **Stale/expired tokens look like "server down".** Failed refresh surfaces as connection errors in `/mcp`; re-authenticate before debugging the server.

## See also

- [[security-safe-tool-use]]
- [[allow-deny-rules]]
- [[environment-variables]]
