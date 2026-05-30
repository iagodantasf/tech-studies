---
title: Docker
track: docker
category: Skill-based
tags: [roadmap, docker, devops]
---

# Docker

> roadmap.sh: https://roadmap.sh/docker

Suggested path through the **Docker** nodes. Each node links to its lesson when written.

## Nodes

### Foundations
- What are containers
- Need for containerization
- Bare metal vs VMs vs containers
- Docker vs other container engines
- The underlying technologies
- Namespaces
- cgroups
- Union filesystems

### Installation & setup
- Installing Docker
- Docker Desktop
- Docker Engine
- Understanding the Docker ecosystem

### Docker fundamentals
- Docker architecture
- Docker daemon
- Docker client (CLI)
- Docker registries
- Images vs containers

### Working with images
- Pulling images
- Finding images on Docker Hub
- Image tags and versions
- Inspecting images
- Image layers
- Listing and removing images

### Building images
- Writing a Dockerfile
- Dockerfile instructions (FROM, RUN, CMD, ENTRYPOINT)
- COPY vs ADD
- ENV and ARG
- WORKDIR, EXPOSE, VOLUME
- Build context and .dockerignore
- Multi-stage builds
- BuildKit
- Layer caching and build optimization
- Image size optimization

### Running containers
- docker run and its flags
- Container lifecycle (start, stop, restart, rm)
- Detached vs foreground mode
- Naming containers
- Interactive containers and exec
- Viewing logs
- Inspecting containers
- Restart policies
- Resource limits (CPU, memory)

### Data persistence
- Ephemeral container filesystem
- Volumes
- Bind mounts
- tmpfs mounts
- Managing volumes

### Networking
- Container networking basics
- Bridge network
- Host network
- None network
- Overlay network
- Port mapping and publishing
- DNS and service discovery
- Custom networks

### Docker Compose
- What is Docker Compose
- compose.yaml structure
- Defining services
- Networks and volumes in Compose
- Environment variables and .env
- Depends_on and healthchecks
- Compose profiles
- Scaling services

### Registries & distribution
- Docker Hub
- Pushing images
- Private registries
- Self-hosted registry
- Tagging strategy
- Image signing

### Security
- Running as non-root user
- Least privilege and capabilities
- Image vulnerability scanning
- Secrets management
- Read-only filesystems
- Image provenance and trust
- Resource isolation

### Best practices & production
- Dockerfile best practices
- Healthchecks
- Logging drivers
- Monitoring containers
- Container orchestration (overview)
- Docker Swarm
- CI/CD with Docker
- Developer experience and dev containers

## Resources
See [resources.md](./resources.md).

## Project ideas
- Containerize a multi-service web app (frontend, API, Postgres) with a single Docker Compose file and a one-command `compose up` dev setup.
- Write an optimized multi-stage Dockerfile for a compiled-language service, then measure and shrink the final image size below 50 MB.
- Build a CI pipeline that lints the Dockerfile, scans the image for vulnerabilities, and pushes a tagged image to a private registry on each commit.
