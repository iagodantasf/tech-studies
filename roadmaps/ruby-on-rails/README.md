---
title: Ruby on Rails
roadmap: ruby-on-rails
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, rails, ruby]
---

# Ruby on Rails

> roadmap.sh: https://roadmap.sh/ruby-on-rails

Track for the **Ruby on Rails** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Ruby language fundamentals
- [ ] Ruby syntax and basics
- [ ] Variables and scope
- [ ] Data types (String, Symbol, Numeric)
- [ ] Arrays and Hashes
- [ ] Ranges
- [ ] Conditionals and control flow
- [ ] Loops and iterators
- [ ] Methods and arguments
- [ ] Blocks, Procs and Lambdas
- [ ] Classes and objects
- [ ] Modules and mixins
- [ ] Inheritance
- [ ] Metaprogramming
- [ ] Exception handling
- [ ] Gems and Bundler
- [ ] RubyGems ecosystem

### Prerequisites
- [ ] HTML and CSS
- [ ] JavaScript fundamentals
- [ ] HTTP and how the web works
- [ ] Relational databases and SQL
- [ ] Git and version control
- [ ] Command line basics

### Rails fundamentals
- [ ] What is Rails / convention over configuration
- [ ] Installation and setup
- [ ] Rails directory structure
- [ ] Rails CLI and generators
- [ ] Rake tasks
- [ ] Environments (development, test, production)
- [ ] Bundler and Gemfile
- [ ] Credentials and secrets

### MVC architecture
- [ ] MVC pattern overview
- [ ] Request/response lifecycle
- [ ] Routing
- [ ] Controllers and actions
- [ ] Strong parameters
- [ ] Views and layouts
- [ ] ERB templating
- [ ] Partials
- [ ] Helpers
- [ ] Models

### Active Record
- [ ] ORM concepts
- [ ] Migrations
- [ ] Schema and schema.rb
- [ ] CRUD operations
- [ ] Validations
- [ ] Callbacks
- [ ] Associations (belongs_to, has_many, has_one)
- [ ] has_many :through and HABTM
- [ ] Polymorphic associations
- [ ] Query interface and scopes
- [ ] N+1 queries and eager loading
- [ ] Database indexes
- [ ] Transactions

### Routing
- [ ] RESTful routes and resources
- [ ] Nested routes
- [ ] Route constraints
- [ ] Named routes and path helpers
- [ ] Namespaces and scopes

### Views and frontend
- [ ] Asset pipeline / Propshaft
- [ ] Importmap and JavaScript bundling
- [ ] Hotwire (Turbo and Stimulus)
- [ ] Turbo Frames and Streams
- [ ] View components
- [ ] Forms and form helpers
- [ ] Tailwind / CSS integration

### Active Support and libraries
- [ ] Active Support core extensions
- [ ] Action Mailer
- [ ] Active Job and background processing
- [ ] Action Cable (WebSockets)
- [ ] Active Storage (file uploads)
- [ ] Action Text (rich text)
- [ ] I18n and localization

### APIs
- [ ] Building JSON APIs
- [ ] API-only mode
- [ ] Serializers (Jbuilder, AMS)
- [ ] Versioning APIs
- [ ] CORS

### Authentication and authorization
- [ ] Sessions and cookies
- [ ] Devise
- [ ] has_secure_password
- [ ] OmniAuth
- [ ] Pundit / CanCanCan
- [ ] Authorization patterns

### Testing
- [ ] Minitest
- [ ] RSpec
- [ ] Fixtures and FactoryBot
- [ ] Model, controller and system tests
- [ ] Capybara
- [ ] Test coverage

### Security
- [ ] CSRF protection
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] Mass assignment protection
- [ ] Brakeman and security scanning

### Performance and caching
- [ ] Fragment and Russian-doll caching
- [ ] Low-level caching
- [ ] Redis and Memcached
- [ ] Database query optimization
- [ ] Bullet gem

### Deployment and ops
- [ ] Puma and web servers
- [ ] Environment configuration
- [ ] Kamal / Docker
- [ ] CI/CD pipelines
- [ ] Logging and monitoring
- [ ] Background workers (Sidekiq, Solid Queue)

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a multi-tenant SaaS blog platform with Devise auth, Pundit authorization, and Hotwire-driven live updates.
- Create a JSON API backend for a task manager with versioned endpoints, Sidekiq background jobs, and RSpec request specs.
- Build a real-time chat app using Action Cable, Turbo Streams, and Active Storage for image attachments.
