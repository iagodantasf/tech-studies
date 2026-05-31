---
title: Auto-Accept & Bypass Modes
track: claude-code
group: Tools & permissions
tags: [claude-code, permissions]
prerequisites: [permission-modes]
see-also: [allow-deny-rules, plan-mode, security-safe-tool-use]
---

# Auto-Accept & Bypass Modes

The two high-autonomy permission modes — `acceptEdits` (edits flow, commands still ask) and `bypassPermissions` (nothing asks) — that trade approval friction for speed.

## Why it matters

Approving every edit is fine for a one-line fix and miserable for a 30-file refactor. The auto-accept tiers let the agent move at its own pace once you trust the task: `acceptEdits` for confident file work where you still want a hand on the shell, `bypassPermissions` (a.k.a. "YOLO mode") for fully unattended runs in a sandbox. Choosing the *right* tier is a security decision — the gap between them is exactly the gap between "edits without prompts" and "arbitrary shell without prompts." See [[security-safe-tool-use]].

## How it works

Both sit on top of the rule engine; a `deny` rule still blocks, but the per-call "yes/no" prompt disappears.

| Mode | Edits / Write | Bash & network | Honors deny rules? |
|---|---|---|---|
| `acceptEdits` | auto-apply | still prompt | yes |
| `bypassPermissions` | auto-apply | auto-run | yes (mostly) |

- Enter `acceptEdits` by cycling **Shift+Tab** (the TUI shows "accept edits on"); the footer reminds you it's active.
- `bypassPermissions` is opt-in and guarded: launch with `--dangerously-skip-permissions`, or set the mode where policy allows. It cannot be enabled if enterprise settings forbid it.
- `acceptEdits` is scoped: it auto-accepts *edits*, not command execution — `Bash` keeps prompting unless an [[allow-deny-rules]] entry covers it.
- For headless/CI, `bypassPermissions` (or a tight allowlist) is what lets `-p` runs proceed without a human; prefer the allowlist when feasible.

## Example

```bash
# Trusted, mechanical change — let edits flow, shell still gated:
claude --permission-mode acceptEdits "Rename getUser → fetchUser repo-wide"

# Disposable container, no human present — full autonomy:
docker run --rm -it -v "$PWD":/w -w /w sandbox \
  claude --dangerously-skip-permissions \
         -p "Upgrade all deps, fix breakages, run the suite"
```

The first applies dozens of edits with zero clicks but still asks before running anything. The second runs unattended *because it's isolated* — the blast radius is the throwaway container, not your laptop.

## Pitfalls

- **`bypassPermissions` on your real machine.** It will run any command the model emits, including destructive ones; only use it inside a container/VM or a directory you'd happily `rm -rf`.
- **Confusing the two tiers.** `acceptEdits` does *not* auto-run `Bash`; expecting silent command execution from it leaves you stuck at a prompt. That's `bypassPermissions`.
- **Forgetting it's still on.** Shift+Tab is sticky — auto-accept persists across many turns; a later, riskier instruction inherits it. Glance at the footer.
- **Treating deny as optional.** Bypass removes prompts, not your deny rules — keep `deny` for secrets/network even in YOLO runs, since it's your last guardrail.

## See also

- [[allow-deny-rules]]
- [[plan-mode]]
- [[security-safe-tool-use]]
