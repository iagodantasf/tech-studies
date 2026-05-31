---
title: OpenAI Assistant API
track: ai-agents
group: Tool / Function Calling
tags: [ai-agents, assistants-api]
prerequisites: [openai-functions-calling, short-term-memory]
see-also: [openai-functions-calling, model-context-protocol-mcp]
---

# OpenAI Assistant API

A higher-level, **stateful** OpenAI API that manages conversation threads, built-in tools, and an explicit run lifecycle so you don't hand-roll the [[agent-loop]] yourself.

## Why it matters

Plain [[openai-functions-calling]] is stateless — you resend the whole message array every turn and manage memory yourself. Assistants moves that server-side (threads persist, context is auto-truncated) and ships hosted tools (Code Interpreter, File Search/retrieval). Note: OpenAI has flagged Assistants for **deprecation in favor of the Responses API**, so treat it as legacy for new builds.

## How it works

Four primitives plus a polling loop: **Assistant** (config + tools), **Thread** (persistent conversation), **Message**, and **Run** (an execution of an assistant on a thread). A run moves through a status machine.

- **Statuses**: `queued → in_progress → requires_action → completed` (or `failed`/`cancelled`/`expired`). You **poll** the run (or stream) until it leaves `in_progress`.
- **`requires_action`** — when the assistant wants a *custom* function tool, the run pauses here; you read the tool calls, execute them, and POST `submit_tool_outputs`. Built-in tools (Code Interpreter, File Search) run server-side with no pause.
- **Threads auto-manage context** — old messages are truncated to fit the window, which is convenient but means token cost is **opaque** and not directly controllable.

| Primitive | Lifetime | Holds |
|---|---|---|
| Assistant | persistent | model, instructions, tools |
| Thread | persistent | message history |
| Run | one execution | status + tool-call requests |

## Example

```
asst = create_assistant(tools=[code_interpreter, my_fn])
thread = create_thread(); add_message(thread, "analyze sales.csv")
run = create_run(thread, asst)
while run.status in ("queued","in_progress","requires_action"):
    if run.status == "requires_action":
        outs = [run_tool(c) for c in run.required_action.tool_calls]
        submit_tool_outputs(run, outs)
    run = poll(run)              # ~0.5s interval
messages = list_messages(thread) # newest assistant reply on top
```

## Pitfalls

- **Building new on a deprecated API** — prefer the Responses API for greenfield; reserve Assistants for existing integrations.
- **Busy-poll cost** — tight polling burns rate limit; back off or use streaming events.
- **`submit_tool_outputs` must answer every call** — like raw function calling, missing one stalls the run until it `expires`.
- **Opaque billing** — server-side truncation and retrieval over uploaded files can quietly inflate token usage; watch [[token-based-pricing]].

## See also

- [[openai-functions-calling]]
- [[model-context-protocol-mcp]]
