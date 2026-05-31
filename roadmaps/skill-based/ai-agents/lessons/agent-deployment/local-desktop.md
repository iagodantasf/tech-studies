---
title: Local Desktop
track: ai-agents
group: Agent Deployment
tags: [ai-agents, deployment]
prerequisites: [acting-tool-invocation]
see-also: [remote-cloud, file-system-access, open-weight-models]
---

# Local Desktop

Running the agent loop as a process on the user's own machine, where it can touch the local filesystem, shell, and apps directly instead of through a remote API surface.

## Why it matters

Some agents *must* be local: a coding agent that edits your repo, a [[personal-assistant]] that reads local files, or a privacy-sensitive workflow where data can't leave the box. Local deployment trades scalability for two big wins — zero per-token egress to a server you run, and native access to [[file-system-access]] and [[git-and-terminal-usage]] without shipping the workspace anywhere. It's also the only way to use a local [[open-weight-models]] backend (Ollama, llama.cpp) for full offline operation.

## How it works

The loop runs as a desktop process (CLI, Electron app, or tray daemon). The LLM call still usually goes out to a hosted API; what's local is the *tool execution* and *state*.

- **Two backends, one loop** — model inference is either remote (Anthropic/OpenAI over HTTPS) or local (an Ollama server on `localhost:11434`). Only the latter is truly offline.
- **Direct tool access** — tools run in-process or via `subprocess`, so the agent reads `~/project`, runs `git`, opens a browser, with the *user's own* OS permissions.
- **Local state** — config, [[long-term-memory]], and logs live in `~/.config/<app>` or a SQLite file; no server round-trip.
- **Secrets on disk** — API keys sit in env vars or an OS keychain (macOS Keychain, Windows Credential Manager), not a cloud secret store.

| Concern | Local desktop | Remote / cloud |
|---|---|---|
| Data egress | files stay local | uploaded to server |
| Scaling | one user, one box | many users, autoscale |
| Inference | remote or local model | server-side |
| Update path | user must upgrade | push centrally |

## Example

A local coding agent's startup:

```
1. load key from macOS Keychain (security find-generic-password)
2. resolve workspace root = $PWD, sandbox tools to it
3. loop: prompt → POST api.anthropic.com → tool_use{edit,bash}
4.        run tool in-process under user's uid → observation
5. persist transcript to ~/.cache/agent/sessions/<id>.jsonl
```

Files never leave the laptop; only prompts + tool *outputs* go to the model API.

## Pitfalls

- **Ambient authority.** The agent inherits the user's full OS permissions — a bad `bash` call can `rm -rf $HOME`. Confine roots and gate destructive tools with confirmation.
- **"Offline" that isn't.** A local UI with a remote model still leaks every prompt and tool result over the wire; only a local model is actually private.
- **Key leakage** — keys in a dotfile or committed `.env` get exfiltrated; use the OS keychain and keep them out of [[git-and-terminal-usage]].
- **Version skew** — each user runs a different build, so a prompt fix can't be hot-pushed; bugs persist until they update, unlike [[remote-cloud]].

## See also

- [[remote-cloud]]
- [[file-system-access]]
- [[open-weight-models]]
