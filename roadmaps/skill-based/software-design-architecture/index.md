---
title: Software Design & Architecture
track: software-design-architecture
category: Skill-based
tags: [roadmap, architecture]
---

# Software Design & Architecture

> roadmap.sh: https://roadmap.sh/software-design-architecture

Suggested path through the **Software Design & Architecture** nodes. Each node links to its lesson when written.

## Nodes

### Clean code
- Be Consistent
- Meaningful Naming
- Indentation & Code Style
- Keep Methods/Classes/Files Small
- Pure Functions
- Minimize Cyclomatic Complexity
- Avoid Passing Nulls & Booleans
- Keep Framework Code Distant
- Use Correct Constructs
- Keep Tests Trivial
- Avoid Premature Optimization
- Command Query Separation
- Structured Programming
- Good Comments / Self-Documenting Code

### Programming paradigms
- Structured Programming
- Object-Oriented Programming
- Functional Programming
- Imperative vs Declarative

### Object-oriented programming
- Abstraction
- Encapsulation
- Inheritance
- Polymorphism
- Composition over Inheritance
- Law of Demeter

### Design principles
- DRY (Don't Repeat Yourself)
- KISS (Keep It Simple, Stupid)
- YAGNI (You Aren't Gonna Need It)
- SOLID Principles
- Single Responsibility Principle
- Open/Closed Principle
- Liskov Substitution Principle
- Interface Segregation Principle
- Dependency Inversion Principle
- Separation of Concerns
- Coupling & Cohesion
- Encapsulate What Varies
- Program Against Abstractions
- Hollywood Principle

### Design patterns
- Gang of Four (GoF) Patterns
- Creational Patterns
- Structural Patterns
- Behavioral Patterns
- Singleton
- Factory & Abstract Factory
- Builder
- Adapter
- Decorator
- Facade
- Strategy
- Observer
- Command
- Dependency Injection
- Anti-Patterns

### Architectural principles
- Component Principles
- Policy vs Detail
- Coupling & Cohesion (Architecture)
- Boundaries
- Composition vs Inheritance
- Stable Dependencies Principle
- Stable Abstractions Principle

### Architectural styles
- Structural Styles
- Messaging Styles
- Distributed Styles
- Monolithic vs Distributed
- Layered Architecture
- Event-Driven Architecture
- Microkernel / Plugin
- Pipe & Filter
- Service-Based Architecture
- Space-Based Architecture

### Architectural patterns
- Microservices
- Monolithic Apps
- Serverless
- Event Sourcing
- CQRS
- Hexagonal (Ports & Adapters)
- Clean Architecture
- Onion Architecture
- MVC / MVP / MVVM
- Domain-Driven Design

### Enterprise patterns
- DTOs
- Identity Maps
- Use Cases / Interactors
- Repositories
- Entities & Value Objects
- Domain Services
- Application Services
- Mappers
- Gateways
- ORMs

## Resources
See [resources.md](./resources.md).

## Project ideas
- Refactor a small monolithic CRUD app into Clean / Hexagonal architecture, separating domain, use cases, and infrastructure adapters.
- Build a worked example that applies all five SOLID principles, then write a companion piece showing the smelly "before" version of each.
- Implement the same feature (e.g. an order workflow) twice — once with classic layered CRUD and once with CQRS + Event Sourcing — and document the trade-offs.
