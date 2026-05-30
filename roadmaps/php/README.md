---
title: PHP
roadmap: php
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, php]
---

# PHP

> roadmap.sh: https://roadmap.sh/php

Track for the **PHP** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Getting started
- [ ] What is PHP?
- [ ] History and versions (PHP 5 vs 7 vs 8)
- [ ] Installing PHP locally
- [ ] CLI vs web server execution
- [ ] PHP-FPM and the SAPI model
- [ ] php.ini configuration
- [ ] Running a built-in dev server

### Language basics
- [ ] Syntax and embedding in HTML
- [ ] Variables and variable scope
- [ ] Data types and type juggling
- [ ] Constants and enums
- [ ] Operators
- [ ] Strings and string functions
- [ ] Arrays (indexed, associative, multidimensional)
- [ ] Control structures (if, switch, match)
- [ ] Loops (for, foreach, while)
- [ ] Functions and arrow functions
- [ ] Variadic and named arguments
- [ ] Null safety and the null coalescing operator
- [ ] Superglobals ($_GET, $_POST, $_SERVER, $_SESSION)

### Object-oriented PHP
- [ ] Classes and objects
- [ ] Properties, methods, and visibility
- [ ] Constructors and constructor promotion
- [ ] Static members
- [ ] Inheritance
- [ ] Interfaces
- [ ] Abstract classes
- [ ] Traits
- [ ] Enums (backed and pure)
- [ ] Magic methods (`__get`, `__set`, `__invoke`, `__toString`)
- [ ] Late static binding
- [ ] Readonly properties
- [ ] Namespaces
- [ ] Anonymous classes

### Type system and quality
- [ ] Type declarations (scalar, union, intersection)
- [ ] Nullable and nullsafe types
- [ ] Strict types declare()
- [ ] Attributes (annotations)
- [ ] Static analysis (PHPStan, Psalm)
- [ ] Coding standards (PSR-1, PSR-12)
- [ ] PHP-CS-Fixer

### Error and exception handling
- [ ] Errors vs exceptions
- [ ] try / catch / finally
- [ ] Custom exception classes
- [ ] Throwable hierarchy
- [ ] Error reporting levels
- [ ] Logging errors

### Tooling and ecosystem
- [ ] Composer (dependency management)
- [ ] Autoloading (PSR-4)
- [ ] PSR standards overview
- [ ] PHP-FIG
- [ ] Packagist
- [ ] Useful CLI tools

### Working with data
- [ ] Forms and request handling
- [ ] Sessions and cookies
- [ ] File I/O and streams
- [ ] JSON encode/decode
- [ ] Working with dates (DateTime)
- [ ] Regular expressions (PCRE)
- [ ] Filtering and validating input

### Databases
- [ ] PDO
- [ ] MySQLi
- [ ] Prepared statements
- [ ] Transactions
- [ ] Connection handling
- [ ] ORMs (Doctrine, Eloquent)

### Security
- [ ] SQL injection prevention
- [ ] XSS prevention and output escaping
- [ ] CSRF protection
- [ ] Password hashing (password_hash / verify)
- [ ] Input sanitization
- [ ] Secure session configuration
- [ ] HTTPS and secure cookies

### Testing
- [ ] PHPUnit
- [ ] Unit vs integration tests
- [ ] Mocking and test doubles
- [ ] Pest
- [ ] Code coverage

### Web and APIs
- [ ] HTTP request lifecycle
- [ ] Building REST APIs
- [ ] PSR-7 HTTP messages
- [ ] Middleware (PSR-15)
- [ ] Frameworks overview (Laravel, Symfony, Slim)
- [ ] Templating (Twig, Blade)

### Advanced topics
- [ ] Generators and iterators
- [ ] Closures and binding
- [ ] Reflection API
- [ ] Dependency injection and containers
- [ ] Design patterns in PHP
- [ ] Async PHP (Fibers, ReactPHP, Swoole)
- [ ] Caching (OPcache, APCu, Redis)
- [ ] Performance profiling (Xdebug, Blackfire)
- [ ] Deployment and process managers

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a small MVC framework from scratch (router, container, PDO-backed model layer) to understand what Laravel/Symfony do under the hood.
- Create a REST API for a task manager using PSR-7/PSR-15 middleware, PDO with prepared statements, and PHPUnit tests for each endpoint.
- Write a Composer-installable package (with PSR-4 autoloading, PHPStan, and CI) and publish it to Packagist.
