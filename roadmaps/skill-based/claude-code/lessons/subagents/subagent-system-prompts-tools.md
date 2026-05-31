---
title: Subagent System Prompts & Tools
track: claude-code
group: Subagents
tags: [claude-code, subagents]
prerequisites: [defining-custom-subagents]
see-also: [frontmatter-allowed-tools, allow-deny-rules, delegating-tasks-to-subagents]
---

# Subagent System Prompts & Tools

The two levers that shape a custom subagent: the markdown **body** (its system prompt, defining role and behavior) and the `tools` frontmatter (the exact capabilities it may use).

## Why it matters

A subagent's quality is almost entirely a function of these two fields. A sharp system prompt turns a generic model into a focused specialist that returns exactly the shape of answer you want; a tight tool list is your safety boundary — it's the difference between a "reviewer" that *suggests* fixes and one that can silently rewrite your code. Getting both right is what makes delegation trustworthy enough to run on autopilot.

## How it works

The body replaces Claude Code's default system prompt for that child; `tools` intersects with what the session actually permits.

- **System prompt (the body):** state the role, the expected input, the output format, and hard constraints ("only report exploitable bugs," "respond as a JSON list"). It's read once at spawn; there's no conversation to drift from.
- **Tools:** comma-separated allow-list of tool *names* (`Read, Grep, Glob, Edit, Bash`). Omit the field to inherit the full session toolset.
- Tool names are case-sensitive and exact — same names matched by [[allow-deny-rules]]. MCP tools use the `mcp__<server>__<tool>` form here too.
- The subagent's tools are further gated by the project's permission rules; `tools:` can only *narrow*, never escalate past what the session allows.

| Goal | Tools to grant |
|---|---|
| Read-only audit / explore | `Read, Grep, Glob` |
| Write tests, run them | `Read, Grep, Glob, Write, Edit, Bash` |
| Fetch + summarize external docs | `WebFetch, WebSearch, Read` |
| Query a service via MCP | `mcp__sentry__*, Read` |

- A subagent can be granted the `Task` tool to spawn its *own* children, but this nests context and is rarely worth the complexity.

## Example

Two agents, same task domain, different blast radius:

```markdown
# explorer.md  (tools: Read, Grep, Glob)   → can map code, never change it
You map code paths. Output a bullet list of file:line references only.

# fixer.md     (tools: Read, Edit, Bash)   → can patch + verify
You fix the failing test described in the prompt, then run it.
Stop when the named test passes; report the diff.
```

The prompt sets the *contract*; the tool list sets the *permissions*. Mismatch them — e.g. a "fixer" with no `Edit` — and the agent narrates a fix it can't apply.

## Pitfalls

- **Prompt says do, tools say can't.** Granting `Bash` but writing "don't run commands" (or the reverse) yields confused, stalled agents — keep prompt and tools consistent.
- **Inheriting `Bash` by omission.** Leaving out `tools:` to "keep it simple" hands the agent shell access; for any reviewer/explorer, list tools explicitly.
- **Output format left implicit.** Without "respond as X," you get prose the parent must re-parse; pin the shape in the prompt.
- **Assuming `tools:` can grant access the session lacks.** It only narrows; if `Bash` is denied project-wide, listing it in a subagent won't re-enable it.

## See also

- [[frontmatter-allowed-tools]]
- [[allow-deny-rules]]
- [[delegating-tasks-to-subagents]]
