---
title: PreToolUse & PostToolUse Hooks
track: claude-code
group: Hooks
tags: [claude-code, hooks]
prerequisites: [hooks-overview-lifecycle]
see-also: [writing-debugging-hook-scripts, allow-deny-rules, built-in-tools-read-edit-bash-etc]
---

# PreToolUse & PostToolUse Hooks

The two tool-scoped hooks: `PreToolUse` runs *before* a tool call and can veto it; `PostToolUse` runs *after* it succeeds and can feed results back to the model.

## Why it matters

These are the workhorses of hook automation. `PreToolUse` is a programmable gate — block `rm -rf`, deny writes to `.env`, force-approve a safe command — running deterministically alongside [[allow-deny-rules]]. `PostToolUse` is the "react to what just happened" hook: auto-format the file the model just edited, run type-checks, or surface a failing test so the agent self-corrects. Together they bracket every [[built-in-tools-read-edit-bash-etc]] call.

## How it works

Both receive JSON on stdin including `tool_name`, `tool_input`, and (Post only) `tool_response`. They differ in *when* they fire and *what their decision can do*:

| Aspect | PreToolUse | PostToolUse |
|---|---|---|
| Timing | before execution | after success |
| `decision` values | `approve` / `block` | `block` only |
| Effect of block | call is cancelled | result + reason sent back to model |
| Common use | guardrails, auto-approve | format, lint, test |

- **PreToolUse** stdout `{"hookSpecificOutput": {"permissionDecision": "deny", "permissionDecisionReason": "..."}}` cancels the tool; `"allow"` skips the normal permission prompt. Exit code `2` is the shorthand block, with stderr shown to the model.
- **PostToolUse** cannot un-run the tool (it already ran); `{"decision": "block", "reason": "..."}` (or exit `2`) injects the reason so the model reacts — e.g. "tsc found 3 errors, fix them".
- The `matcher` field selects tools by exact name or regex alternation: `Edit|Write|MultiEdit`, `Bash`, `mcp__.*`, or `*` for all.
- Multiple hooks on one matcher run in order; any one blocking is enough.

## Example

PostToolUse that formats whatever file was just edited:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{ "type": "command",
        "command": "prettier --write \"$(jq -r '.tool_input.file_path')\"" }]
    }]
  }
}
```

A PreToolUse guard blocking edits to secrets — exit `2` so stderr reaches the model:

```bash
#!/usr/bin/env bash
f=$(jq -r '.tool_input.file_path')
[[ "$f" == *.env ]] && { echo "Refusing to edit secrets file" >&2; exit 2; }
```

## Pitfalls

- **PostToolUse can't prevent the side effect.** The write already landed; you can only react. Use PreToolUse to truly block.
- **Wrong field shape.** Pre uses `permissionDecision` under `hookSpecificOutput`; Post uses top-level `decision`/`reason`. Mixing them silently no-ops.
- **`approve` still honors deny rules.** A PreToolUse `allow` suppresses the prompt but cannot override an explicit settings deny in most builds.
- **Matcher misses MCP tools.** MCP tools are named `mcp__server__tool`; a `Bash`-only matcher won't catch them — use a regex if you mean "everything".

## See also

- [[hooks-overview-lifecycle]]
- [[writing-debugging-hook-scripts]]
- [[allow-deny-rules]]
