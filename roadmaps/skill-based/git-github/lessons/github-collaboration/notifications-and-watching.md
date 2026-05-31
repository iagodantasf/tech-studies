---
title: Notifications and watching
track: git-github
group: GitHub collaboration
tags: [git-github, workflow]
prerequisites: [creating-a-github-account-and-repository]
see-also: [labels-and-assignees, pull-requests]
---

# Notifications and watching

How GitHub decides what reaches your inbox — the watch level you set on a repo, plus the per-thread subscriptions that participation and @mentions create automatically.

## Why it matters

On an active org, naive defaults bury you: watching 40 busy repos at "All Activity" is hundreds of emails a day, so people mute everything and then miss the [[pull-requests|PR]] that actually needs them. The skill is tuning *signal*: get pinged for your review requests and @mentions, stay quiet on the rest. Notifications are also the delivery layer for [[github-actions-and-ci-cd|CI]] failures and security alerts, so misconfiguring them means missing the things that page you.

## How it works

Two independent layers combine: a repo **watch level**, and automatic **thread subscriptions** from activity.

| Watch level | You get notified about |
|---|---|
| Participating and @mentions | Only threads you join or are @mentioned in |
| All Activity | Every issue, PR, release, and discussion |
| Ignore | Nothing, even @mentions |
| Custom | Chosen event types (Issues, PRs, Releases, Discussions) |

- You're **auto-subscribed** to a thread when you open it, comment, get assigned, request/are-requested a review, or are @mentioned — independent of the repo watch level.
- `@you` from a [[labels-and-assignees|team]] mention notifies every member; large-team mentions are a common inbox-flood source.
- **Reasons** tag each notification (`review_requested`, `mention`, `assign`, `ci_activity`) — filter your inbox by them with `reason:` to triage fast.
- **Unsubscribe** stops one thread without changing the repo watch; **Ignore** silences a whole repo including direct mentions.

## Example

```
# High-signal setup for a busy org:
Default repo watch ............ Participating and @mentions
Repo you maintain ............. Custom: Issues + PRs + Releases
Noisy bot-heavy repo .......... Ignore

# Inbox triage by reason:
filter:  is:unread reason:review-requested   ->   PRs waiting on you
```

## Pitfalls

- **"Ignore" hides @mentions too** — someone needs you on an ignored repo and you never see it; prefer "Participating" over "Ignore" unless truly done with it.
- **Auto-subscription stickiness** — one comment subscribes you to a 200-reply mega-thread forever; unsubscribe the thread, don't just mute notifications app-wide.
- **Team @mentions flood everyone** — pinging `@acme/eng` for a trivial question notifies the whole team; mention the individual.
- **Watching a fork, not upstream** — you watch your [[forking-a-repository|fork]] and wonder why upstream releases never notify you.

## See also

- [[labels-and-assignees]]
- [[pull-requests]]
