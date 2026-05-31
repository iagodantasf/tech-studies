---
title: Delegating Tasks to Subagents
track: claude-code
group: Subagents
tags: [claude-code, subagents]
prerequisites: [what-are-subagents]
see-also: [the-task-tool-parallelism, defining-custom-subagents, cost-context-optimization]
---

# Delegating Tasks to Subagents

The practice of handing a scoped, self-contained job to a subagent — automatically by the main model, or explicitly by you — so the heavy work stays out of the primary context.

## Why it matters

Delegation is the main lever for keeping long sessions coherent and cheap. A "search the whole repo for every caller of this function" task can burn tens of thousands of tokens of file contents; done in a subagent, only the answer comes back, and your main thread stays lean for the actual decision-making. The judgment call — *what* is worth delegating — is a senior skill: delegate broad/noisy/exploratory work, keep tight/interactive work inline. See [[cost-context-optimization]].

## How it works

There are two routes into a [[the-task-tool-parallelism|Task]] call:

| Route | Trigger | You control |
|---|---|---|
| Automatic | main model matches task to a `description` | by writing good descriptions |
| Explicit | you say "use the X subagent to…" | by naming the agent + prompt |

- The main agent writes the child's prompt; for automatic routing it summarizes your request, so be explicit if details matter.
- A good delegated task is **closed-form**: a clear goal, all needed context in the prompt, and a defined deliverable ("return file:line list", "return passing diff").
- Because the child can't ask questions, ambiguity becomes a guess — front-load constraints rather than expecting clarification.
- Results return as one message; the main agent then decides next steps. Nothing the child read enters your context unless the child repeats it in its summary.

**Delegate vs. do-inline:**

| Delegate | Keep inline |
|---|---|
| repo-wide search / "find all X" | a single known-path `Read` |
| diff/security review of many files | a 2-line edit you'll eyeball |
| parallel independent investigations | a back-and-forth you'll steer |
| anything that floods context | work needing the raw files in context |

## Example

```text
You: "Before I refactor, find everything that depends on the legacy
      PaymentsClient and tell me what'll break."

Main agent → Task(general-purpose,
  "List all imports/usages of PaymentsClient across the repo, with file:line,
   and note any that rely on its deprecated retry() method. Return a table.")
  child: Grep + 15 Reads in its own context        (~18k tokens, discarded)
  child returns: 9 call-sites, 2 using retry()      (~120 tokens)

You now plan the refactor from a 120-token summary, context intact.
```

## Pitfalls

- **Delegating interactive work.** If you'll want to steer mid-task ("no, not that file"), inline is better — the subagent commits to one shot.
- **Thin prompts.** "Look into the auth bug" with no repro/context makes the child flail; give it the symptom, the suspect files, and the goal.
- **Trusting an unverifiable summary.** A read-only explorer can't run code; its "this is correct" is reasoned, not tested — verify load-bearing claims yourself.
- **Over-delegation.** Spawning agents for trivial lookups adds startup latency and indirection; the win only materializes when the avoided context is large.

## See also

- [[the-task-tool-parallelism]]
- [[defining-custom-subagents]]
- [[cost-context-optimization]]
