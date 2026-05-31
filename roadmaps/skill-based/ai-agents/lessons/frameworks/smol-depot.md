---
title: Smol Depot
track: ai-agents
group: Frameworks
tags: [ai-agents, framework]
prerequisites: [manual-from-scratch, code-execution-repl]
see-also: [open-weight-models, langgraph]
---

# Smol Depot

A deliberately tiny agent library (Hugging Face's `smolagents` lineage) whose defining idea is the **code agent**: the model acts by writing Python that calls tools, instead of emitting JSON tool calls.

## Why it matters

Most frameworks make the model emit a [[llm-native-function-calling|JSON tool call]] per step; Smol Depot instead has it write a code snippet that orchestrates tools directly — so one block can loop, branch, and chain several tools without a round-trip to the model each time. Research (and HF's own benchmarks) shows code-actions often need ~30% fewer steps than JSON-action agents on multi-tool tasks. The whole core is ~1k lines, so it stays close to a [[manual-from-scratch|from-scratch loop]] while adding sandboxing and a tool/model registry.

## How it works

The agent's "action" is executable code; the runtime parses, sandboxes, and runs it.

| Piece | Role |
|---|---|
| CodeAgent | model writes Python actions |
| ToolCallingAgent | classic JSON-action variant |
| Tool | Python fn exposed to generated code |
| Executor | runs the snippet (local / E2B / Docker) |

- Each step the model emits a `Thought` + a Python block; the executor runs it, captures the value of `final_answer(...)` or the printed output, and feeds it back (see [[code-execution-repl]]).
- Because actions are real code, the model can do `for x in search(q): ...` in **one** action — composing tools without per-call LLM latency.
- **Model-agnostic**: backs onto any inference endpoint — HF Inference, a local [[open-weight-models|open-weight model]], or a hosted API.
- **Sandboxing is mandatory** given it executes generated code; remote executors (E2B) isolate it from your host.

## Example

A code-action step looks like the model writing a script, not a JSON call:

```python
agent = CodeAgent(tools=[web_search, visit], model=HfApiModel())
agent.run("Which of the top-3 results mentions 'GDP'?")

# model emits an action block, executor runs it:
#   hits = web_search("...")
#   for url in hits[:3]:
#       if "GDP" in visit(url): final_answer(url); break
```

That single block searches, loops the top 3, and visits each — work that a JSON-action agent would spread across ~4 separate model turns.

## Pitfalls

- **Executing model code unsandboxed.** The core risk: generated Python can do anything; never run it on your host — use E2B/Docker isolation.
- **Weak-model code errors.** Small models write buggy actions; feed the traceback back as the next [[observation-reflection|observation]] so it self-corrects.
- **Import/scope surprises.** The sandbox whitelists modules; code referencing a non-allowed import fails — declare `additional_authorized_imports`.
- **Wrong tool for the job.** For strict, auditable single tool calls a JSON-action or [[langgraph]] flow is safer than free-form code.

## See also

- [[open-weight-models]]
- [[langgraph]]
