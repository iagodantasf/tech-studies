---
title: Manual / From Scratch
track: ai-agents
group: Building Agents Manually
tags: [ai-agents, agent-loop]
prerequisites: [agent-loop, llm-native-function-calling, api-requests]
see-also: [understanding-the-architecture, langchain]
---

# Manual / From Scratch

Building an agent with nothing but the raw model SDK and a `while` loop — you own the message list, the tool dispatch, and the stopping logic instead of a framework.

## Why it matters

A from-scratch loop is ~40 lines and makes every moving part visible, which is why it is the best way to *learn* agents and to *debug* production ones — when a [[langchain|framework]] agent misbehaves, the fix is usually understanding the loop it hid from you. It also wins when you need tight control: custom retry, token budgeting, or an unusual tool protocol the framework can't express. The cost is that you re-implement plumbing (retries, parallel tools, tracing) the framework gave you for free.

## How it works

The whole agent is the [[agent-loop]] driving a [[llm-native-function-calling|function-calling]] model. Three pieces you must write yourself:

| Piece | Your job |
|---|---|
| Tool registry | map a name to a Python fn + its JSON schema |
| Dispatch | look up the requested tool, call it, catch errors |
| Loop control | accumulate messages, detect "final", enforce caps |

- **Message accumulation** — every turn you append *both* the assistant message and the tool result; dropping either corrupts the conversation and throws a 400.
- **Errors are data** — wrap each tool call in `try/except` and feed the exception text back as a tool result, not a crash; the model routes around it (see [[observation-reflection]]).
- **Caps before cleverness** — a `MAX_STEPS` and a token/$ ceiling are non-negotiable; add them on line one, not after the first runaway bill.
- Use [[anthropic-tool-use]] / [[openai-functions-calling]] for the exact block shapes; they differ on arg encoding and result roles.

## Example

A complete loop (Anthropic dialect), tools as a `{name: (fn, schema)}` dict:

```python
ctx = [{"role": "user", "content": goal}]
for _ in range(MAX_STEPS):                     # hard cap
    r = client.messages.create(model=M, tools=schemas, messages=ctx)
    ctx.append({"role": "assistant", "content": r.content})
    if r.stop_reason != "tool_use":            # final answer
        return text_of(r)
    results = []
    for b in r.content:
        if b.type == "tool_use":
            try:    out = TOOLS[b.name][0](**b.input)
            except Exception as e:  out, err = str(e), True
            else:   err = False
            results.append({"type": "tool_result", "tool_use_id": b.id,
                            "content": str(out), "is_error": err})
    ctx.append({"role": "user", "content": results})   # all results, one msg
raise StepLimitExceeded
```

## Pitfalls

- **Forgetting to echo the assistant turn** — appending only the tool result, not the `tool_use` message before it, breaks block pairing and 400s.
- **Returning one result per message** when the model emitted parallel calls — all `tool_result`s for a turn must ride in a single following message.
- **`json.loads`-ing parsed args** — Anthropic's `input` is already a dict; only OpenAI hands you an arguments *string*.
- **Reinventing what you shouldn't** — once you need retries, parallelism, and tracing, a thin [[langchain|framework]] or [[langgraph]] may be less code than maintaining your own.

## See also

- [[understanding-the-architecture]]
- [[agent-loop]]
