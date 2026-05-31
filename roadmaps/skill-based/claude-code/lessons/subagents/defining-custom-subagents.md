---
title: Defining Custom Subagents
track: claude-code
group: Subagents
tags: [claude-code, subagents]
prerequisites: [what-are-subagents]
see-also: [subagent-system-prompts-tools, frontmatter-allowed-tools, delegating-tasks-to-subagents]
---

# Defining Custom Subagents

A custom subagent is a single markdown file — YAML frontmatter (`name`, `description`, optional `tools`/`model`) plus a body that becomes the agent's system prompt — that Claude Code can route work to by name.

## Why it matters

Built-in general-purpose agents are fine for ad-hoc exploration, but a *named* specialist is reusable, reviewable, and shareable: check `.claude/agents/test-writer.md` into the repo and the whole team gets the same reviewer/test-author behavior with the same locked-down toolset. It turns "remember to tell Claude to act like a security reviewer" into a first-class artifact with version history — and the `description` field lets the main agent invoke it automatically when a task matches.

## How it works

Drop a `.md` file in an agents directory. Frontmatter configures the agent; everything below the `---` is its [[subagent-system-prompts-tools|system prompt]].

| Location | Scope | Wins on name clash |
|---|---|---|
| `.claude/agents/` | this project (committed) | project over user |
| `~/.claude/agents/` | all your projects | — |

| Field | Required | Purpose |
|---|---|---|
| `name` | yes | invocation id; kebab-case |
| `description` | yes | when-to-use routing hint for the main agent |
| `tools` | no | allowed tools; omit to inherit all |
| `model` | no | `sonnet` / `opus` / `haiku` / `inherit` |

- Omitting `tools` grants the agent the same tools the main session has; listing them (comma-separated) restricts it. See [[frontmatter-allowed-tools]].
- `description` drives **automatic** delegation — phrase it like "Use proactively to review code after edits," not just "a code reviewer."
- Run `/agents` to list, create, and edit subagents interactively (it scaffolds the file and can prefill the tool list).
- Changes take effect on next invocation; no restart needed.

## Example

`.claude/agents/security-reviewer.md`:

```markdown
---
name: security-reviewer
description: Use proactively after code changes to audit for injection,
  authz, and secret-leak issues. MUST be used before merging auth code.
tools: Read, Grep, Glob
model: opus
---
You are a senior application-security reviewer. Given a diff or file set,
flag concrete vulnerabilities with file:line and a one-line fix. Be terse.
Only report real, exploitable issues — no style nits, no speculation.
```

Read-only by construction (`Read, Grep, Glob`), so it physically cannot edit code while reviewing.

## Pitfalls

- **Vague `description` ⇒ never auto-invoked.** If it doesn't say *when* to use the agent, the main model won't route to it; you'll have to name it explicitly.
- **Forgetting it's a fresh agent.** The body is the *entire* system prompt — it has no project memory beyond what's passed in; don't write "as discussed above."
- **Over-granting tools.** Omitting `tools` inherits everything including `Bash`; a "reviewer" that can run shell commands isn't really read-only.
- **Name collisions.** A project agent silently shadows a user agent of the same name — surprising when behavior differs across repos.

## See also

- [[subagent-system-prompts-tools]]
- [[frontmatter-allowed-tools]]
- [[delegating-tasks-to-subagents]]
