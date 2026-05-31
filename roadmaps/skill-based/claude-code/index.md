---
title: Claude Code
track: claude-code
category: Skill-based
tags: [roadmap, claude-code, ai]
---

# Claude Code

> roadmap.sh: https://roadmap.sh/claude-code

Suggested path through the **Claude Code** nodes. Each node links to its lesson when written.

## Nodes

### Getting started
- [[what-is-claude-code]]
- [[installation-setup]]
- [[authentication-api-keys]]
- [[first-session-repl-basics]]
- [[choosing-a-model]]
- [[pricing-token-usage]]

### CLI usage
- [[interactive-mode]]
- [[one-shot-print-mode-p]]
- [[piping-input-output]]
- [[cli-flags-options]]
- [[resuming-continuing-sessions]]
- [[managing-context-clear-compact]]
- [[image-file-input]]
- [[keyboard-shortcuts-vim-mode]]

### Project configuration
- [[claude-md-project-memory]]
- [[nested-imported-memory-files]]
- [[user-vs-project-vs-local-memory]]
- [[claudeignore-file-scoping]]

### Slash commands
- [[built-in-slash-commands]]
- [[custom-slash-commands]]
- [[command-arguments-arguments]]
- [[namespaced-project-commands]]
- [[frontmatter-allowed-tools]]

### Tools & permissions
- [[built-in-tools-read-edit-bash-etc]]
- [[permission-modes]]
- [[allow-deny-rules]]
- [[plan-mode]]
- [[auto-accept-bypass-modes]]

### Settings
- [[settings-json-hierarchy]]
- [[user-project-settings]]
- [[environment-variables]]
- [[model-output-configuration]]
- [[managed-enterprise-policy-settings]]

### Hooks
- [[hooks-overview-lifecycle]]
- [[pretooluse-posttooluse-hooks]]
- [[userpromptsubmit-stop-hooks]]
- [[notification-sessionstart-hooks]]
- [[writing-debugging-hook-scripts]]

### MCP (Model Context Protocol)
- [[what-is-mcp]]
- [[adding-mcp-servers]]
- [[stdio-vs-sse-http-servers]]
- [[mcp-tools-resources-prompts]]
- [[mcp-authentication-scopes]]
- [[building-a-custom-mcp-server]]

### Subagents
- [[what-are-subagents]]
- [[defining-custom-subagents]]
- [[subagent-system-prompts-tools]]
- [[delegating-tasks-to-subagents]]
- [[the-task-tool-parallelism]]

### IDE integrations
- [[vs-code-extension]]
- [[jetbrains-integration]]
- [[terminal-vs-ide-workflow]]
- [[diff-viewing-inline-edits]]

### Agent SDK
- [[claude-agent-sdk-overview]]
- [[typescript-sdk]]
- [[python-sdk]]
- [[programmatic-sessions-streaming]]
- [[custom-tools-mcp-in-the-sdk]]
- [[building-headless-agents]]

### Workflows & automation
- [[headless-ci-usage]]
- [[github-actions-integration]]
- [[git-pr-workflows]]
- [[multi-step-agentic-tasks]]
- [[cost-context-optimization]]
- [[security-safe-tool-use]]

## Resources
See [resources.md](./resources.md).

## Project ideas
- Author a custom slash command plus a PreToolUse hook that lints or guards Bash calls, and prove it fires on a real edit-and-test loop.
- Build a small MCP server (e.g. wrapping an internal API) and wire it into Claude Code, then drive it end-to-end from a session.
- Use the Agent SDK to script a headless agent that triages GitHub issues in CI, posting a summary comment with a custom subagent for code search.
