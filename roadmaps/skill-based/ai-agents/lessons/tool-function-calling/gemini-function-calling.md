---
title: Gemini Function Calling
track: ai-agents
group: Tool / Function Calling
tags: [ai-agents, function-calling]
prerequisites: [llm-native-function-calling, api-requests]
see-also: [openai-functions-calling, anthropic-tool-use]
---

# Gemini Function Calling

Google Gemini's take on [[llm-native-function-calling]]: you declare `function_declarations`, Gemini replies with a `functionCall` part, and you answer with a `functionResponse` part.

## Why it matters

It's the dialect for Gemini-based agents (AI Studio and Vertex AI), and it bakes in two things the others bolt on: a built-in **automatic function calling** mode in the Python SDK (pass real Python functions; the SDK runs the loop for you), and first-class **modes** that force or suppress calling. Schemas use a subset of the **OpenAPI 3.0** spec rather than raw JSON-Schema.

## How it works

Content is a list of **parts**. When Gemini wants a tool, a part contains a `functionCall` with `name` and `args` (a parsed object). You reply by sending a `functionResponse` part carrying the result back into the conversation.

- **`function_calling_config.mode`** — `AUTO` (model decides), `ANY` (must call; optionally restrict to `allowed_function_names`), or `NONE` (text only).
- **Automatic mode (Python SDK)** — give the SDK callable functions and it intercepts `functionCall`, executes, and resends the `functionResponse` without you writing the loop. Disable it for manual control.
- **Parallel & compositional** — Gemini supports multiple `functionCall` parts at once, and *compositional* calling where one call's output feeds the next.
- **Schema** — OpenAPI 3.0 subset: `type`, `properties`, `required`, `enum`; some JSON-Schema keywords are unsupported.

| OpenAI | Gemini |
|---|---|
| `tool_calls` | `functionCall` part |
| `arguments` (string) | `args` (parsed object) |
| `tool_choice: required` | `mode: ANY` |

## Example

```python
# manual loop
resp = model.generate_content(prompt, tools=[weather_tool])
part = resp.candidates[0].content.parts[0]
if part.function_call:
    out = run_tool(part.function_call.name, dict(part.function_call.args))
    resp = model.generate_content([
        prompt, part,
        {"function_response": {"name": part.function_call.name,
                               "response": {"result": out}}}])
```

## Pitfalls

- **Unsupported schema keywords** — it's OpenAPI 3.0, not full JSON-Schema; `anyOf`/`$ref`-heavy schemas may be rejected or ignored.
- **Automatic mode hides failures** — convenient, but exceptions in your functions and silent retries are easy to miss; disable it when debugging or in production loops you must control.
- **Sending results wrong** — the `functionResponse` must echo the `name` and wrap the payload (commonly under a `result` key); a bare value confuses the model.
- **Mode confusion** — leaving `AUTO` when you need a guaranteed call lets Gemini answer from memory; use `ANY` with `allowed_function_names`.

## See also

- [[openai-functions-calling]]
- [[anthropic-tool-use]]
