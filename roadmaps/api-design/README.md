---
title: API Design
roadmap: api-design
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, api]
---

# API Design

> roadmap.sh: https://roadmap.sh/api-design

Track for the **API Design** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Fundamentals
- [ ] Learn the basics of APIs
- [ ] Basics of DNS
- [ ] Different API styles
- [ ] Synchronous vs asynchronous APIs

### HTTP foundations
- [ ] HTTP
- [ ] HTTP versions
- [ ] HTTP methods
- [ ] HTTP status codes
- [ ] HTTP headers
- [ ] Cookies
- [ ] Content negotiation
- [ ] CORS

### REST
- [ ] REST principles
- [ ] RESTful APIs
- [ ] Building JSON / RESTful APIs
- [ ] Simple JSON APIs
- [ ] Handling CRUD operations
- [ ] HATEOAS

### Other API styles
- [ ] GraphQL APIs
- [ ] gRPC APIs
- [ ] SOAP APIs
- [ ] Real-time APIs
- [ ] Server-sent events
- [ ] WebSockets

### Authentication
- [ ] Authentication methods
- [ ] Basic auth
- [ ] Token-based auth
- [ ] Session-based auth
- [ ] JWT
- [ ] OAuth 2.0
- [ ] API keys & management

### Authorization
- [ ] Authorization methods
- [ ] RBAC
- [ ] ABAC
- [ ] PBAC
- [ ] ReBAC
- [ ] DAC
- [ ] MAC

### API security
- [ ] API security overview
- [ ] Common vulnerabilities
- [ ] Rate limiting & throttling
- [ ] Standards and compliance
- [ ] GDPR
- [ ] CCPA
- [ ] HIPAA
- [ ] PCI DSS
- [ ] PII

### Reliability & design patterns
- [ ] Idempotency
- [ ] Pagination
- [ ] Error handling
- [ ] Error handling & retries
- [ ] RFC 7807 — Problem Details
- [ ] Caching strategies
- [ ] HTTP caching

### Performance & scaling
- [ ] API performance
- [ ] Performance metrics
- [ ] Profiling and monitoring
- [ ] Load balancing
- [ ] Batch processing

### Async & integration
- [ ] Event-driven architecture
- [ ] Messaging queues
- [ ] Kafka
- [ ] RabbitMQ
- [ ] API integration patterns
- [ ] Microservices architecture
- [ ] API gateways

### Testing
- [ ] API testing
- [ ] Functional testing
- [ ] Integration testing
- [ ] Contract testing
- [ ] Load testing
- [ ] Performance testing
- [ ] Mocking APIs
- [ ] Postman

### Documentation & lifecycle
- [ ] API documentation tools
- [ ] Swagger / OpenAPI
- [ ] Stoplight
- [ ] Readme.com
- [ ] API lifecycle management
- [ ] Best practices

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Design and document a versioned REST API with OpenAPI, idempotency keys, cursor pagination, and RFC 7807 errors.
- Build an OAuth 2.0 + RBAC authorization layer for a multi-tenant API and write contract tests for it.
- Stand up an API gateway with rate limiting, caching, and request validation in front of a microservice backend.
