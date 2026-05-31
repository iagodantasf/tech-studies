---
title: UserPromptSubmit & Stop Hooks
track: claude-code
group: Hooks
tags: [claude-code, hooks]
prerequisites: [hooks-overview-lifecycle]
see-also: [pretooluse-posttooluse-hooks, notification-sessionstart-hooks, writing-debugging-hook-scripts]
---

# UserPromptSubmit & Stop Hooks

The two turn-boundary hooks: `UserPromptSubmit` fires the instant you send a prompt (and can edit or reject it); `Stop` fires when the agent tries to end its turn (and can force it to keep going).

## Why it matters

`UserPromptSubmit` is the only hook that runs *before the model sees your message*, making it the place to inject fresh context — current branch, ticket text, today's date — or to block prompts that violate policy. `Stop` is the "are you actually done?" gate: it can refuse the agent's attempt to finish until tests pass or a checklist is met, turning a one-shot reply into a loop. Both bracket the conversation turn the way Pre/PostToolUse bracket a tool call (see [[pretooluse-posttooluse-hooks]]).

## How it works

Both read JSON on stdin; their decision channel differs because one gates *input* and the other gates *finishing*:

| Aspect | UserPromptSubmit | Stop |
|---|---|---|
| Fires | on prompt submit | when agent ends turn |
| stdin includes | `prompt` text | `stop_hook_active` flag |
| Block effect | prompt rejected | agent forced to continue |
| Bonus power | stdout text is *added to context* | reason tells model what's left |

- **UserPromptSubmit**: plain stdout (exit `0`) is **prepended to the prompt as extra context** — uniquely, non-JSON output here is consumed, not ignored. `{"decision": "block", "reason": "..."}` or exit `2` rejects the prompt and shows the reason to *you*, not the model.
- **Stop** / `SubagentStop`: `{"decision": "block", "reason": "..."}` (or exit `2`) prevents stopping and feeds `reason` back so the agent continues working on it.
- The `stop_hook_active` field is `true` when the agent is already continuing *because* of a prior Stop block — check it to avoid an infinite loop.
- Neither uses a `matcher` (they aren't tool-scoped).

## Example

`UserPromptSubmit` injecting git context into every prompt:

```bash
#!/usr/bin/env bash
echo "Current branch: $(git branch --show-current)"
echo "Uncommitted files: $(git status --porcelain | wc -l)"
```

`Stop` hook that blocks finishing while tests fail, but only once:

```bash
#!/usr/bin/env bash
active=$(jq -r '.stop_hook_active')
[[ "$active" == "true" ]] && exit 0       # already looping, let it stop
npm test --silent || { echo '{"decision":"block","reason":"Tests fail — fix them."}'; exit 0; }
```

## Pitfalls

- **Stop loops.** Blocking unconditionally makes the agent never finish; always short-circuit on `stop_hook_active`.
- **Leaking via UserPromptSubmit stdout.** Whatever you print is silently injected into the model's context — don't echo secrets or huge dumps.
- **Confusing who sees the reason.** A blocked *prompt* reason is shown to the user; a blocked *Stop* reason is shown to the model. They drive different audiences.
- **Latency on every turn.** UserPromptSubmit runs before *each* message; a slow script adds perceptible lag to typing.

## See also

- [[hooks-overview-lifecycle]]
- [[pretooluse-posttooluse-hooks]]
- [[notification-sessionstart-hooks]]
