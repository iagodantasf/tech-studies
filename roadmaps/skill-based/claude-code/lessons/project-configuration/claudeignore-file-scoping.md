---
title: .claudeignore & File Scoping
track: claude-code
group: Project configuration
tags: [claude-code, scoping]
prerequisites: [what-is-claude-code]
see-also: [claude-md-project-memory, allow-deny-rules, settings-json-hierarchy]
---

# .claudeignore & File Scoping

File scoping controls which paths Claude Code is allowed to see and touch — narrowing the agent's view to relevant source and keeping noise, secrets, and giant artifacts out of context.

## Why it matters

The launch directory's subtree defines the agent's *reach*, but a raw repo is full of things that hurt: `node_modules/` and build output bloat search results, lockfiles waste context, and `.env` files are exactly what you do not want a tool reading or editing. Scoping keeps the agent focused on code that matters, which improves answer quality, cuts token cost, and shrinks the blast radius if a permission is too loose. It is the read-side complement to [[allow-deny-rules]], which gate the *actions*.

## How it works

Scoping comes from a few layered sources, applied together:

- **`.gitignore` is honored by default.** Claude's search/glob tools skip git-ignored paths, so `node_modules/`, `dist/`, and friends are already out of view without extra config.
- **`.claudeignore`** (repo root) adds Claude-specific exclusions using the same glob syntax as `.gitignore` — for files you *do* track in git but don't want the agent wandering into (large fixtures, vendored code, data dumps).
- **Permission deny rules** in `settings.json` can hard-block reads of sensitive paths, e.g. `"deny": ["Read(./.env)", "Read(./secrets/**)"]` — stronger than an ignore, because it's an explicit refusal. See [[allow-deny-rules]] and [[settings-json-hierarchy]].

| Mechanism | Blocks | Strength |
|---|---|---|
| `.gitignore` | search/glob discovery | default, soft |
| `.claudeignore` | tracked-but-noisy paths | soft, Claude-only |
| `Read(...)` deny rule | a direct read of that path | hard refusal |

- Excluding a path keeps it out of *automatic* discovery and context; pair it with a deny rule when you need a guarantee, not just a default.
- Smaller effective scope = fewer tokens per [[hash-tables]] and tighter, more relevant grep results.

## Example

A web app keeps the agent out of noise and secrets:

```gitignore
# .claudeignore
fixtures/**/*.json     # 40 MB of test data, tracked but irrelevant
vendor/                # third-party code we don't modify
*.snap                 # large snapshot files
```

```jsonc
// .claude/settings.json — hard guarantee, not just a hint
{ "permissions": { "deny": ["Read(./.env*)", "Read(./secrets/**)"] } }
```

Now a grep for a config key returns hits from `src/`, not 200 matches buried in `fixtures/`, and `.env` cannot be read even if asked.

## Pitfalls

- **Ignore ≠ secret protection.** An ignored `.env` is merely undiscovered; if the agent is told its exact path it may still read it unless a **deny rule** forbids it. Use deny for secrets.
- **Over-scoping hides needed code.** Excluding a directory the task depends on makes the agent "blind" to it and it will flail — scope to noise, not to working code.
- **Forgetting `.gitignore` already applies.** Re-listing `node_modules/` in `.claudeignore` is redundant; reserve it for tracked files git keeps.
- **Scope is not a sandbox.** It limits discovery and reads, not what a `Bash` command can reach — secure shell access via [[allow-deny-rules]] too.

## See also

- [[claude-md-project-memory]]
- [[allow-deny-rules]]
- [[settings-json-hierarchy]]
