---
title: AI Agents
track: ai-agents
category: Skill-based
tags: [roadmap, ai, agents]
---

# AI Agents

> roadmap.sh: https://roadmap.sh/ai-agents

Suggested path through the **AI Agents** nodes. Each node links to its lesson when written.

## Nodes

### Pre-requisites
- [[basic-backend-development]]
- [[rest-api-knowledge]]
- [[api-requests]]
- [[git-and-terminal-usage]]

### What are AI Agents
- [[what-are-ai-agents]]
- [[agent-loop]]
- [[perception-user-input]]
- [[reason-and-plan]]
- [[acting-tool-invocation]]
- [[observation-reflection]]

### LLM Fundamentals
- [[closed-weight-models]]
- [[open-weight-models]]
- [[reasoning-vs-standard-models]]
- [[context-windows]]
- [[fine-tuning-vs-prompt-engineering]]
- [[embeddings-and-vector-search]]
- [[token-based-pricing]]
- [[pricing-of-common-models]]

### Model Configuration / Tuning
- [[temperature]]
- [[top-p-top-k]]
- [[max-length-max-tokens]]
- [[stopping-criteria]]
- [[frequency-penalty]]
- [[presence-penalty]]
- [[streamed-vs-unstreamed-responses]]

### Prompt Engineering
- [[be-specific-in-what-you-want]]
- [[provide-additional-context]]
- [[specify-length-format-etc]]
- [[iterate-and-test-your-prompts]]
- [[chain-of-thought-cot]]
- [[react-reason-act]]

### Tool / Function Calling
- [[llm-native-function-calling]]
- [[openai-functions-calling]]
- [[openai-assistant-api]]
- [[anthropic-tool-use]]
- [[gemini-function-calling]]

### Building Agents Manually
- [[manual-from-scratch]]
- [[understanding-the-architecture]]

### Agent Architectures
- [[react-reason-act]]
- [[planner-executor]]
- [[dag-agents]]
- [[chain-of-thought-cot]]
- [[tree-of-thought-tot]]

### Tools an Agent Can Use
- [[code-execution-repl]]
- [[web-scraping-crawling]]
- [[web-search]]
- [[api-requests]]
- [[database-queries]]
- [[file-system-access]]
- [[git-and-terminal-usage]]
- [[email-slack-sms]]

### Model Context Protocol (MCP)
- [[model-context-protocol-mcp]]
- [[mcp-hosts]]
- [[mcp-client]]
- [[mcp-servers]]
- [[creating-mcp-servers]]

### Memory
- [[short-term-memory]]
- [[long-term-memory]]
- [[episodic-vs-semantic-memory]]
- [[rag-and-vector-databases]]
- [[summarization-compression]]
- [[forgetting-aging-strategies]]

### Frameworks
- [[langchain]]
- [[langgraph]]
- [[llamaindex]]
- [[haystack]]
- [[crewai]]
- [[autogen]]
- [[smol-depot]]

### Evaluation / Observability
- [[metrics-to-track]]
- [[human-in-the-loop-evaluation]]
- [[langsmith]]
- [[langfuse]]
- [[helicone]]
- [[deepeval]]
- [[ragas]]
- [[openllmetry]]
- [[structured-logging-tracing]]
- [[integration-testing-for-flows]]
- [[unit-testing]]

### Security / Safety
- [[prompt-injection-jailbreaks]]
- [[data-privacy-pii-redaction]]
- [[bias-toxicity-guardrails]]
- [[safety-red-team-testing]]

### Agent Deployment
- [[local-desktop]]
- [[remote-cloud]]

### Example Use Cases
- [[personal-assistant]]
- [[rag-agent]]
- [[code-generation]]
- [[data-analysis]]
- [[npc-game-ai]]

## Resources
See [resources.md](./resources.md).

## Project ideas
- **MCP-powered research assistant**: build an agent that exposes web search, a vector store, and a code-execution tool over MCP, then chains ReAct reasoning to answer multi-step questions with citations.
- **Self-evaluating coding agent**: a planner-executor agent that generates code, runs it in a REPL sandbox, reads the failures, and iterates — wired to LangSmith/Langfuse for traces and a DeepEval test suite as a regression gate.
- **Personal inbox triage agent**: an agent with long-term memory (vector DB) that reads email/Slack, classifies and drafts replies, escalates with human-in-the-loop approval, and redacts PII before logging.
