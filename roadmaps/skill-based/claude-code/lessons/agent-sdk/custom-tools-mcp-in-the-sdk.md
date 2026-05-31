---
title: Custom Tools & MCP in the SDK
track: claude-code
group: Agent SDK
tags: [claude-code, mcp]
prerequisites: [python-sdk, what-is-mcp]
see-also: [building-a-custom-mcp-server, mcp-tools-resources-prompts, allow-deny-rules]
---

# Custom Tools & MCP in the SDK

The SDK lets you define tools as plain in-process functions and bundle them into an in-memory MCP server, so the agent can call your code with no separate process or transport.

## Why it matters

Built-in tools cover the filesystem and shell, but real agents need to hit *your* database, pricing engine, or internal API. Defining these as in-process tools avoids the overhead and ops burden of a [[stdio-vs-sse-http-servers]] subprocess — the handler is just a function call in the same runtime, sharing your connection pools and auth.

## How it works

You declare a tool (name, description, input schema, async handler), pass a list to a server factory, then register that server in options. The model invokes it through the standard [[what-is-mcp]] machinery.

- **TypeScript:** `tool(name, description, zodSchema, handler)` + `createSdkMcpServer({ name, version, tools })`. Schemas use Zod for typed, validated args.
- **Python:** the `@tool(name, description, input_schema)` decorator + `create_sdk_mcp_server(name, version, tools)`. Handlers are `async` and return `{"content": [{"type": "text", ...}]}`.
- **Wiring:** put the server under `mcpServers` / `mcp_servers`. The tool's fully-qualified name is `mcp__<server>__<tool>`; add that exact string to `allowedTools` to auto-approve it (see [[allow-deny-rules]]).
- **In-process vs external:** SDK MCP servers run in your process; you can *also* point `mcpServers` at external stdio/HTTP servers in the same config.

## Example

A Python calculator tool, exposed and pre-approved:

```python
from claude_agent_sdk import tool, create_sdk_mcp_server, ClaudeAgentOptions

@tool("add", "Add two numbers", {"a": float, "b": float})
async def add(args):
    return {"content": [{"type": "text", "text": f"Sum: {args['a'] + args['b']}"}]}

calc = create_sdk_mcp_server(name="calculator", version="1.0.0", tools=[add])
options = ClaudeAgentOptions(
    mcp_servers={"calc": calc},
    allowed_tools=["mcp__calc__add"],   # note the mcp__<server>__<tool> form
)
```

## Pitfalls

- **Wrong allow-list name.** It must be `mcp__calc__add`, not `add` or `calc.add`; a mismatch means the call still prompts or is denied.
- **Return shape matters.** Handlers must return the `{"content": [...]}` block list. Returning a bare string or `None` breaks the tool result and confuses the agent.
- **Handlers run with your privileges.** An in-process tool can touch anything your service can — validate inputs as carefully as you would a [[hooks-overview-lifecycle]] script; this is real attack surface.
- **Blocking I/O in an async handler stalls the loop.** Use async clients (or a thread pool); a synchronous DB call freezes message streaming.

## See also

- [[building-a-custom-mcp-server]]
- [[mcp-tools-resources-prompts]]
- [[allow-deny-rules]]
