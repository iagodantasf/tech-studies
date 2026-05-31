---
title: Python SDK
track: claude-code
group: Agent SDK
tags: [claude-code, agent-sdk]
prerequisites: [claude-agent-sdk-overview]
see-also: [typescript-sdk, programmatic-sessions-streaming, custom-tools-mcp-in-the-sdk]
---

# Python SDK

The `claude-agent-sdk` package gives Python an async `query()` for one-shot runs and a `ClaudeSDKClient` context manager for stateful, multi-turn conversations.

## Why it matters

Python dominates data, ML, and ops tooling, so this SDK is how Claude Code agents land inside notebooks, Airflow tasks, and FastAPI services. The two entry points map cleanly to two shapes of work: fire-and-forget (`query`) versus a long-lived conversational session (`ClaudeSDKClient`).

## How it works

Everything is `async`; you need an async runtime (`asyncio` or `anyio`). Config lives in `ClaudeAgentOptions` (renamed from `ClaudeCodeOptions`).

```python
async def query(*, prompt, options=None) -> AsyncIterator[Message]
```

- **`query()`** opens a fresh session and yields messages; use it for scripts and CI.
- **`ClaudeSDKClient`** keeps context across turns. Key methods: `connect()`, `query(prompt)`, `receive_response()`, `receive_messages()`, `interrupt()`, `set_permission_mode()`, `disconnect()`. Prefer `async with` so disconnect is automatic.
- **`ClaudeAgentOptions` fields:** `system_prompt`, `model`, `allowed_tools` / `disallowed_tools`, `permission_mode`, `max_turns`, `mcp_servers`, `hooks`, `can_use_tool`, `cwd`, `resume`, `continue_conversation`, `setting_sources`, `max_budget_usd`.
- **Message dataclasses:** `AssistantMessage` (a `.content` list of blocks like `TextBlock`), `UserMessage`, `SystemMessage`, and `ResultMessage` (`total_cost_usd`, `num_turns`, `usage`). Branch with `isinstance`.
- Install: `pip install claude-agent-sdk`. Requires **Python 3.10+** and pulls in `anyio`.

## Example

Multi-turn with a retained session, extracting text blocks:

```python
from claude_agent_sdk import ClaudeSDKClient, AssistantMessage, TextBlock

async with ClaudeSDKClient() as client:
    await client.query("What's the capital of France?")
    async for m in client.receive_response():
        if isinstance(m, AssistantMessage):
            for b in m.content:
                if isinstance(b, TextBlock):
                    print(b.text)
    await client.query("What's its population?")  # "its" resolves — context kept
```

## Pitfalls

- **`receive_response()` ends at the result; `receive_messages()` does not.** The former stops after the `ResultMessage` for the current turn; the latter streams forever and will hang a `for` loop awaiting the next turn.
- **`No matching distribution found`** on `pip install` almost always means the interpreter is `< 3.10` — check `python3 --version`.
- **`ClaudeAgentOptions`, not `ClaudeCodeOptions`.** Code or tutorials predating the rename import the old name and `ImportError`.
- **Synthetic code paths.** Calling these from sync code without `asyncio.run(...)` / `anyio.run(...)` silently never executes the coroutine.

## See also

- [[typescript-sdk]]
- [[programmatic-sessions-streaming]]
- [[custom-tools-mcp-in-the-sdk]]
