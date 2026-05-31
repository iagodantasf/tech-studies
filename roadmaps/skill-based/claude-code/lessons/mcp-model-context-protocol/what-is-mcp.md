---
title: What is MCP
track: claude-code
group: MCP (Model Context Protocol)
tags: [claude-code, mcp]
prerequisites: [built-in-tools-read-edit-bash-etc]
see-also: [adding-mcp-servers, stdio-vs-sse-http-servers, mcp-tools-resources-prompts]
---

# What is MCP

The Model Context Protocol is an open, JSON-RPC-based standard that lets Claude Code talk to external servers exposing **tools**, **resources**, and **prompts** — a universal plug for connecting the agent to your APIs, databases, and SaaS.

## Why it matters

The [[built-in-tools-read-edit-bash-etc|built-in tools]] cover the local repo and shell, but real work also lives in Jira, Postgres, Sentry, and internal services. MCP solves the M×N integration problem: instead of every client hand-coding an adapter for every service, a service ships *one* MCP server and every MCP-capable client (Claude Code, Claude Desktop, IDEs) can use it. Think "[[networking|LSP]] for agent tools" — one protocol, many implementations, reusable across hosts.

## How it works

MCP is a client–server protocol over JSON-RPC 2.0. Claude Code is the **host/client**; each configured integration is a **server** it spawns or connects to and handshakes with.

| Term | Meaning in Claude Code |
|---|---|
| Host | the app holding the model (Claude Code) |
| Client | per-server connection the host opens |
| Server | process exposing capabilities |
| Tool | model-callable action (a function) |
| Resource | read-only context (a file/record/URL) |
| Prompt | a reusable templated message/workflow |

- On startup the client opens each server, calls `initialize`, then lists capabilities (`tools/list`, `resources/list`, `prompts/list`).
- Tools surface to the model namespaced as `mcp__<server>__<tool>` — that exact name is what your [[allow-deny-rules]] must match.
- Transport is pluggable: local `stdio` or remote `SSE`/`HTTP`. See [[stdio-vs-sse-http-servers]].
- The model decides *when* to call a tool; Claude Code still gates the call through normal permissions before it runs.

## Example

A request like "what changed since the last deploy?" can fan across servers:

```text
mcp__github__list_commits   since=last-tag   → 12 commits
mcp__sentry__list_issues    env=prod         → 3 new errors
Read CHANGELOG.md                            → local context
```

One protocol, three independent servers (two remote, one built-in tool), composed in a single turn — no bespoke glue per service.

## Pitfalls

- **MCP is a capability surface, not a sandbox.** A server's tools run with whatever access you gave that server; vet third-party servers like dependencies.
- **It's not magic recall.** Resources are only seen if the model (or you, via `@`) actually pulls them in; merely connecting a server doesn't load its data.
- **Token cost of `tools/list`.** Every connected server's tool schemas sit in context each turn — dozens of tools quietly inflate the prompt.
- **Confusing MCP with model-side features.** MCP standardizes *transport of tools*; it doesn't change reasoning, and a flaky server just fails the call.

## See also

- [[adding-mcp-servers]]
- [[stdio-vs-sse-http-servers]]
- [[mcp-tools-resources-prompts]]
