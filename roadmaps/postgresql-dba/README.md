---
title: PostgreSQL
roadmap: postgresql-dba
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, postgresql, databases]
---

# PostgreSQL

> roadmap.sh: https://roadmap.sh/postgresql-dba

Track for the **PostgreSQL** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Introduction
- [ ] What are Relational Databases?
- [ ] RDBMS Benefits and Limitations
- [ ] PostgreSQL vs Other Databases
- [ ] Object-Relational Concepts
- [ ] ACID, MVCC, Transactions Overview
- [ ] Installation and Setup

### Basic Operations
- [ ] psql Client
- [ ] Connecting to a Database
- [ ] Roles and Authentication Basics
- [ ] Creating Databases and Tables
- [ ] DDL Queries
- [ ] DML Queries
- [ ] Import / Export (COPY)
- [ ] Backup and Restore (pg_dump / pg_restore)

### Data Types
- [ ] Numeric Types
- [ ] Character Types
- [ ] Date / Time Types
- [ ] Boolean Type
- [ ] UUID
- [ ] JSON and JSONB
- [ ] Arrays
- [ ] hstore
- [ ] Range Types
- [ ] Geometric and Network Types

### Querying Data
- [ ] SELECT and Filtering
- [ ] Joins
- [ ] Subqueries and CTEs
- [ ] Aggregate Functions
- [ ] Window Functions
- [ ] Set Operations
- [ ] Full Text Search
- [ ] LATERAL Joins

### Advanced SQL Features
- [ ] Views and Materialized Views
- [ ] Functions and Stored Procedures
- [ ] Triggers and Rules
- [ ] PL/pgSQL
- [ ] Sequences and Identity Columns
- [ ] Constraints
- [ ] Common Table Expressions (Recursive)
- [ ] Grouping Sets, Rollup, Cube

### Architecture
- [ ] Postmaster and Backend Processes
- [ ] Shared Memory Architecture
- [ ] Write-Ahead Log (WAL)
- [ ] MVCC Implementation
- [ ] Vacuum Processing
- [ ] Buffer Management
- [ ] Checkpoints and Background Writer
- [ ] Storage Layout (Heap, TOAST, FSM, VM)

### Configuration
- [ ] postgresql.conf
- [ ] pg_hba.conf
- [ ] Resource Consumption Settings
- [ ] WAL Configuration
- [ ] Connection and Authentication Settings
- [ ] Memory Settings (shared_buffers, work_mem)
- [ ] Reloading vs Restarting

### Security
- [ ] Authentication Methods (md5, scram, peer, cert)
- [ ] Roles and Privileges
- [ ] GRANT / REVOKE
- [ ] Row Level Security
- [ ] Object Ownership
- [ ] SSL/TLS Configuration
- [ ] Encryption at Rest and in Transit
- [ ] Auditing (pgAudit)

### Infrastructure & Deployment
- [ ] Resource Provisioning
- [ ] Operating System Tuning
- [ ] Filesystem and Disk Layout
- [ ] Connection Pooling (PgBouncer, Pgpool-II)
- [ ] Containerization (Docker)
- [ ] Kubernetes Operators (CloudNativePG, Crunchy, Zalando)
- [ ] Cloud Managed Services (RDS, Cloud SQL, Azure)
- [ ] Configuration Management (Ansible)

### High Availability & Replication
- [ ] Replication Concepts
- [ ] Streaming Replication
- [ ] Logical Replication
- [ ] Synchronous vs Asynchronous Replication
- [ ] Replication Slots
- [ ] Failover and Switchover
- [ ] Patroni
- [ ] repmgr
- [ ] Load Balancing

### Backup & Recovery
- [ ] Logical Backups (pg_dump / pg_dumpall)
- [ ] Physical Backups (pg_basebackup)
- [ ] Point-in-Time Recovery (PITR)
- [ ] WAL Archiving
- [ ] Backup Tools (pgBackRest, Barman, WAL-G)
- [ ] Backup Validation and Restore Testing
- [ ] Disaster Recovery Planning

### Monitoring
- [ ] System Catalogs (pg_catalog)
- [ ] Statistics Views (pg_stat_*)
- [ ] pg_stat_statements
- [ ] Logging Configuration
- [ ] Prometheus + postgres_exporter
- [ ] Grafana Dashboards
- [ ] Alerting
- [ ] Bloat and Dead Tuple Monitoring

### Performance Tuning
- [ ] EXPLAIN and EXPLAIN ANALYZE
- [ ] Query Planner and Cost Model
- [ ] Index Types (B-Tree, Hash, GIN, GiST, BRIN, SP-GiST)
- [ ] Partial and Expression Indexes
- [ ] Index-Only Scans
- [ ] Table Partitioning
- [ ] VACUUM and ANALYZE Tuning
- [ ] Autovacuum Tuning
- [ ] Slow Query Analysis
- [ ] Workload Benchmarking (pgbench)

### Troubleshooting & Operations
- [ ] Locks and Deadlocks
- [ ] Long-Running Queries and Blocking
- [ ] Transaction ID Wraparound
- [ ] Connection Exhaustion
- [ ] Disk Space Issues
- [ ] Corruption Detection and Recovery
- [ ] Major Version Upgrades (pg_upgrade)
- [ ] Extensions (postgis, pg_partman, etc.)
- [ ] Migration Strategies

### Automation & Tooling
- [ ] Shell Scripting for DBAs
- [ ] cron and Scheduled Jobs
- [ ] Infrastructure as Code (Terraform)
- [ ] CI/CD for Schema Changes (Migrations)
- [ ] Observability and SLOs

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Stand up a primary/replica PostgreSQL cluster with Patroni and PgBouncer, then practice a planned failover and a simulated primary crash recovery.
- Build a monitoring stack with postgres_exporter, Prometheus, and Grafana; create alerts for replication lag, bloat, and transaction-ID wraparound.
- Implement a full backup/restore runbook using pgBackRest with WAL archiving, then perform a point-in-time recovery to a specific timestamp and verify data.
