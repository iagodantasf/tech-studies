---
title: Allow / Deny Rules
track: claude-code
group: Tools & permissions
tags: [claude-code, permissions]
prerequisites: [permission-modes]
see-also: [settings-json-hierarchy, built-in-tools-read-edit-bash-etc, plan-mode]
---

# Allow / Deny Rules

Per-tool, per-argument rules that pre-approve or hard-block specific tool calls, turning "the agent asks every time" into precise, reviewable policy.

## How it works

A rule is `Tool` or `Tool(specifier)`. Empty parens means the whole tool; a specifier narrows it by argument — a command pattern for `Bash`, a path glob for file tools, a host for `WebFetch`. Three lists are evaluated in strict order:

| List | Effect | Wins? |
|---|---|---|
| `deny` | block, no prompt, even in bypass | highest |
| `ask` | force a prompt even if a mode would auto-allow | middle |
| `allow` | run with no prompt | lowest |

- Evaluation: **deny → ask → allow → fall back to the mode's default**. First match decides.
- `Bash` specifiers are prefix patterns: `Bash(npm run test:*)` matches `npm run test`, `npm run test:watch`; `:*` is the wildcard tail. They are *not* full shell parsing.
- File rules use gitignore-style globs against the path: `Edit(src/**)`, `Read(./.env)`, `Write(//tmp/**)`.
- Rules live in [[settings-json-hierarchy]] under `permissions`; `/permissions` and `/allowed-tools` edit them live and persist to the chosen settings file.
- `--allowedTools` / `--disallowedTools` (and `--add-dir`) set them per-invocation, the usual pattern for [[headless-ci-usage]].

## Why it matters

The default "approve everything" flow is safe but slow; blanket [[auto-accept-bypass-modes]] is fast but reckless. Rules are the middle path — let the boring, safe calls (`Bash(git status)`, `Read`, `npm test`) run free while still gating `git push`, network access, and edits to secrets. Because they're committed in settings, the safety envelope is shared and code-reviewed, not improvised per session.

## Example

A project `.claude/settings.json` that frees up routine work but fences the dangerous edges:

```json
{
  "permissions": {
    "allow": ["Read", "Grep", "Glob", "Bash(npm run test:*)", "Bash(git status)"],
    "ask":   ["Bash(git push:*)"],
    "deny":  ["Read(./.env)", "Read(./secrets/**)", "Bash(curl:*)", "WebFetch"]
  }
}
```

Tests and read-only git run silently; `git push` always asks; the agent can never read `.env` or reach the network — regardless of permission mode.

## Pitfalls

- **Bash specifiers aren't real parsing.** `Bash(git:*)` does not stop `echo x && git push`; chained/obfuscated commands can slip past prefix matches. Deny-list the verb *and* keep `Bash` itself gated.
- **Allow too broad.** `Bash(*)` or `Bash` with empty parens re-opens everything; one wide allow can swallow your deny intent for narrower cases.
- **Wrong settings layer.** A user-global allow can be overridden — or an enterprise deny can override *you*. Know the precedence in [[settings-json-hierarchy]].
- **Path rules are literal-ish.** `Read(.env)` and `Read(./.env)` may not match the same way; test with `/permissions` rather than assuming.

## See also

- [[settings-json-hierarchy]]
- [[built-in-tools-read-edit-bash-etc]]
- [[plan-mode]]
