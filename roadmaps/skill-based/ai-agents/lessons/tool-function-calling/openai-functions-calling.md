---
title: OpenAI Functions Calling
track: ai-agents
group: Tool / Function Calling
tags: [ai-agents, function-calling]
prerequisites: [llm-native-function-calling, api-requests]
see-also: [anthropic-tool-use, openai-assistant-api]
---

# OpenAI Functions Calling

OpenAI's implementation of [[llm-native-function-calling]] on the Chat Completions API: you pass `tools`, the model replies with `tool_calls`, and you return results as `role: "tool"` messages.

## Why it matters

It's the most widely-copied dialect — most OpenAI-compatible servers (vLLM, Together, Groq, LiteLLM) speak it, so learning it transfers broadly. The 2023 `functions`/`function_call` fields are **deprecated**; the current shape is `tools` (a list of `{type: "function", function: {...}}`) plus `tool_choice`.

## How it works

Each tool is a function with a JSON-Schema `parameters` block. The model returns one or more `tool_calls`, each with an `id`, a name, and `arguments` as a **JSON string** (you must `json.loads` it).

- **`tool_choice`** — `"auto"` (default), `"none"`, `"required"` (must call something), or `{"type":"function","function":{"name":"x"}}` to force a specific one.
- **The `tool_call_id` handshake** — every tool result message must echo the `tool_call_id` from the call. Mismatch or a missing result for any call in the turn is a 400 error.
- **`strict: true`** — opt into Structured Outputs so arguments are guaranteed to satisfy the schema (requires `additionalProperties: false` and all fields `required`).
- **Parallel calls** — on by default; set `parallel_tool_calls: false` to force one at a time.

| Field | Where | Note |
|---|---|---|
| `tools` | request | list of function schemas |
| `tool_calls` | response | `arguments` is a JSON **string** |
| `role: "tool"` | follow-up | must carry `tool_call_id` |

## Example

```python
resp = client.chat.completions.create(
  model="gpt-4o", messages=msgs, tools=tools, tool_choice="auto")
call = resp.choices[0].message.tool_calls[0]
args = json.loads(call.arguments)          # arguments is a string!
out  = run_tool(call.function.name, args)
msgs += [resp.choices[0].message,
         {"role":"tool","tool_call_id":call.id,"content":str(out)}]
# call the API again with the appended tool result
```

The newer **Responses API** uses `function_call` / `function_call_output` items instead, but the loop is identical.

## Pitfalls

- **Forgetting `arguments` is a string** — it's not a dict; parse it (and guard against invalid JSON despite `strict`).
- **Dropping the assistant `tool_calls` message** — you must append the model's call message *before* the tool result, or the next request 400s.
- **Partial results** — if the model made 3 calls you must return 3 results; one missing breaks the turn.
- **`strict` schema rules** — every property must be `required` and `additionalProperties:false`; optional fields are expressed via union with `null`.

## See also

- [[anthropic-tool-use]]
- [[openai-assistant-api]]
