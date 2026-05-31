---
title: Claude Agent SDK Overview
track: claude-code
group: Agent SDK
tags: [claude-code, agent-sdk]
prerequisites: [what-is-claude-code, authentication-api-keys]
see-also: [typescript-sdk, python-sdk, building-headless-agents]
---

# Claude Agent SDK Overview

The Agent SDK exposes the exact agent loop, built-in tools, and context management that power the Claude Code CLI as a Python and TypeScript library you embed in your own programs.

## Why it matters

When you want an agent inside a backend, a CI job, or a SaaS feature — not a human at a terminal — you reach for the SDK instead of [[interactive-mode]]. Unlike the raw Anthropic Client SDK, where you write the `while stop_reason == "tool_use"` loop yourself, the Agent SDK runs the loop for you: Claude reads files, runs Bash, edits code, and reports back. It is the supported path for [[github-actions-integration]], SRE bots, and domain agents (legal, finance, support).

## How it works

The SDK wraps a Claude Code subprocess; your code streams messages in and consumes typed messages out. The packages were **renamed from the "Claude Code SDK"** in v0.1.0:

| | Old | New |
|---|---|---|
| npm (TS/JS) | `@anthropic-ai/claude-code` | `@anthropic-ai/claude-agent-sdk` |
| PyPI (Python) | `claude-code-sdk` | `claude-agent-sdk` |
| Python options type | `ClaudeCodeOptions` | `ClaudeAgentOptions` |

- **Breaking default (v0.1.0):** the SDK no longer injects Claude Code's system prompt. You get a minimal prompt unless you pass `systemPrompt: { type: 'preset', preset: 'claude_code' }` — see [[cost-context-optimization]].
- **Auth** is API-key only: `ANTHROPIC_API_KEY`, or providers via `CLAUDE_CODE_USE_BEDROCK=1` / `CLAUDE_CODE_USE_VERTEX=1`. claude.ai subscription login is not permitted for third-party agents.
- Built-in tools ship ready to run: `Read`, `Write`, `Edit`, `Bash`, `Glob`, `Grep`, `WebSearch`, `WebFetch`. Add your own via [[custom-tools-mcp-in-the-sdk]].
- Everything from the CLI is here: [[what-are-subagents]], [[what-is-mcp]] servers, [[hooks-overview-lifecycle]] (as callbacks), permission modes, and resumable sessions.

## Example

A three-line bug-fixer that drives the full agent loop (TypeScript):

```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";
for await (const m of query({
  prompt: "Find and fix the bug in auth.ts",
  options: { allowedTools: ["Read", "Edit", "Bash"] }
})) console.log(m); // reads, diagnoses, edits — no tool loop written
```

## Pitfalls

- **Expecting CLI behavior out of the box.** Post-v0.1.0 the system prompt and (historically) settings differ from the CLI; an agent that "feels dumber" usually needs the `claude_code` preset.
- **Confusing it with the Client SDK or Managed Agents.** Client SDK = you run tools; Managed Agents = Anthropic hosts the loop+sandbox; Agent SDK = the loop runs *in your process* on *your* filesystem.
- **Forgetting it spawns Claude Code.** The Node/Python binary must be present (TS bundles it as an optional dep); locked-down containers may block the subprocess.

## See also

- [[typescript-sdk]]
- [[python-sdk]]
- [[building-headless-agents]]
