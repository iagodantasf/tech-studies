---
title: Ruby
track: ruby
category: Skill-based
tags: [roadmap, ruby]
---

# Ruby

> roadmap.sh: https://roadmap.sh/ruby

Suggested path through the **Ruby** nodes. Each node links to its lesson when written.

## Nodes

### Getting started
- What is Ruby?
- History and philosophy (MINASWAN)
- Installing Ruby (rbenv, rvm, asdf)
- IRB and the REPL
- Running scripts
- Ruby versions and implementations (MRI, JRuby, TruffleRuby)

### Language basics
- Everything is an object
- Variables and scope
- Data types (Integer, Float, String, Symbol)
- Booleans, nil, and truthiness
- Strings and interpolation
- Symbols vs strings
- Arrays
- Hashes
- Ranges
- Operators
- Comments and documentation

### Control flow
- if / unless
- case / when (and pattern matching)
- Loops (while, until, for)
- Iterators (each, map, select, reduce)
- Ternary and conditional modifiers
- break, next, redo

### Methods and blocks
- Defining methods
- Arguments (default, keyword, splat, block)
- Return values
- Blocks
- Procs and lambdas
- yield
- Method visibility (public, private, protected)

### Object-oriented Ruby
- Classes and objects
- Instance variables and methods
- Class variables and methods
- attr_accessor / reader / writer
- Inheritance
- Modules and mixins
- include vs extend vs prepend
- Comparable and Enumerable
- Polymorphism and duck typing
- Constants
- self
- Method missing and respond_to?

### Metaprogramming
- Open classes (monkey patching)
- define_method
- send and public_send
- instance_eval / class_eval
- Reflection (methods, instance_variables)
- Hooks (included, inherited, method_added)

### Error handling
- begin / rescue / ensure
- raise
- Exception hierarchy
- Custom exceptions
- retry

### Standard library and core
- Enumerable module
- Comparable module
- Struct and OpenStruct
- Time and Date
- File and IO
- JSON
- Regular expressions
- Set

### Functional features
- Higher-order methods
- Method chaining
- Lazy enumerators
- Frozen objects and immutability

### Tooling and ecosystem
- Gems and RubyGems
- Bundler and the Gemfile
- Creating a gem
- Rake tasks
- IRB / Pry for debugging
- RuboCop (linting)
- Documentation with RDoc / YARD

### Testing
- Minitest
- RSpec
- Test-driven development
- Mocks and stubs
- Fixtures and factories

### Concurrency
- Threads
- The GVL/GIL
- Fibers
- Ractors
- Async and non-blocking IO

### Beyond the language
- Ruby on Rails (web framework)
- Sinatra (microframework)
- Building CLI tools
- Garbage collection and memory
- Performance profiling and benchmarking

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a command-line tool (e.g. a Markdown-to-HTML converter or a budget tracker) packaged as a gem with Bundler, Rake tasks, and RSpec tests.
- Write a small web framework or app with Sinatra to understand routing, middleware, and Rack before reaching for Rails.
- Implement a classic algorithm library (sorting, graph traversal) leaning on Enumerable, blocks, and metaprogramming, fully tested with Minitest.
