---
title: AI Product Builder
roadmap: ai-product-builder
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, ai, product]
---

# AI Product Builder

> roadmap.sh: https://roadmap.sh/ai-product-builder

Track for the **AI Product Builder** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Foundations
- [ ] What Is an AI Product
- [ ] LLM Basics & Tokens
- [ ] Context Windows
- [ ] Capabilities vs Limitations
- [ ] Model Landscape (Closed vs Open)
- [ ] Choosing a Model for the Job
- [ ] Multimodal Models

### Prompt Engineering
- [ ] Prompt Engineering Fundamentals
- [ ] System vs User Prompts
- [ ] Few-Shot & Chain-of-Thought
- [ ] Structured Output (JSON/Schema)
- [ ] Prompt Templates & Versioning
- [ ] Prompt Caching

### Working With APIs & SDKs
- [ ] Calling LLM APIs
- [ ] Streaming Responses
- [ ] Function / Tool Calling
- [ ] Embeddings
- [ ] Rate Limits & Retries
- [ ] Cost & Token Budgeting

### Retrieval-Augmented Generation
- [ ] RAG Fundamentals
- [ ] Chunking Strategies
- [ ] Vector Databases
- [ ] Hybrid & Semantic Search
- [ ] Reranking
- [ ] Grounding & Citations

### Agents & Workflows
- [ ] AI Agents Overview
- [ ] Tool Use & Orchestration
- [ ] Multi-Step Workflows
- [ ] Memory & State
- [ ] Model Context Protocol (MCP)
- [ ] Agent Frameworks

### Fine-Tuning & Customization
- [ ] When to Fine-Tune
- [ ] Fine-Tuning vs RAG vs Prompting
- [ ] Dataset Preparation
- [ ] Distillation

### Evaluation & Quality
- [ ] Defining Success Metrics
- [ ] Building Evals
- [ ] LLM-as-a-Judge
- [ ] Human Feedback Loops
- [ ] Hallucination Detection
- [ ] Regression Testing

### Product & UX
- [ ] Designing AI UX Patterns
- [ ] Handling Latency & Streaming UX
- [ ] Trust, Transparency & Citations
- [ ] Error & Fallback States
- [ ] Feedback Capture
- [ ] Pricing AI Features

### Safety & Responsibility
- [ ] Guardrails & Moderation
- [ ] Prompt Injection Defense
- [ ] PII & Data Privacy
- [ ] Bias & Fairness
- [ ] Responsible AI Policies

### Deployment & Operations
- [ ] Serving & Inference Infrastructure
- [ ] Observability & Tracing
- [ ] Caching & Cost Optimization
- [ ] Scaling & Load Management
- [ ] CI/CD for AI Apps
- [ ] Monitoring & Drift

### Going to Market
- [ ] Identifying AI Use Cases
- [ ] Build vs Buy
- [ ] MVP & Rapid Prototyping
- [ ] Measuring Adoption & ROI

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Ship a RAG-powered "chat with your docs" app: ingest a PDF set, build embeddings, add reranking and inline citations, and wire up streaming UX.
- Build an agent that uses tool calling to answer questions over a real API (weather, GitHub, or a calendar), with retries, guardrails, and an eval suite scoring answer quality.
- Create an evals harness for an existing AI feature: define metrics, add an LLM-as-a-judge grader, and run regression tests on every prompt change in CI.
