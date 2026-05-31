---
title: What are Subagents
track: claude-code
group: Subagents
tags: [claude-code, subagents]
prerequisites: [built-in-tools-read-edit-bash-etc]
see-also: [defining-custom-subagents, delegating-tasks-to-subagents, the-task-tool-parallelism]
---

# What are Subagents

A subagent is a separate Claude instance Claude Code spawns to handle a scoped job in its **own context window**, with its own system prompt and a restricted tool set, returning only a summary to the main thread.

## Why it matters

The main conversation's context is a finite, shared resource: every file read and command output stays in it, and once it fills you lose coherence (and pay to re-process it each turn). Subagents are the answer to "explore this huge codebase" or "review this diff" without dumping 50 files into the primary thread — the grunt work happens in a child context that gets discarded, and only a distilled answer comes back. They also let you encode a *specialist* (a security reviewer, a test writer) with a focused prompt and a deliberately narrow toolset, so it can't wander.

## How it works

The main agent calls the [[the-task-tool-parallelism|Task tool]], which instantiates a fresh agent. That child runs its own tool-call loop and reports back a single result.

| Property | Main thread | Subagent |
|---|---|---|
| Context window | shared, long-lived | isolated, ephemeral |
| System prompt | full Claude Code prompt | the subagent's own |
| Tools | all permitted tools | only its `tools:` set |
| Result | the conversation | one summary message |

- Two kinds exist: **built-in** general-purpose agents the model picks for itself, and **custom** ones you define as markdown files (see [[defining-custom-subagents]]).
- Custom subagents live in `.claude/agents/` (project) or `~/.claude/agents/` (user); each is a markdown file with YAML frontmatter (`name`, `description`, `tools`) plus a body that is its system prompt.
- A subagent cannot see the parent's history and cannot ask the user questions — it gets a prompt, works, and returns. Its intermediate tokens never enter your context.
- The `description` field is what the main agent reads to decide *when* to delegate; write it as a routing hint, not prose.

## Example

Asking "where is rate limiting enforced, and is it correct?" can route to a custom `code-explorer` subagent:

```text
Main agent → Task(subagent_type="code-explorer",
                  prompt="Find every place rate limiting is enforced; summarize")
  child: Grep "ratelimit", reads 8 files, traces middleware   (~12k tokens)
  child returns: "Enforced in middleware/limit.py:40 via token bucket;
                  bypassed for internal IPs in config.py:88"   (~80 tokens)
Main agent continues with the 80-token answer, not the 12k of reading.
```

## Pitfalls

- **It is not shared memory.** The subagent can't see what you discussed; pass every fact it needs *in the prompt*, or it works blind.
- **Round-trip latency.** Spawning a fresh agent costs a full startup + its own multi-turn loop; for a one-line `grep` it's slower than doing it inline.
- **Lossy by design.** You get the summary, not the reasoning — if you need the raw files in context, don't delegate.
- **No interactive follow-up.** A subagent can't pause to ask you something; an underspecified prompt yields a confident, possibly wrong, answer.

## See also

- [[defining-custom-subagents]]
- [[delegating-tasks-to-subagents]]
- [[the-task-tool-parallelism]]
