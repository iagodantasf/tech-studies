---
title: MCP Servers
track: ai-agents
group: Model Context Protocol (MCP)
tags: [ai-agents, mcp]
prerequisites: [model-context-protocol-mcp, mcp-client]
see-also: [creating-mcp-servers, mcp-hosts]
---

# MCP Servers

An MCP server is a standalone process that exposes a focused set of capabilities — tools, resources, and prompts — over the protocol, so any [[mcp-hosts|host]] can use them without bespoke code.

## Why it matters

Servers are the reusable half of MCP's N+M math: one well-built GitHub or Postgres server serves every host that speaks the protocol. They let the *integration owner* (often a vendor) ship and version the connector, moving glue code out of each agent. A healthy ecosystem already covers filesystem, Git, Slack, Sentry, and databases as off-the-shelf servers.

## How it works

A server advertises which of the three primitives it supports during the `initialize` handshake, then answers `list` / `call` / `read` requests from the [[mcp-client|client]].

| Primitive | List → Use | Who triggers it |
|---|---|---|
| Tools | `tools/list` → `tools/call` | the model |
| Resources | `resources/list` → `resources/read` | the app, by URI |
| Prompts | `prompts/list` → `prompts/get` | the user, explicitly |

- **Tools** carry an `inputSchema` (JSON-Schema) and return `content` blocks; this is what surfaces to [[anthropic-tool-use|native function calling]].
- **Resources** are read-only, addressed by URI (`file:///work/a.md`, `db://orders/42`) — context the host pulls in, not actions.
- **Prompts** are user-invoked templates (e.g. a `/summarize` slash command), distinct from tools the model auto-selects.
- **Transport** — a `stdio` server reads/writes JSON-RPC over pipes (local, one client); an HTTP server listens on a URL and can serve many clients remotely.
- Servers may call **back** to the host for sampling (asking the host's LLM) or roots, but only if the host advertised those capabilities.

## Example

A "weather" server's advertised surface and a call:

```
initialize → capabilities: { tools:{}, resources:{} }
tools/list → [{ name:"get_forecast",
                inputSchema:{ type:"object",
                  properties:{ city:{type:"string"} }, required:["city"] } }]
tools/call {name:"get_forecast", arguments:{city:"Paris"}}
        → { content:[{type:"text", text:"Paris: 14C, light rain"}],
            isError:false }
```

## Pitfalls

- **Tool/resource confusion** — exposing a read as a tool forces the model to "call" for data it could just be handed; reads belong in resources.
- **Leaky errors** — returning raw stack traces in `content` feeds noise to the model; set `isError:true` with a terse, recoverable message.
- **Over-broad surface** — a server granting `run_sql(arbitrary)` is a SQL-injection and exfiltration vector; scope tools narrowly.
- **Unpinned dependencies** — a server auto-updated via `npx` latest can change tool behavior under a stable host; pin versions.

## See also

- [[creating-mcp-servers]]
- [[mcp-hosts]]
