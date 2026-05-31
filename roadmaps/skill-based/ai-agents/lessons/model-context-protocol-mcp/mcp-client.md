---
title: MCP Client
track: ai-agents
group: Model Context Protocol (MCP)
tags: [ai-agents, mcp]
prerequisites: [model-context-protocol-mcp, mcp-hosts]
see-also: [mcp-servers, rest-api-knowledge]
---

# MCP Client

An MCP client is the protocol connector living inside a [[mcp-hosts|host]] that holds a single stateful session to one [[mcp-servers|server]] and translates host intent into JSON-RPC.

## Why it matters

The client is the strict 1:1 counterpart to a server: it owns the transport, the `initialize` handshake, request/response correlation by `id`, and lifecycle (reconnect, shutdown). Separating it from the host means the host can manage *N* servers by simply holding *N* clients, each a clean isolated channel — the unit that makes MCP's N+M integration math work.

## How it works

On startup the client sends `initialize` (its supported protocol version + client capabilities), receives the server's capabilities, then sends an `initialized` notification — only after that may it issue normal requests. It matches each response to its request via the JSON-RPC `id`, like correlating any async [[rest-api-knowledge|HTTP]] call.

- **Discovery** — calls `tools/list`, `resources/list`, `prompts/list` to learn what exists; may cache and listen for `list_changed` notifications.
- **Invocation** — turns a model's tool decision into a `tools/call` request and returns the `content` blocks to the host.
- **Reverse direction** — the client *handles* requests too: a server can send `sampling/createMessage` or `roots/list`, which the client routes back into the host.

| Direction | Example message | Kind |
|---|---|---|
| client → server | `tools/call` | request |
| server → client | `notifications/tools/list_changed` | notification |
| server → client | `sampling/createMessage` | request |

## Example

The minimal client lifecycle around one tool call:

```
client → server  {id:1, method:"initialize", params:{protocolVersion, capabilities}}
server → client  {id:1, result:{capabilities:{tools:{listChanged:true}}}}
client → server  {method:"notifications/initialized"}      # no id = notification
client → server  {id:2, method:"tools/call",
                  params:{name:"get_weather", arguments:{city:"Paris"}}}
server → client  {id:2, result:{content:[{type:"text", text:"14C"}]}}
```

Note `id:2` ties the result to that call — concurrent calls each carry a distinct id.

## Pitfalls

- **Calling before `initialized`** — issuing `tools/call` before the handshake completes is a protocol violation; wait for the notification.
- **Sharing one client across servers** — a client is bound to exactly one server; reuse breaks isolation and id correlation.
- **Ignoring `list_changed`** — a server can add/remove tools mid-session; a client caching the first `tools/list` forever goes stale.
- **Blocking on a hung server** — `stdio` reads can hang if the subprocess wedges; enforce timeouts and surface the error to the [[agent-loop|loop]].

## See also

- [[mcp-servers]]
- [[rest-api-knowledge]]
