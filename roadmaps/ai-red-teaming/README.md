---
title: AI Red Teaming
roadmap: ai-red-teaming
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, ai, security]
---

# AI Red Teaming

> roadmap.sh: https://roadmap.sh/ai-red-teaming

Track for the **AI Red Teaming** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Introduction
- [ ] Introduction
- [ ] Why Red Team AI Systems?
- [ ] Role of Red Teams
- [ ] AI Security Fundamentals
- [ ] Confidentiality, Integrity & Availability
- [ ] Ethical Considerations
- [ ] Responsible Disclosure

### Machine Learning Foundations
- [ ] Neural Networks
- [ ] Generative Models
- [ ] Large Language Models
- [ ] Supervised Learning
- [ ] Unsupervised Learning
- [ ] Reinforcement Learning

### Prompt Hacking
- [ ] Prompt Engineering
- [ ] Prompt Hacking
- [ ] Prompt Injection
- [ ] Direct (Prompt Injection)
- [ ] Indirect (Prompt Injection)
- [ ] Jailbreak Techniques
- [ ] Safety Filter Bypasses

### Model Vulnerabilities
- [ ] Model Vulnerabilities
- [ ] Adversarial Examples
- [ ] Data Poisoning
- [ ] Model Inversion
- [ ] Model Weight Stealing

### Infrastructure & Application Security
- [ ] Infrastructure Security
- [ ] API Protection
- [ ] Authentication
- [ ] Authorization
- [ ] Unauthorized Access
- [ ] Code Injection
- [ ] Insecure Deserialization
- [ ] Remote Code Execution

### Testing Methodologies
- [ ] LLM Security Testing
- [ ] Agentic AI Security
- [ ] Threat Modeling
- [ ] Vulnerability Assessment
- [ ] Risk Management
- [ ] White Box Testing
- [ ] Black Box Testing
- [ ] Grey Box Testing
- [ ] Automated vs Manual
- [ ] Continuous Testing
- [ ] Red Team Simulations

### Tooling
- [ ] Testing Platforms
- [ ] Custom Testing Scripts
- [ ] Reporting Tools
- [ ] Benchmark Datasets
- [ ] Monitoring Solutions
- [ ] Continuous Monitoring

### Defenses & Countermeasures
- [ ] Countermeasures
- [ ] Adversarial Training
- [ ] Robust Model Design
- [ ] Industry Standards

### Advanced & Emerging
- [ ] Advanced Techniques
- [ ] Emerging Threats
- [ ] Research Opportunities

### Learning & Community
- [ ] Specialized Courses
- [ ] Industry Credentials
- [ ] Lab Environments
- [ ] CTF Challenges
- [ ] Testing Platforms (Practice)
- [ ] Research Groups
- [ ] Conferences
- [ ] Forums

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a prompt-injection test harness that runs a battery of jailbreak payloads against a local LLM endpoint and scores how many bypass its safety filter.
- Recreate an OWASP LLM Top 10 vulnerable chatbot, then write an automated red-team script that detects each weakness and produces a findings report.
- Set up a CTF-style lab with a deliberately leaky RAG pipeline and document an end-to-end attack chain from indirect prompt injection to data exfiltration.
