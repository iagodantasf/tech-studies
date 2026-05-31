---
title: settings.json Hierarchy
track: claude-code
group: Settings
tags: [claude-code, settings]
prerequisites: []
see-also: [user-project-settings, managed-enterprise-policy-settings, environment-variables]
---

# settings.json Hierarchy

The layered `settings.json` files that configure Claude Code — permissions, hooks, env, model — merged from enterprise down to per-session in a fixed precedence.

## Why it matters

Settings are *config*, distinct from the CLAUDE.md memory hierarchy ([[user-vs-project-vs-local-memory]]): memory shapes the prompt, settings control permissions, hooks, and runtime knobs. Because a project file is committed and a local file is not, the same repo can ship a shared safety policy ([[allow-deny-rules]]) while each developer keeps personal overrides — and an org can pin rules no one can loosen. Misreading which layer wins is the usual cause of "my deny rule isn't taking effect".

## How it works

Five sources load and deep-merge; higher rows override lower on conflict. Object fields (like `permissions.allow`) concatenate across layers; scalar fields (like `model`) are taken from the highest-precedence layer that sets them.

| Layer | Location | Scope | In git |
|---|---|---|---|
| Enterprise | managed system path | org-wide, locked | n/a |
| CLI flags | `--model`, `--permission-mode` | this invocation | n/a |
| Local project | `.claude/settings.local.json` | you, this repo | no |
| Project | `.claude/settings.json` | team, this repo | yes |
| User | `~/.claude/settings.json` | all your projects | no |

- Precedence high→low: **enterprise → CLI args → local project → project → user**. Enterprise policy is the hard ceiling — see [[managed-enterprise-policy-settings]].
- Common keys: `permissions` (`allow`/`ask`/`deny`/`defaultMode`/`additionalDirectories`), `hooks`, `env`, `model`, `apiKeyHelper`, `cleanupPeriodDays`.
- `/permissions` and `/config` edit settings live and persist them to the chosen file; you can also hand-edit the JSON.
- `settings.local.json` is auto-added to `.gitignore` so personal tweaks never get committed.

## Example

A project that allows tests but denies network, with one developer widening it locally:

```json
// .claude/settings.json (committed)
{ "permissions": { "allow": ["Bash(npm test:*)"], "deny": ["WebFetch"] },
  "model": "sonnet" }

// .claude/settings.local.json (gitignored, this dev only)
{ "permissions": { "allow": ["Bash(docker:*)"] } }
```

The merged `allow` is both lists; `deny: WebFetch` still holds (the local file didn't override it); `model` stays `sonnet` unless `--model` is passed.

## Pitfalls

- **Deny can't be un-denied below.** An enterprise or project `deny` wins over any lower-layer `allow` — you cannot re-permit it in `settings.local.json`.
- **Editing the wrong file.** Hand-editing `~/.claude/settings.json` won't fix a rule that the project file overrides; check all five layers.
- **Invalid JSON fails silent-ish.** A trailing comma or bad key can make a whole layer get skipped; validate after manual edits.
- **Confusing settings with memory.** `settings.json` ≠ `CLAUDE.md`; they share the user/project/local shape but do different jobs ([[user-project-settings]]).

## See also

- [[user-project-settings]]
- [[managed-enterprise-policy-settings]]
- [[environment-variables]]
