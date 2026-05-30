---
title: Node.js
roadmap: nodejs
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, nodejs, backend]
---

# Node.js

> roadmap.sh: https://roadmap.sh/nodejs

Track for the **Node.js** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Introduction
- [ ] What is Node.js
- [ ] Node.js vs the browser
- [ ] How Node.js works (V8, libuv)
- [ ] Installing Node.js
- [ ] Running Node.js code

### JavaScript Prerequisites
- [ ] Variables, types & operators
- [ ] Functions & closures
- [ ] Asynchronous JavaScript (callbacks, promises, async/await)
- [ ] ES Modules vs CommonJS

### Modules
- [ ] CommonJS (require / module.exports)
- [ ] ECMAScript Modules (import / export)
- [ ] Module resolution
- [ ] global keyword
- [ ] Built-in (core) modules
- [ ] Writing your own modules

### npm
- [ ] package.json
- [ ] Installing packages (local vs global)
- [ ] Semantic versioning
- [ ] package-lock.json
- [ ] npm scripts
- [ ] npx
- [ ] Publishing packages
- [ ] Alternatives: Yarn, pnpm

### Error Handling
- [ ] Error objects & stack traces
- [ ] try/catch & async error handling
- [ ] Error-first callbacks
- [ ] Uncaught exceptions & unhandled rejections
- [ ] process.on for errors
- [ ] Debugging (node --inspect, debugger)

### Asynchronous Programming
- [ ] Event loop (phases)
- [ ] Event emitters
- [ ] Callbacks
- [ ] Promises
- [ ] async/await
- [ ] process.nextTick & setImmediate
- [ ] Timers (setTimeout, setInterval)

### Working with Files
- [ ] fs module (sync, callback, promises)
- [ ] Reading & writing files
- [ ] Watching files
- [ ] path module
- [ ] `__dirname` & `__filename`

### Command Line Apps
- [ ] process.argv
- [ ] process.env
- [ ] stdin / stdout / stderr
- [ ] Exit codes
- [ ] Printing output (console, chalk)
- [ ] Taking input (prompts, inquirer)

### Working with APIs / Networking
- [ ] http & https modules
- [ ] Making HTTP requests (fetch, axios, undici)
- [ ] net & dgram (TCP/UDP)
- [ ] URL & querystring
- [ ] WebSockets (ws, socket.io)

### Frameworks
- [ ] Express.js
- [ ] Fastify
- [ ] NestJS
- [ ] Koa
- [ ] Hapi

### Working with Databases
- [ ] Relational (PostgreSQL, MySQL)
- [ ] NoSQL (MongoDB, Redis)
- [ ] ORMs & query builders (Prisma, Sequelize, TypeORM, Knex)
- [ ] Connection pooling
- [ ] Migrations

### Streams
- [ ] Readable streams
- [ ] Writable streams
- [ ] Duplex & Transform streams
- [ ] Piping & backpressure
- [ ] Buffer

### Concurrency & Performance
- [ ] Child processes (spawn, exec, fork)
- [ ] Cluster module
- [ ] Worker threads
- [ ] Memory & CPU profiling
- [ ] Benchmarking

### Testing
- [ ] node:test (built-in test runner)
- [ ] Jest
- [ ] Vitest
- [ ] Mocha & Chai
- [ ] Supertest (HTTP assertions)

### Logging
- [ ] console
- [ ] Pino
- [ ] Winston
- [ ] Morgan

### Keeping App Running & Deploying
- [ ] Process managers (PM2, nodemon)
- [ ] Environment configuration (dotenv)
- [ ] Containerizing with Docker
- [ ] Graceful shutdown
- [ ] Health checks

### More Debugging
- [ ] Memory leaks
- [ ] Async hooks
- [ ] Garbage collection
- [ ] Heap snapshots

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a streaming CSV-to-JSON converter CLI using Readable/Transform streams with backpressure.
- Create a REST API in Express with PostgreSQL, Prisma, JWT auth, and Supertest integration tests.
- Write a clustered HTTP load balancer using the cluster module and benchmark requests/sec.
