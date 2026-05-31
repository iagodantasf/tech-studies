---
title: Writing & Debugging Hook Scripts
track: claude-code
group: Hooks
tags: [claude-code, hooks]
prerequisites: [hooks-overview-lifecycle]
see-also: [pretooluse-posttooluse-hooks, userpromptsubmit-stop-hooks, settings-json-hierarchy]
---

# Writing & Debugging Hook Scripts

The practical craft of authoring a hook command — parsing its stdin JSON, returning the right exit code and stdout shape, and figuring out why it silently did nothing.

## Why it matters

Every hook in [[hooks-overview-lifecycle]] is just a shell command, so the failure modes are mundane and infuriating: a typo'd `jq` filter, a non-executable script, a path that resolves differently under the agent than in your shell. Knowing the input/output contract and the debug entry points turns "my hook isn't firing" from a guessing game into a five-minute fix.

## How it works

A hook reads a JSON event on **stdin**, does work, and communicates back via **exit code** + optional **stdout JSON**. Common stdin fields:

| Field | Present in | Meaning |
|---|---|---|
| `session_id` | all | current session id |
| `cwd` | all | working directory |
| `tool_name` | tool hooks | e.g. `Bash`, `Edit` |
| `tool_input` | tool hooks | the tool's arguments |
| `tool_response` | PostToolUse | the tool's result |
| `prompt` | UserPromptSubmit | the submitted text |

- Exit codes: `0` = success (stdout may be parsed/injected), `2` = **block** with stderr shown to the model, anything else = non-blocking error (stderr logged, action proceeds).
- Parse stdin with `jq`: `cmd=$(jq -r '.tool_input.command')`. Reading positional args won't work — input is on stdin, not `argv`.
- Configure with absolute paths or `$CLAUDE_PROJECT_DIR`; the hook's `cwd` may not be where you expect. Use `"command": "$CLAUDE_PROJECT_DIR/.claude/hooks/check.sh"`.
- Debug with `claude --debug` (prints hook execution + exit codes), inspect the registered hooks via `/hooks`, and log to a file since stdout is consumed by Claude Code.
- Keep it fast and `chmod +x` the script; the default per-hook timeout is 60 s.

## Example

A defensive, well-formed PreToolUse guard script:

```bash
#!/usr/bin/env bash
set -euo pipefail
input=$(cat)                                   # consume stdin once
cmd=$(echo "$input" | jq -r '.tool_input.command // ""')
echo "$(date) $cmd" >> "$CLAUDE_PROJECT_DIR/.claude/hook.log"  # log, not stdout
if [[ "$cmd" == *"rm -rf /"* ]]; then
  echo "Blocked dangerous command" >&2          # stderr -> shown to model
  exit 2                                         # 2 = block
fi
exit 0
```

Test it in isolation before wiring it up:

```bash
echo '{"tool_input":{"command":"rm -rf /tmp/x"}}' | .claude/hooks/check.sh; echo "exit=$?"
```

## Pitfalls

- **Not executable / wrong shebang.** A missing `chmod +x` or absent interpreter makes the hook fail silently; `--debug` reveals it.
- **Writing diagnostics to stdout.** For most events stdout is parsed as control JSON — stray `echo`s corrupt it or get injected as context. Log to a file or stderr.
- **`cwd` assumptions.** Relative paths break because the hook may run from a different directory; anchor on `$CLAUDE_PROJECT_DIR`.
- **`jq` on absent fields.** `jq -r '.tool_input.file_path'` prints `null` when missing; guard with `// ""` to avoid acting on the literal string "null".

## See also

- [[hooks-overview-lifecycle]]
- [[pretooluse-posttooluse-hooks]]
- [[userpromptsubmit-stop-hooks]]
