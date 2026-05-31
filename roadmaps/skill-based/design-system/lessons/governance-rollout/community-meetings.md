---
title: Community Meetings
track: design-system
group: Governance & rollout
tags: [design-system, community]
prerequisites: [governance]
see-also: [communication-channel, open-hours, milestones]
---

# Community Meetings

A community meeting is the recurring, scheduled gathering of a design system's contributors and consumers — a regular forum to demo changes, debate proposals, and keep many teams aligned on one system.

## Why it matters

A system used by many teams accumulates decisions that are too big for an async channel: should we deprecate this [[component]], reshape this token scale, adopt this [[pattern]] org-wide? Without a shared forum, these get made in silos and surprise everyone downstream. The meeting is also the heartbeat of adoption — a visible, recurring signal that the system is alive, maintained, and worth depending on. It is the synchronous, agenda-driven counterpart to the always-on [[communication-channel]] and the drop-in [[open-hours]], and it's where federated [[governance]] actually happens.

## How it works

Run it on a predictable cadence with a real agenda, and keep it broadcast-plus-decision, not status theater:

| Cadence | Audience | Fits org of |
|---|---|---|
| Weekly | core + active contributors | small, fast-moving |
| Biweekly | core + team reps | mid-size, federated |
| Monthly | all consumers, demo-style | large, broad adoption |

A reliable 30-45 minute agenda:

- **What shipped** — last release, breaking changes, new [[component]]s, demo over slides.
- **Proposals up for decision** — RFCs from [[governance]], decided live with the right people in the room.
- **Deprecations and migrations** — what's going away, the timeline, the codemod.
- **Open floor** — team pain points and requests, feeding the roadmap and [[milestones]].

Record decisions and post notes to the [[communication-channel]] so absentees aren't blocked. Keep it small enough to decide things; a 60-person all-hands becomes a webinar where nothing gets resolved.

## Example

A biweekly meeting of 8 team reps. Agenda: demo the new [[carousel]], decide an RFC to deprecate the legacy `Alert` in favor of [[banner]] (timeline set: 2 versions, codemod shipped), and field a request for a date-picker (logged, needs a second team to justify). Thirty-five minutes, decisions recorded, notes dropped in the channel within the hour. The forum turns what would be eight separate side-conversations into one aligned decision the whole org can act on.

## Pitfalls

- **Status theater** — a meeting that only reports progress with no decisions wastes everyone's calendar; make it decide things.
- **Too big to decide** — a 60-person all-hands can't resolve an RFC; keep the deciding room small and broadcast the outcome.
- **No notes** — decisions made live and never written down strand the absent and get re-litigated async.
- **Cadence drift** — an irregular or quietly-cancelled meeting signals the system is dying; protect the slot or it loses trust.

## See also

- [[communication-channel]]
- [[open-hours]]
