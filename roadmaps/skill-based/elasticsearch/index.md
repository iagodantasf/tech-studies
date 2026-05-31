---
title: Elasticsearch
track: elasticsearch
category: Skill-based
tags: [roadmap, elasticsearch, search]
---

# Elasticsearch

> roadmap.sh: https://roadmap.sh/elasticsearch

Suggested path through the **Elasticsearch** nodes. Each node links to its lesson when written.

## Nodes

### Introduction
- [[what-is-elasticsearch]]
- [[search-engine-fundamentals]]
- [[elasticsearch-vs-relational-databases]]
- [[the-elastic-stack-elk-elastic]]
- [[use-cases-search-logging-observability-analytics]]
- [[apache-lucene-foundations]]
- [[installing-elasticsearch]]

### Core Concepts
- [[documents]]
- [[indices]]
- [[fields-data-types]]
- [[mappings]]
- [[inverted-index]]
- [[shards-replicas]]
- [[nodes-cluster]]
- [[segments]]
- [[near-real-time-search]]

### Mappings & Text Analysis
- [[dynamic-vs-explicit-mapping]]
- [[core-field-types-text-keyword-numeric-date-boolean]]
- [[object-nested-fields]]
- [[analyzers-standard-language-custom]]
- [[tokenizers]]
- [[token-filters-character-filters]]
- [[normalizers]]
- [[multi-fields]]

### Indexing Data (CRUD)
- [[index-api]]
- [[get-update-delete-apis]]
- [[bulk-api]]
- [[reindex-api]]
- [[update-by-query-delete-by-query]]
- [[optimistic-concurrency-control-versioning]]
- [[ingest-pipelines]]

### Querying (Query DSL)
- [[query-dsl-overview]]
- [[query-vs-filter-context]]
- [[match-match-phrase-queries]]
- [[term-level-queries]]
- [[bool-query-must-should-must-not-filter]]
- [[range-queries]]
- [[full-text-search]]
- [[compound-queries]]
- [[relevance-scoring-bm25]]
- [[pagination-from-size-search-after-scroll]]
- [[sorting]]
- [[highlighting]]

### Aggregations
- [[metric-aggregations]]
- [[bucket-aggregations]]
- [[pipeline-aggregations]]
- [[nested-aggregations]]
- [[cardinality-percentiles]]

### Advanced Search Features
- [[suggesters-autocomplete]]
- [[fuzzy-wildcard-search]]
- [[geo-queries]]
- [[percolate-queries]]
- [[search-templates]]
- [[runtime-fields]]
- [[knn-vector-search]]

### Cluster Architecture & Operations
- [[node-roles-master-data-ingest-coordinating]]
- [[discovery-cluster-formation]]
- [[shard-allocation-routing]]
- [[cluster-health-green-yellow-red]]
- [[index-lifecycle-management-ilm]]
- [[snapshots-restore]]
- [[rolling-upgrades]]

### Performance & Scaling
- [[sharding-strategy]]
- [[index-templates]]
- [[data-streams]]
- [[hot-warm-cold-architecture]]
- [[bulk-indexing-tuning]]
- [[caching-query-request-cache]]
- [[force-merge-refresh-interval]]

### Security
- [[authentication-users]]
- [[role-based-access-control-rbac]]
- [[tls-encryption]]
- [[api-keys]]
- [[field-document-level-security]]
- [[audit-logging]]

### The Elastic Stack
- [[kibana]]
- [[logstash]]
- [[beats-filebeat-metricbeat]]
- [[elastic-agent-fleet]]
- [[apm-observability]]

### Clients & Ecosystem
- [[rest-api]]
- [[official-language-clients]]
- [[elasticsearch-sql]]
- [[painless-scripting]]
- [[monitoring-alerting]]
- [[elastic-cloud-managed-offerings]]

## Resources
See [resources.md](./resources.md).

## Project ideas
- Index a public dataset (e.g. movies or products), then build a search UI with autocomplete, faceted filtering via aggregations, and BM25-tuned relevance.
- Ship application logs through Filebeat → Elasticsearch → Kibana and build a dashboard with ILM rolling indices over to a cold tier.
- Implement semantic search by generating embeddings for a document corpus and serving results through Elasticsearch kNN / vector queries.
