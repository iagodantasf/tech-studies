---
title: API Security
roadmap: api-security
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, api, security]
---

# API Security

> roadmap.sh: https://roadmap.sh/best-practices/api-security

Track for the **API Security** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Authentication
- [ ] Use a Standard Auth Framework (don't roll your own)
- [ ] No Basic Auth (use standard tokens)
- [ ] Token-Based Authentication
- [ ] JWT (use proven libraries)
- [ ] Validate JWT Signature & Algorithm (avoid `alg: none`)
- [ ] Set Short Token Expiry (`exp`, `nbf`, `iat`)
- [ ] Max Retry & Account Lockout on Login
- [ ] Encrypt Sensitive Data at Rest
- [ ] OAuth 2.0 / OpenID Connect

### Authorization
- [ ] Enforce Authorization on Every Request
- [ ] BOLA / IDOR Prevention (object-level checks)
- [ ] Role-Based Access Control (RBAC)
- [ ] Principle of Least Privilege
- [ ] Function-Level Authorization Checks

### Access & Transport
- [ ] Use HTTPS / TLS Everywhere
- [ ] HSTS (Strict-Transport-Security)
- [ ] Limit Allowed HTTP Methods per Route
- [ ] Reject Non-Whitelisted Methods (405)
- [ ] Restrictive CORS Policy
- [ ] Rate Limiting & Throttling
- [ ] Use API Keys for Public/Anonymous Access

### Input Validation & Processing
- [ ] Validate All Input (allow-list)
- [ ] Use the Right HTTP Method per Operation
- [ ] Validate `Content-Type` on Requests
- [ ] Set Correct `Content-Type` on Responses
- [ ] Validate User Input to Avoid Injection
- [ ] Avoid Sensitive Data in URLs / Query Strings
- [ ] Validate Redirect URLs (open-redirect)
- [ ] Limit Payload / Request Body Size
- [ ] Mass Assignment Protection
- [ ] Use Parameterized Queries (no string concat)

### Output & Data Handling
- [ ] Don't Leak Stack Traces or Internal Errors
- [ ] Return Generic Error Messages
- [ ] Use Appropriate HTTP Status Codes
- [ ] Strip / Mask Sensitive Fields in Responses
- [ ] Security Headers (CSP, X-Content-Type-Options, X-Frame-Options)
- [ ] Remove Fingerprinting Headers (`X-Powered-By`)

### Processing & Architecture
- [ ] Authenticate Before Processing
- [ ] Disable Endpoints Not in Use
- [ ] Avoid Sensitive Data in Logs
- [ ] Use Non-Executable Storage for Uploads
- [ ] Run Workers / Services with Least Privilege
- [ ] Use an API Gateway / Management Layer

### CI/CD & Operations
- [ ] Audit & Review Design and Code
- [ ] Continuous Security Testing (SAST/DAST)
- [ ] Scan Dependencies for Vulnerabilities
- [ ] Carry Out Security Checks in CI/CD
- [ ] Centralized & Continuous Logging
- [ ] Monitoring, Alerting & Anomaly Detection

### Standards & References
- [ ] OWASP API Security Top 10
- [ ] OWASP ASVS
- [ ] Threat Modeling APIs

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Take a small REST API and harden it end to end against the OWASP API Security Top 10, documenting each fix.
- Build a reusable middleware bundle (rate limiting, security headers, input validation, JWT verification) for your framework of choice.
- Run a SAST/DAST scan (e.g. OWASP ZAP) against a deliberately vulnerable API and write up each finding with its remediation.
