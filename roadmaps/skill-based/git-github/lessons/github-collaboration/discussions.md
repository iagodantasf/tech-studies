---
title: Discussions
track: git-github
group: GitHub collaboration
tags: [git-github, community]
prerequisites: [creating-a-github-account-and-repository]
see-also: [github-issues, projects-and-milestones]
---

# Discussions

A forum-style space attached to a repo or org for open-ended conversation — questions, ideas, and announcements — that doesn't belong in the issue tracker.

## Why it matters

[[github-issues|Issues]] are for actionable, closeable work; cramming "how do I configure X?" or "should we adopt Y?" into them pollutes the backlog and skews metrics. Discussions give that conversation a home with threaded replies and answer-marking, which is why most large OSS projects route support and RFCs there to keep Issues clean and assignable. For maintainers it's a triage funnel: a discussion that surfaces a real bug gets converted into an issue.

## How it works

Discussions are organized into **categories**, each with a format that changes its behavior.

| Category format | Behavior | Typical use |
|---|---|---|
| Open-ended | Flat/threaded thread, no answer | General chat, show-and-tell |
| Question / Answer | Replies can be marked the accepted answer | Q&A, support |
| Announcement | Only maintainers can post; everyone comments | Releases, news |
| Poll | Vote on options | Quick decisions |

- Replies are **threaded** (nested), unlike issue comments which are flat — better for branching conversation.
- A maintainer can **convert an issue to a discussion** (and vice versa, promoting a discussion to an issue) without losing the thread.
- Discussions support upvotes, pinning, and labels, but **not assignees or [[projects-and-milestones|milestones]]** — they're not tracked work.

## Example

```
# Triage flow
Discussion (Q&A): "Memory leak after upgrade to 4.2?"
  └─ reproduces, confirmed bug
     └─ maintainer: "Convert to issue"  ──►  Issue #913, labeled `bug`,
                                              linked back to the discussion
```

## Pitfalls

- **Using Discussions for tracked work** — no assignee, status, or board, so action items posted there fall through the cracks; convert to an issue.
- **Disabled by default** — Discussions must be enabled in repo settings; expecting users to find a tab that isn't turned on.
- **Answer never marked** — in Q&A categories, an unmarked thread leaves the next visitor re-asking; mark the accepted answer.
- **Announcement category misused** — if anyone can start threads in it, it stops being a trustworthy signal channel.

## See also

- [[github-issues]]
- [[projects-and-milestones]]
