---
title: AI and Data Scientist
track: ai-data-scientist
category: Role-based
tags: [roadmap, ai, data-science]
---

# AI and Data Scientist

> roadmap.sh: https://roadmap.sh/ai-data-scientist

Suggested path through the **AI and Data Scientist** nodes. Each node links to its lesson when written.

## Nodes

### Mathematics
- Linear algebra
- Vectors and matrices
- Matrix operations and decompositions
- Calculus
- Derivatives and gradients
- Partial derivatives
- Optimization basics
- Gradient descent
- Discrete mathematics

### Statistics
- Descriptive statistics
- Probability theory
- Random variables
- Probability distributions
- Bayes' theorem
- Inferential statistics
- Hypothesis testing
- Confidence intervals
- p-values and significance
- A/B testing
- Bayesian statistics

### Econometrics
- Regression analysis
- Linear regression
- Time series analysis
- Causal inference
- Endogeneity and instrumental variables

### Coding
- Python
- NumPy
- Pandas
- SQL
- Data structures and algorithms
- Jupyter notebooks
- Git and version control
- APIs and web scraping
- R (optional)

### Exploratory Data Analysis
- Data collection
- Data cleaning
- Handling missing data
- Outlier detection
- Feature engineering
- Data transformation and scaling
- Data visualization
- Matplotlib and Seaborn
- Correlation analysis
- Dimensionality reduction (PCA, t-SNE)

### Machine Learning
- Supervised learning
- Unsupervised learning
- Linear and logistic regression
- Decision trees
- Random forests
- Gradient boosting (XGBoost, LightGBM)
- Support vector machines
- k-Nearest Neighbors
- Naive Bayes
- Clustering (k-means, hierarchical, DBSCAN)
- Model evaluation metrics
- Cross-validation
- Bias-variance tradeoff
- Regularization
- Hyperparameter tuning
- Feature selection
- scikit-learn
- Imbalanced data handling
- Ensemble methods

### Deep Learning
- Neural networks
- Backpropagation
- Activation functions
- Loss functions and optimizers
- Convolutional Neural Networks (CNNs)
- Recurrent Neural Networks (RNNs)
- LSTMs and GRUs
- Transformers
- Attention mechanism
- Transfer learning
- Generative models (GANs, VAEs)
- Large Language Models
- TensorFlow
- PyTorch
- Natural Language Processing
- Computer Vision

### MLOps
- Model deployment
- Model serving (REST, batch)
- Containerization (Docker)
- CI/CD for ML
- Model monitoring
- Data and model drift
- Experiment tracking (MLflow, Weights & Biases)
- Feature stores
- Model registry
- Workflow orchestration (Airflow, Kubeflow)
- Cloud platforms (AWS, GCP, Azure)
- Reproducibility and versioning

## Resources
See [resources.md](./resources.md).

## Project ideas
- Train and compare several classifiers (logistic regression, random forest, XGBoost) on a real tabular dataset with proper cross-validation, then track every run in MLflow.
- Build an end-to-end NLP pipeline that fine-tunes a transformer for text classification in PyTorch and serves it behind a containerized REST API.
- Run an A/B test analysis from scratch: simulate or load experiment data, check assumptions, compute significance and confidence intervals, and write up the causal conclusion.
