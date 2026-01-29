# Todo Chatbot Helm Chart

Helm chart for deploying the AI-powered Todo Chatbot application to Kubernetes.

## Overview

This chart deploys:
- **Frontend**: Next.js 14 application (2 replicas by default)
- **Backend**: FastAPI application (1 replica by default)
- **ConfigMap**: Non-sensitive configuration
- **Secret**: Sensitive credentials (database, API keys)

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- Local Docker images built:
  - `todo-frontend:1.0.0`
  - `todo-backend:1.0.0`

## Installation

### 1. Prepare Configuration

Copy the example values file and fill in your secrets:

```bash
cp values-local.yaml.example values-local.yaml
# Edit values-local.yaml with your actual credentials
```

⚠️ **IMPORTANT**: Never commit `values-local.yaml` to version control!

### 2. Create Namespace

```bash
kubectl create namespace todo-app
```

### 3. Load Images into Minikube

If using Minikube:

```bash
minikube image load todo-frontend:1.0.0
minikube image load todo-backend:1.0.0
```

### 4. Install the Chart

```bash
helm install todo-chatbot . -n todo-app -f values-local.yaml
```

## Accessing the Application

After installation, the application is accessible via NodePort:

- **Frontend**: http://localhost:30080
- **Backend API**: http://localhost:30800
- **Backend Docs**: http://localhost:30800/docs
- **Health Check**: http://localhost:30800/health

## Configuration

### Key Values

| Parameter | Description | Default |
|-----------|-------------|---------|
| `frontend.replicaCount` | Number of frontend replicas | `2` |
| `backend.replicaCount` | Number of backend replicas | `1` |
| `frontend.service.nodePort` | Frontend NodePort | `30080` |
| `backend.service.nodePort` | Backend NodePort | `30800` |
| `config.environment` | Environment name | `development` |
| `config.logLevel` | Logging level | `INFO` |

### Secrets

Required secrets (configure in `values-local.yaml`):

- `databaseUrl`: PostgreSQL connection string
- `openaiApiKey`: OpenAI API key for AI features
- `betterAuthSecret`: Authentication secret
- `jwtSecret`: JWT signing secret

Optional:
- `anthropicApiKey`: Anthropic API key (if using Claude)

## Upgrading

To upgrade the deployment with new values:

```bash
helm upgrade todo-chatbot . -n todo-app -f values-local.yaml
```

To modify configuration (e.g., increase replicas):

```bash
# Edit values-local.yaml
helm upgrade todo-chatbot . -n todo-app -f values-local.yaml
```

## Rollback

To rollback to the previous release:

```bash
helm rollback todo-chatbot -n todo-app
```

To rollback to a specific revision:

```bash
# List revisions
helm history todo-chatbot -n todo-app

# Rollback to specific revision
helm rollback todo-chatbot <revision> -n todo-app
```

## Uninstalling

To remove the deployment:

```bash
helm uninstall todo-chatbot -n todo-app
```

To also delete the namespace:

```bash
kubectl delete namespace todo-app
```

## Troubleshooting

### Check Pod Status

```bash
kubectl get pods -n todo-app
kubectl describe pod <pod-name> -n todo-app
```

### View Logs

```bash
# Frontend logs
kubectl logs -f -n todo-app -l app=frontend

# Backend logs
kubectl logs -f -n todo-app -l app=backend
```

### Check Events

```bash
kubectl get events -n todo-app --sort-by='.lastTimestamp'
```

### Common Issues

**Pods in CrashLoopBackOff**:
- Check if secrets are properly configured
- Verify database is accessible
- Check logs: `kubectl logs <pod-name> -n todo-app`

**ImagePullBackOff**:
- Ensure images are loaded into Minikube: `minikube image load <image>`
- Check image names match: `minikube image ls | grep todo`

**Service not accessible**:
- Verify Minikube is running: `minikube status`
- Check service: `kubectl get svc -n todo-app`
- Try port-forward: `kubectl port-forward svc/<service-name> 8080:8000 -n todo-app`

## Development

### Testing Template Rendering

```bash
helm template todo-chatbot . -f values-local.yaml
```

### Linting

```bash
helm lint .
```

### Dry Run

```bash
helm install todo-chatbot . --dry-run --debug -n todo-app -f values-local.yaml
```

## Chart Structure

```
todo-chatbot/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default values
├── values-local.yaml       # Local values (gitignored)
├── templates/
│   ├── _helpers.tpl        # Template helpers
│   ├── configmap.yaml      # ConfigMap template
│   ├── secrets.yaml        # Secret template
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   └── NOTES.txt           # Post-install notes
└── README.md               # This file
```

## Support

For issues and questions, refer to:
- Project documentation: `../../specs/001-k8s-local-deployment/`
- Quickstart guide: `../../specs/001-k8s-local-deployment/quickstart.md`
- Troubleshooting: `../../specs/001-k8s-local-deployment/quickstart.md#troubleshooting`
