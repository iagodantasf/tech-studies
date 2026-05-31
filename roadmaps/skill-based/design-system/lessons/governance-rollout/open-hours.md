---
title: Open Hours
track: design-system
group: Governance & rollout
tags: [design-system, support]
prerequisites: [governance]
see-also: [communication-channel, community-meetings, contribution-guidelines]
---

# Open Hours

Open hours are a recurring drop-in support window where the design system team is live and available — no agenda, no booking — for consumers to bring questions, pair on integration, or get unblocked face to face.

## Why it matters

Some problems don't fit an async channel: a half-broken layout, a "is this a bug or am I holding it wrong?", a contribution someone needs help shaping. These resolve in five minutes of screen-sharing and take days of back-and-forth in text. Open hours lower the barrier to *real* help, which keeps teams on the system instead of forking a [[component]] in frustration. They're also a listening post — sitting with consumers as they struggle reveals friction no bug report would ever capture. They sit between the async [[communication-channel]] and the formal [[community-meetings]]: scheduled, but unstructured and consumer-driven.

## How it works

Run a fixed, predictable window staffed by someone who can actually unblock people:

| Dimension | Typical choice | Note |
|---|---|---|
| Cadence | 1-2x per week, 30-60 min | predictable beats frequent |
| Format | video call, drop-in | screen-share is the point |
| Staffing | a maintainer who can fix things | not a triager who only logs |
| Agenda | none — bring your own problem | first-come, queue if busy |

What it's for, and what it isn't:

- **Pairing and unblocking** — integration help, "which component", debugging a broken state live.
- **Shaping contributions** — help a team turn a fork into a PR that fits [[contribution-guidelines]].
- **Not for decisions** — org-wide proposals belong in [[community-meetings]]; open hours is hands-on help.
- **Capture the recurring** — anything asked repeatedly here becomes a [[faqs]] entry or a [[documentation]] fix.

## Example

A weekly 45-minute slot. One engineer drops in with a [[forms]] layout that breaks at the `md` [[breakpoints]]; screen-share, the maintainer spots a missing token and fixes it live in eight minutes — a thread that would've spanned three days in chat. A second team brings a half-built `Tag` component they'd forked; the maintainer helps reshape it into a proper PR. By quarter's end the same breakpoint question has surfaced enough times that it's promoted into the docs, and open-hours traffic for it drops.

## Pitfalls

- **Staffed by a logger, not a fixer** — if the person on call can only file tickets, drop-ins learn nothing got solved and stop coming.
- **Irregular slot** — a frequently-cancelled or floating time kills the habit; a steady weekly window beats an erratic daily one.
- **Letting it absorb everything** — open hours is not the roadmap or the decision forum; route those to [[community-meetings]].
- **Insights never captured** — the friction you witness live evaporates unless it lands in [[documentation]] or the backlog.

## See also

- [[communication-channel]]
- [[community-meetings]]
