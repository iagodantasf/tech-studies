---
title: Prompt Engineering
roadmap: prompt-engineering
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, ai, prompting]
---

# Prompt Engineering

> roadmap.sh: https://roadmap.sh/prompt-engineering

Track for the **Prompt Engineering** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Foundations
- [ ] What is Prompt Engineering
- [ ] Why Prompt Engineering matters
- [ ] What are Large Language Models
- [ ] How LLMs work
- [ ] Tokens and tokenization
- [ ] Context window
- [ ] Embeddings
- [ ] Pretraining vs Fine-tuning
- [ ] Capabilities and limitations of LLMs
- [ ] Hallucinations

### Generation settings
- [ ] Temperature
- [ ] Top-p (nucleus sampling)
- [ ] Top-k
- [ ] Max tokens
- [ ] Stop sequences
- [ ] Frequency and presence penalties
- [ ] System vs User vs Assistant roles

### Prompt anatomy
- [ ] Instruction
- [ ] Context
- [ ] Input data
- [ ] Output indicator
- [ ] Role / persona prompting
- [ ] Delimiters and formatting
- [ ] Specifying output format
- [ ] Length and style control

### Core techniques
- [ ] Zero-shot prompting
- [ ] Few-shot prompting
- [ ] Chain-of-Thought prompting
- [ ] Zero-shot Chain-of-Thought
- [ ] Self-consistency
- [ ] Prompt chaining
- [ ] Tree of Thoughts
- [ ] ReAct (Reason + Act)
- [ ] Least-to-most prompting
- [ ] Generated knowledge prompting
- [ ] Step-back prompting
- [ ] Self-criticism / self-refine

### Advanced techniques
- [ ] Retrieval-Augmented Generation (RAG)
- [ ] Function / tool calling
- [ ] Structured outputs (JSON mode)
- [ ] Agents and agentic workflows
- [ ] Multimodal prompting
- [ ] Meta prompting
- [ ] Prompt templates and variables
- [ ] In-context learning

### Reliability and quality
- [ ] Reducing hallucinations
- [ ] Grounding with sources
- [ ] Handling ambiguity
- [ ] Iterative prompt refinement
- [ ] Evaluating prompt outputs
- [ ] Prompt testing and benchmarks
- [ ] LLM-as-a-judge

### Security and safety
- [ ] Prompt injection
- [ ] Jailbreaking
- [ ] Prompt leaking
- [ ] Defensive prompting
- [ ] Content moderation
- [ ] Responsible AI and bias

### Tooling and ecosystem
- [ ] OpenAI API
- [ ] Anthropic Claude API
- [ ] Prompt playgrounds
- [ ] LangChain
- [ ] LlamaIndex
- [ ] Vector databases
- [ ] Prompt management and versioning
- [ ] Cost and token optimization

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a prompt-evaluation harness that runs the same task across several prompting techniques (zero-shot, few-shot, chain-of-thought) and scores outputs with an LLM-as-a-judge.
- Create a small RAG assistant over a personal document set, with tool calling and structured JSON outputs, and measure how grounding reduces hallucinations.
- Build a red-team test suite of prompt-injection and jailbreak attempts against your own system prompt, then iterate on defensive prompting to harden it.
