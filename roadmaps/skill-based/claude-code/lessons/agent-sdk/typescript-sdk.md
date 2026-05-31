---
title: TypeScript SDK
track: claude-code
group: Agent SDK
tags: [claude-code, agent-sdk]
prerequisites: [claude-agent-sdk-overview]
see-also: [python-sdk, programmatic-sessions-streaming, custom-tools-mcp-in-the-sdk]
---

# TypeScript SDK

The `@anthropic-ai/claude-agent-sdk` package exposes a single async-generator `query()` function plus helpers for tools, MCP, and runtime control, all strongly typed.

## Why it matters

Node/TypeScript is the default for web backends, Lambdas, and CI scripts, so this is the most common way to embed Claude Code. Full typings on `Options`, `SDKMessage`, and `PermissionMode` mean misconfigured tools or modes fail at compile time, not at runtime in production.

## How it works

`query()` returns a `Query` — an `AsyncGenerator<SDKMessage, void>` that also carries control methods. You iterate messages; you call methods to steer mid-run.

```typescript
function query({ prompt, options }: {
  prompt: string | AsyncIterable<SDKUserMessage>;
  options?: Options;
}): Query;
```

- **`Options` essentials:** `systemPrompt`, `model`, `allowedTools` / `disallowedTools`, `permissionMode`, `maxTurns`, `mcpServers`, `hooks`, `canUseTool`, `cwd`, `resume`, `continue`, `settingSources`, `agents`, `abortController`, `maxBudgetUsd`.
- **`Query` control methods** (work in streaming-input mode): `interrupt()`, `setPermissionMode(mode)`, `setModel(model)`, `streamInput(stream)`, `close()`.
- **`permissionMode`** is one of: `'default'`, `'acceptEdits'`, `'bypassPermissions'`, `'plan'`. Maps to [[permission-modes]].
- **Message stream** is a union `SDKMessage`; branch on `message.type`. The terminal `SDKResultMessage` (`type: "result"`) carries `total_cost_usd`, `num_turns`, `duration_ms`, and `usage`.
- Install: `npm install @anthropic-ai/claude-agent-sdk`. A native Claude Code binary ships as an optional dependency, so no separate CLI install is needed.

## Example

Read the result and cost from a one-shot run:

```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";

const q = query({
  prompt: "Summarize README.md in 3 bullets",
  options: { allowedTools: ["Read"], maxTurns: 3 }
});
for await (const m of q) {
  if (m.type === "result")
    console.log(m.subtype, `$${m.total_cost_usd}`, `${m.num_turns} turns`);
}
```

## Pitfalls

- **`interrupt()` only works with streaming input.** Pass an `AsyncIterable<SDKUserMessage>` (not a plain string) or the control channel is inert — see [[programmatic-sessions-streaming]].
- **Iterate to completion or you leak the subprocess.** Breaking early without `q.close()` (or an `abortController`) can orphan the Claude Code child process.
- **`allowedTools` ≠ enabling tools.** It auto-approves [[allow-deny-rules]]; the tool must still be available. MCP tools need their `mcp__server__tool` name.
- **No top-level `await`?** `for await` must sit inside an `async` function or an ESM module configured for it.

## See also

- [[python-sdk]]
- [[programmatic-sessions-streaming]]
- [[custom-tools-mcp-in-the-sdk]]
