---
title: Networking
track: computer-science
group: Systems
tags: [cs, systems, networking]
prerequisites: [operating-systems]
see-also: [graphs, databases]
---

# Networking

Networking is how independent machines exchange bytes reliably across an unreliable medium, organized
into **layers** so each solves one problem and hands off to the next.

## Why it matters

Almost every program you ship talks to something over a network, and the abstractions leak: a slow
page load might be DNS, a TCP handshake, TLS, or the server itself. Knowing which layer owns which
problem turns "the internet is broken" into a diagnosable, fixable fault.

## How it works

The **OSI model** is the seven-layer reference; the **TCP/IP** stack is the four-layer model the
internet actually runs on:

| TCP/IP layer | Job | Examples |
|---|---|---|
| Application | App protocols | HTTP, DNS |
| Transport | End-to-end delivery | TCP, UDP |
| Internet | Routing between networks | IP |
| Link | One physical hop | Ethernet, Wi-Fi |

The internet is a [[graphs|graph]] of routers; **IP** moves packets hop-by-hop toward an address with
no delivery guarantee. **TCP** layers reliability on top: a **three-way handshake** (`SYN`,
`SYN-ACK`, `ACK`), sequence numbers, acknowledgements, retransmission, and flow/congestion control.
**UDP** skips all of that — fire-and-forget, lower latency, used for DNS, games, and video.

**DNS** resolves a name like `example.com` into an IP address, walking from root to TLD to
authoritative servers, with caching at every level. **HTTP** is the request/response application
protocol on top of TCP; `HTTPS` wraps it in **TLS** for encryption and authentication. HTTP is
**stateless**, so sessions are reconstructed with cookies or tokens.

## Example

```
# What a browser does for https://example.com
1. DNS:  example.com        → 93.184.x.x      (UDP query, often cached)
2. TCP:  SYN → SYN-ACK → ACK                  (connect to port 443)
3. TLS:  negotiate keys, verify certificate
4. HTTP: GET / HTTP/1.1  →  200 OK + body
```

Each step is a different layer, and each can fail independently — which is exactly why isolating the
failing one matters.

## Pitfalls

- **Confusing latency with bandwidth** — a fat pipe doesn't help a chatty protocol doing many
  round-trips; batch requests instead.
- **Ignoring DNS/TLS caching and reuse** — re-resolving and re-handshaking per request adds round
  trips; keep connections alive.
- **Assuming TCP delivers messages** — it's a byte *stream*; you must frame your own message
  boundaries on top.

## See also

- [[graphs]]
- [[databases]]
