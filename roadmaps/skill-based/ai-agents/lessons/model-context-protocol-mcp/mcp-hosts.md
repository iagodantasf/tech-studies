---
title: MCP Hosts
track: ai-agents
group: Model Context Protocol (MCP)
tags: [ai-agents, mcp]
prerequisites: [model-context-protocol-mcp, agent-loop]
see-also: [mcp-client, mcp-servers]
---

# MCP Hosts

An MCP host is the user-facing application — Claude Desktop, an IDE, your agent — that owns the LLM, runs the [[agent-loop|loop]], and spawns one [[mcp-client|client]] per connected [[mcp-servers|server]].

## Why it matters

The host is where MCP meets the model: it aggregates tools from many servers into a single tool list, decides which the model sees, and enforces every security boundary the wire protocol does not. Capabilities a user grants (filesystem roots, network, approval prompts) live here, not in the server. Get the host wrong and a single malicious server can read every other server's data.

## How it works

The host is a **1-to-many** container: it manages a pool of clients, each holding exactly one server session. It merges their `tools/list` results, prefixes names to avoid collisions, and feeds the union into the model as [[anthropic-tool-use|tool definitions]].

- **Config** — hosts read a JSON map of servers to launch (command + args for `stdio`, or a URL for HTTP). Claude Desktop uses `claude_desktop_config.json`.
- **Approval / consent** — the host gates `tools/call` behind user confirmation (allow once / always / deny), since the model alone is not a trust boundary.
- **Sampling broker** — if a server requests `sampling/createMessage`, the host runs it against *its* model and may inject a human-in-the-loop check first.
- **Isolation** — clients should not see each other's traffic; the host is responsible for keeping server B from reading server A's results.

| Host owns | Server owns |
|---|---|
| The LLM + loop | Capability implementation |
| Tool aggregation & routing | Tool/resource schemas |
| User consent & secrets | Domain logic / side effects |

## Example

A host wiring two servers from config:

```json
{ "mcpServers": {
    "fs":  {"command":"npx","args":["@mcp/server-filesystem","/work"]},
    "gh":  {"command":"npx","args":["@mcp/server-github"],
            "env":{"GITHUB_TOKEN":"ghp_..."}} } }
```

The host spawns both, gets `read_file` + `create_issue`, and presents the model a 2-server union. A model call to `create_issue` triggers a host approval dialog before the [[mcp-client|client]] forwards the RPC.

## Pitfalls

- **No consent gate** — auto-approving `tools/call` lets a prompt-injected model delete files; always confirm side-effecting calls.
- **Secret leakage** — passing API keys as server `env` is fine, but logging full RPC traffic can spill them; redact.
- **Tool-name collisions** — two servers both exposing `search` confuse the model unless the host namespaces them (`gh.search`).
- **Unbounded tool count** — merging 20 servers floods the [[context-windows|context window]] with schemas; let users disable unused servers.

## See also

- [[mcp-client]]
- [[mcp-servers]]
