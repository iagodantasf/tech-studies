---
title: Server Side Game Developer
roadmap: server-side-game-developer
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, game-dev, backend]
---

# Server Side Game Developer

> roadmap.sh: https://roadmap.sh/server-side-game-developer

Track for the **Server Side Game Developer** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Foundations
- [ ] What is a game server
- [ ] Client-server vs peer-to-peer
- [ ] Authoritative vs non-authoritative servers
- [ ] Online game architecture overview
- [ ] Roles on a backend game team

### Programming Languages
- [ ] C++
- [ ] C#
- [ ] Go
- [ ] Rust
- [ ] Java
- [ ] Node.js / JavaScript
- [ ] Python

### Networking Fundamentals
- [ ] OSI model
- [ ] TCP
- [ ] UDP
- [ ] IP & ports
- [ ] WebSockets
- [ ] HTTP / HTTPS
- [ ] DNS
- [ ] NAT & port forwarding
- [ ] Reliable UDP

### Game Networking
- [ ] Client-side prediction
- [ ] Server reconciliation
- [ ] Entity interpolation
- [ ] Lag compensation
- [ ] Snapshot & delta compression
- [ ] State synchronization
- [ ] Tick rate & netcode loops
- [ ] Rollback netcode
- [ ] Latency & jitter handling

### Server Architecture
- [ ] Dedicated game servers
- [ ] Listen servers
- [ ] Matchmaking services
- [ ] Lobby systems
- [ ] Session management
- [ ] Game server orchestration (Agones)
- [ ] Horizontal scaling & sharding
- [ ] Load balancing
- [ ] Microservices vs monolith

### Data & Persistence
- [ ] Relational databases (PostgreSQL, MySQL)
- [ ] NoSQL databases (MongoDB, DynamoDB)
- [ ] In-memory stores (Redis)
- [ ] Caching strategies
- [ ] Player data & profiles
- [ ] Leaderboards
- [ ] Inventory & economy systems
- [ ] Data modeling for games

### Backend Services
- [ ] Authentication & accounts
- [ ] Authorization
- [ ] APIs (REST / gRPC)
- [ ] Message queues (Kafka, RabbitMQ)
- [ ] Real-time messaging
- [ ] Telemetry & analytics events
- [ ] Live ops & remote config

### Security
- [ ] Anti-cheat fundamentals
- [ ] Server-side validation
- [ ] Encryption (TLS)
- [ ] DDoS protection
- [ ] Rate limiting
- [ ] Secrets management
- [ ] Exploit & abuse prevention

### DevOps & Infrastructure
- [ ] Containers (Docker)
- [ ] Kubernetes
- [ ] Cloud providers (AWS, GCP, Azure)
- [ ] Infrastructure as Code
- [ ] CI/CD pipelines
- [ ] Monitoring & observability
- [ ] Logging
- [ ] Auto-scaling

### Performance & Reliability
- [ ] Profiling server performance
- [ ] Concurrency & multithreading
- [ ] Memory management
- [ ] Fault tolerance & failover
- [ ] Graceful degradation
- [ ] Load & stress testing

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build an authoritative real-time server for a simple multiplayer game (e.g. a .io-style arena) with client-side prediction and server reconciliation.
- Implement a matchmaking + lobby service backed by Redis, with session management and a leaderboard.
- Containerize a dedicated game server and deploy it on Kubernetes with Agones for fleet orchestration and auto-scaling.
