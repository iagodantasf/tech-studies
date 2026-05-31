---
title: Keyboard Shortcuts & Vim Mode
track: claude-code
group: CLI usage
tags: [claude-code, keybindings]
prerequisites: [interactive-mode]
see-also: [managing-context-clear-compact, built-in-slash-commands, permission-modes]
---

# Keyboard Shortcuts & Vim Mode

The interactive REPL has a set of keybindings for editing prompts, interrupting the agent, and navigating history — plus an optional Vim editing mode for the input box.

## Why it matters

Claude Code is a terminal tool you live in for hours; fluent keybindings are the difference between fighting the prompt box and flowing. Knowing how to *stop* a runaway turn, edit a prior message, or cycle permission modes without reaching for the mouse is core ergonomics — and Vim users get familiar modal editing for multi-line prompts.

## How it works

Core shortcuts (REPL input and agent control):

| Key | Action |
|---|---|
| `Enter` | submit prompt |
| `\` + `Enter` / `Option+Enter` | newline (multi-line prompt) |
| `Esc` | interrupt the running agent turn |
| `Esc` `Esc` | edit/rewind a previous message |
| `Ctrl+C` | clear input line (twice quickly = quit) |
| `Ctrl+D` | exit the session (EOF) |
| `Ctrl+L` | clear the terminal screen |
| `Shift+Tab` | cycle permission mode (plan / accept-edits / default) |
| `Up` / `Down` | walk prompt history |

- **`Shift+Tab`** rotates through [[permission-modes]] live — into [[plan-mode]], auto-accept-edits, and back — without restarting.
- **`Esc` once** stops the agent (vs `Ctrl+C` which only touches the input line); **`Esc` twice** opens history to edit and re-run an earlier turn.
- **Vim mode** is opt-in via `/vim` (or the `editorMode` setting). It adds NORMAL/INSERT modes to the input box: `Esc` → NORMAL, then `h j k l`, `w b`, `dd`, `cw`, `0`/`$`, `i`/`a`/`o` work as expected; `i` (or typing) returns to INSERT.

## Example

```text
> implement the whole migration in one shot   # too broad
  …agent starts editing 8 files…
> Esc                                          # stop it
> Esc Esc                                       # rewind to that prompt
> /vim                                          # enable modal editing
  (NORMAL)  cw  → change "whole migration" to "users table only"  → Esc
> [submit the narrowed prompt]
```

`Esc` halts the over-eager run, `Esc Esc` recovers the message, and Vim's `cw` rewrites it in place.

## Pitfalls

- **`Ctrl+C` to stop the agent.** It clears the *input line*, not the running turn — use `Esc`; a reflexive double-`Ctrl+C` quits the whole session.
- **Lost multi-line prompts.** Hitting `Enter` mid-thought submits early; use `\`+`Enter` / `Option+Enter` for newlines.
- **Vim mode surprise.** With `/vim` on, plain keystrokes in NORMAL mode are commands, not text — forgetting to enter INSERT (`i`) makes the prompt box "eat" your typing.
- **Terminal key capture.** Some terminals/multiplexers (tmux, iTerm) intercept `Esc`/`Shift+Tab`; rebind at the terminal or expect delayed `Esc`.

## See also

- [[managing-context-clear-compact]]
- [[built-in-slash-commands]]
- [[permission-modes]]
