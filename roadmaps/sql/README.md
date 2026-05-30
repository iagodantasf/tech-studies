---
title: SQL
roadmap: sql
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, sql, databases]
---

# SQL

> roadmap.sh: https://roadmap.sh/sql

Track for the **SQL** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Fundamentals
- [ ] What are Relational Databases?
- [ ] RDBMS Benefits and Limitations
- [ ] SQL vs NoSQL Databases
- [ ] What is SQL?
- [ ] Tables, Rows and Columns
- [ ] Schemas and Catalogs
- [ ] Data Types
- [ ] Primary Keys
- [ ] Foreign Keys
- [ ] NULL Values

### Basic SQL Syntax
- [ ] SELECT Statement
- [ ] FROM Clause
- [ ] WHERE Clause
- [ ] Comparison and Logical Operators
- [ ] ORDER BY
- [ ] LIMIT / OFFSET / FETCH
- [ ] DISTINCT
- [ ] Aliases (AS)
- [ ] Comments

### Filtering Data
- [ ] LIKE and Wildcards
- [ ] IN Operator
- [ ] BETWEEN Operator
- [ ] IS NULL / IS NOT NULL
- [ ] AND / OR / NOT

### Data Definition (DDL)
- [ ] CREATE DATABASE
- [ ] CREATE TABLE
- [ ] ALTER TABLE
- [ ] DROP TABLE
- [ ] TRUNCATE TABLE
- [ ] Constraints (UNIQUE, CHECK, DEFAULT, NOT NULL)

### Data Manipulation (DML)
- [ ] INSERT INTO
- [ ] UPDATE
- [ ] DELETE
- [ ] UPSERT / MERGE

### Aggregate Functions
- [ ] COUNT
- [ ] SUM
- [ ] AVG
- [ ] MIN / MAX
- [ ] GROUP BY
- [ ] HAVING Clause

### Joins
- [ ] INNER JOIN
- [ ] LEFT JOIN
- [ ] RIGHT JOIN
- [ ] FULL OUTER JOIN
- [ ] CROSS JOIN
- [ ] SELF JOIN
- [ ] UNION / UNION ALL
- [ ] INTERSECT / EXCEPT

### Subqueries
- [ ] Scalar Subqueries
- [ ] Correlated Subqueries
- [ ] EXISTS / NOT EXISTS
- [ ] Subqueries in FROM (Derived Tables)
- [ ] Common Table Expressions (CTEs)
- [ ] Recursive CTEs

### Functions
- [ ] String Functions
- [ ] Numeric Functions
- [ ] Date and Time Functions
- [ ] CASE Expressions
- [ ] COALESCE / NULLIF
- [ ] CAST and Type Conversion

### Window Functions
- [ ] OVER Clause
- [ ] PARTITION BY
- [ ] ROW_NUMBER / RANK / DENSE_RANK
- [ ] LAG / LEAD
- [ ] Running Totals and Moving Averages

### Database Objects
- [ ] Views
- [ ] Materialized Views
- [ ] Indexes
- [ ] Stored Procedures
- [ ] Functions (User-Defined)
- [ ] Triggers
- [ ] Sequences

### Transactions
- [ ] BEGIN / COMMIT / ROLLBACK
- [ ] ACID Properties
- [ ] Savepoints
- [ ] Isolation Levels
- [ ] Locking and Concurrency

### Database Design
- [ ] Normalization (1NF, 2NF, 3NF, BCNF)
- [ ] Denormalization
- [ ] Entity-Relationship Modeling
- [ ] One-to-One / One-to-Many / Many-to-Many

### Performance & Security
- [ ] Query Execution Plans (EXPLAIN)
- [ ] Index Optimization
- [ ] Query Optimization Techniques
- [ ] SQL Injection and Prevention
- [ ] Privileges (GRANT / REVOKE)
- [ ] Roles and Access Control

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a normalized schema for an e-commerce store and write analytics queries (top customers, revenue by month, cohort retention) using CTEs and window functions.
- Create a reporting dashboard backed by views and materialized views over a sample dataset, then compare query plans with and without indexes.
- Write a data-cleaning pipeline in pure SQL: dedupe rows, standardize dates/strings, and validate referential integrity with constraint checks.
