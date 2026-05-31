---
title: Web Search
track: ai-agents
group: Tools an Agent Can Use
tags: [ai-agents, web-search]
prerequisites: [acting-tool-invocation]
see-also: [web-scraping-crawling, rag-and-vector-databases]
---

# Web Search

A tool that queries a search engine or search API and returns ranked results (title, URL, snippet) so the agent can find current, external information.

## Why it matters

An LLM's weights are frozen at a training cutoff and it hallucinates specifics. Web search is the antidote for *freshness* and *long-tail facts*: today's price, last night's score, a brand-new library's API. It's the first half of the research pattern — search to find sources, then [[web-scraping-crawling]] to read them — and a cheaper alternative to indexing the whole world into a [[rag-and-vector-databases]] store.

## How it works

The tool takes a query string, hits a search API, and returns the top-k results as compact structured items. The model then decides which URLs to open.

- **Search APIs** — Brave, Bing, SerpAPI, Tavily, Exa. Some (Tavily, Exa) are *built for agents*: they return cleaned snippets or even a synthesized answer, saving a scrape step.
- **Query crafting** — the model should issue *keyword* queries, not its full chatty question; multiple narrow queries beat one broad one.
- **Snippet vs full read** — snippets often answer simple lookups directly; only fetch the page when the snippet is insufficient, to save [[token-based-pricing]] and latency.
- **Provider-hosted search** — Anthropic and OpenAI offer a server-side web-search tool, so the loop runs without you wiring an API; you trade control for convenience.

| Approach | Returns | Best for |
|---|---|---|
| Raw search API | links + snippets | agent picks sources |
| Answer API (Tavily/Exa) | snippets or synthesized answer | quick factual lookups |
| Hosted (Anthropic/OpenAI) | results + auto-citation | zero-wiring agents |

## Example

```
user: "What's the latest stable Postgres version?"
tool call → web_search("latest stable PostgreSQL release version 2026")
results:
  1. postgresql.org/docs — "PostgreSQL 18.1 released…"
  2. ...
model: answers "18.1", citing result 1
```

Search resolved a fact the model's weights could not know.

## Pitfalls

- **Stale or SEO-spam results** outrank the truth; prefer authoritative domains and cross-check before asserting.
- **Over-searching** — firing a query for things in the model's parametric knowledge wastes latency and money; reserve search for fresh/uncertain facts.
- **Injection via results.** Snippets and pages are untrusted; a malicious result can carry instructions ([[prompt-injection-jailbreaks]]). Treat them as data.
- **No citation = unverifiable.** Always carry the source URL through so answers can be audited and the model isn't tempted to confabulate.

## See also

- [[web-scraping-crawling]]
- [[rag-and-vector-databases]]
