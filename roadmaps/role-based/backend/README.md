---
title: Backend
track: backend
category: Role-based
tags: [roadmap, backend]
---

# Backend

> roadmap.sh: https://roadmap.sh/backend

Suggested path through the **Backend** nodes. Each node links to its lesson when written.

## Nodes

### Internet fundamentals
- How does the internet work
- What is HTTP
- HTTPS / TLS
- What is a domain name
- What is hosting
- DNS and how it works
- Browsers and how they work

### Programming language
- Pick a language (JavaScript / TypeScript)
- Python
- Go
- Java
- C#
- Rust
- PHP
- Ruby

### Version control & repo hosting
- Git
- GitHub
- GitLab
- Bitbucket

### Web servers
- Learn about web servers
- Nginx
- Apache
- Caddy
- MS IIS

### Relational databases
- PostgreSQL
- MySQL
- MariaDB
- MS SQL Server
- Oracle
- Database indexes
- Normalization
- Transactions
- ACID
- Migrations

### NoSQL databases
- MongoDB
- Redis
- DynamoDB
- Cassandra
- CouchDB
- Firebase / Firestore
- Document vs key-value vs column vs graph

### Scaling databases
- Database replication
- Sharding strategies
- CAP theorem
- Data consistency models
- Failure modes

### APIs
- Learn about APIs
- REST
- JSON APIs
- GraphQL
- gRPC
- SOAP
- HATEOAS
- Open API / Swagger
- Long polling / short polling
- Server-sent events
- WebSockets

### Authentication
- Authentication concepts
- Basic authentication
- Token-based auth
- JWT
- OAuth 2.0
- Cookie-based auth
- OpenID

### Web security
- Hashing (bcrypt, MD5, SHA)
- HTTPS
- CORS
- Content Security Policy (CSP)
- SSL / TLS
- OWASP security risks
- Server security

### Caching
- Caching concepts
- CDN
- Server-side caching (Redis, Memcached)
- Client-side caching
- HTTP caching

### Testing
- Integration testing
- Functional testing
- Unit testing
- Load testing

### CI/CD
- CI/CD concepts
- Build pipelines
- Code reviews

### Architecture & design
- Microservices
- Monolithic apps
- SOA
- Serverless
- Architectural patterns
- Integration patterns
- Building for scale
- Twelve-factor apps

### Message brokers & search
- Message brokers
- RabbitMQ
- Kafka
- Search engines
- Elasticsearch

### Containerization & web servers
- Docker
- Kubernetes
- LXC
- Reverse proxy

### Observability & resilience
- Instrumentation
- Monitoring
- Telemetry
- Graceful degradation
- Backpressure
- Circuit breaker
- Load shifting

### Real-time data & GraphQL
- WebSockets
- GraphQL subscriptions
- Apollo / Relay

### AI in the backend
- How LLMs work
- Embeddings
- Function calling / tool use
- Agents
- Model Context Protocol (MCP)
- AI-assisted coding
- RAG basics

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a REST + GraphQL API for a task manager with PostgreSQL, JWT auth, and rate limiting.
- Add Redis caching and a Kafka-driven async worker to an existing CRUD service, then load-test it.
- Containerize a microservice with Docker, add health checks, structured logging, and a CI/CD pipeline.
