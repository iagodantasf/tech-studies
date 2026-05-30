---
title: Elasticsearch
roadmap: elasticsearch
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, elasticsearch, search]
---

# Elasticsearch

> roadmap.sh: https://roadmap.sh/elasticsearch

Track for the **Elasticsearch** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Introduction
- [ ] What is Elasticsearch?
- [ ] Search engine fundamentals
- [ ] Elasticsearch vs relational databases
- [ ] The Elastic Stack (ELK / Elastic)
- [ ] Use cases (search, logging, observability, analytics)
- [ ] Apache Lucene foundations
- [ ] Installing Elasticsearch

### Core Concepts
- [ ] Documents
- [ ] Indices
- [ ] Fields & data types
- [ ] Mappings
- [ ] Inverted index
- [ ] Shards & replicas
- [ ] Nodes & cluster
- [ ] Segments
- [ ] Near real-time search

### Mappings & Text Analysis
- [ ] Dynamic vs explicit mapping
- [ ] Core field types (text, keyword, numeric, date, boolean)
- [ ] Object & nested fields
- [ ] Analyzers (standard, language, custom)
- [ ] Tokenizers
- [ ] Token filters & character filters
- [ ] Normalizers
- [ ] Multi-fields

### Indexing Data (CRUD)
- [ ] Index API
- [ ] Get / Update / Delete APIs
- [ ] Bulk API
- [ ] Reindex API
- [ ] Update by query / Delete by query
- [ ] Optimistic concurrency control (versioning)
- [ ] Ingest pipelines

### Querying (Query DSL)
- [ ] Query DSL overview
- [ ] Query vs filter context
- [ ] Match & match_phrase queries
- [ ] Term-level queries
- [ ] Bool query (must / should / must_not / filter)
- [ ] Range queries
- [ ] Full-text search
- [ ] Compound queries
- [ ] Relevance scoring (BM25)
- [ ] Pagination (from/size, search_after, scroll)
- [ ] Sorting
- [ ] Highlighting

### Aggregations
- [ ] Metric aggregations
- [ ] Bucket aggregations
- [ ] Pipeline aggregations
- [ ] Nested aggregations
- [ ] Cardinality & percentiles

### Advanced Search Features
- [ ] Suggesters & autocomplete
- [ ] Fuzzy & wildcard search
- [ ] Geo queries
- [ ] Percolate queries
- [ ] Search templates
- [ ] Runtime fields
- [ ] kNN / vector search

### Cluster Architecture & Operations
- [ ] Node roles (master, data, ingest, coordinating)
- [ ] Discovery & cluster formation
- [ ] Shard allocation & routing
- [ ] Cluster health (green / yellow / red)
- [ ] Index lifecycle management (ILM)
- [ ] Snapshots & restore
- [ ] Rolling upgrades

### Performance & Scaling
- [ ] Sharding strategy
- [ ] Index templates
- [ ] Data streams
- [ ] Hot-warm-cold architecture
- [ ] Bulk indexing tuning
- [ ] Caching (query / request cache)
- [ ] Force merge & refresh interval

### Security
- [ ] Authentication & users
- [ ] Role-based access control (RBAC)
- [ ] TLS encryption
- [ ] API keys
- [ ] Field & document level security
- [ ] Audit logging

### The Elastic Stack
- [ ] Kibana
- [ ] Logstash
- [ ] Beats (Filebeat, Metricbeat)
- [ ] Elastic Agent & Fleet
- [ ] APM & observability

### Clients & Ecosystem
- [ ] REST API
- [ ] Official language clients
- [ ] Elasticsearch SQL
- [ ] Painless scripting
- [ ] Monitoring & alerting
- [ ] Elastic Cloud / managed offerings

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Index a public dataset (e.g. movies or products), then build a search UI with autocomplete, faceted filtering via aggregations, and BM25-tuned relevance.
- Ship application logs through Filebeat → Elasticsearch → Kibana and build a dashboard with ILM rolling indices over to a cold tier.
- Implement semantic search by generating embeddings for a document corpus and serving results through Elasticsearch kNN / vector queries.
