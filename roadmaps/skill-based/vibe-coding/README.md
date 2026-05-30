---
title: Vibe Coding
track: vibe-coding
category: Skill-based
tags: [roadmap, ai, coding]
---

# Vibe Coding

> roadmap.sh: https://roadmap.sh/vibe-coding

Suggested path through the **Vibe Coding** nodes. Each node links to its lesson when written.

## Nodes

### Foundations
- What is Vibe Coding
- AI-Assisted vs Traditional Development
- When to Vibe Code (and When Not To)
- How LLMs Generate Code
- Strengths & Limitations of Coding Models
- Keeping Fundamentals Sharp

### Tooling landscape
- AI Coding Assistants Overview
- IDE Copilots (Copilot, Cursor, Windsurf)
- Agentic CLIs (Claude Code, Codex, Aider)
- Browser / No-Code Builders (Bolt, Lovable, v0)
- Choosing the Right Tool for the Task
- Local vs Cloud Models

### Prompting for code
- Prompt Engineering Basics
- Writing Clear Specs
- Providing Context & Examples
- Iterative Prompting
- Constraining Output & Scope
- Few-Shot & Reference Code

### Context management
- Project Context Files (rules, AGENTS.md)
- Selecting Relevant Files
- Managing the Context Window
- Memory & Persistent Instructions
- Retrieval & Codebase Indexing

### Workflow & process
- Plan-Then-Build Workflow
- Decomposing Tasks for Agents
- Small Diffs & Tight Loops
- Human-in-the-Loop Review
- Pair Programming with AI
- Test-Driven Vibe Coding

### Quality & verification
- Reading & Understanding Generated Code
- Reviewing AI Output Critically
- Debugging AI-Generated Bugs
- Refactoring Generated Code
- Automated Tests as a Safety Net
- Avoiding Hallucinated APIs

### Risks & responsibility
- Security Pitfalls of Generated Code
- Secrets & Sensitive Data Handling
- Licensing & Code Provenance
- Technical Debt & Maintainability
- Over-Reliance & Skill Atrophy
- Cost & Token Awareness

### Shipping
- From Prototype to Production
- Documentation & Handoff
- CI/CD for AI-Built Projects
- Iterating with User Feedback

## Resources
See [resources.md](./resources.md).

## Project ideas
- Take one feature idea fully from a written spec to a deployed app using only an agentic tool, logging every prompt and the fixes you had to make by hand.
- Run the same small build with two different tools (e.g. Cursor vs Claude Code) and write up a comparison of speed, code quality, and review burden.
- Build a reusable project rules file (AGENTS.md + lint/test setup) that reliably steers an AI agent toward your conventions, then validate it across three tasks.
