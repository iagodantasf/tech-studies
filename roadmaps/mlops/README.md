---
title: MLOps
roadmap: mlops
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, mlops]
---

# MLOps

> roadmap.sh: https://roadmap.sh/mlops

Track for the **MLOps** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Foundations
- [ ] What is MLOps
- [ ] MLOps Principles
- [ ] MLOps Components

### Programming
- [ ] Programming Fundamentals
- [ ] Python
- [ ] Go
- [ ] Bash

### Version Control
- [ ] Version Control Systems
- [ ] Git
- [ ] GitHub
- [ ] GitLab

### Maths & ML Fundamentals
- [ ] Maths & Statistics
- [ ] Machine Learning Fundamentals
- [ ] Machine Learning
- [ ] Deep Learning

### ML Frameworks & Libraries
- [ ] scikit-learn
- [ ] TensorFlow
- [ ] PyTorch

### Data Engineering
- [ ] Data Engineering Fundamentals
- [ ] SQL
- [ ] Data Pipelines
- [ ] Data Ingestion Architecture
- [ ] Data Lakes & Warehouses
- [ ] Data Lineage
- [ ] Data Versioning (DVC)
- [ ] CML

### Data Processing & Streaming
- [ ] Spark
- [ ] Flink
- [ ] Kafka

### Experimentation & Tracking
- [ ] Experiment Tracking
- [ ] MLflow
- [ ] Model Evaluation

### Containerization
- [ ] Containerization
- [ ] Docker
- [ ] Kubernetes

### Cloud Computing
- [ ] Cloud Computing
- [ ] AWS / Azure / GCP
- [ ] Cloud Native ML Services

### Infrastructure as Code
- [ ] Infrastructure as Code
- [ ] Terraform
- [ ] Ansible

### CI/CD
- [ ] CI/CD
- [ ] GitHub Actions
- [ ] Jenkins

### Orchestration & Deployment
- [ ] Orchestration
- [ ] Orchestration & Deployment
- [ ] Airflow
- [ ] Kubeflow
- [ ] Model Training & Serving

### Monitoring & Observability
- [ ] Monitoring & Observability
- [ ] Prometheus
- [ ] Grafana

### Explainability
- [ ] Explainable AI
- [ ] SHAP
- [ ] LIME

### Edge AI
- [ ] Edge AI
- [ ] Jetson
- [ ] PyTorch Mobile
- [ ] TFLite

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build an end-to-end ML pipeline: ingest data with a Kafka/Spark stage, train a scikit-learn model, track runs in MLflow, and serve it behind a containerized API on Kubernetes.
- Set up a CI/CD workflow with GitHub Actions + DVC that retrains and redeploys a model on new data, gated by automated model-evaluation checks before promotion.
- Stand up a monitoring stack (Prometheus + Grafana) for a deployed model that tracks latency, request volume, and data/concept drift, with alerting that triggers retraining.
