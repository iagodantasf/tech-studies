---
title: LangChain
track: ai-agents
group: Frameworks
tags: [ai-agents, framework]
prerequisites: [llm-native-function-calling, manual-from-scratch]
see-also: [langgraph, langsmith]
---

# LangChain

A Python/JS framework that wraps models, tools, and prompts behind common interfaces so you compose agents and chains from swappable parts instead of raw SDK calls.

## Why it matters

The value is the abstraction layer: one `ChatModel` interface means swapping Anthropic for OpenAI is a one-line change, and 100+ prebuilt tool/loader integrations save you writing glue. It is the default first reach for prototypes and the most common thing a new agent dev inherits. The cost is leakage — the abstractions hide the [[agent-loop]], so when something breaks you often must understand the raw loop anyway (see [[manual-from-scratch]]).

## How it works

The modern core is **LCEL** (LangChain Expression Language): components implement a `Runnable` interface and pipe with `|`, giving free `.invoke`, `.batch`, `.stream`, and async.

| Primitive | Role |
|---|---|
| `ChatModel` | uniform function-calling model wrapper |
| `PromptTemplate` | parameterized prompt with variables |
| `Tool` | name + schema + callable, bound to the model |
| `OutputParser` | model text → typed object |
| `Runnable` | composable unit, piped with `pipe` |

- The `ChatModel` is the uniform [[llm-native-function-calling]] layer; swap providers without touching the chain.
- A **chain** is a fixed DAG (`prompt | model | parser`) — deterministic, no loop.
- An **agent** adds the loop: bind tools, let the model pick, dispatch, feed results back until it stops.
- For multi-step or cyclic control flow, LangChain now points you at [[langgraph]]; the legacy `AgentExecutor` is effectively superseded.
- `.with_structured_output(Schema)` forces tool-call-backed JSON, replacing brittle regex parsing.

## Example

A tool-using agent in a few lines:

```python
model = ChatAnthropic(model="claude-...").bind_tools([search, calculator])
chain = prompt | model | parser
chain.invoke({"q": "pop of France / 2"})
# model emits tool_calls -> you dispatch -> append ToolMessage -> re-invoke
# .stream() yields tokens; .batch([q1,q2]) runs both concurrently
```

LCEL gives streaming and batching for free; the `| parser` step turns the final message into a typed result.

## Pitfalls

- **Abstraction debt.** A failing agent is hard to debug because the prompt and loop are buried — wire up [[langsmith]] tracing on day one, not after.
- **Version churn.** v0.1→v0.2 split packages (`langchain-core`, `langchain-anthropic`); tutorials rot fast, pin versions.
- **Legacy `AgentExecutor`.** Many old guides use it; for real control flow use [[langgraph]] instead.
- **Hidden token cost.** Memory and retriever components silently stuff [[context-windows|context]]; log token counts or bills surprise you.

## See also

- [[langgraph]]
- [[langsmith]]
