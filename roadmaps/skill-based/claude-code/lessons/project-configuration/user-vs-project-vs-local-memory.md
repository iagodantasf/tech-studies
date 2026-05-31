---
title: User vs Project vs Local Memory
track: claude-code
group: Project configuration
tags: [claude-code, memory]
prerequisites: [claude-md-project-memory]
see-also: [nested-imported-memory-files, claude-md-project-memory, settings-json-hierarchy]
---

# User vs Project vs Local Memory

Claude Code reads memory from three tiers — user-global, project-shared, and project-local — and knowing which file a rule belongs in keeps team conventions, personal habits, and secrets cleanly separated.

## How it works

All three load at startup and concatenate into context; the difference is *scope* and *whether they're committed*. Roughly, broad-and-personal loads first, narrow-and-specific loads last, so the most specific guidance is freshest in context.

| Tier | File | Applies to | In git |
|---|---|---|---|
| User | `~/.claude/CLAUDE.md` | every project you open | no (personal) |
| Project | `<repo>/CLAUDE.md` | everyone on this repo | yes |
| Local | `<repo>/CLAUDE.local.md` | you, this repo only | no (gitignore) |

- **User memory** carries habits that travel with *you*: "prefer TypeScript", "explain before large refactors". It applies regardless of repo.
- **Project memory** is the shared contract — build/test commands, architecture, conventions — committed so the whole team and CI get identical agent behavior.
- **Local memory** holds per-developer, per-repo notes that must not be shared: a scratch DB URL, a personal TODO, a temporary workaround. Add `CLAUDE.local.md` to `.gitignore`.
- This is the *memory* hierarchy and is separate from the *settings* hierarchy (`settings.json`); see [[settings-json-hierarchy]]. Memory shapes the prompt; settings control permissions and config.
- Nested subtree files (see [[nested-imported-memory-files]]) layer on top of all three.

## Example

Same repo, three concerns in three files:

```text
~/.claude/CLAUDE.md      # "I prefer pytest over unittest"   (all my projects)
payments/CLAUDE.md       # "money is int cents; PRs -> develop" (whole team)
payments/CLAUDE.local.md # "my staging DB = postgres://localhost:55432" (only me)
```

A teammate cloning `payments` gets the project file verbatim but never sees your local DB URL or your personal pytest preference — yet your own sessions benefit from all three.

## Pitfalls

- **Wrong tier = leaked or lost rules.** A machine path in the committed project file leaks to teammates; a team convention left in user memory never reaches them.
- **Forgetting to gitignore `CLAUDE.local.md`.** Without the ignore entry, "local" memory gets committed and stops being local.
- **Assuming precedence is enforcement.** Later-loaded specifics usually win the model's attention but nothing *hard-overrides* — contradictions between tiers confuse the agent, so reconcile them.
- **Confusing memory tiers with settings tiers.** They share the user/project/local shape but are different files with different jobs — see [[settings-json-hierarchy]].

## See also

- [[claude-md-project-memory]]
- [[nested-imported-memory-files]]
- [[settings-json-hierarchy]]
