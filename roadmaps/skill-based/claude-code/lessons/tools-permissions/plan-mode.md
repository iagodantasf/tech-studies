---
title: Plan Mode
track: claude-code
group: Tools & permissions
tags: [claude-code, permissions]
prerequisites: [permission-modes]
see-also: [auto-accept-bypass-modes, managing-context-clear-compact, multi-step-agentic-tasks]
---

# Plan Mode

A read-only permission mode where Claude Code investigates and drafts a step-by-step plan but is structurally forbidden from changing anything until you approve.

## Why it matters

Letting an agent edit first and explain later is how you get a confident, wrong, half-finished refactor scattered across ten files. Plan mode inverts the loop: the model reads the codebase, reasons about the change, and presents a concrete plan you can correct *before* a single byte is written. For anything multi-file, risky, or ambiguous — schema migrations, cross-cutting renames, "I'm not sure this is the right approach" work — it's the cheapest way to catch a bad strategy early. See [[multi-step-agentic-tasks]].

## How it works

Plan mode is one of the [[permission-modes]]; while active, all mutating tools (`Edit`, `Write`, `Bash`, `Task`) are blocked, while read/search tools stay open.

| Available in plan mode | Blocked in plan mode |
|---|---|
| `Read`, `Glob`, `Grep` | `Edit`, `MultiEdit`, `Write` |
| `WebFetch` / `WebSearch` (read-only) | `Bash` (any command) |
| reasoning, drafting the plan | `Task` subagent spawning |

- Enter it by cycling **Shift+Tab**, or launch with `claude --permission-mode plan`.
- The agent ends by presenting the plan and asking to proceed; approving exits plan mode (commonly into `acceptEdits`) and execution begins.
- Because *no* command runs, `Bash`-driven discovery (e.g. `grep` via shell, `git log`) is unavailable — the model leans on `Grep`/`Glob`/`Read` instead.
- Pairs well with a fresh context: `/clear`, plan, then execute, so the plan isn't polluted by earlier turns. See [[managing-context-clear-compact]].

## Example

```text
You:  (Shift+Tab → plan) "Migrate the auth module from JWT to PASETO."
Claude (plan mode):
  reads src/auth/*, grep "jwt" across repo, reads tests
  → Plan:
     1. Add paseto dep, keep jwt during transition
     2. Introduce TokenVerifier interface (src/auth/verify.py)
     3. Port issue/verify; dual-accept tokens for one release
     4. Migrate tests; flip default; remove jwt in follow-up
  "Proceed?"  ← nothing changed yet
You:  "Swap steps 3 and 4 — drop dual-accept." → approve → edits begin
```

You redirected the whole approach before any file was touched, at the cost of a few read calls.

## Pitfalls

- **Expecting it to verify by running.** Plan mode can't execute tests or build; its plan is reasoned from reading, so a step may be infeasible until execution exposes it.
- **Approving a wall of text unread.** The value is entirely in reviewing the plan — rubber-stamping it forfeits the safety it buys.
- **Stuck wondering why nothing happens.** If edits "don't apply," you're likely still in plan mode; Shift+Tab out or approve the plan.
- **Plan drift after big edits.** A plan written against stale context can mismatch reality; for long jobs, re-plan after major milestones rather than trusting the original.

## See also

- [[auto-accept-bypass-modes]]
- [[managing-context-clear-compact]]
- [[multi-step-agentic-tasks]]
