---
title: Go
roadmap: golang
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, go]
---

# Go

> roadmap.sh: https://roadmap.sh/golang

Track for the **Go** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Introduction
- [ ] What is Go
- [ ] Why Go (Simplicity / Concurrency)
- [ ] Installing Go
- [ ] Go Toolchain (`go` command)
- [ ] Hello World
- [ ] `go run` / `go build` / `go install`
- [ ] GOROOT / GOPATH / Go Modules

### Basics / Syntax
- [ ] Variables & `:=`
- [ ] Constants & `iota`
- [ ] Basic Types
- [ ] Zero Values
- [ ] Type Conversions
- [ ] Operators
- [ ] Control Flow (`if` / `for` / `switch`)
- [ ] `defer`
- [ ] Comments

### Functions
- [ ] Declaring Functions
- [ ] Multiple Return Values
- [ ] Named Return Values
- [ ] Variadic Functions
- [ ] Closures & Anonymous Functions
- [ ] First-Class Functions
- [ ] `defer`, `panic`, `recover`

### Data Structures
- [ ] Arrays
- [ ] Slices
- [ ] Slice Internals (len / cap)
- [ ] Maps
- [ ] Structs
- [ ] Anonymous Structs
- [ ] Struct Embedding
- [ ] Pointers

### Methods & Interfaces
- [ ] Methods
- [ ] Pointer vs Value Receivers
- [ ] Interfaces
- [ ] Empty Interface / `any`
- [ ] Type Assertions
- [ ] Type Switches
- [ ] Interface Composition
- [ ] `Stringer` & Common Interfaces

### Generics
- [ ] Type Parameters
- [ ] Constraints
- [ ] `comparable` & `constraints` Package
- [ ] Generic Functions & Types

### Error Handling
- [ ] The `error` Interface
- [ ] Creating Errors (`errors.New`, `fmt.Errorf`)
- [ ] Error Wrapping (`%w`)
- [ ] `errors.Is` / `errors.As`
- [ ] Custom Error Types
- [ ] Sentinel Errors

### Concurrency
- [ ] Goroutines
- [ ] Channels
- [ ] Buffered Channels
- [ ] `select`
- [ ] `sync.WaitGroup`
- [ ] `sync.Mutex` / `RWMutex`
- [ ] `sync.Once`
- [ ] `context` Package
- [ ] Worker Pools
- [ ] Race Detector

### Packages & Modules
- [ ] Packages
- [ ] Imports
- [ ] Exported vs Unexported
- [ ] Go Modules (`go.mod` / `go.sum`)
- [ ] `go get` & Versioning
- [ ] Workspaces (`go.work`)
- [ ] `init` Functions

### Standard Library
- [ ] `fmt`
- [ ] `strings` / `strconv`
- [ ] `os` / `io`
- [ ] `bufio`
- [ ] `time`
- [ ] `encoding/json`
- [ ] `net/http`
- [ ] `sort`
- [ ] `regexp`
- [ ] `log` / `log/slog`

### Testing & Tooling
- [ ] `testing` Package
- [ ] Table-Driven Tests
- [ ] Benchmarks
- [ ] `go test` & Coverage
- [ ] Fuzzing
- [ ] `go fmt` / `gofmt`
- [ ] `go vet`
- [ ] `golangci-lint`
- [ ] `pprof` Profiling
- [ ] Delve Debugger

### Web & Beyond
- [ ] Building HTTP Servers
- [ ] Routing & Middleware
- [ ] Web Frameworks (Gin / Echo / Chi)
- [ ] Database Access (`database/sql`)
- [ ] ORMs (GORM / sqlc)
- [ ] gRPC & Protobuf
- [ ] Cross-Compilation

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Harden the existing `playgrounds/go/worker-pool` into a generic, context-cancellable pool: add a `context.Context` for graceful shutdown, error aggregation, and a benchmark plus race-detector run (`go test -race`).
- Add a `playgrounds/go/url-shortener` HTTP service using only `net/http` and `encoding/json` (in-memory map + `sync.RWMutex`), then layer table-driven handler tests over it.
- Generalize `playgrounds/go/binary-search` into a generic `func BinarySearch[T cmp.Ordered](…)` using type parameters, with a fuzz test (`go test -fuzz`) to find edge cases.
