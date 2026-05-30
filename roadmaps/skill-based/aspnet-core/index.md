---
title: ASP.NET Core
track: aspnet-core
category: Skill-based
tags: [roadmap, dotnet, backend]
---

# ASP.NET Core

> roadmap.sh: https://roadmap.sh/aspnet-core

Suggested path through the **ASP.NET Core** nodes. Each node links to its lesson when written.

## Nodes

### Prerequisites
- C# fundamentals
- .NET and the CLR
- .NET CLI
- NuGet packages
- HTTP and REST basics

### Getting Started
- What is ASP.NET Core
- ASP.NET Core vs ASP.NET
- Project structure
- Program.cs and the host
- Kestrel web server
- Generic and web host
- Configuration system
- Options pattern
- Environments

### Middleware and Pipeline
- Request pipeline
- Built-in middleware
- Custom middleware
- Routing
- Endpoint routing
- Static files
- Exception handling middleware

### Dependency Injection
- Built-in DI container
- Service lifetimes (transient, scoped, singleton)
- Registering services
- Constructor injection

### Building APIs
- Controllers
- Minimal APIs
- Model binding
- Model validation
- Action results
- Content negotiation
- Filters
- API versioning
- OpenAPI / Swagger
- Problem Details
- CORS
- Rate limiting

### Web UI
- Razor Pages
- MVC pattern
- Razor views and syntax
- Tag helpers
- View components
- Blazor Server
- Blazor WebAssembly

### Data Access
- Entity Framework Core
- DbContext
- Migrations
- LINQ queries
- Relationships
- Dapper
- Repository pattern
- Connection management

### Security
- Authentication
- Authorization
- ASP.NET Core Identity
- JWT bearer tokens
- Cookie authentication
- OAuth2 and OpenID Connect
- Policy-based authorization
- Data protection
- HTTPS and HSTS

### Real-Time and Communication
- SignalR
- WebSockets
- gRPC
- HttpClient and IHttpClientFactory
- Background services
- Hosted services

### Testing
- Unit testing (xUnit)
- Integration testing
- WebApplicationFactory
- Mocking with Moq

### Observability and Deployment
- Logging
- Health checks
- OpenTelemetry
- Caching (in-memory, distributed)
- Output caching
- Publishing apps
- Docker and containers
- .NET Aspire

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a minimal API for a task tracker with EF Core, validation, and Swagger documentation.
- Add ASP.NET Core Identity with JWT auth and policy-based authorization to an existing API.
- Create a real-time chat app using SignalR with a Blazor WebAssembly front end.
