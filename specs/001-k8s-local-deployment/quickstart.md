# Quickstart Guide - Local Kubernetes Deployment

**Project**: Todo Chatbot Phase IV
**Version**: 1.0.0
**Last Updated**: 2026-01-28

---

## Overview

This guide walks you through deploying the Todo Chatbot application to a local Kubernetes cluster using Minikube and Helm.

**What you'll deploy**:
- **Frontend**: Next.js 14 application (2 replicas)
- **Backend**: FastAPI application with AI capabilities (1 replica)
- **Services**: NodePort services for local access
- **Configuration**: ConfigMap and Secrets for environment variables

**Deployment time**: ~10 minutes (after prerequisites installed)

---

## Prerequisites

### Required Tools

Before starting, install these tools:

| Tool | Version | Purpose | Installation Link |
|------|---------|---------|------------------|
| **Docker Desktop** | Latest | Container runtime | https://www.docker.com/products/docker-desktop |
| **Minikube** | 1.25+ | Local Kubernetes cluster | https://minikube.sigs.k8s.io/docs/start/ |
| **Helm** | 3.0+ | Kubernetes package manager | https://helm.sh/docs/intro/install/ |
| **kubectl** | 1.19+ | Kubernetes CLI | https://kubernetes.io/docs/tasks/tools/ |

### System Requirements

- **CPU**: 2+ cores available for Minikube
- **Memory**: 4GB+ RAM available
- **Disk**: 20GB+ free space
- **OS**: Windows 10/11, macOS, or Linux

### Verify Installation

```bash
# Check Docker
docker --version
docker ps  # Should not error

# Check Minikube
minikube version

# Check Helm
helm version

# Check kubectl
kubectl version --client
```

### Phase III Application

Ensure the Phase III application exists:
- `../todo_phase3/frontend/` - Next.js frontend
- `../todo_phase3/backend/` - FastAPI backend

---

## Quick Start (Automated)

The fastest way to deploy is using the automation scripts:

### 1. Build Docker Images

```bash
cd kubernetes/scripts
./build-images.sh
```

This script will:
- Build frontend and backend Docker images
- Validate image sizes
- Load images into Minikube (if running)

### 2. Configure Secrets

```bash
cd kubernetes/helm-chart/todo-chatbot
cp values-local.yaml.example values-local.yaml
# Edit values-local.yaml with your actual secrets
```

**Required secrets**:
- `databaseUrl`: PostgreSQL connection string
- `openaiApiKey`: OpenAI API key
- `betterAuthSecret`: Authentication secret (generate with `openssl rand -hex 32`)
- `jwtSecret`: JWT secret (generate with `openssl rand -hex 32`)

### 3. Deploy to Kubernetes

```bash
cd kubernetes/scripts
./deploy.sh
```

This script will:
- Start Minikube if not running
- Create namespace
- Load images
- Install Helm chart
- Wait for pods to be ready
- Display access URLs

### 4. Validate Deployment

```bash
cd kubernetes/scripts
./validate.sh
```

This runs comprehensive validation tests to ensure everything is working.

### 5. Access the Application

- **Frontend**: http://localhost:30080
- **Backend API**: http://localhost:30800
- **Backend Docs**: http://localhost:30800/docs
- **Health Check**: http://localhost:30800/health

---

## Manual Deployment (Step-by-Step)

If you prefer manual control or the scripts don't work:

### Step 1: Start Minikube

```bash
minikube start --cpus=2 --memory=4096 --disk-size=20gb
```

Verify:
```bash
kubectl cluster-info
minikube status
```

### Step 2: Build Docker Images

From project root:

```bash
# Build frontend
docker build \
  -f kubernetes/dockerfiles/frontend.Dockerfile \
  -t todo-frontend:1.0.0 \
  ../todo_phase3/frontend

# Build backend
docker build \
  -f kubernetes/dockerfiles/backend.Dockerfile \
  -t todo-backend:1.0.0 \
  ../todo_phase3/backend
```

