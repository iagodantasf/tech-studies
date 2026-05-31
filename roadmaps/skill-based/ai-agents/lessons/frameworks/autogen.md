---
title: AutoGen
track: ai-agents
group: Frameworks
tags: [ai-agents, multi-agent]
prerequisites: [agent-loop, llm-native-function-calling]
see-also: [crewai, langgraph]
---

# AutoGen

Microsoft's framework for multi-agent systems built around **conversation**: agents solve tasks by sending each other messages, including a built-in agent that executes code.

## Why it matters

AutoGen models collaboration as a chat among agents, which is a natural fit for the "generate code → run it → read the error → fix it" loop that powers data-analysis and coding agents. Its standout is a first-class **code-executor agent**: the assistant writes code, the executor runs it (often in Docker) and replies with real output, closing the [[observation-reflection|observation]] loop without you wiring an interpreter. It also offers group chats with a manager that picks who speaks next.

## How it works

Agents exchange messages until a termination condition fires; a few canonical types:

| Agent | Behavior |
|---|---|
| AssistantAgent | LLM that writes answers/code |
| UserProxyAgent | executes code, relays human/auto replies |
| CodeExecutor | runs code in a sandbox, returns output |
| GroupChatManager | selects next speaker in a group |

- A minimal team is two agents: assistant proposes [[code-execution-repl|code]], user-proxy runs it and sends back stdout/stderr; they iterate until the task ends.
- **Termination** is explicit — a max-turns cap or a sentinel like `TERMINATE` in a message; without it the chat runs forever.
- **Group chat** routes via the manager's speaker-selection (LLM-chosen, round-robin, or custom) — flexible but harder to predict than [[crewai|CrewAI]]'s fixed process.
- The newer **`autogen-agentchat` / core** redesign (v0.4) is async, event-driven, and the API to target; v0.2 differs.

## Example

The classic two-agent code loop:

```python
asst = AssistantAgent("coder", llm_config=cfg)
user = UserProxyAgent("runner", code_execution_config={"executor": docker},
                      human_input_mode="NEVER", max_consecutive_auto_reply=8)

user.initiate_chat(asst, message="Plot the trend in sales.csv")
# coder -> ```python ...```   runner -> executes, returns output/traceback
# coder reads the error, fixes, repeats until it emits TERMINATE
```

The runner actually executes each block and feeds back real tracebacks, so the coder debugs against ground truth rather than guessing.

## Pitfalls

- **No termination = infinite chat.** Always set `max_consecutive_auto_reply` and a `TERMINATE` check, or agents loop and burn [[token-based-pricing|tokens]].
- **Unsandboxed execution.** Running model-written code locally is dangerous; use the Docker executor — the agent will happily run `rm -rf`.
- **Group-chat drift.** Free speaker selection can let agents talk past the goal; constrain the manager or prefer a fixed two-agent loop.
- **v0.2 vs v0.4.** The rewrite changed the API and packages; old examples won't run on the new core, so match versions.

## See also

- [[crewai]]
- [[langgraph]]
