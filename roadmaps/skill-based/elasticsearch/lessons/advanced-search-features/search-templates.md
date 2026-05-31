---
title: Search templates
track: elasticsearch
group: Advanced Search Features
tags: [elasticsearch, templates]
prerequisites: [query-dsl-overview, painless-scripting]
see-also: [query-vs-filter-context, pagination-from-size-search-after-scroll, official-language-clients]
---

# Search templates

A search template is a stored, parameterized [[query-dsl-overview|Query DSL]] body written in the Mustache language, executed by passing only the variable values at search time.

## Why it matters

Application code that builds query JSON by string concatenation is brittle and leaks DSL into every service. Templates move the query shape into the cluster: clients send `{ id, params }`, so you can tune relevance or fix a query without redeploying apps, and you centralize one canonical query instead of N drifting copies.

## How it works

Templates are stored in cluster state as scripts of `lang: mustache` and rendered to JSON before the search runs.

- **Store** — `PUT _scripts/<id>` with a `mustache` source; **run** — `GET <index>/_search/template` with `{ "id": "<id>", "params": {...} }`.
- **Substitution** — `{{var}}` injects a value (JSON-escaped); `{{#var}}...{{/var}}` is a conditional/section that renders only when `var` is set; `{{^var}}` renders when it is *not*.
- **`{{#toJson}}list{{/toJson}}`** serializes an array/object param into valid JSON (e.g. for a `terms` list).
- **`{{#url}}`/default values** — `{{var}}{{^var}}fallback{{/var}}` supplies a default like `size` or `from`.
- **`_render/template`** — dry-runs the substitution and returns the final query JSON without searching — essential for debugging.

## Example

```
PUT _scripts/by_status { "script": { "lang": "mustache", "source": {
  "query": { "bool": { "filter": [ { "term": { "status": "{{status}}" } } ] } },
  "size": "{{size}}{{^size}}10{{/size}}" } } }

GET /orders/_search/template { "id": "by_status", "params": { "status": "open" } }
```

`status` is injected; `size` falls back to 10 because the caller omitted it — the rendered query filters open orders, page size 10.

## Pitfalls

- **String vs JSON params** — a bare `{{n}}` renders a quoted string; for numeric `size`/`from` or arrays use `{{#toJson}}`, or the query fails to parse.
- **Mustache is logic-light** — no arithmetic or loops with computation; complex shaping belongs in [[painless-scripting|Painless]] or the client, not the template.
- **Injection still possible** — values are JSON-escaped but not query-validated; never let a param choose the *field* or [[query-vs-filter-context|context]] unless you trust the caller.
- **Versioning** — updating a stored template is silent and global; coordinate changes like a schema migration so old clients don't break.

## See also

- [[painless-scripting]]
- [[official-language-clients]]