Verify:
```bash
docker images | grep todo
```

Expected output:
```
todo-frontend    1.0.0   ...   <200MB   ...
todo-backend     1.0.0   ...   <500MB   ...
```

### Step 3: Load Images into Minikube

```bash
minikube image load todo-frontend:1.0.0
minikube image load todo-backend:1.0.0
```

Verify:
```bash
minikube image ls | grep todo
```

### Step 4: Create Namespace

```bash
kubectl create namespace todo-app
```

Verify:
```bash
kubectl get namespaces
```

### Step 5: Configure Secrets

Create `kubernetes/helm-chart/todo-chatbot/values-local.yaml`:

```yaml
secrets:
  databaseUrl: "postgresql+asyncpg://user:pass@host:5432/db"
  openaiApiKey: "sk-your-key-here"
  betterAuthSecret: "your-secret-here"
  jwtSecret: "your-jwt-secret-here"
```

⚠️ **Important**: This file contains secrets. Do not commit to Git!

### Step 6: Install Helm Chart

```bash
cd kubernetes/helm-chart/todo-chatbot

helm install todo-chatbot . \
  -n todo-app \
  -f values-local.yaml \
  --create-namespace
```

### Step 7: Wait for Pods

```bash
# Watch pods start
kubectl get pods -n todo-app -w

# Or wait for ready condition
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/instance=todo-chatbot \
  -n todo-app \
  --timeout=180s
```

### Step 8: Verify Deployment

```bash
# Check all resources
kubectl get all -n todo-app

# Check pod status
kubectl get pods -n todo-app

# Check services
kubectl get svc -n todo-app

# Test health endpoint
curl http://localhost:30800/health
```

### Step 9: Access Application

Open in browser:
- Frontend: http://localhost:30080
- Backend API Docs: http://localhost:30800/docs

---

## Common Tasks

### View Logs

```bash
# Frontend logs
kubectl logs -f -n todo-app -l app=frontend

# Backend logs
kubectl logs -f -n todo-app -l app=backend

# Specific pod
kubectl logs -f -n todo-app <pod-name>
```

### Update Configuration

1. Edit `values-local.yaml`
2. Upgrade release:
   ```bash
   helm upgrade todo-chatbot kubernetes/helm-chart/todo-chatbot \
     -n todo-app \
     -f kubernetes/helm-chart/todo-chatbot/values-local.yaml
   ```

### Scale Replicas

```bash
# Edit values-local.yaml
frontend:
  replicaCount: 3  # Change from 2 to 3

# Apply changes
helm upgrade todo-chatbot kubernetes/helm-chart/todo-chatbot \
  -n todo-app \
  -f kubernetes/helm-chart/todo-chatbot/values-local.yaml
```

### Rollback Deployment

```bash
# View history
helm history todo-chatbot -n todo-app

# Rollback to previous
helm rollback todo-chatbot -n todo-app

# Rollback to specific revision
helm rollback todo-chatbot 2 -n todo-app
```

### Restart Pods

```bash
# Restart all frontend pods
kubectl rollout restart deployment -n todo-app -l app=frontend

# Restart all backend pods
kubectl rollout restart deployment -n todo-app -l app=backend
```

### Clean Up

```bash
# Uninstall Helm release
helm uninstall todo-chatbot -n todo-app

# Delete namespace (removes all resources)
kubectl delete namespace todo-app

# Stop Minikube
minikube stop

# Delete Minikube cluster
minikube delete
```

---

## Troubleshooting

### Issue: Docker Daemon Not Running

**Symptoms**: `docker ps` fails, "Cannot connect to Docker daemon"

**Solution**:
1. Start Docker Desktop
2. Wait for Docker to fully start (whale icon in system tray)
3. Run `docker ps` to verify

### Issue: Minikube Won't Start

**Symptoms**: `minikube start` hangs or fails

