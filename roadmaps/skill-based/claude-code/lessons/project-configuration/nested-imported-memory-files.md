---
title: Nested & Imported Memory Files
track: claude-code
group: Project configuration
tags: [claude-code, memory]
prerequisites: [claude-md-project-memory]
see-also: [user-vs-project-vs-local-memory, claudeignore-file-scoping, claude-md-project-memory]
---

# Nested & Imported Memory Files

Beyond a single root file, Claude Code composes memory from nested per-directory `CLAUDE.md` files and from `@path` imports that pull other files in by reference.

## Why it matters

A monorepo with ten services should not cram every service's conventions into one root `CLAUDE.md` — that bloats context for everyone and buries the rules that actually apply. Nesting lets each subtree carry its own memory, loaded only when you work there, while imports let you keep a shared style guide or per-developer overrides in their own files and reference them instead of copy-pasting. Together they turn memory from one monolith into a composable tree (see [[trees]]).

## How it works

Two distinct mechanisms, often combined:

- **Nested files** — a `CLAUDE.md` in any directory on the path from the repo root down to your launch directory is auto-loaded. Deeper files load *after* shallower ones, so they can refine or override broader guidance.
- **Imports** — a line `@relative/or/absolute/path` inside any memory file inlines that file's contents at load time.

| Syntax | Meaning |
|---|---|
| `@./docs/style.md` | import a repo-relative file |
| `@~/.claude/my-prefs.md` | import a user-home file (personal overrides) |
| `@../shared/conventions.md` | import from a sibling directory |

- Imports are **recursive** up to a depth of **5 hops**; a cycle is detected and stops, it does not loop forever.
- A bare `@path` on its own line is an import; `@` inside prose or code spans (and inside fenced code blocks) is **not** treated as an import.
- Imported files count toward context exactly like inline text — there is no token discount for indirection.
- Use `/memory` to see the fully resolved set of files actually loaded, including everything imports dragged in.

## Example

Root `CLAUDE.md` stays thin and delegates:

```markdown
# Monorepo memory
@./docs/engineering-standards.md   # shared, committed
@~/.claude/alice-prefs.md          # personal, machine-local

Services live under `services/*`; each has its own CLAUDE.md.
```

Then `services/billing/CLAUDE.md` adds only what's local:

```markdown
# billing service
- Test: `go test ./...`  · money is int64 cents.
```

Launch from `services/billing/` and the agent sees: root + the two imports + the billing file — but none of the *other* services' memory.

## Pitfalls

- **Hidden bloat via imports.** A small root file that imports four large docs can blow the budget; resolve with `/memory` and check the real total.
- **Broken relative paths.** `@path` is resolved relative to the *file containing it*, not the launch dir — a moved file silently drops its import.
- **Over-deep nesting.** Imports past 5 hops are ignored; flatten the chain rather than relying on deep transitive includes.
- **Expecting `@` everywhere to import.** Only a line that *is* a path imports; an email-like `@handle` in prose is left alone, which is usually what you want.

## See also

- [[claude-md-project-memory]]
- [[user-vs-project-vs-local-memory]]
- [[claudeignore-file-scoping]]
