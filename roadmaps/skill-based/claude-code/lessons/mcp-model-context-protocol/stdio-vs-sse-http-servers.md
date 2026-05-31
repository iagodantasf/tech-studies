---
title: stdio vs SSE / HTTP Servers
track: claude-code
group: MCP (Model Context Protocol)
tags: [claude-code, mcp]
prerequisites: [adding-mcp-servers]
see-also: [what-is-mcp, mcp-authentication-scopes, building-a-custom-mcp-server]
---

# stdio vs SSE / HTTP Servers

The three [[what-is-mcp|MCP]] transports — local `stdio`, and remote `Streamable HTTP` / legacy `SSE` — and how the choice shapes auth, lifecycle, and where the server actually runs.

## Why it matters

Transport is the first decision when wiring a server, and it dictates everything downstream: a `stdio` server is a child process on your machine (no network, no auth headers, dies with the session), while HTTP/SSE servers are shared remote services needing tokens and tolerating reconnects. Pick wrong and you either expose a local-only tool to nobody, or try to bolt OAuth onto something that never needed it.

## How it works

Claude Code launches/connects per the configured transport and speaks JSON-RPC over it.

| Transport | Where it runs | How addressed | Auth |
|---|---|---|---|
| `stdio` | local child process | launch command | inherited env / none |
| `http` (Streamable) | remote service | URL endpoint | headers / OAuth |
| `sse` | remote (legacy) | URL endpoint | headers / OAuth |

- **stdio**: Claude spawns the process and pipes JSON-RPC over its `stdin`/`stdout`; the server's `stderr` is for logs only. Lowest latency, no ports, scoped to the host machine.
- **Streamable HTTP** is the current remote standard — a single endpoint that upgrades to streaming as needed; **SSE** is the older two-endpoint scheme kept for back-compat.
- Remote transports carry credentials in headers or via OAuth and survive flaky links by reconnecting; stdio just restarts the child.
- Choose with `--transport stdio|http|sse` in [[adding-mcp-servers|claude mcp add]] (`stdio` is implied when you pass a `-- command`).

## Example

Same logical "issues" capability, two ways:

```bash
# local: a process on THIS machine over stdio
claude mcp add issues -- node ./servers/issues.js

# remote: a hosted service over Streamable HTTP, with a token
claude mcp add --transport http issues \
  --header "Authorization: Bearer $LINEAR_TOKEN" \
  https://mcp.linear.app/mcp
```

The stdio variant needs no network and no secret-in-config; the HTTP variant is shareable and centrally updated but must authenticate every request.

## Pitfalls

- **Writing to stdout in a stdio server.** Any non-JSON-RPC byte on stdout corrupts the stream and breaks the connection — log to stderr only. See [[building-a-custom-mcp-server]].
- **Using legacy SSE for new work.** Prefer Streamable HTTP; SSE's separate message/stream endpoints are clunkier and being phased out.
- **Expecting stdio to be shared.** It's a local child process — teammates need their own install; it can't be a central service.
- **Localhost HTTP for "remote".** Pointing `http` at `localhost` works but you own the lifecycle and port; often a plain stdio command is simpler.

## See also

- [[what-is-mcp]]
- [[mcp-authentication-scopes]]
- [[building-a-custom-mcp-server]]
