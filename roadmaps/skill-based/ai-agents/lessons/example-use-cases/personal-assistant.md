---
title: Personal Assistant
track: ai-agents
group: Example Use Cases
tags: [ai-agents, personal-assistant]
prerequisites: [agent-loop, long-term-memory]
see-also: [email-slack-sms, model-context-protocol-mcp]
---

# Personal Assistant

A personal-assistant agent is a long-lived [[agent-loop]] wired to a user's calendar, mail, and tasks that triages, drafts, and schedules on their behalf across many sessions.

## Why it matters

This is the "Jarvis" use case and the one users judge hardest: it touches their inbox, their time, and their contacts, so a single wrong send is a real-world failure, not a bad chat reply. The hard problems are not the LLM — they are durable [[long-term-memory]] (it must remember your boss, your timezone, "never schedule before 10am"), correct tool side effects, and knowing when to ask versus act. Get those right and it saves an hour a day; get them wrong and it emails the wrong client.

## How it works

The assistant is a stateful agent over a fixed toolset, usually exposed through [[model-context-protocol-mcp|MCP]] servers so the same Gmail/Calendar tools work across hosts.

- **Trigger.** Two entry points: user message (chat/SMS) and *event* (new email, calendar reminder) that wakes the loop without a prompt.
- **Memory split.** [[short-term-memory|Short-term]] holds the current thread; [[long-term-memory|long-term]] holds stable facts (`prefers Zoom`, `partner = Sam`) retrieved per turn.
- **Confirm gate.** Classify each planned action as read-only vs side-effecting; auto-run reads, require approval for sends/deletes — a [[human-in-the-loop-evaluation|human-in-the-loop]] checkpoint.
- **Idempotency.** Tag outbound actions with a key so a retried "send invite" doesn't double-book.

| Tool | Side effect | Default gate |
|---|---|---|
| search_email / list_events | none | auto |
| draft_reply | none (draft only) | auto |
| send_email / create_event | external, visible | confirm |
| delete / decline | destructive | confirm |

## Example

Event-triggered triage of an incoming email:

```
event: new mail "Can we meet Thu?"
  recall LT-memory → {tz: PT, no-mtg-before-10, calendar: g_cal}
  check_calendar(Thu) → free 14:00–15:00
  draft_reply("Thu 2pm PT works — sending an invite")
  → CONFIRM gate (send is side-effecting)
  user taps ✓ → send_email + create_event(idempotency_key=mail_id)
```

The agent did the lookup and drafting unattended, but the send waited one tap — autonomy on reads, approval on writes.

## Pitfalls

- **Acting without confirmation.** Auto-sending on a hallucinated address or time is unrecoverable; gate every external side effect.
- **No idempotency.** A timeout-and-retry on `create_event` silently books the meeting twice; key every mutating call.
- **Stale or cross-user memory.** Recalling last month's address, or another user's facts, leaks and embarrasses — scope by `user_id` and age out facts.
- **Timezone / locale bugs.** "3pm" with no zone is the classic double-booking; always resolve against the user's stored timezone.

## See also

- [[email-slack-sms]]
- [[model-context-protocol-mcp]]
