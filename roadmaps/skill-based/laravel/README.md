---
title: Laravel
track: laravel
category: Skill-based
tags: [roadmap, laravel, php]
---

# Laravel

> roadmap.sh: https://roadmap.sh/laravel

Suggested path through the **Laravel** nodes. Each node links to its lesson when written.

## Nodes

### Prerequisites
- Solid PHP 8+ fundamentals
- OOP and namespaces
- Composer
- SQL and relational databases
- HTTP and REST basics
- Command line basics

### Getting started
- What is Laravel?
- Installing Laravel (installer, Composer)
- Laravel Sail / Herd / Valet
- Directory structure
- The .env file and configuration
- Artisan CLI
- Application lifecycle

### Routing
- Basic routes
- Route parameters and constraints
- Named routes
- Route groups
- Route model binding
- Resource routes
- Fallback routes
- Rate limiting routes

### Middleware
- What is middleware?
- Global vs route middleware
- Creating custom middleware
- Middleware parameters
- Middleware groups

### Controllers and requests
- Controllers
- Single-action controllers
- Resource controllers
- Request lifecycle
- Form Request validation
- Validation rules
- Dependency injection in controllers

### Views and frontend
- Blade templating
- Blade components and slots
- Layouts and inheritance
- Directives and control structures
- Passing data to views
- Asset bundling with Vite
- Laravel Breeze / Jetstream
- Livewire
- Inertia.js

### Eloquent ORM
- Models and conventions
- Migrations
- Seeders and factories
- Query builder
- Eloquent relationships (one-to-one, one-to-many, many-to-many, polymorphic)
- Eager loading and N+1
- Accessors, mutators, and casts
- Scopes (local and global)
- Soft deletes
- Collections
- Database transactions

### Authentication and authorization
- Authentication starter kits
- Manual authentication
- Guards and providers
- Laravel Sanctum
- Laravel Passport
- Gates
- Policies
- Email verification
- Password reset

### Services and architecture
- Service container
- Service providers
- Facades
- Contracts
- Dependency injection
- Events and listeners
- Observers
- Action / service classes

### Asynchronous and background work
- Queues and jobs
- Queue workers and Horizon
- Job batching and chaining
- Task scheduling (cron)
- Broadcasting and websockets (Reverb)
- Notifications (mail, database, Slack)

### APIs
- API routes
- API Resources (transformers)
- API authentication with Sanctum
- Pagination
- Rate limiting
- Versioning

### Caching, storage, and mail
- Cache drivers and usage
- Sessions
- Filesystem and cloud storage
- File uploads
- Mailables and Markdown mail
- Localization

### Testing
- PHPUnit in Laravel
- Pest
- Feature vs unit tests
- HTTP tests
- Database testing and RefreshDatabase
- Mocking and fakes
- Browser tests (Dusk)

### Ecosystem and deployment
- Laravel Forge
- Laravel Envoyer / zero-downtime deploys
- Laravel Vapor (serverless)
- Laravel Octane
- Telescope (debugging)
- Pint (code style)
- Larastan / static analysis
- Deployment best practices

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a multi-tenant SaaS starter with Sanctum auth, Eloquent relationships, queued jobs for emails, and an API consumed by a small Vue/Inertia frontend.
- Create a blogging platform with Blade + Livewire, policies for authorization, full-text search, and Pest feature tests covering every route.
- Build a REST API with API Resources, rate limiting, pagination, and OpenAPI docs, deployed with Forge and queue workers via Horizon.
