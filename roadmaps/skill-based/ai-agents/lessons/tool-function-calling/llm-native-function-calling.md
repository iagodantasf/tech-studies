---
title: LLM Native Function Calling
track: ai-agents
group: Tool / Function Calling
tags: [ai-agents, function-calling]
prerequisites: [rest-api-knowledge, acting-tool-invocation]
see-also: [anthropic-tool-use, react-reason-act]
---

# LLM Native Function Calling

Native function calling is a model capability where you declare typed tools in the request and the model returns a **structured call** (name + JSON arguments) instead of prose, so your code can execute it.

## Why it matters

It replaces the brittle pre-2023 pattern of regex-parsing free text ("ACTION: search(...)") with a contract the model was fine-tuned to honor. This is the substrate every agent [[agent-loop]] runs on: the model decides *which* tool and *with what arguments*, your runtime does the side effects, and the result feeds back. Without it, [[acting-tool-invocation]] is a parsing nightmare.

## How it works

You pass a list of tool **schemas** (name, description, JSON-Schema parameters). The model emits a tool-call object; you execute and return the result in a follow-up turn. The loop is request → tool_call → execute → tool_result → request.

- **Schema fidelity** — providers constrain decoding so arguments are valid JSON matching the schema. The `description` field is prompt-engineering: it's how the model knows *when* to call.
- **It does not execute anything.** The model only *proposes* a call. Your code is the trust boundary — validate before running.
- **Parallel calls** — modern models emit several tool calls in one turn (e.g. fetch weather for 3 cities at once); execute them concurrently, return all results.
- **Forcing** — most APIs let you set tool choice to `auto`, `none`, `required`, or a named tool to constrain behavior.

| Concept | Maps to |
|---|---|
| Tool schema | A typed function signature |
| Tool call | The model "calling" it (returns args) |
| Tool result | Your return value, fed back as a turn |

## Example

A 2-tool weather agent, one round trip:

```
tools = [get_weather(city: string), get_time(tz: string)]
user: "weather in Paris and Tokyo?"
→ model returns tool_calls:
    [get_weather(city="Paris"), get_weather(city="Tokyo")]   # parallel
→ you run both, append two tool_result messages
→ model: "Paris is 14C, Tokyo is 21C."
```

The provider dialects differ only in field names — see [[anthropic-tool-use]], [[openai-functions-calling]], [[gemini-function-calling]].

## Pitfalls

- **Hallucinated arguments** — the model can invent a `user_id` or pass a malformed enum. Always validate against the schema *and* business rules; never trust args straight into a DB query or shell.
- **No-call when you needed one** — a vague `description` or weak system prompt makes the model answer from memory instead of calling. Tighten the description; consider `required`.
- **Infinite tool loops** — model re-calls the same failing tool. Cap iterations and surface errors as text the model can reason about.
- **Schema drift** — overly deep/nested schemas degrade reliability; keep parameters flat and enums explicit.

## See also

- [[anthropic-tool-use]]
- [[react-reason-act]]
