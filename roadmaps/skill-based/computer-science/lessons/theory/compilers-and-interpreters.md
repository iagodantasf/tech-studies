---
title: Compilers & interpreters
track: computer-science
group: Theory
tags: [cs, theory, compilers]
prerequisites: [automata-and-formal-languages, trees]
see-also: [stacks-and-queues, automata-and-formal-languages]
---

# Compilers & interpreters

A **compiler** translates source code into another language (often machine code) ahead of time, while an
**interpreter** executes it directly — but both share the same front-end pipeline of turning text into a
structured program.

## Why it matters

Every program you run passed through one of these. Understanding the pipeline demystifies error messages,
explains why some languages are faster than others, and is the core skill behind config parsers, query
engines, template languages, and DSLs — you will build "a little compiler" far more often than a big one.

## How it works

The classic front-to-back stages:

- **Lexing (scanning)** — split the character stream into tokens (`if`, `+`, `42`). Driven by finite
  automata, straight from [[automata-and-formal-languages|formal language theory]].
- **Parsing** — apply a context-free grammar to build an **abstract syntax tree** (`AST`), a
  [[trees|tree]] capturing structure. So `2 + 3 * 4` nests `*` below `+` to honor precedence.
- **Semantic analysis** — type checking, name/scope resolution, building symbol tables.
- **Optimization & code generation** — lower the `AST`/IR to target code (compiler) or **walk the tree
  and evaluate** it (tree-walking interpreter).

Expression evaluation leans on a [[stacks-and-queues|stack]]: shunting-yard converts infix to postfix,
and a stack machine then evaluates it. Many modern engines split the difference with **bytecode** — a
compiler emits a compact instruction set that a virtual machine interprets.

## Example

Evaluating the `AST` for `2 + 3 * 4` by recursive descent over the [[trees|tree]]:

```
eval(node):
    if node is number: return node.value
    l ← eval(node.left); r ← eval(node.right)
    if node.op == '+': return l + r
    if node.op == '*': return l * r
```

The tree shape `(+ 2 (* 3 4))` makes the result `14`, not `20` — structure encodes precedence.

## Pitfalls

- **Hand-parsing with string splitting** — ignoring precedence and nesting breaks on the first
  non-trivial input; build a real grammar and `AST`.
- **Mixing lexing and parsing concerns** — keep tokenization separate; conflating them yields tangled,
  unmaintainable code.
- **Left recursion in naive recursive-descent parsers** — a rule like `E -> E + T` loops forever; refactor
  or use a different parsing strategy.

## See also

- [[automata-and-formal-languages]]
- [[stacks-and-queues]]
