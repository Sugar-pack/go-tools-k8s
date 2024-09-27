# Minikube Deployment Guide

This guide provides step-by-step instructions to deploy a Go application to a local Kubernetes cluster
using Minikube with 3 replicas and access the pprof/debug server of one of the pods.

## Prerequisites

- Install [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- Docker installed and running locally
- Install [Go](https://golang.org/doc/install)

## Steps

### 1. Start Minikube

Start Minikube with the following command:

```bash
minikube start
```

### 2. Build the Docker Image

Use Minikube's Docker environment to build the image:

```bash
eval $(minikube docker-env)
docker build -t go-app:latest .
```

### 3. Deploy the Application

Apply the deployment and service configuration files:

```bash
kubectl apply -f deployment.yml
kubectl apply -f service.yml
```

### 4. Verify the Deployment

Check the status of the deployment:

```bash
kubectl get deployments
```

### 5. Choose pod to inspect (3 replicas, so you can choose any pod)

To list all pods:

```bash
kubectl get pods
```

### 6. Access the pprof server

Pprof server is running on port 6060

```bash
kubectl port-forward <pod-name> 6060:6060
```

and then access the pprof server on `localhost:6060/debug/pprof/`

### 7. Access the debug server

Debug server is running on port 40000

```bash
kubectl port-forward <pod-name> 40000:40000
```

Access to debug server depends on ide/editor that you use.
