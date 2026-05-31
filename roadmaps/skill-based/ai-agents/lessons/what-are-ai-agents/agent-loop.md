---
title: Agent Loop
track: ai-agents
group: What are AI Agents
tags: [ai-agents, agent-loop]
prerequisites: [what-are-ai-agents]
see-also: [react-reason-act, acting-tool-invocation]
---

# Agent Loop

The agent loop is the driver that repeatedly calls the model, executes any tool it requests, appends the result, and re-calls — until the model emits a final answer or a limit trips.

## Why it matters

The loop is where agency actually lives; the model only emits text, and the loop is the code that turns "I should call `search`" into a real call and a fed-back result. It owns everything the model cannot: stopping conditions, retries, budget, and turning tool output into the next prompt. Almost every agent bug — runaway cost, infinite repetition, lost context — is a loop bug, not a model bug.

## How it works

One iteration is **perceive → reason → act → observe**, mapped onto [[perception-user-input]], [[reason-and-plan]], [[acting-tool-invocation]], [[observation-reflection]]. The loop maintains a growing message list (the working context) and decides each turn whether to continue.

```
ctx = [system, user_goal]
for step in range(MAX_STEPS):          # hard cap, e.g. 15
    msg = model(ctx)                   # reason
    if msg.is_final: return msg.text
    out = run_tool(msg.tool, msg.args) # act + observe
    ctx += [msg, tool_result(out)]
    if tokens(ctx) > BUDGET: ctx = compress(ctx)
raise StepLimitExceeded
```

- **Termination** comes from one of: a `final_answer` signal, the step cap, a token/$ budget, or a [[stopping-criteria|stop sequence]].
- The format is usually [[llm-native-function-calling|native function calling]] (structured tool JSON) or the older text-based [[react-reason-act|ReAct]] (`Thought/Action/Observation`).
- Keep the loop's prompt **idempotent on retry** — a tool that times out should be safely re-runnable.

## Example

A 4-step run with caps `MAX_STEPS=15`, `BUDGET=8k` tokens:

| Step | Model decision | Tool result fed back |
|---|---|---|
| 1 | call `web_search("X")` | 5 snippets |
| 2 | call `fetch(url3)` | page text |
| 3 | call `fetch(url5)` | 404 error |
| 4 | final answer | — (loop returns) |

Step 3's error stays in context so step 4 can route around it instead of repeating the fetch.

## Pitfalls

- **No step cap** — a single missing `MAX_STEPS` is the classic way to burn a month's budget overnight.
- **Loop thrash** — the model calls the same tool with the same args repeatedly; detect repeats and inject a nudge or abort.
- **Context blowup** — appending every raw tool result eventually overflows the [[context-windows|window]]; compress or window old turns.
- **Swallowed tool errors** — hiding a failure instead of feeding it back removes the model's only chance to recover.

## See also

- [[react-reason-act]]
- [[acting-tool-invocation]]
