---
title: Data Engineer
roadmap: data-engineer
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, data-engineering]
---

# Data Engineer

> roadmap.sh: https://roadmap.sh/data-engineer

Track for the **Data Engineer** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Introduction
- [ ] What is Data Engineering
- [ ] Data Engineering vs Data Science
- [ ] The Data Engineering Lifecycle
- [ ] Skills and Responsibilities
- [ ] Choosing the Right Technologies
- [ ] Best Practices

### Programming Skills
- [ ] Python
- [ ] Java
- [ ] Scala
- [ ] Go
- [ ] Learn SQL
- [ ] Data Structures and Algorithms
- [ ] Git and GitHub
- [ ] Linux Basics
- [ ] APIs

### Databases & Storage
- [ ] Database Fundamentals
- [ ] Relational Databases
- [ ] NoSQL Databases
- [ ] OLTP vs OLAP
- [ ] Transactions
- [ ] Indexing
- [ ] Data Normalization
- [ ] Data Modelling Techniques

### Relational Databases
- [ ] PostgreSQL
- [ ] MySQL
- [ ] MariaDB
- [ ] MS SQL
- [ ] Oracle

### NoSQL Databases
- [ ] Key-Value
- [ ] Document
- [ ] Column
- [ ] Graph
- [ ] MongoDB
- [ ] Cassandra
- [ ] HBase
- [ ] CouchDB
- [ ] Redis
- [ ] Memcached
- [ ] Elasticsearch
- [ ] Neo4j

### Data Warehousing
- [ ] What is a Data Warehouse
- [ ] Data Warehousing Architectures
- [ ] Data Mart
- [ ] Data Lake
- [ ] Data Hub
- [ ] Star vs Snowflake Schema
- [ ] Slowly Changing Dimension (SCD)
- [ ] Snowflake
- [ ] Amazon Redshift
- [ ] Google BigQuery
- [ ] Databricks Delta Lake

### Data Pipelines & ETL
- [ ] Data Pipelines
- [ ] Data Ingestion
- [ ] Types of Data Ingestion (Batch / Streaming / Realtime)
- [ ] Sources of Data
- [ ] Data Collection Considerations
- [ ] Extract Data
- [ ] Transform Data
- [ ] Load Data
- [ ] ETL vs Reverse ETL
- [ ] Reverse ETL
- [ ] Reverse ETL Use Cases
- [ ] Job Scheduling
- [ ] Idempotency

### ETL & Orchestration Tools
- [ ] Apache Airflow
- [ ] dbt
- [ ] Luigi
- [ ] Prefect
- [ ] AWS Glue ETL
- [ ] Azure Data Factory (ETL)
- [ ] GCP Dataflow
- [ ] Hightouch
- [ ] Census
- [ ] Segment

### Big Data & Distributed Systems
- [ ] Big Data Tools
- [ ] Distributed Systems Basics
- [ ] CAP Theorem
- [ ] Distributed File Systems
- [ ] Cluster Computing Basics
- [ ] What is Cluster Computing
- [ ] Cluster Management Tools
- [ ] Horizontal vs Vertical Scaling
- [ ] Apache Hadoop YARN
- [ ] HDFS
- [ ] MapReduce
- [ ] Apache Spark

### Messaging & Streaming
- [ ] Messaging Systems
- [ ] Messages vs Streams
- [ ] Async vs Sync Communication
- [ ] Apache Kafka
- [ ] RabbitMQ
- [ ] AWS SQS
- [ ] AWS SNS
- [ ] Streaming
- [ ] Batch
- [ ] Realtime

### Data Quality, Governance & Privacy
- [ ] Data Quality
- [ ] Data Lineage
- [ ] Metadata Management
- [ ] Metadata-First Architecture
- [ ] Data Mesh
- [ ] Data Fabric
- [ ] Data Interoperability
- [ ] Data Masking
- [ ] Data Obfuscation
- [ ] Encryption
- [ ] Tokenization
- [ ] Authentication vs Authorization
- [ ] GDPR
- [ ] ECPA
- [ ] EU AI Act

### Analytics, BI & Serving
- [ ] Data Serving
- [ ] Data Analytics
- [ ] Business Intelligence
- [ ] AB Testing
- [ ] Microsoft Power BI
- [ ] Tableau
- [ ] Looker
- [ ] Streamlit
- [ ] Machine Learning
- [ ] MLOps

### Cloud Computing
- [ ] Cloud Computing
- [ ] Cloud Architectures
- [ ] Serverless Options
- [ ] Hybrid Cloud
- [ ] Amazon EC2 (Compute)
- [ ] GCP Compute Engine
- [ ] Azure Virtual Machines
- [ ] S3 Storage
- [ ] Google Cloud Storage
- [ ] Azure Blob Storage
- [ ] Amazon RDS
- [ ] Aurora DB
- [ ] Cloud SQL Database
- [ ] Azure SQL Database
- [ ] DynamoDB
- [ ] Bigtable
- [ ] CosmosDB
- [ ] Neptune

### DevOps & Infrastructure
- [ ] Containers & Orchestration
- [ ] Docker
- [ ] Kubernetes
- [ ] AWS EKS
- [ ] Google Cloud GKE
- [ ] Infrastructure as Code (IaC)
- [ ] Terraform
- [ ] OpenTofu
- [ ] AWS CDK
- [ ] Google Deployment Manager
- [ ] CI/CD
- [ ] GitHub Actions
- [ ] GitLab CI
- [ ] CircleCI
- [ ] ArgoCD
- [ ] Networking Fundamentals
- [ ] Declarative vs Imperative

### Monitoring & Testing
- [ ] Monitoring
- [ ] Logs
- [ ] Prometheus
- [ ] Datadog
- [ ] New Relic
- [ ] Sentry
- [ ] Testing
- [ ] Unit Testing
- [ ] Integration Testing
- [ ] Functional Testing
- [ ] End-to-End Testing
- [ ] Load Testing
- [ ] Smoke Testing
- [ ] Reusability
- [ ] Environmental Management

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- **Batch ELT pipeline**: ingest a public dataset (e.g. NYC taxi trips) into object storage, model it with dbt into a star schema in a warehouse (BigQuery/Snowflake/Postgres), and orchestrate the whole DAG with Airflow. Wire in data-quality tests and lineage. See `playgrounds/`.
- **Real-time streaming aggregator**: produce synthetic events to Kafka, process them with Spark Structured Streaming (windowed aggregations), and sink results to a serving store (Redis/Postgres) with a small Streamlit dashboard on top.
- **Self-hosted lakehouse on containers**: stand up MinIO + Spark + Delta Lake with Docker Compose, provisioned via Terraform, and load incremental data with SCD Type-2 handling; add Prometheus/Grafana monitoring for the jobs.