**Solutions**:
```bash
# Try with specific driver
minikube start --driver=docker

# Or with hyperkit (macOS)
minikube start --driver=hyperkit

# Or with virtualbox
minikube start --driver=virtualbox

# Check logs
minikube logs
```

### Issue: Pods Stuck in Pending

**Symptoms**: `kubectl get pods` shows "Pending" status

**Diagnosis**:
```bash
kubectl describe pod <pod-name> -n todo-app
```

**Common causes**:
- **Insufficient resources**: Increase Minikube memory/CPU
- **Image not loaded**: Run `minikube image load <image>`
- **Node not ready**: Check `kubectl get nodes`

### Issue: Pods in CrashLoopBackOff

**Symptoms**: Pods keep restarting

**Diagnosis**:
```bash
# View pod logs
kubectl logs <pod-name> -n todo-app

# View previous container logs
kubectl logs <pod-name> -n todo-app --previous

# Describe pod for events
kubectl describe pod <pod-name> -n todo-app
```

**Common causes**:
- **Missing environment variables**: Check ConfigMap and Secret
- **Database connection failed**: Verify `DATABASE_URL` in secrets
- **Port already in use**: Check for port conflicts
- **Application crash**: Check logs for error details

### Issue: Cannot Access Application (localhost:30080)

**Symptoms**: Browser cannot load http://localhost:30080

**Diagnosis**:
```bash
# Check service
kubectl get svc -n todo-app

# Check if Minikube is running
minikube status

# Get Minikube IP (if not localhost)
minikube ip
```

**Solutions**:
```bash
# Option 1: Use Minikube tunnel (if localhost doesn't work)
minikube tunnel  # Run in separate terminal

# Option 2: Use Minikube IP
# Access at http://<minikube-ip>:30080

# Option 3: Port forward
kubectl port-forward svc/frontend 8080:3000 -n todo-app
# Then access at http://localhost:8080
```

### Issue: ImagePullBackOff Error

**Symptoms**: Pods show "ImagePullBackOff" status

**Cause**: Image not available in Minikube

**Solution**:
```bash
# Load images into Minikube
minikube image load todo-frontend:1.0.0
minikube image load todo-backend:1.0.0

# Verify images loaded
minikube image ls | grep todo

# Restart deployment
kubectl rollout restart deployment -n todo-app
```

### Issue: Helm Install Fails

**Symptoms**: `helm install` command errors

**Common errors and solutions**:

1. **"Release already exists"**
   ```bash
   helm list -n todo-app
   helm uninstall todo-chatbot -n todo-app
   # Then try install again
   ```

2. **"Validation errors"**
   ```bash
   # Lint chart
   helm lint kubernetes/helm-chart/todo-chatbot

   # Dry run to see rendered templates
   helm install todo-chatbot kubernetes/helm-chart/todo-chatbot \
     --dry-run --debug -n todo-app -f values-local.yaml
   ```

3. **"values-local.yaml not found"**
   ```bash
   cp kubernetes/helm-chart/todo-chatbot/values-local.yaml.example \
      kubernetes/helm-chart/todo-chatbot/values-local.yaml
   # Edit with your secrets
   ```

### Issue: Port Conflicts (30080 or 30800 in use)

**Diagnosis**:
```bash
# Check what's using the port (Windows)
netstat -ano | findstr :30080

# Check what's using the port (Mac/Linux)
lsof -i :30080
```

**Solutions**:
1. **Stop conflicting service**
2. **Change NodePort** in `values-local.yaml`:
   ```yaml
   frontend:
     service:
       nodePort: 30081  # Change from 30080
   backend:
     service:
       nodePort: 30801  # Change from 30800
   ```
3. **Upgrade deployment** with new ports

### Issue: Database Connection Errors

**Symptoms**: Backend logs show database connection errors

**Checklist**:
1. ✅ Database is running and accessible
2. ✅ `DATABASE_URL` in `values-local.yaml` is correct
3. ✅ Database user has proper permissions
4. ✅ Firewall allows connection from Minikube

