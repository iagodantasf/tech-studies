---
title: Django
track: django
category: Skill-based
tags: [roadmap, django, python]
---

# Django

> roadmap.sh: https://roadmap.sh/django

Suggested path through the **Django** nodes. Each node links to its lesson when written.

## Nodes

### Prerequisites
- Python fundamentals
- HTTP & request/response cycle
- HTML & CSS basics
- Relational databases & SQL
- Virtual environments
- pip & package management

### Getting started
- Installation & project setup
- django-admin & manage.py
- Project vs app structure
- Settings module
- Development server (runserver)

### MVT architecture
- Model-View-Template overview
- URL dispatcher & routing
- URL namespaces & reverse()
- Views (function-based)
- Views (class-based)
- Generic views

### Templates
- Django template language
- Template inheritance
- Context & context processors
- Filters & tags
- Custom template tags

### Models & the ORM
- Defining models
- Fields & field types
- Migrations
- QuerySets & managers
- Relationships (FK, M2M, O2O)
- Aggregation & annotation
- Transactions
- Raw SQL & query optimization

### Forms
- Form basics
- ModelForms
- Form validation
- Formsets
- CSRF protection

### Admin site
- Registering models
- Customizing ModelAdmin
- Admin actions & filters

### Authentication & authorization
- User model & custom users
- Login / logout / sessions
- Permissions & groups
- Password management

### Class-based view mixins
- ListView & DetailView
- CreateView, UpdateView, DeleteView
- LoginRequired & permission mixins

### Static & media files
- Static files handling
- Media / file uploads
- collectstatic & storage backends

### Middleware
- Built-in middleware
- Writing custom middleware

### REST & APIs
- Django REST Framework
- Serializers
- ViewSets & routers
- Authentication & permissions
- GraphQL (Graphene / Strawberry)

### Async & background work
- ASGI & async views
- Celery & task queues
- Django Channels (WebSockets)
- Caching (Redis / Memcached)

### Testing
- Django test framework
- pytest-django
- Test client & fixtures
- Factory Boy

### Security
- XSS, CSRF & SQL injection defenses
- Clickjacking protection
- HTTPS & secure settings
- Security middleware

### Deployment
- WSGI / ASGI servers (Gunicorn, Uvicorn)
- Nginx reverse proxy
- Environment configuration
- Docker & containerization
- Logging & monitoring
- CI/CD

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a blog with auth, the admin, ModelForms, and class-based views end to end.
- Expose a REST API for a todo app using Django REST Framework with token auth and tests.
- Add a Celery + Redis background pipeline that sends email notifications and caches expensive queries.
