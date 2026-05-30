---
title: GraphQL
track: graphql
category: Skill-based
tags: [roadmap, graphql, api]
---

# GraphQL

> roadmap.sh: https://roadmap.sh/graphql

Suggested path through the **GraphQL** nodes. Each node links to its lesson when written.

## Nodes

### Prerequisites
- HTTP and how the web works
- Client-server model
- JSON
- A backend language (JS/Node, etc.)
- REST API basics
- Databases fundamentals

### Introduction
- What is GraphQL
- GraphQL vs REST
- GraphQL vs gRPC
- When to use GraphQL
- Single endpoint concept
- Strongly typed schema
- GraphQL specification

### Core concepts
- Schema Definition Language (SDL)
- Operations: query, mutation, subscription
- Fields and arguments
- Aliases
- Fragments
- Variables
- Directives (@include, @skip, @deprecated)
- Operation names

### Type system
- Scalar types
- Object types
- Enum types
- Interface types
- Union types
- Input types
- Lists and non-null
- Custom scalars
- Type modifiers

### Schema design
- Designing the schema
- Query type
- Mutation type
- Subscription type
- Schema-first vs code-first
- Nullability best practices
- Pagination (offset and cursor / Relay connections)
- Naming conventions
- Schema versioning and evolution
- Deprecation strategy

### Resolvers and execution
- What are resolvers
- Resolver arguments (parent, args, context, info)
- Default resolvers
- Resolver chains
- Execution and validation phases
- Context and dependency injection
- Root value

### Server-side
- Apollo Server
- GraphQL Yoga
- Express GraphQL
- graphql-js reference implementation
- Schema stitching
- Apollo Federation
- Connecting to data sources / databases
- DataLoader and the N+1 problem
- Batching and caching

### Client-side
- Apollo Client
- Relay
- urql
- graphql-request
- Caching on the client
- Fetching, mutating and subscribing
- Code generation (GraphQL Code Generator)
- Fragment colocation

### Real-time
- Subscriptions
- WebSockets transport
- Server-Sent Events
- PubSub

### Security
- Authentication
- Authorization
- Query depth limiting
- Query complexity / cost analysis
- Rate limiting
- Disabling introspection in production
- Persisted queries
- Input validation

### Performance and caching
- Caching strategies
- Persisted queries (APQ)
- Response caching
- CDN caching
- Avoiding over-fetching with DataLoader

### Tooling and ecosystem
- GraphiQL
- GraphQL Playground
- Apollo Studio / Explorer
- Introspection
- Schema linting
- Error handling and error formats
- Testing GraphQL APIs
- Monitoring and tracing

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a code-first GraphQL API with Apollo Server backed by a Postgres database, using DataLoader to eliminate N+1 queries.
- Create a React frontend with Apollo Client and GraphQL Code Generator featuring cursor-based pagination and optimistic UI updates.
- Build a real-time collaborative board using GraphQL subscriptions over WebSockets with query-depth limiting and auth directives.
