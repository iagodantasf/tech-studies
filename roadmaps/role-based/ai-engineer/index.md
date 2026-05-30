---
title: AI Engineer
track: ai-engineer
category: Role-based
tags: [roadmap, ai]
---

# AI Engineer

> roadmap.sh: https://roadmap.sh/ai-engineer

Suggested path through the **AI Engineer** nodes. Each node links to its lesson when written.

## Nodes

### Fundamentals
- What is an AI Engineer (vs ML Engineer)
- How LLMs work (inference vs training)
- AI vs AGI
- Impact on product development
- Roles & responsibilities

### LLM basics
- Large Language Models (LLMs)
- Tokens & tokenization
- Context window & context engineering
- Sampling params — temperature, top-p, top-k, repetition penalty
- Pre-trained models — benefits & limitations
- RAG vs fine-tuning — when to use which

### Models & providers
- Closed vs open-source models
- OpenAI GPT / o-series
- Anthropic Claude
- Google Gemini
- Open models — Llama, Mistral, DeepSeek, Qwen, Gemma, Cohere
- Choosing the right model
- Self-hosting — Ollama, LM Studio, Hugging Face Hub
- OpenRouter & OpenAI-compatible APIs

### Provider APIs
- OpenAI Responses / Chat API
- Claude Messages API
- Google Gemini API
- Streaming responses
- Structured output
- Tools / function calling
- Prompt caching
- Using SDKs directly

### Prompt engineering
- Prompt engineering basics & system prompting
- Zero-shot & few-shot
- Chain of thought (CoT)
- ReAct prompting
- Role & behavior shaping
- Prompt injection attacks
- Robust / adversarial prompting

### Embeddings
- What are embeddings
- Embedding models (OpenAI, Gemini, Cohere, Jina, sentence-transformers)
- Indexing embeddings
- Semantic / similarity search

### Vector databases
- Vector databases — Pinecone, Weaviate, Qdrant, Chroma, FAISS, pgvector

### RAG
- What is RAG & use-cases
- Chunking
- Retrieval process & dynamic filters
- Implementing RAG (LangChain, LlamaIndex, Haystack)

### AI agents
- AI agents & use-cases
- Tools & function calling
- ReAct & multi-agents
- External memory
- Model Context Protocol (MCP) — host, client, server
- Agent SDKs — OpenAI AgentKit, Claude Agent SDK, Google ADK

### Multimodal
- Multimodal AI & use-cases
- Image understanding & generation (DALL·E, vision API)
- Video understanding
- Audio — text-to-speech & speech-to-text (Whisper)

### Dev tools
- Frameworks — LangChain, LlamaIndex, Haystack
- AI coding tools — Cursor, Windsurf, Replit, Codex, Claude Code

### Safety & ops
- AI safety & ethics
- Bias & fairness
- Security & privacy concerns
- Adversarial testing & content moderation
- Fine-tuning (when, LoRA)

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a RAG chatbot over your own notes (chunk → embed → retrieve → answer)
- Build a tool-calling agent (MCP server + client) for a real task
- Ship a multimodal feature (image-in → structured-out) via a provider vision API
