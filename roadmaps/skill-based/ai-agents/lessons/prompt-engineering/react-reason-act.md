---
title: ReAct (Reason + Act)
track: ai-agents
group: Prompt Engineering
tags: [ai-agents, agent-loop]
prerequisites: [chain-of-thought-cot]
see-also: [agent-loop, llm-native-function-calling]
---

# ReAct (Reason + Act)

ReAct is a prompting pattern that interleaves reasoning traces with tool actions, letting a model think, act on the world, observe the result, and think again.

## Why it matters

Pure [[chain-of-thought-cot|CoT]] reasons in a closed box — it can't look anything up, so it hallucinates facts it doesn't have. ReAct breaks the box open: the model grounds each reasoning step in a real [[acting-tool-invocation|tool result]], which slashes hallucination on knowledge tasks and lets it recover from a bad step by observing failure. It is the canonical implementation of the [[agent-loop]] and underpins most tool-using agents (LangChain's default agent, many [[llm-native-function-calling|function-calling]] loops).

## How it works

The model emits a repeating **Thought → Action → Observation** cycle until it has enough to answer:

| Token | Produced by | Role |
|---|---|---|
| Thought | model | reason about the next step |
| Action | model | name a tool + arguments |
| Observation | environment | the tool's returned result |
| Final Answer | model | terminate the loop |

The loop is driven by your code, not the model: you parse the `Action`, execute the tool, append the `Observation` back into the prompt, and re-invoke. Crucially the model **stops generating after Action** — you enforce this with a [[stopping-criteria|stop sequence]] on `Observation:` so the model can't hallucinate the tool's output itself. Modern stacks express the Action as a structured [[llm-native-function-calling|function call]] rather than parsed text, which is more robust, but the Thought/Act/Observe shape is identical. Cap the iterations to bound cost and prevent loops.

## Example

A two-hop question that needs a live lookup:

```
Q: Who is the current CTO of the company that makes Quartz?

Thought: I need to know who makes the Quartz site generator.
Action: web_search("Quartz static site generator company")
Observation: Quartz is open-source, maintained by Jacky Zhao.
Thought: It's a community project, not a company with a CTO.
Final Answer: Quartz is a community-run open-source project; it
              has no company or CTO.
```

CoT alone would have invented a plausible CTO; the search step grounds the model into the correct "no such thing" answer.

## Pitfalls

- **No stop sequence** — without halting at `Observation:`, the model writes its own fake tool output and reasons over fiction.
- **Unbounded loops** — a confused agent repeats the same failing action forever; enforce a max-step / max-cost ceiling.
- **Dumping full observations** — pasting a 5k-token API response each turn blows the [[context-windows|window]]; summarize or truncate tool output.
- **Brittle text parsing** — regex-parsing `Action:` lines breaks on odd formatting; prefer structured function calls where available.

## See also

- [[agent-loop]]
- [[llm-native-function-calling]]
