---
title: MCP Tools, Resources & Prompts
track: claude-code
group: MCP (Model Context Protocol)
tags: [claude-code, mcp]
prerequisites: [what-is-mcp]
see-also: [adding-mcp-servers, building-a-custom-mcp-server, built-in-slash-commands]
---

# MCP Tools, Resources & Prompts

The three things an [[what-is-mcp|MCP]] server can expose — **tools** (model-callable actions), **resources** (read-only context), and **prompts** (user-invoked templates) — and how each surfaces inside Claude Code.

## Why it matters

These three primitives map to three different control models, and conflating them is the most common MCP design error. Tools are *model-driven* (the agent decides to call them, so they can have side effects and need gating); resources are *context* (pulled in for reading); prompts are *user-driven* shortcuts. Knowing which primitive fits a capability decides whether it shows up as an `mcp__…` tool, an `@`-mention, or a `/` command — and whether it ever runs without your say-so.

## How it works

Each primitive has its own JSON-RPC methods and its own entry point in the UI.

| Primitive | Controlled by | Surfaces as | Side effects? |
|---|---|---|---|
| Tool | the model | `mcp__<srv>__<tool>` call | yes (gated) |
| Resource | the app/user | `@<srv>:<uri>` mention | no (read-only) |
| Prompt | the user | `/mcp__<srv>__<prompt>` | runs a workflow |

- **Tools** declare a name, description, and a JSON-Schema `inputSchema`; the model fills the args. They go through normal [[allow-deny-rules|permission rules]] before running.
- **Resources** are identified by URI (`postgres://…/orders`, `file://…`) via `resources/list` and fetched with `resources/read`; you bring them in with `@`-mentions, so they cost tokens only when used.
- **Prompts** are server-defined templated messages (with optional arguments) exposed as slash commands alongside [[built-in-slash-commands|built-ins]] — a portable way to ship a vetted workflow.
- `/mcp` lists a connected server's available tools, resources, and prompts.

## Example

A `db` server exposing all three:

```text
tool      mcp__db__run_query(sql)     → model calls it to answer "top 5 customers"
resource  @db:schema://public          → you paste the live schema into context
prompt    /mcp__db__explain-plan       → runs a canned EXPLAIN-and-analyze workflow
```

The model *chooses* `run_query` (and is gated on it); you *choose* to attach the schema resource and to fire the `explain-plan` prompt.

## Pitfalls

- **Modeling a read as a tool.** Exposing "get schema" as a tool forces a gated model call for pure context; a resource is cheaper and side-effect-free.
- **Vague tool descriptions.** The description *is* the model's only API doc — terse or ambiguous text leads to wrong/no calls.
- **Schema-less or loose `inputSchema`.** Missing constraints let the model pass garbage args; tight JSON Schema is your validation.
- **Forgetting resources aren't auto-loaded.** Listing a resource doesn't inject it — nothing happens until something `@`-mentions or reads it.

## See also

- [[adding-mcp-servers]]
- [[building-a-custom-mcp-server]]
- [[built-in-slash-commands]]
