---
title: LlamaIndex
track: ai-agents
group: Frameworks
tags: [ai-agents, rag]
prerequisites: [embeddings-and-vector-search, rag-and-vector-databases]
see-also: [rag-agent, haystack]
---

# LlamaIndex

A data framework focused on **retrieval over your own data**: it ingests documents, indexes them, and exposes query engines that agents call as tools.

## Why it matters

Where [[langchain|LangChain]] is agent-loop-first, LlamaIndex is RAG-first — it owns the ingestion-to-retrieval pipeline that most agents actually live or die on. It bundles 100+ data loaders (PDF, Notion, SQL, web) plus node parsing, indexing, and re-ranking, so building a "chat with my docs" [[rag-agent]] is a handful of lines. The agent layer then treats each index as a queryable tool, letting one agent route across many data sources.

## How it works

The pipeline is **load → parse into Nodes → index → query**.

| Stage | What it does |
|---|---|
| Reader | file/API → `Document` objects |
| Node parser | splits docs into `Node` chunks |
| Index | `VectorStoreIndex`, `SummaryIndex`, etc. |
| Retriever | Index → top-k Nodes for a query |
| Query engine | retriever + LLM synthesis = answer |

- A **`VectorStoreIndex`** embeds Nodes for [[embeddings-and-vector-search|semantic search]]; a `SummaryIndex` walks all Nodes for whole-corpus questions.
- **Response synthesis** modes matter: `compact` stuffs Nodes into one prompt; `refine` loops Node-by-Node when results overflow the [[context-windows|context window]].
- Wrap a query engine as a **`QueryEngineTool`** and hand it to an agent; with several tools the agent does **routing** — pick the right index per question.
- A **`PropertyGraphIndex`** adds graph/entity retrieval beyond flat vectors.

## Example

Docs-to-agent in five steps:

```python
docs  = SimpleDirectoryReader("./policies").load_data()
index = VectorStoreIndex.from_documents(docs)        # parse+embed+store
qe    = index.as_query_engine(response_mode="compact")
tool  = QueryEngineTool.from_defaults(qe, name="policy_docs")
agent = ReActAgent.from_tools([tool, hr_db_tool])    # routes across sources
agent.chat("How many sick days do I have left?")
```

The agent reads the question, routes to `policy_docs` vs `hr_db_tool`, and the query engine returns a synthesized, citation-backed answer.

## Pitfalls

- **Re-indexing every run.** `from_documents` re-embeds the whole corpus; `persist()` the index and reload, or you pay the [[token-based-pricing|embedding cost]] each boot.
- **Wrong synthesis mode.** `compact` silently truncates when Nodes exceed context; use `refine`/`tree_summarize` for large result sets.
- **Default chunking.** The out-of-box splitter ignores document structure; tune `chunk_size`/overlap to your content or recall drops.
- **One giant index.** Routing across several small, well-named indexes beats one undifferentiated blob the agent can't reason about.

## See also

- [[rag-agent]]
- [[haystack]]
