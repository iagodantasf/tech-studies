---
title: Email / Slack / SMS
track: ai-agents
group: Tools an Agent Can Use
tags: [ai-agents, messaging]
prerequisites: [api-requests]
see-also: [human-in-the-loop-evaluation, personal-assistant]
---

# Email / Slack / SMS

Tools that let an agent send (and sometimes read) messages over human channels — email, Slack/Teams, SMS — turning it from a chatbot into something that acts in the outside world.

## Why it matters

These are the agent's *output to humans and notification* tools: a [[personal-assistant]] emailing a summary, a monitoring agent paging on-call via SMS, a workflow posting a Slack approval request. They're also the natural surface for [[human-in-the-loop-evaluation]] — the agent pauses and asks a person to confirm. Crucially, these are **side-effecting, often irreversible** actions: a sent email can't be unsent, so they demand more guardrails than a read-only tool.

## How it works

Each channel is a thin wrapper over a provider API (SMTP/Gmail, Slack Web API, Twilio). The agent calls `send(to, body)`; the hard parts are *trust* and *recovery*, not the HTTP call. See [[api-requests]].

- **Outbound vs inbound** — sending is simple; *reading* (incoming email/Slack events via webhooks) lets the channel become a trigger, but inbound text is untrusted input.
- **Confirmation gates** — for anything user-visible or costly, require explicit approval before sending (interactive) or a dry-run preview; high-stakes sends should not be fully autonomous.
- **Idempotency** — a retried tool call must not send twice; attach an idempotency key or dedupe on a message hash.
- **Rate limits & threading** — respect provider limits (Slack ~1 msg/sec/channel), reply in-thread, and back off on 429.

| Channel | Provider ex. | Watch out |
|---|---|---|
| Email | SMTP, Gmail/SES | spam filters, no unsend |
| Chat | Slack, Teams | rate limits, threading |
| SMS | Twilio | per-message cost, 160-char segs |

## Example

```
agent: drafts "Deploy to prod failed at 14:03, see logs…"
gate  → preview shown to on-call engineer (HITL)
human → approves
tool  → slack.post(channel="#oncall", text=…, idem_key="deploy-9af3")
result→ ok (re-running the step is a no-op via idem_key)
```

The idempotency key means a retried run pings the channel once, not twice.

## Pitfalls

- **Prompt injection → exfiltration.** An agent that *reads* email and *sends* email can be told by a malicious message to forward your inbox or secrets — a classic confused-deputy/data-exfil chain. Gate sends and treat inbound as data ([[prompt-injection-jailbreaks]]).
- **Duplicate sends on retry** spam recipients; always make sends idempotent.
- **Wrong recipient / reply-all** is irreversible and embarrassing; confirm `to:` and prefer reply-in-thread.
- **PII in messages** — redact sensitive data before it leaves your system ([[data-privacy-pii-redaction]]).

## See also

- [[human-in-the-loop-evaluation]]
- [[personal-assistant]]
