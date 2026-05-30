---
title: DevSecOps
track: devsecops
category: Role-based
tags: [roadmap, devsecops, security]
---

# DevSecOps

> roadmap.sh: https://roadmap.sh/devsecops

Suggested path through the **DevSecOps** nodes. Each node links to its lesson when written.

## Nodes

### Foundations
- Introduction
- DevSecOps vs DevOps
- CIA Triad
- Defense in Depth Concepts
- Least Privilege
- Zero Trust

### Programming & Scripting
- Learn a Programming Language
- Python
- Go
- Rust
- Ruby
- JavaScript / Node.js
- Scripting Knowledge
- Bash
- PowerShell

### Networking
- Networking Basics
- DNS
- HTTP
- Firewalls
- Network Segmentation
- Secure Network Zoning

### Identity & Access Management
- Identity Basics
- IAM
- Authentication
- Authorization
- Role-Based Access
- Role-Based Access Control (RBAC)
- ACLs
- Large-Scale Identity Strategy

### Cryptography & PKI
- Encryption
- Symmetric Encryption
- Asymmetric Encryption
- Cryptographic Hashing
- SHA-256
- bcrypt
- SSL / TLS
- TLS
- Certificate Lifecycle
- Key Management Service (KMS)
- PKI Design and Failover

### Threat Modeling
- Threat Modeling
- STRIDE
- PASTA
- Attack Surface Mapping
- Risk Quantification

### Application Security
- Secure Coding
- OWASP Top 10
- Input Validation Patterns
- SQL Injection
- Web Application Security
- Secure API Design
- Dependency Risk Management
- SBOMs

### CI/CD & Pipeline Security
- Build Pipeline Hardening
- Image Scanning
- Automated Patching

### Container & Cloud Security
- Docker
- Kubernetes
- Container Security
- Cloud Security
- CSPM
- Multi-Region Security Planning

### Vulnerability Assessment Tools
- Vulnerability Assessment
- Nmap
- Nmap Basics
- Nessus
- OpenVAS
- Qualys
- Burp Suite
- Wireshark

### Monitoring & Detection
- Monitoring
- Log Analysis
- Alert Types
- SIEM
- IDS
- IPS
- Endpoint Detection
- EDR Strategy
- DDoS Mitigation Strategy

### Incident Response & Forensics
- Incident Response
- IR Lifecycle
- Containment
- Response Strategy
- Root Cause Analysis
- Forensics
- SOAR Concepts
- SOAR Automation

### Governance, Risk & Compliance
- Audit & Compliance Mapping
- ISO 27001
- NIST
- SOC 2
- Enterprise Operations

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a hardened CI/CD pipeline (GitHub Actions or GitLab CI) with SAST, dependency scanning (Trivy/Grype), secret scanning, and SBOM generation gating every merge.
- Stand up a self-hosted security monitoring lab: ship container/app logs to a SIEM (Wazuh or Elastic), write detection rules, and trigger a SOAR-style automated response to a simulated intrusion.
- Create a "secure-by-default" Kubernetes deployment kit with image scanning, admission policies (OPA/Kyverno), network policies, and runtime CSPM checks, then document the threat model behind each control.
