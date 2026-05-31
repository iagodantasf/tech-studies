---
title: Creating MCP Servers
track: ai-agents
group: Model Context Protocol (MCP)
tags: [ai-agents, mcp]
prerequisites: [mcp-servers, basic-backend-development]
see-also: [mcp-hosts, anthropic-tool-use]
---

# Creating MCP Servers

Building an MCP server means declaring a few typed tools (or resources/prompts) with an SDK and choosing a transport — the official SDKs handle the JSON-RPC so you write only the handlers.

## Why it matters

Wrapping your internal API as a server is how you make it usable by *every* [[mcp-hosts|host]] at once instead of writing per-app glue. The work is small — a decorated function per tool — but the design choices (schema clarity, error shape, transport) determine whether the model uses your tool correctly. This is where [[basic-backend-development|backend skills]] meet [[anthropic-tool-use|function-calling]] design.

## How it works

With the Python SDK's `FastMCP`, each tool is a decorated function; type hints and the docstring become the `inputSchema` and the model-facing `description`. Run `stdio` for local use, Streamable HTTP for remote.

- **Schema from signature** — annotate params (`city: str`) so the SDK emits valid JSON-Schema; the docstring is prompt-engineering the model reads to decide *when* to call.
- **Return content** — return a string/structured block; the SDK wraps it in `content`. Raise or flag errors so the [[agent-loop|loop]] can recover.
- **Transport choice** — `mcp.run(transport="stdio")` for a subprocess host; HTTP when many clients connect over a network.
- **Test locally** — the MCP Inspector connects a throwaway [[mcp-client|client]] so you can call tools before wiring a real host.

| Decision | Tool | Resource | Prompt |
|---|---|---|---|
| Has side effects | yes | no | no |
| Model auto-invokes | yes | no | no |
| User picks it | no | no | yes |

## Example

A two-tool server in a dozen lines:

```python
from mcp.server.fastmcp import FastMCP
mcp = FastMCP("weather")

@mcp.tool()
def get_forecast(city: str) -> str:
    """Return today's forecast for a city. Use for weather questions."""
    return fetch_forecast(city)          # your existing API call

@mcp.resource("config://units")          # read-only, URI-addressed
def units() -> str:
    return "metric"

if __name__ == "__main__":
    mcp.run(transport="stdio")           # host launches this file
```

A host then adds `{"command":"python","args":["weather.py"]}` and the model sees `get_forecast`.

## Pitfalls

- **Vague descriptions** — "gets data" gives the model no signal on *when* to call; write the docstring as if it's the only instruction (it is).
- **Deep nested schemas** — many providers degrade on deeply nested args; keep parameters flat with explicit enums.
- **Unvalidated inputs** — model-supplied args are untrusted; validate before touching a [[database-queries|DB]] or shell, exactly as with raw [[llm-native-function-calling|function calling]].
- **Blocking the event loop** — long synchronous work in a `stdio` server stalls the single client; make slow handlers async.

## See also

- [[mcp-hosts]]
- [[anthropic-tool-use]]
