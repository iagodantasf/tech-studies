---
title: Programmatic Sessions & Streaming
track: claude-code
group: Agent SDK
tags: [claude-code, streaming]
prerequisites: [typescript-sdk, python-sdk]
see-also: [resuming-continuing-sessions, building-headless-agents, managing-context-clear-compact]
---

# Programmatic Sessions & Streaming

The SDK streams typed messages as the agent works and lets you keep, resume, or fork the underlying session so context survives across separate calls.

## Why it matters

A real agent UI needs to render partial output, show which tool is running, and let a user interrupt — none of which a blocking "wait for the final string" call supports. Sessions are how a multi-step job ([[multi-step-agentic-tasks]]) continues tomorrow with full memory of files already read, instead of re-paying to re-read them.

## How it works

Two independent axes: **how output flows** (always streamed) and **how input flows** (single prompt vs. streaming input).

- **Output streaming.** Both `query()` (TS) and `query()` / `receive_response()` (Py) yield messages incrementally: assistant text, tool-use, tool-result, then a terminal `result`/`ResultMessage`. Branch on type to drive a UI.
- **Streaming input** unlocks the live control channel. In TS, pass `prompt` as an `AsyncIterable<SDKUserMessage>` (or call `query.streamInput(...)`); only then do `interrupt()` and `setPermissionMode()` take effect. In Python, use `ClaudeSDKClient` and feed turns with `client.query(...)`.
- **Session identity.** The `init` system message carries a `session_id`. Persist it.

| Goal | TypeScript option | Python option |
|---|---|---|
| Resume a specific session | `resume: "<id>"` | `resume="<id>"` |
| Continue the latest session | `continue: true` | `continue_conversation=True` |
| Branch without mutating original | `forkSession: true` | `fork_session=True` |

- Sessions persist as JSONL on your filesystem, mirroring [[resuming-continuing-sessions]] in the CLI.

## Example

Capture a session id, then resume it with full context (TypeScript):

```typescript
let id: string | undefined;
for await (const m of query({ prompt: "Read the auth module",
                              options: { allowedTools: ["Read", "Glob"] } })) {
  if (m.type === "system" && m.subtype === "init") id = m.session_id;
}
for await (const m of query({ prompt: "Now find every caller",
                              options: { resume: id } })) {
  if (m.type === "result") console.log(m.result);
}
```

## Pitfalls

- **`interrupt()` silently no-ops with a string prompt.** The control channel exists only in streaming-input mode; single-prompt `query()` cannot be interrupted.
- **Resuming is not free.** It replays prior context into the window — cheaper than redoing work, but it still consumes tokens; compact long sessions (see [[managing-context-clear-compact]]).
- **`continue` is "most recent in this cwd".** Run from a different directory and you may continue the wrong session, or none. Prefer an explicit `resume` id for reliability.
- **Forking, not branching in place.** Without `forkSession`/`fork_session`, a resumed session appends to the original history.

## See also

- [[resuming-continuing-sessions]]
- [[building-headless-agents]]
- [[managing-context-clear-compact]]
