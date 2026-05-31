---
title: Permission Modes
track: claude-code
group: Tools & permissions
tags: [claude-code, permissions]
prerequisites: [built-in-tools-read-edit-bash-etc]
see-also: [allow-deny-rules, plan-mode, auto-accept-bypass-modes]
---

# Permission Modes

The session-wide policy that decides, before any tool runs, whether Claude Code asks you, runs silently, or refuses outright.

## Why it matters

Permission mode is the master switch for how much autonomy the agent has *right now*. The same task feels completely different in `default` (constant approvals), `acceptEdits` (edits flow, shell still asks), or `bypassPermissions` (no brakes). Picking the wrong mode either drowns you in prompts or hands an LLM unfettered shell access — so understanding the four modes, and how they compose with [[allow-deny-rules]], is core to using the tool safely and fast.

## How it works

A mode sits *above* the rule list: it sets the default disposition, then allow/deny rules carve exceptions. The modes:

| Mode | Edits | Bash / other writes | Reads |
|---|---|---|---|
| `default` | prompt | prompt | run |
| `plan` | blocked | blocked | run |
| `acceptEdits` | auto | prompt | run |
| `bypassPermissions` | auto | auto | run |

- Set it for a session with `--permission-mode <mode>`, or switch live by cycling **Shift+Tab** at the prompt.
- `plan` is read-only investigation — the agent proposes, mutates nothing. See [[plan-mode]].
- `acceptEdits` and `bypassPermissions` are the autonomy tiers covered in [[auto-accept-bypass-modes]].
- Deny rules win in every mode (even bypass honors an explicit deny in most builds); allow rules suppress prompts that the mode would otherwise raise.
- `defaultMode` in [[settings-json-hierarchy]] sets the startup mode per project; enterprise policy can pin or forbid specific modes.

## Example

Same "refactor and test" task, by mode:

```text
default  : prompt on every Edit, prompt on `pytest`     → ~6 approvals
acceptEdits: edits apply instantly, prompt only on `pytest` → 1 approval
plan     : writes a step-by-step plan, changes 0 files   → 0 approvals
bypass   : edits + pytest run untouched                  → 0 approvals
```

A common loop: start in `plan` to scope the change, Shift+Tab into `acceptEdits` to let edits flow, drop back to `default` for anything that runs commands.

## Pitfalls

- **`bypassPermissions` in an untrusted repo or CI.** It is the "no questions asked" mode; a single bad command runs unchecked. Reserve it for throwaway sandboxes.
- **Thinking a mode overrides a deny.** Deny rules are the hard floor — `bypass` does not re-enable a denied `Bash(curl:*)`.
- **Headless with no autonomy.** `-p` has no human to click "yes"; in `default` mode gated tools stall. Pair print mode with `acceptEdits`/allowlists, not the default.
- **Forgetting the mode is sticky.** Shift+Tab changes persist for the session; you may be in `acceptEdits` long after you meant to leave it.

## See also

- [[allow-deny-rules]]
- [[plan-mode]]
- [[auto-accept-bypass-modes]]
