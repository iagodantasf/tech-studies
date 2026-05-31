---
title: Communication Channel
track: design-system
group: Governance & rollout
tags: [design-system, communication]
prerequisites: [governance]
see-also: [open-hours, community-meetings, contribution-guidelines]
---

# Communication Channel

A communication channel is the always-on, asynchronous place — typically a Slack/Teams channel — where consumers of a design system ask questions, report bugs, and hear about changes, without booking a meeting.

## Why it matters

Adoption stalls on friction: if getting help means filing a ticket and waiting two days, teams stop asking and start forking [[component]]s instead. A fast async channel is the cheapest support surface a system has — one public answer is searchable by the next 40 people who hit the same wall, so the marginal cost of support falls over time. It is also the early-warning system: the first sign a release broke someone shows up here, minutes after it ships, long before a formal bug report. It complements synchronous [[open-hours]] and [[community-meetings]], handling the long tail of small questions.

## How it works

Run one canonical channel with clear norms, not a sprawl of side DMs:

| Use the channel for | Route elsewhere |
|---|---|
| "which component for X?" | deep design debate → [[community-meetings]] |
| bug reports, regressions | contributions → [[contribution-guidelines]] |
| release announcements | live pairing → [[open-hours]] |
| usage questions, gotchas | account/access → IT |

Operating rules that keep it healthy:

- **Answer in public** — even DMs get pulled into the channel, so the answer is searchable and reused.
- **A named owner on rotation** — someone owns triage each week so questions don't fall into the void; a first response within hours, not days.
- **Announce every release here** — version, changelog link, breaking changes, codemod — this is the broadcast surface.
- **Pin the on-ramp** — install, first component, docs link, and "how to report a bug" pinned so newcomers self-serve.
- **Turn repeats into docs** — a question asked three times becomes a [[faqs]] entry or a [[documentation]] fix.

## Example

A team posts "Input won't show an error — bug?" at 10:02. The on-rotation maintainer replies by 10:30 with a workaround and files an issue; because it's public, two other teams hitting the same thing find the answer instead of asking again. Friday's `@acme/ui@1.2` release is announced in-channel with a changelog and a one-line codemod. Over a quarter, the same five questions recur often enough that they're promoted into [[faqs]] — and the channel's question volume drops measurably as the docs absorb the load.

## Pitfalls

- **Answering in DMs** — private answers help one person and are invisible to the next ten who hit the same issue.
- **No owner** — an unowned channel goes silent; questions pile up unanswered and teams conclude the system is abandoned.
- **Channel as the only docs** — if the searchable answer lives only in chat history, it rots; promote recurring ones to [[documentation]].
- **Announcement-only or noise-only** — a channel that's pure release spam, or pure chatter with no triage, trains people to mute it.

## See also

- [[open-hours]]
- [[community-meetings]]
