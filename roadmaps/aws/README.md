---
title: AWS
roadmap: aws
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, aws, cloud]
---

# AWS

> roadmap.sh: https://roadmap.sh/aws

Track for the **AWS** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Cloud & AWS fundamentals
- [ ] What is Cloud Computing
- [ ] IaaS vs PaaS vs SaaS
- [ ] AWS Global Infrastructure
- [ ] Regions, Availability Zones & Edge Locations
- [ ] AWS Management Console
- [ ] AWS CLI
- [ ] AWS SDKs
- [ ] AWS Free Tier
- [ ] Shared Responsibility Model

### Identity & access (IAM)
- [ ] IAM Users
- [ ] IAM Groups
- [ ] IAM Roles
- [ ] IAM Policies
- [ ] Permission Boundaries
- [ ] AWS Organizations & SCPs
- [ ] AWS IAM Identity Center (SSO)
- [ ] AWS STS & Temporary Credentials
- [ ] MFA

### Compute
- [ ] EC2 Instances
- [ ] EC2 Instance Types
- [ ] AMIs
- [ ] Security Groups
- [ ] Key Pairs
- [ ] Elastic Load Balancing (ALB / NLB)
- [ ] Auto Scaling Groups
- [ ] AWS Lambda
- [ ] Elastic Beanstalk
- [ ] AWS Batch
- [ ] EC2 Spot, Reserved & Savings Plans

### Containers
- [ ] Amazon ECR
- [ ] Amazon ECS
- [ ] AWS Fargate
- [ ] Amazon EKS
- [ ] AWS App Runner

### Storage
- [ ] Amazon S3
- [ ] S3 Storage Classes
- [ ] S3 Lifecycle Policies
- [ ] Amazon EBS
- [ ] Amazon EFS
- [ ] Amazon FSx
- [ ] AWS Storage Gateway
- [ ] AWS Backup

### Networking & content delivery
- [ ] Amazon VPC
- [ ] Subnets (Public / Private)
- [ ] Route Tables
- [ ] Internet Gateway & NAT Gateway
- [ ] VPC Peering
- [ ] AWS Transit Gateway
- [ ] AWS PrivateLink & VPC Endpoints
- [ ] Amazon Route 53
- [ ] Amazon CloudFront
- [ ] AWS Direct Connect
- [ ] Site-to-Site VPN

### Databases
- [ ] Amazon RDS
- [ ] Amazon Aurora
- [ ] Amazon DynamoDB
- [ ] Amazon ElastiCache
- [ ] Amazon Redshift
- [ ] Amazon Neptune
- [ ] Amazon DocumentDB

### Messaging & integration
- [ ] Amazon SQS
- [ ] Amazon SNS
- [ ] Amazon EventBridge
- [ ] AWS Step Functions
- [ ] Amazon API Gateway
- [ ] Amazon MQ
- [ ] Amazon Kinesis

### Observability & management
- [ ] Amazon CloudWatch
- [ ] AWS CloudTrail
- [ ] AWS Config
- [ ] AWS Systems Manager
- [ ] AWS Health Dashboard
- [ ] AWS Trusted Advisor

### Security, identity & compliance
- [ ] AWS KMS
- [ ] AWS Secrets Manager
- [ ] AWS Certificate Manager
- [ ] AWS WAF & Shield
- [ ] Amazon GuardDuty
- [ ] AWS Security Hub
- [ ] Amazon Inspector

### Infrastructure as Code & deployment
- [ ] AWS CloudFormation
- [ ] AWS CDK
- [ ] AWS SAM
- [ ] AWS CodeCommit
- [ ] AWS CodeBuild
- [ ] AWS CodeDeploy
- [ ] AWS CodePipeline

### Cost & operations
- [ ] AWS Billing & Cost Management
- [ ] AWS Cost Explorer
- [ ] AWS Budgets
- [ ] Tagging Strategy
- [ ] Well-Architected Framework

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a 3-tier web app on a custom VPC: ALB + Auto Scaling EC2 + RDS Multi-AZ, all provisioned with CloudFormation or CDK.
- Ship a fully serverless REST API with API Gateway, Lambda, and DynamoDB, fronted by CloudFront and secured with IAM and WAF.
- Set up a cost-governance baseline for a multi-account AWS Organization: SCPs, consolidated billing, Budgets alerts, and tag-based Cost Explorer reports.