**Test database connection**:
```bash
# Get backend pod name
kubectl get pods -n todo-app

# Execute shell in backend pod
kubectl exec -it <backend-pod-name> -n todo-app -- bash

# Test connection (inside pod)
python -c "import asyncpg; print('Connection test')"
```

### Issue: Out of Memory

**Symptoms**: Pods evicted, Minikube crashes

**Solution**:
```bash
# Stop Minikube
minikube stop

# Delete and recreate with more resources
minikube delete
minikube start --cpus=4 --memory=8192 --disk-size=40gb
```

---

## Advanced Topics

### Using Different Docker Images

To use custom image tags:

1. Build with custom tag:
   ```bash
   docker build -t todo-frontend:dev ...
   ```

2. Update `values-local.yaml`:
   ```yaml
   frontend:
     image:
       tag: "dev"
   ```

3. Load into Minikube and upgrade:
   ```bash
   minikube image load todo-frontend:dev
   helm upgrade todo-chatbot ...
   ```

### Enabling Metrics

To monitor resource usage:

```bash
# Enable metrics-server
minikube addons enable metrics-server

# Wait a minute, then check
kubectl top pods -n todo-app
kubectl top nodes
```

### Using kubectl-ai (Optional)

If you have kubectl-ai installed:

```bash
# Install via krew
kubectl krew install ai

# Generate manifests with AI
kubectl ai "create deployment for nginx"
```

### Debugging with Logs

Comprehensive logging:

```bash
# All pods in namespace
kubectl logs -n todo-app --all-containers=true

# Follow logs from all frontend pods
kubectl logs -f -n todo-app -l app=frontend --all-containers=true

# Export logs to file
kubectl logs -n todo-app <pod-name> > pod-logs.txt
```

---

## Team Standards

### NodePort Assignments

**Standard ports** (do not change without team coordination):
- Frontend: **30080**
- Backend: **30800**

### Namespace

Always use `todo-app` namespace for consistency.

### Branch and Versioning

- Feature branch: `001-k8s-local-deployment`
- Image tag: `1.0.0` (increment for new versions)

---

## Performance Metrics

### Target Metrics

| Metric | Target | Actual |
|--------|--------|--------|
| Full deployment time | < 10 min | \_\_\_\_\_ |
| Pod startup time | < 3 min | \_\_\_\_\_ |
| Application ready time | < 30 sec | \_\_\_\_\_ |
| Frontend image size | < 200 MB | \_\_\_\_\_ |
| Backend image size | < 500 MB | \_\_\_\_\_ |

### Measuring

```bash
# Deployment time
time ./kubernetes/scripts/deploy.sh

# Pod startup time
time kubectl wait --for=condition=ready pod ...

# Image sizes
docker images | grep todo
```

---

## Next Steps

After successful deployment:

1. ✅ **Verify end-to-end functionality**
   - Login with Phase III credentials
   - Create tasks via chat
   - Verify task operations work

2. ✅ **Run validation suite**
   ```bash
   ./kubernetes/scripts/validate.sh
   ```

3. ✅ **Document any issues** in `ai-prompts-log.md`

4. ✅ **Test resilience**
   - Delete a pod, verify it recreates
   - Upgrade Helm release
   - Rollback Helm release

---

## Additional Resources

- **Kubernetes Documentation**: https://kubernetes.io/docs/
- **Helm Documentation**: https://helm.sh/docs/
- **Minikube Documentation**: https://minikube.sigs.k8s.io/docs/
- **Phase IV Tasks**: `specs/001-k8s-local-deployment/tasks.md`
- **Deployment Architecture**: `specs/001-k8s-local-deployment/deployment-architecture.md`

---

**Questions or Issues?**

Check the troubleshooting section above or review:
- `specs/001-k8s-local-deployment/ai-prompts-log.md` - AI generation logs
- `kubernetes/helm-chart/todo-chatbot/README.md` - Helm chart details
- GitHub Issues (if applicable)

---

**Last Updated**: 2026-01-28
**Status**: Ready for deployment
