---
title: Kubernetes
track: kubernetes
category: Skill-based
tags: [roadmap, kubernetes, devops]
---

# Kubernetes

> roadmap.sh: https://roadmap.sh/kubernetes

Suggested path through the **Kubernetes** nodes. Each node links to its lesson when written.

## Nodes

### Foundations
- What is Kubernetes
- Why Kubernetes / problems it solves
- Containers and container orchestration
- Kubernetes vs Docker Swarm vs Nomad
- Declarative vs imperative
- Desired state and reconciliation
- Cluster concepts overview

### Architecture
- Control plane vs worker nodes
- kube-apiserver
- etcd
- kube-scheduler
- kube-controller-manager
- cloud-controller-manager
- kubelet
- kube-proxy
- Container runtime (containerd / CRI-O)
- Add-ons (DNS, dashboard, metrics)

### Setup & distributions
- kubectl
- Minikube
- kind
- k3s / k3d
- kubeadm
- Managed Kubernetes (EKS, GKE, AKS)
- kubeconfig and contexts

### Core objects — workloads
- Pods
- Multi-container pods and sidecars
- ReplicaSets
- Deployments
- Rolling updates and rollbacks
- StatefulSets
- DaemonSets
- Jobs
- CronJobs
- Init containers

### Configuration
- Labels and selectors
- Annotations
- Namespaces
- ConfigMaps
- Secrets
- Environment variables
- Resource requests and limits
- Probes (liveness, readiness, startup)

### Networking
- Kubernetes networking model
- Services (ClusterIP, NodePort, LoadBalancer)
- Headless services
- Service discovery and DNS
- Ingress
- Ingress controllers
- Gateway API
- Network policies
- CNI plugins (Calico, Cilium, Flannel)

### Storage
- Volumes
- PersistentVolumes
- PersistentVolumeClaims
- StorageClasses
- Dynamic provisioning
- CSI drivers
- Volume access modes

### Scheduling
- How the scheduler works
- Node selectors
- Affinity and anti-affinity
- Taints and tolerations
- Topology spread constraints
- Pod priority and preemption
- Resource quotas and LimitRanges

### Security
- Authentication
- Authorization and RBAC
- Service accounts
- Admission controllers
- Pod security standards / admission
- Security contexts
- Secrets encryption at rest
- Image and supply-chain security

### Scaling & availability
- Horizontal Pod Autoscaler
- Vertical Pod Autoscaler
- Cluster Autoscaler
- Pod Disruption Budgets
- Self-healing and reconciliation
- High-availability control plane

### Observability & operations
- kubectl logs and exec
- Events
- Metrics Server
- Prometheus and Grafana
- Logging (Loki, EFK stack)
- Tracing
- Debugging pods and nodes

### Extending & ecosystem
- Custom Resource Definitions (CRDs)
- Operators and the operator pattern
- Helm
- Kustomize
- GitOps (Argo CD, Flux)
- Service meshes (Istio, Linkerd)
- Cluster upgrades and lifecycle

## Resources
See [resources.md](./resources.md).

## Project ideas
- Stand up a local kind cluster and deploy a 3-tier app with Deployments, a Service, an Ingress, and a Postgres StatefulSet backed by a PersistentVolumeClaim.
- Package an application as a Helm chart with configurable values, then set up Argo CD to deploy it from a Git repo via GitOps.
- Configure Horizontal Pod Autoscaling on a CPU-bound workload, load-test it, and dashboard the scaling behavior in Prometheus + Grafana.
