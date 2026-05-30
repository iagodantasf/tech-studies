---
title: Cloudflare
roadmap: cloudflare
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, cloudflare, cloud]
---

# Cloudflare

> roadmap.sh: https://roadmap.sh/cloudflare

Track for the **Cloudflare** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Fundamentals
- [ ] What is Cloudflare
- [ ] How Cloudflare's Network Works
- [ ] Anycast & the Global Edge Network
- [ ] Reverse Proxy Model
- [ ] Cloudflare Dashboard
- [ ] Cloudflare API
- [ ] Wrangler CLI
- [ ] Cloudflare Plans (Free / Pro / Business / Enterprise)

### DNS
- [ ] Adding a Site to Cloudflare
- [ ] DNS Records (A, AAAA, CNAME, MX, TXT)
- [ ] Proxied vs DNS-only Records
- [ ] CNAME Flattening
- [ ] DNSSEC
- [ ] Cloudflare Registrar
- [ ] Secondary DNS

### CDN & caching
- [ ] CDN Basics
- [ ] Caching Levels
- [ ] Cache Rules
- [ ] Cache Purge
- [ ] Tiered Cache & Argo Smart Routing
- [ ] Cache Reserve
- [ ] Bandwidth Alliance

### Performance
- [ ] Page Rules
- [ ] Auto Minify & Brotli
- [ ] Rocket Loader
- [ ] Polish & Mirage (Image Optimization)
- [ ] Cloudflare Images
- [ ] Stream (Video)
- [ ] Load Balancing
- [ ] Waiting Room

### Security
- [ ] SSL/TLS Modes
- [ ] Universal & Advanced Certificates
- [ ] Web Application Firewall (WAF)
- [ ] Managed & Custom Rules
- [ ] Rate Limiting
- [ ] DDoS Protection
- [ ] Bot Management
- [ ] Turnstile
- [ ] Firewall Rules / IP Access Rules
- [ ] Page Shield

### Zero Trust
- [ ] Cloudflare Zero Trust Overview
- [ ] Cloudflare Access
- [ ] Cloudflare Tunnel (cloudflared)
- [ ] Cloudflare Gateway
- [ ] WARP Client
- [ ] Identity Providers & Service Tokens

### Developer platform
- [ ] Cloudflare Workers
- [ ] Workers Runtime & Isolates
- [ ] Wrangler & Deployments
- [ ] Workers KV
- [ ] Durable Objects
- [ ] R2 (Object Storage)
- [ ] D1 (SQL Database)
- [ ] Queues
- [ ] Cloudflare Pages
- [ ] Pages Functions
- [ ] Workers AI
- [ ] Vectorize
- [ ] Hyperdrive

### Networking
- [ ] Magic Transit
- [ ] Magic WAN
- [ ] Spectrum
- [ ] Argo Tunnel
- [ ] China Network

### Observability & operations
- [ ] Analytics & Web Analytics
- [ ] Logpush & Logpull
- [ ] Health Checks
- [ ] Notifications
- [ ] Audit Logs
- [ ] Terraform Provider

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Move a domain onto Cloudflare end-to-end: set up DNS, enable full-strict SSL/TLS, add WAF managed rules, and tune cache rules for a static site.
- Build and deploy a full-stack app on the developer platform: a Workers API backed by D1 and R2, with the frontend on Cloudflare Pages.
- Secure an internal service with Zero Trust: expose it via Cloudflare Tunnel and gate access with Cloudflare Access policies tied to an identity provider.
