---
title: AI Agents
roadmap: ai-agents
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, ai, agents]
---

# AI Agents

> roadmap.sh: https://roadmap.sh/ai-agents

Track for the **AI Agents** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Pre-requisites
- [ ] Basic Backend Development
- [ ] REST API Knowledge
- [ ] API Requests
- [ ] Git and Terminal Usage

### What are AI Agents
- [ ] What are AI Agents
- [ ] Agent Loop
- [ ] Perception / User Input
- [ ] Reason and Plan
- [ ] Acting / Tool Invocation
- [ ] Observation / Reflection

### LLM Fundamentals
- [ ] Closed-Weight Models
- [ ] Open-Weight Models
- [ ] Reasoning vs Standard Models
- [ ] Context Windows
- [ ] Fine-tuning vs Prompt Engineering
- [ ] Embeddings and Vector Search
- [ ] Token-based Pricing
- [ ] Pricing of Common Models

### Model Configuration / Tuning
- [ ] Temperature
- [ ] Top-p / Top-k
- [ ] Max Length / Max Tokens
- [ ] Stopping Criteria
- [ ] Frequency Penalty
- [ ] Presence Penalty
- [ ] Streamed vs Unstreamed Responses

### Prompt Engineering
- [ ] Be Specific in What You Want
- [ ] Provide Additional Context
- [ ] Specify Length, Format, etc.
- [ ] Iterate and Test Your Prompts
- [ ] Chain of Thought (CoT)
- [ ] ReAct (Reason + Act)

### Tool / Function Calling
- [ ] LLM Native Function Calling
- [ ] OpenAI Functions Calling
- [ ] OpenAI Assistant API
- [ ] Anthropic Tool Use
- [ ] Gemini Function Calling

### Building Agents Manually
- [ ] Manual / From Scratch
- [ ] Understanding the Architecture

### Agent Architectures
- [ ] ReAct (Reason + Act)
- [ ] Planner-Executor
- [ ] DAG Agents
- [ ] Chain of Thought (CoT)
- [ ] Tree of Thought (ToT)

### Tools an Agent Can Use
- [ ] Code Execution / REPL
- [ ] Web Scraping / Crawling
- [ ] Web Search
- [ ] API Requests
- [ ] Database Queries
- [ ] File System Access
- [ ] Git and Terminal Usage
- [ ] Email / Slack / SMS

### Model Context Protocol (MCP)
- [ ] Model Context Protocol (MCP)
- [ ] MCP Hosts
- [ ] MCP Client
- [ ] MCP Servers
- [ ] Creating MCP Servers

### Memory
- [ ] Short-term Memory
- [ ] Long-term Memory
- [ ] Episodic vs Semantic Memory
- [ ] RAG and Vector Databases
- [ ] Summarization / Compression
- [ ] Forgetting / Aging Strategies

### Frameworks
- [ ] LangChain
- [ ] LangGraph
- [ ] LlamaIndex
- [ ] Haystack
- [ ] CrewAI
- [ ] AutoGen
- [ ] Smol Depot

### Evaluation / Observability
- [ ] Metrics to Track
- [ ] Human-in-the-loop Evaluation
- [ ] LangSmith
- [ ] Langfuse
- [ ] Helicone
- [ ] DeepEval
- [ ] Ragas
- [ ] OpenLLMetry
- [ ] Structured Logging / Tracing
- [ ] Integration Testing for Flows
- [ ] Unit Testing

### Security / Safety
- [ ] Prompt Injection / Jailbreaks
- [ ] Data Privacy / PII Redaction
- [ ] Bias / Toxicity Guardrails
- [ ] Safety / Red-Team Testing

### Agent Deployment
- [ ] Local Desktop
- [ ] Remote / Cloud

### Example Use Cases
- [ ] Personal Assistant
- [ ] RAG Agent
- [ ] Code Generation
- [ ] Data Analysis
- [ ] NPC / Game AI

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- **MCP-powered research assistant**: build an agent that exposes web search, a vector store, and a code-execution tool over MCP, then chains ReAct reasoning to answer multi-step questions with citations.
- **Self-evaluating coding agent**: a planner-executor agent that generates code, runs it in a REPL sandbox, reads the failures, and iterates — wired to LangSmith/Langfuse for traces and a DeepEval test suite as a regression gate.
- **Personal inbox triage agent**: an agent with long-term memory (vector DB) that reads email/Slack, classifies and drafts replies, escalates with human-in-the-loop approval, and redacts PII before logging.
