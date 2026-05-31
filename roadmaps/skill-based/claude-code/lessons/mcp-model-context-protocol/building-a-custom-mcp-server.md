---
title: Building a Custom MCP Server
track: claude-code
group: MCP (Model Context Protocol)
tags: [claude-code, mcp]
prerequisites: [mcp-tools-resources-prompts, stdio-vs-sse-http-servers]
see-also: [adding-mcp-servers, custom-tools-mcp-in-the-sdk, mcp-authentication-scopes]
---

# Building a Custom MCP Server

Writing your own [[what-is-mcp|MCP]] server with the official SDK to expose internal tools/resources to Claude Code — the minimal shape, the wiring, and the stdio rules that trip people up.

## Why it matters

The off-the-shelf servers cover popular SaaS, but your *internal* systems — a deploy API, a feature-flag service, a domain-specific query layer — have no public server. A 40-line custom server turns any function into a model-callable tool, reusable across every MCP client your team uses, with one auth and one schema instead of N bespoke integrations. It's the highest-leverage way to extend the agent past the local repo.

## How it works

The `@modelcontextprotocol/sdk` (TS) and `mcp` (Python, incl. `FastMCP`) handle the JSON-RPC; you register handlers and pick a transport.

- **Define a tool**: a name, a one-line description (the model's only doc), a JSON-Schema input, and an async handler returning content.
- **Transport**: `stdio` for a local child process (simplest — Claude spawns it); HTTP for a shared remote service. See [[stdio-vs-sse-http-servers]].
- **Wire it**: register with [[adding-mcp-servers|claude mcp add]] pointing at the launch command (stdio) or URL (HTTP).
- **Golden stdio rule**: JSON-RPC owns stdout — send *all* logs to **stderr**; a stray `print`/`console.log` corrupts the protocol stream.
- Inside the SDK you can also expose resources and prompts; for in-process tools defined *within* a host app, see [[custom-tools-mcp-in-the-sdk]].

## Example

A minimal Python stdio server with one tool:

```python
from mcp.server.fastmcp import FastMCP
mcp = FastMCP("deploy")

@mcp.tool()
def rollback(service: str, to_sha: str) -> str:
    """Roll a service back to a given commit SHA."""
    # ...call internal deploy API...
    return f"{service} rolled back to {to_sha}"

if __name__ == "__main__":
    mcp.run()  # stdio transport
```

Register it: `claude mcp add deploy -- python server.py`. The model can now call `mcp__deploy__rollback`, gated by your permissions and [[mcp-authentication-scopes|auth]].

## Pitfalls

- **Logging to stdout.** The #1 bug: any non-JSON byte on stdout breaks the stream. Log to stderr; test with the MCP Inspector before wiring into Claude.
- **Fat tool surface.** Exposing 30 fine-grained tools bloats every turn's `tools/list` context — design a few well-described, coarse tools.
- **No input validation.** Treat tool args as untrusted model output; validate against the schema and guard side effects.
- **Blocking the event loop.** A synchronous slow call freezes the whole server; do real I/O `async` and consider timeouts.

## See also

- [[adding-mcp-servers]]
- [[custom-tools-mcp-in-the-sdk]]
- [[mcp-authentication-scopes]]
