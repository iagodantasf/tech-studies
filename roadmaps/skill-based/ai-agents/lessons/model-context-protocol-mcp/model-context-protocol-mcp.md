---
title: Model Context Protocol (MCP)
track: ai-agents
group: Model Context Protocol (MCP)
tags: [ai-agents, mcp]
prerequisites: [anthropic-tool-use, rest-api-knowledge]
see-also: [mcp-hosts, mcp-servers]
---

# Model Context Protocol (MCP)

MCP is an open protocol that standardizes how an agent app connects to external tools, data, and prompts — the "USB-C port for AI", so one integration works across every host.

## Why it matters

Before MCP, every app re-implemented every integration: an N×M problem where N hosts each glued themselves to M tools. MCP collapses this to N+M — write one [[mcp-servers|server]] for GitHub and it works in Claude Desktop, Cursor, and your own agent unchanged. It moves tool definitions *out* of your prompt code and behind a versioned wire contract, so a tool's owner can ship updates without you redeploying.

## How it works

MCP is **JSON-RPC 2.0** over a transport, with three roles: a [[mcp-hosts|host]] (the app), one [[mcp-client|client]] per connection inside it, and an [[mcp-servers|server]] exposing capabilities. A session opens with an `initialize` handshake that negotiates protocol version and capabilities.

Servers expose three primitive types:

| Primitive | Controlled by | Analogy |
|---|---|---|
| Tools | model | a POST endpoint the LLM may call |
| Resources | app | a GET-able file/record (by URI) |
| Prompts | user | a reusable templated message |

- **Tools** are the bridge to [[anthropic-tool-use|native function calling]]: the client fetches `tools/list`, the host injects them into the model, and a model call becomes a `tools/call` RPC.
- **Transports** — `stdio` (local subprocess, pipes) or **Streamable HTTP** (remote, with optional SSE for server→client streaming).
- The host can also offer servers a **sampling** callback (let a server ask the host's LLM) and **roots** (which directories the server may touch).

## Example

A host starting a local filesystem server, then a tool call:

```
host spawns: npx @modelcontextprotocol/server-filesystem /work
client → server  initialize {protocolVersion, capabilities}
server → client  result {capabilities:{tools:{}}}
client → server  tools/list
server → client  [{name:"read_file", inputSchema:{path:string}}, ...]
# model later decides to call it:
client → server  tools/call {name:"read_file", arguments:{path:"/work/a.md"}}
server → client  {content:[{type:"text", text:"..."}]}
```

## Pitfalls

- **Treating MCP as the agent loop** — it standardizes the *connection*, not reasoning or [[agent-loop|looping]]; the host still owns step caps and retries.
- **Trusting tool descriptions blindly** — a malicious server can put injection text in a tool `description` the model reads; treat servers as untrusted code.
- **Skipping capability negotiation** — calling `resources/read` against a server that only advertised `tools` is a protocol error; check the `initialize` result.

## See also

- [[mcp-hosts]]
- [[mcp-servers]]
