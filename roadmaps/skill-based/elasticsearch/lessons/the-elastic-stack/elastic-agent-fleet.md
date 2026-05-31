---
title: Elastic Agent & Fleet
track: elasticsearch
group: The Elastic Stack
tags: [elasticsearch, elastic-agent]
prerequisites: [beats-filebeat-metricbeat]
see-also: [kibana, apm-observability, logstash]
---

# Elastic Agent & Fleet

Elastic Agent is a single unified collector that replaces multiple [[beats-filebeat-metricbeat|Beats]] on a host; Fleet is the Kibana-based control plane that configures and upgrades agents centrally.

## Why it matters

Running and configuring a separate Beat per data type on thousands of hosts is an operational tax — config drift, per-Beat upgrades, no central inventory. One Agent collects logs, metrics, and traces, and Fleet pushes policy and version bumps from a UI. This is the strategic direction of the stack; new integrations target Agent, not standalone Beats.

## How it works

Agents enroll into Fleet, pull a *policy* (a bundle of integrations), and run the right sub-processes under the hood. Data does not flow through Fleet Server — it manages config only.

```
Elastic Agent ──enroll──▶ Fleet Server ──policy──▶ Agent
Elastic Agent ──data────────────────────────────▶ Elasticsearch (or Logstash)
```

- **Integrations** — packaged inputs (nginx, AWS, Kubernetes) that bundle config, [[ingest-pipelines|ingest pipelines]], mappings, and dashboards; adding one to a policy reconfigures every agent on it.
- **Fleet Server** — a dedicated Agent instance that brokers enrollment and policy; agents poll it for changes (control plane only).
- **Agent policy** — assigned to a group of hosts; one edit rolls out to all, and Fleet shows each agent's health and applied version.
- **Under the hood** — Agent still runs Beat/Endpoint binaries internally, but you manage one thing, not many.

## Example

Onboard 500 hosts with nginx + system monitoring without touching any of them after enroll:

```
1. In Fleet, create policy "edge-web" → add integrations: nginx, system.
2. On each host: elastic-agent enroll --url https://fleet:8220 --enrollment-token <tok>
3. Later: add the "endpoint_security" integration to "edge-web".
   → all 500 agents pick it up on next policy poll; no SSH, no redeploy.
```

## Pitfalls

- **Fleet Server is a hard dependency for managed mode** — if it is down, *new* enrollment and policy changes stall (already-running agents keep shipping). Make it HA.
- **Mixing standalone and Fleet-managed** — an agent is one or the other; flipping modes means re-enroll, and standalone agents need YAML, not the UI.
- **Privileges** — Agent integrations like endpoint security need elevated host permissions; least-privilege is harder than a log-tailing Beat.
- **Migration overlap** — running old Beats *and* Agent for the same source double-ingests; cut over per source, don't run both.

## See also

- [[beats-filebeat-metricbeat]]
- [[kibana]]
