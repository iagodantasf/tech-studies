---
title: Anthropic Tool Use
track: ai-agents
group: Tool / Function Calling
tags: [ai-agents, tool-use]
prerequisites: [llm-native-function-calling, api-requests]
see-also: [openai-functions-calling, model-context-protocol-mcp]
---

# Anthropic Tool Use

Claude's implementation of [[llm-native-function-calling]]: you pass `tools` with an `input_schema`, and Claude responds with `tool_use` content blocks that you answer using `tool_result` blocks.

## Why it matters

It's the dialect behind Claude-based agents and the conceptual parent of [[model-context-protocol-mcp]] (MCP tools surface to the model as exactly this shape). The mechanics differ enough from OpenAI that porting code requires care: arguments arrive as a **parsed object** (not a JSON string), and results go back as user-turn content blocks, not a separate `tool` role.

## How it works

A response is a list of content blocks. When Claude wants a tool, one block has `type: "tool_use"` with an `id`, `name`, and `input` (already-parsed JSON). The API also sets `stop_reason: "tool_use"` — your signal to run tools and continue.

- **Returning results** — append a **user** message whose content is one or more `tool_result` blocks, each with `tool_use_id` matching the call. Set `is_error: true` to report a failure Claude can recover from.
- **`tool_choice`** — `{"type":"auto"}` (default), `{"type":"any"}` (must use some tool), `{"type":"tool","name":"x"}` (force one), or `{"type":"none"}`.
- **Parallel** — Claude may emit multiple `tool_use` blocks in one turn; return all `tool_result`s in a single following message.
- **Server-side & MCP tools** — Anthropic also offers hosted tools (web search, code execution) and an MCP connector, all expressed through the same loop.

| OpenAI | Anthropic |
|---|---|
| `tool_calls` | `tool_use` content block |
| `arguments` (string) | `input` (parsed object) |
| `role: "tool"` msg | `tool_result` block in a user msg |

## Example

```python
msg = client.messages.create(model="claude-...", tools=tools, messages=msgs)
if msg.stop_reason == "tool_use":
    tu = next(b for b in msg.content if b.type == "tool_use")
    out = run_tool(tu.name, tu.input)         # input is already a dict
    msgs += [{"role":"assistant","content":msg.content},
             {"role":"user","content":[{
                 "type":"tool_result","tool_use_id":tu.id,
                 "content":str(out)}]}]
# call messages.create again
```

## Pitfalls

- **Treating `input` like OpenAI's string** — it's already parsed; don't `json.loads` it.
- **Wrong role for results** — `tool_result` goes in a **user** message, not an assistant/tool role; getting this wrong throws a 400.
- **Echo the assistant turn** — you must re-send the assistant message containing the `tool_use` block before the result, preserving full block order.
- **Forgetting `is_error`** — silently returning an error string as success confuses recovery; flag failures so Claude retries sensibly.

## See also

- [[openai-functions-calling]]
- [[model-context-protocol-mcp]]
