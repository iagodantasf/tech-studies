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
- What is Claude Code
- Installation & Setup
- Authentication & API Keys
- First Session & REPL Basics
- Choosing a Model
- Pricing & Token Usage

### CLI usage
- Interactive Mode
- One-Shot / Print Mode (-p)
- Piping Input & Output
- CLI Flags & Options
- Resuming & Continuing Sessions
- Managing Context (/clear, /compact)
- Image & File Input
- Keyboard Shortcuts & Vim Mode

### Project configuration
- CLAUDE.md Project Memory
- Nested & Imported Memory Files
- User vs Project vs Local Memory
- .claudeignore & File Scoping

### Slash commands
- Built-in Slash Commands
- Custom Slash Commands
- Command Arguments ($ARGUMENTS)
- Namespaced & Project Commands
- Frontmatter & Allowed Tools

### Tools & permissions
- Built-in Tools (Read, Edit, Bash, etc.)
- Permission Modes
- Allow / Deny Rules
- Plan Mode
- Auto-Accept & Bypass Modes

### Settings
- settings.json Hierarchy
- User & Project Settings
- Environment Variables
- Model & Output Configuration
- Managed / Enterprise Policy Settings

### Hooks
- Hooks Overview & Lifecycle
- PreToolUse & PostToolUse Hooks
- UserPromptSubmit & Stop Hooks
- Notification & SessionStart Hooks
- Writing & Debugging Hook Scripts

### MCP (Model Context Protocol)
- What is MCP
- Adding MCP Servers
- stdio vs SSE / HTTP Servers
- MCP Tools, Resources & Prompts
- MCP Authentication & Scopes
- Building a Custom MCP Server

### Subagents
- What are Subagents
- Defining Custom Subagents
- Subagent System Prompts & Tools
- Delegating Tasks to Subagents
- The Task Tool & Parallelism

### IDE integrations
- VS Code Extension
- JetBrains Integration
- Terminal vs IDE Workflow
- Diff Viewing & Inline Edits

### Agent SDK
- Claude Agent SDK Overview
- TypeScript SDK
- Python SDK
- Programmatic Sessions & Streaming
- Custom Tools & MCP in the SDK
- Building Headless Agents

### Workflows & automation
- Headless / CI Usage
- GitHub Actions Integration
- Git & PR Workflows
- Multi-Step Agentic Tasks
- Cost & Context Optimization
- Security & Safe Tool Use

## Resources
See [resources.md](./resources.md).

## Project ideas
- Author a custom slash command plus a PreToolUse hook that lints or guards Bash calls, and prove it fires on a real edit-and-test loop.
- Build a small MCP server (e.g. wrapping an internal API) and wire it into Claude Code, then drive it end-to-end from a session.
- Use the Agent SDK to script a headless agent that triages GitHub issues in CI, posting a summary comment with a custom subagent for code search.
