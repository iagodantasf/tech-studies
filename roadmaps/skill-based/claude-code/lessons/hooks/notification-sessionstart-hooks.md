---
title: Notification & SessionStart Hooks
track: claude-code
group: Hooks
tags: [claude-code, hooks]
prerequisites: [hooks-overview-lifecycle]
see-also: [userpromptsubmit-stop-hooks, claude-md-project-memory, writing-debugging-hook-scripts]
---

# Notification & SessionStart Hooks

Two ambient, non-blocking hooks: `Notification` fires when Claude Code wants your attention; `SessionStart` fires when a session opens and can inject startup context.

## Why it matters

`Notification` is how you bridge a long-running agent to the outside world — a desktop ping or Slack message when the agent is waiting for a permission approval or has gone idle, so you don't babysit the terminal. `SessionStart` is the "load bearing setup" hook: it runs once at the top of a session and can pull dynamic context (open issues, recent commits, the current sprint) into the conversation, complementing the static rules in [[claude-md-project-memory]]. Neither can block — they observe and inform.

## How it works

Both receive JSON on stdin but serve opposite directions: one pushes *out* to you, one pulls context *in*.

| Aspect | Notification | SessionStart |
|---|---|---|
| Fires when | permission needed / idle wait | session starts or resumes |
| stdin includes | `message` text | `source` (startup/resume/clear) |
| Typical use | desktop/Slack alert | inject git/issue context |
| Output consumed? | no (side-effect only) | yes — stdout added to context |

- **Notification** triggers on events like "Claude needs your permission to use Bash" or "Claude is waiting for your input" (idle). Use it purely for its side effect — play a sound, post a webhook. Its stdout is not fed back.
- **SessionStart** stdout (exit `0`) is **added to the session context**, same mechanism as `UserPromptSubmit` — so `git log --oneline -5` at startup seeds the agent with recent history. The `source` field distinguishes a fresh `startup` from a `resume` or post-`/clear` start.
- Neither hook has a `decision`; exit code only signals success vs. logged error.
- Like all hooks, both run synchronously under the shared timeout.

## Example

`Notification` hook for a macOS sound + banner when the agent needs you:

```json
{
  "hooks": {
    "Notification": [{
      "hooks": [{ "type": "command",
        "command": "osascript -e 'display notification \"Claude needs you\" sound name \"Glass\"'" }]
    }]
  }
}
```

`SessionStart` seeding the conversation with open work:

```bash
#!/usr/bin/env bash
echo "## Open PRs"
gh pr list --limit 5 2>/dev/null
echo "## Recent commits"
git log --oneline -5
```

## Pitfalls

- **Notification ≠ Stop.** Notification fires on *waiting* (permission/idle), not on turn completion; for "agent finished" reactions use a `Stop` hook (see [[userpromptsubmit-stop-hooks]]).
- **Bloating context at start.** SessionStart stdout is injected verbatim — a 500-line `git log` wastes tokens every session; cap the output.
- **Slow startup hooks delay the prompt.** `SessionStart` runs before you can type; a sluggish network call (e.g. `gh`) stalls session open.
- **Assuming notifications need no setup.** The hook runs your command — if `osascript`/webhook isn't there, nothing happens and the failure is easy to miss.

## See also

- [[hooks-overview-lifecycle]]
- [[userpromptsubmit-stop-hooks]]
- [[claude-md-project-memory]]
