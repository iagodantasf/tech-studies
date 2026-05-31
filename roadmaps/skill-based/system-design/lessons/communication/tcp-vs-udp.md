---
title: TCP vs UDP
track: system-design
group: Communication
tags: [system-design, transport-protocols]
prerequisites: [networking]
see-also: [http, rpc-grpc]
---

# TCP vs UDP

TCP and UDP are the two core transport-layer protocols: TCP gives you a reliable, ordered byte stream; UDP gives you cheap, fire-and-forget datagrams.

## Why it matters

The choice dictates whether the network guarantees delivery for you or hands that job to your application. Pick TCP and you inherit connection setup, retransmission, and head-of-line blocking; pick UDP and you trade those guarantees for the lowest possible latency and full control. Almost every higher-level protocol — [[http]], DNS, gRPC, video — is really a decision about which of these two it rides on, and why.

## How it works

Both sit on top of IP and use 16-bit ports to multiplex flows to processes. The difference is what TCP adds on top:

| Property | TCP | UDP |
|---|---|---|
| Connection | Handshake (3-way) | Connectionless |
| Delivery | Guaranteed, retransmits | Best-effort, may drop |
| Ordering | In-order | None |
| Flow/congestion control | Yes | No |
| Header overhead | 20+ bytes | 8 bytes |

- **TCP** opens with a SYN / SYN-ACK / ACK handshake, then numbers every byte so it can detect loss, retransmit, and reassemble in order. **Flow control** (receiver window) stops a fast sender from drowning a slow receiver; **congestion control** (slow start, AIMD) backs off when the network drops packets.
- **UDP** just stamps a source/dest port and a checksum and sends. No handshake, no state, no reordering — if a datagram is lost the application either ignores it or recovers itself.
- A key TCP cost is **head-of-line blocking**: one lost segment stalls every later byte until it is retransmitted, even bytes that already arrived.

## Example

Two ways to fetch the same 3 small records:

```
TCP:  SYN ->            (1 RTT just to connect)
      <- SYN-ACK
      ACK + request ->
      <- record 1,2,3   (ordered, guaranteed)
      packet 2 lost -> stall until retransmit, THEN deliver 3

UDP:  req1,req2,req3 ->  (0 setup, sent immediately)
      <- rec1, rec3     (rec2 dropped; app reissues only req2)
```

For a DNS lookup or a game position update, the UDP path's lower latency and per-message independence win; for a file download, TCP's guarantees are non-negotiable.

## Pitfalls

- **Reaching for UDP to "go faster" without a recovery plan.** You now own loss, ordering, and congestion — that is a lot of TCP to reinvent, usually badly.
- **Ignoring handshake/TLS RTTs at scale.** Short-lived TCP+TLS connections spend most of their life in setup; reuse connections or use connection pools.
- **Assuming UDP datagrams arrive whole and once.** They can be dropped, duplicated, or reordered; large ones fragment and become more fragile.
- **Forgetting head-of-line blocking.** Multiplexing many independent streams over one TCP connection (HTTP/2) means one lost packet stalls all of them — the problem HTTP/3 over QUIC/UDP exists to solve.

## See also

- [[http]]
- [[rpc-grpc]]
