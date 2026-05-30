---
title: DevOps
track: devops
category: Role-based
tags: [roadmap, devops]
---

# DevOps

> roadmap.sh: https://roadmap.sh/devops

Suggested path through the **DevOps** nodes. Each node links to its lesson when written.

## Nodes

### Programming language
- Learn a programming language
- Python
- Go
- Rust
- Ruby
- JavaScript / Node.js
- PHP

### Operating systems
- OS concepts
- Ubuntu
- SLES
- Debian / RHEL / CentOS
- Windows
- FreeBSD
- OpenBSD
- NetBSD
- Solaris

### OS / terminal skills
- Bash scripting
- Vim
- Tmux
- Process monitoring
- Performance monitoring
- Networking tools
- Text manipulation
- System startup & service management

### Networking & protocols
- HTTP
- HTTPS
- SSL / TLS
- DNS
- FTP / SFTP
- SSH
- SMTP
- IMAP
- DMARC
- Domain keys
- SNMP
- White / grey listing
- Firewall

### Web servers
- Nginx
- Apache
- Caddy
- IIS
- Tomcat
- Forward proxy
- Reverse proxy
- Caching server
- Load balancer
- Firewall

### Version control systems
- Git
- GitHub
- GitLab
- Bitbucket

### Containers
- Containers
- Docker
- LXC
- Podman

### Container orchestration
- Container orchestration
- Kubernetes
- Docker Swarm
- Nomad
- AWS ECS / Fargate
- GKE / EKS / AKS

### Infrastructure as Code
- Infrastructure provisioning
- Terraform
- AWS CDK
- CloudFormation
- Configuration management
- Ansible
- Chef
- Puppet
- SaltStack

### CI / CD
- CI / CD tools
- Jenkins
- GitHub Actions
- GitLab CI
- CircleCI
- GitOps
- ArgoCD
- FluxCD

### Cloud providers
- Cloud providers
- AWS
- Azure
- Google Cloud
- Digital Ocean
- Heroku
- Alibaba Cloud
- Cloudflare
- Hetzner
- Contabo
- Vultr
- OpenStack
- VMware

### Serverless
- AWS Lambda
- Azure Functions
- GCP Functions
- Vercel
- Netlify

### Service mesh & discovery
- Service mesh
- Istio
- Envoy
- Linkerd
- Consul

### Secrets management
- Secrets management
- Vault
- Cloud-specific tools
- External Secrets Operator (ESO)

### Artifact management
- Artifact management
- Artifactory
- Cloudsmith

### GitOps & cloud design
- Cloud design patterns
- Availability
- Data management
- Design and implementation
- Management and monitoring

### Observability & monitoring
- Observability
- Infrastructure monitoring
- Prometheus
- Grafana
- Datadog
- Dynatrace
- Sysdig
- Application monitoring
- Sentry
- PagerDuty
- Logs management
- Elastic Stack
- Graylog
- Loki
- Splunk
- Uptime Kuma
- OpenTelemetry
- Jaeger

### Databases & data stores
- Postgres
- Redis
- RabbitMQ
- ZooKeeper

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a full CI/CD pipeline that lints, tests, builds a Docker image, pushes it to a registry, and deploys to a Kubernetes cluster via GitOps (ArgoCD) on every merge to main.
- Provision a reproducible cloud environment from scratch with Terraform (VPC, load balancer, autoscaling group, managed DB) and configure the hosts with Ansible.
- Stand up a complete observability stack (Prometheus + Grafana + Loki + OpenTelemetry) for a sample microservice app, with alerting rules and a dashboard that surfaces the four golden signals.
