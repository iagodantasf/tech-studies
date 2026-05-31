---
title: User & Project Settings
track: claude-code
group: Settings
tags: [claude-code, settings]
prerequisites: [settings-json-hierarchy]
see-also: [settings-json-hierarchy, environment-variables, allow-deny-rules]
---

# User & Project Settings

The two developer-owned settings tiers — `~/.claude/settings.json` for you everywhere, `.claude/settings.json` (plus `settings.local.json`) for one repo — and which knobs belong where.

## Why it matters

Putting a setting in the wrong tier either leaks a personal choice into the team's repo or fails to share a convention CI also needs. The committed project file is a *shared contract*: clone the repo, get identical permissions, hooks, and model. User settings carry habits that travel with you; local settings hold per-developer, per-repo tweaks that must never be committed. Getting this split right is what makes agent behavior reproducible across a team.

## How it works

Three of the five [[settings-json-hierarchy]] layers are developer-owned. They deep-merge; project overrides user, and local project overrides project.

| Tier | File | Use for | Committed |
|---|---|---|---|
| User | `~/.claude/settings.json` | personal defaults across all repos | no |
| Project | `.claude/settings.json` | team policy for this repo | yes |
| Local | `.claude/settings.local.json` | your overrides for this repo | no (gitignored) |

- **User:** preferred `model`, personal `env`, an `apiKeyHelper`, broad read allows — things true for *you* in every project.
- **Project:** the shared `permissions` ([[allow-deny-rules]]), repo-specific `hooks`, the `defaultMode`, `additionalDirectories` — reviewed in PRs like code.
- **Local:** a teammate-specific allow (`Bash(docker:*)`), an experimental hook, a scratch `additionalDirectories` — kept out of git.
- `/permissions` writes to the **project** file by default; `/config` and direct edits target whichever file you choose.
- Project files mean CI and every teammate run with the same envelope — central to [[github-actions-integration]] and [[headless-ci-usage]].

## Example

Same repo, three concerns in three files:

```jsonc
// ~/.claude/settings.json        → applies to ALL my repos
{ "model": "sonnet", "permissions": { "allow": ["Read", "Grep"] } }

// payments/.claude/settings.json → whole team, committed
{ "permissions": { "deny": ["Read(./.env)", "WebFetch"],
                   "defaultMode": "acceptEdits" } }

// payments/.claude/settings.local.json → only me, gitignored
{ "permissions": { "allow": ["Bash(psql:*)"] } }
```

A teammate cloning `payments` inherits the deny rules and `acceptEdits` default but never your `psql` allow or your personal model pin.

## Pitfalls

- **Team rule stuck in user settings.** A convention only in `~/.claude/settings.json` never reaches teammates or CI — promote it to the project file.
- **Machine specifics in the committed file.** An absolute path or personal `env` in `.claude/settings.json` breaks everyone else; put it in `settings.local.json`.
- **`settings.local.json` not ignored.** If your `.gitignore` lacks it, "local" settings get committed and stop being local.
- **Assuming user wins.** Project overrides user — your personal `model` can be superseded by a project pin.

## See also

- [[settings-json-hierarchy]]
- [[environment-variables]]
- [[allow-deny-rules]]
