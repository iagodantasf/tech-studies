---
title: Angular
roadmap: angular
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, angular, frontend]
---

# Angular

> roadmap.sh: https://roadmap.sh/angular

Track for the **Angular** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Introduction
- [ ] Introduction to Angular
- [ ] Angular and history
- [ ] Angular architecture
- [ ] Local setup
- [ ] Angular CLI
- [ ] Developer tools / DevTools
- [ ] Language service

### Components
- [ ] Components
- [ ] Creating components
- [ ] Component anatomy
- [ ] Component templates
- [ ] Component bindings
- [ ] Component lifecycle
- [ ] Dynamic components
- [ ] Encapsulation
- [ ] Content child (ContentChild)

### Templates & data binding
- [ ] Data binding
- [ ] Interpolation
- [ ] Attribute binding
- [ ] Attributes
- [ ] Event binding
- [ ] Input / output
- [ ] Communication

### Control flow
- [ ] Control flow
- [ ] @if
- [ ] @else / @else-if
- [ ] @for
- [ ] @switch / @case / @default
- [ ] @let
- [ ] @defer
- [ ] Deferrable views

### Directives
- [ ] Directives
- [ ] Attribute directives
- [ ] Custom directives

### Pipes
- [ ] Common pipes
- [ ] Custom pipes

### Dependency injection
- [ ] Dependency injection
- [ ] Services
- [ ] Containers

### RxJS & signals
- [ ] RxJS
- [ ] Observables
- [ ] Subjects
- [ ] Operators
- [ ] Signals
- [ ] Inputs as signals
- [ ] Change detection

### Routing
- [ ] Routing
- [ ] Router
- [ ] Route guards
- [ ] Link identification
- [ ] Lazy loading

### Forms
- [ ] Forms
- [ ] Template-driven forms
- [ ] Reactive forms
- [ ] Dynamic forms
- [ ] Custom validators
- [ ] Control value accessor

### HTTP & APIs
- [ ] HTTP client
- [ ] Interceptors
- [ ] HttpClient CSRF

### Modules & libraries
- [ ] Creating modules
- [ ] Feature modules
- [ ] Lazy loading modules
- [ ] Imports
- [ ] Dependencies
- [ ] Libraries
- [ ] Creating libraries

### Animation
- [ ] Animation
- [ ] Complex sequences
- [ ] Combination

### Security
- [ ] Cross-site scripting (XSS)
- [ ] Cross-site request forgery (CSRF)
- [ ] Cross-site script inclusion (XSSI)
- [ ] HTTP vulnerabilities
- [ ] Enforce trusted types

### Performance & SSR
- [ ] AOT compilation
- [ ] Hydration
- [ ] Image optimization
- [ ] Server-side rendering (SSR)
- [ ] Build environments
- [ ] CLI builders
- [ ] Configuration

### Testing
- [ ] Code coverage
- [ ] Debugging tests
- [ ] End-to-end testing

### Internationalization & accessibility
- [ ] Internationalization
- [ ] Accessibility

### Deployment & ecosystem
- [ ] Deployment
- [ ] AnalogJS
- [ ] Elf

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build an admin dashboard with standalone components, the new `@if`/`@for` control flow, signals for state, and lazy-loaded feature routes.
- Create a typed REST client layer using HttpClient + interceptors (auth token, error handling) and RxJS operators, consumed by a reactive-forms CRUD UI.
- Ship an SSR-rendered blog with AnalogJS, hydration enabled, image optimization, and i18n for two locales.
