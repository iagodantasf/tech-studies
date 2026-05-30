---
title: MongoDB
roadmap: mongodb
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, mongodb, databases]
---

# MongoDB

> roadmap.sh: https://roadmap.sh/mongodb

Track for the **MongoDB** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Introduction
- [ ] What is MongoDB?
- [ ] SQL vs NoSQL
- [ ] Document Databases
- [ ] When to Use MongoDB
- [ ] MongoDB Editions (Community, Enterprise, Atlas)
- [ ] BSON vs JSON
- [ ] Installation and Setup

### Core Concepts
- [ ] Databases
- [ ] Collections
- [ ] Documents
- [ ] Fields and Data Types
- [ ] _id and ObjectId
- [ ] Embedded Documents
- [ ] References
- [ ] Capped Collections

### MongoDB Shell & Tools
- [ ] mongosh
- [ ] MongoDB Compass
- [ ] mongoimport / mongoexport
- [ ] mongodump / mongorestore
- [ ] MongoDB for VS Code
- [ ] Database Drivers

### CRUD Operations
- [ ] insertOne / insertMany
- [ ] find and findOne
- [ ] Query Operators (Comparison, Logical)
- [ ] Element and Evaluation Operators
- [ ] Projection
- [ ] updateOne / updateMany
- [ ] Update Operators ($set, $inc, $push, etc.)
- [ ] replaceOne
- [ ] deleteOne / deleteMany
- [ ] Bulk Write Operations
- [ ] Cursors

### Querying
- [ ] Querying Embedded Documents
- [ ] Querying Arrays
- [ ] Array Operators ($elemMatch, $all, $size)
- [ ] Sorting
- [ ] Limiting and Skipping
- [ ] Counting Documents
- [ ] Distinct Values
- [ ] Regular Expressions

### Aggregation Framework
- [ ] Aggregation Pipeline Concept
- [ ] $match
- [ ] $group
- [ ] $project
- [ ] $sort / $limit / $skip
- [ ] $lookup (Joins)
- [ ] $unwind
- [ ] $addFields / $set
- [ ] $facet
- [ ] $bucket / $bucketAuto
- [ ] Accumulator Operators
- [ ] $out and $merge
- [ ] Map-Reduce

### Indexing
- [ ] Index Concepts
- [ ] Single Field Indexes
- [ ] Compound Indexes
- [ ] Multikey Indexes
- [ ] Text Indexes
- [ ] Geospatial Indexes
- [ ] Hashed Indexes
- [ ] Wildcard Indexes
- [ ] TTL Indexes
- [ ] Partial and Sparse Indexes
- [ ] Unique Indexes
- [ ] explain() and Index Usage
- [ ] Covered Queries

### Data Modeling
- [ ] Schema Design Principles
- [ ] Embedding vs Referencing
- [ ] One-to-One Relationships
- [ ] One-to-Many Relationships
- [ ] Many-to-Many Relationships
- [ ] Schema Design Patterns (Bucket, Outlier, Computed)
- [ ] Anti-Patterns
- [ ] Schema Validation

### Transactions
- [ ] ACID in MongoDB
- [ ] Single Document Atomicity
- [ ] Multi-Document Transactions
- [ ] Sessions
- [ ] Read and Write Concerns
- [ ] Read Preferences

### Replication
- [ ] Replica Set Concepts
- [ ] Primary and Secondary Nodes
- [ ] Arbiter
- [ ] Elections and Failover
- [ ] Oplog
- [ ] Replica Set Configuration
- [ ] Write Concern and Replication

### Sharding
- [ ] Sharding Concepts
- [ ] Shard Keys
- [ ] Chunks and Balancing
- [ ] Ranged vs Hashed Sharding
- [ ] Config Servers
- [ ] mongos Router
- [ ] Zone Sharding

### Performance
- [ ] Query Optimization
- [ ] Index Optimization
- [ ] Profiler and Slow Queries
- [ ] Working Set and Memory
- [ ] Connection Pooling
- [ ] Aggregation Performance

### Security
- [ ] Authentication (SCRAM, x.509, LDAP)
- [ ] Role-Based Access Control
- [ ] Built-in and Custom Roles
- [ ] Network Security and IP Allowlists
- [ ] TLS/SSL Encryption
- [ ] Encryption at Rest
- [ ] Field Level Encryption
- [ ] Auditing

### Administration & Deployment
- [ ] Backup and Restore Strategies
- [ ] Monitoring (mongostat, mongotop)
- [ ] MongoDB Atlas
- [ ] Atlas Search
- [ ] Change Streams
- [ ] GridFS
- [ ] Logging
- [ ] Deployment Topologies
- [ ] Upgrades and Maintenance

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Design and build a blog or e-commerce data model that demonstrates embedding vs referencing trade-offs, then add schema validation rules to enforce it.
- Write an analytics aggregation pipeline over a real dataset using $match, $group, $lookup, and $facet, and tune it with compound and covered indexes.
- Deploy a 3-node replica set locally (or on Atlas), simulate a primary failover, and use Change Streams to drive a real-time event consumer.
