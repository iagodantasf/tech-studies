---
title: Scala
track: scala
category: Skill-based
tags: [roadmap, scala]
---

# Scala

> roadmap.sh: https://roadmap.sh/scala

Suggested path through the **Scala** nodes. Each node links to its lesson when written.

## Nodes

### Getting started
- What is Scala
- Scala 2 vs Scala 3
- Installing the JDK
- sbt build tool
- Scala CLI
- REPL / worksheets
- IDE & Metals setup

### Basics & syntax
- Values & variables (val/var)
- Basic data types
- Operators
- String interpolation
- Expressions vs statements
- Conditionals (if/else)
- Loops & ranges
- Comments & scaladoc

### Functions
- Defining methods
- Function literals & lambdas
- Higher-order functions
- Default & named arguments
- Variadic parameters
- Currying & partial application
- Tail recursion
- By-name parameters

### Object-oriented Scala
- Classes & constructors
- Objects & companion objects
- Case classes
- Traits
- Abstract classes
- Access modifiers
- Inheritance & overriding
- Sealed traits
- Enums (Scala 3)

### Functional programming
- Immutability
- Pure functions & referential transparency
- Pattern matching
- Option, Some, None
- Either & Try
- for-comprehensions
- Recursion over iteration
- Algebraic data types

### Collections
- List, Vector, Seq
- Set & Map
- Tuples
- Arrays
- map / flatMap / filter
- fold & reduce
- Lazy collections (LazyList)
- Immutable vs mutable collections

### Type system
- Type inference
- Generics & type parameters
- Variance (covariance/contravariance)
- Bounds (upper/lower)
- Implicits / given & using (Scala 3)
- Type classes
- Context bounds
- Higher-kinded types
- Opaque types (Scala 3)
- Union & intersection types (Scala 3)

### Concurrency & async
- Futures & Promises
- ExecutionContext
- Parallel collections
- Akka / Pekko actors
- Cats Effect
- ZIO

### Error handling
- Exceptions vs functional errors
- Try / Success / Failure
- Validated & error accumulation

### Ecosystem & libraries
- Cats
- ZIO
- Akka / Pekko
- Play Framework
- http4s
- Spark (big data)
- Circe (JSON)
- Doobie (database)

### Tooling
- sbt tasks & plugins
- Mill build tool
- Scalafmt
- Scalafix
- Dependency management

### Testing
- ScalaTest
- munit
- ScalaCheck (property-based)
- Mockito for Scala

### Build & deploy
- Packaging & assembly (fat jars)
- Cross-compilation
- Scala.js
- Scala Native
- Publishing libraries

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a typed JSON REST API with http4s + Circe and run it on Cats Effect.
- Write a property-based-tested parser/calculator using pattern matching and ADTs.
- Process a dataset with Apache Spark, modeling the pipeline with case classes and for-comprehensions.
