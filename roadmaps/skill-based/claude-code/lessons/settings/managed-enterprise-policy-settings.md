---
title: Managed / Enterprise Policy Settings
track: claude-code
group: Settings
tags: [claude-code, enterprise]
prerequisites: [settings-json-hierarchy]
see-also: [settings-json-hierarchy, user-project-settings, allow-deny-rules]
---

# Managed / Enterprise Policy Settings

An admin-deployed `managed-settings.json` that sits at the top of the settings hierarchy and enforces org-wide rules no developer can override.

## Why it matters

In a regulated or large org, "please don't let the agent read secrets or hit the open internet" can't depend on every developer's local config. Managed policy is the hard ceiling: IT deploys one file via MDM/config management, and its `deny` rules and disabled features apply to every session on the machine — including [[auto-accept-bypass-modes|bypass mode]] and CI. It's the layer that lets security sign off on rolling Claude Code out to a whole company.

## How it works

The managed file is the highest-precedence layer in [[settings-json-hierarchy]] — it wins over CLI flags, project, local, and user settings. It uses the same schema (`permissions`, `hooks`, `env`, etc.) but is enforced, not merged-as-a-suggestion.

| Platform | Typical managed path |
|---|---|
| macOS | `/Library/Application Support/ClaudeCode/managed-settings.json` |
| Linux | `/etc/claude-code/managed-settings.json` |
| Windows | `C:\ProgramData\ClaudeCode\managed-settings.json` |

- Precedence high→low: **enterprise → CLI args → local project → project → user**. A managed `deny` cannot be re-allowed anywhere below.
- Deploy it root-owned via MDM (Jamf/Intune) or config management so developers can't edit it.
- Good policy targets: `deny` for secret paths and `WebFetch`, a mandatory audit `hook`, a pinned `ANTHROPIC_BASE_URL` to a corporate gateway, forbidding `bypassPermissions`.
- Because it's enforced even in bypass mode, it's the only layer security can fully trust — project/user files are advisory by comparison.
- Pairs with [[environment-variables]] for routing all traffic through Bedrock/Vertex or an internal proxy.

## Example

A `managed-settings.json` that locks the safety envelope company-wide:

```json
{
  "permissions": {
    "deny": ["Read(./.env)", "Read(./secrets/**)", "WebFetch", "Bash(curl:*)"]
  },
  "env": { "ANTHROPIC_BASE_URL": "https://llm-gateway.corp.internal" },
  "hooks": { "PreToolUse": [{ "matcher": "Bash",
    "hooks": [{ "type": "command", "command": "/usr/local/bin/audit-log.sh" }] }] }
}
```

Every developer's session — even one that opens `settings.local.json` and adds `"allow": ["WebFetch"]` — still can't reach the network, and every Bash call is audited.

## Pitfalls

- **Deploying it writable.** If a developer can edit the managed file, it's no longer a policy — lock it down with root ownership and MDM.
- **Over-locking productivity.** Denying `Bash` wholesale or forcing `default` mode everywhere drowns devs in prompts; deny the *dangerous* edges, not everything ([[allow-deny-rules]]).
- **Wrong platform path.** A file in the macOS path won't load on Linux runners — deploy the correct path per OS or CI silently runs unpoliced.
- **Assuming bypass ignores it.** Devs sometimes expect `bypassPermissions` to skip policy; managed `deny` still holds, which is the whole point.

## See also

- [[settings-json-hierarchy]]
- [[user-project-settings]]
- [[allow-deny-rules]]
