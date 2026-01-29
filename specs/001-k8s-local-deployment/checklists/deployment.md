# Deployment Checklist - Phase IV: Local Kubernetes Deployment

**Project**: Todo Chatbot
**Environment**: Local Kubernetes (Minikube)
**Date**: 2026-01-28

---

## Pre-Deployment Checklist

### Environment Prerequisites

- [ ] **Docker Desktop** installed and running
  - [ ] Version: __________ (run `docker --version`)
  - [ ] Docker daemon accessible (`docker ps` succeeds)

- [ ] **Minikube** installed
  - [ ] Version: __________ (run `minikube version`)
  - [ ] Minimum resources available: 2 CPUs, 4GB RAM, 20GB disk

- [ ] **Helm** 3.x installed
  - [ ] Version: __________ (run `helm version`)

- [ ] **kubectl** installed
  - [ ] Version: __________ (run `kubectl version --client`)

### Optional AI Tools

- [ ] **kubectl-ai** plugin (via krew)
  - [ ] Installed: Yes / No
  - [ ] Version: __________

- [ ] **Docker AI (Gordon)**
  - [ ] Available: Yes / No

### Phase III Application

- [ ] **Phase III directories exist**
  - [ ] `../todo_phase3/frontend/` with Next.js app
  - [ ] `../todo_phase3/backend/` with FastAPI app

- [ ] **Backend health endpoint**
  - [ ] `/health` endpoint exists in `../todo_phase3/backend/src/main.py`

- [ ] **Environment variables**
  - [ ] `.env` file available with required secrets
  - [ ] DATABASE_URL configured
  - [ ] OPENAI_API_KEY available
  - [ ] BETTER_AUTH_SECRET available

---

## Build Checklist

### Dockerfile Creation

- [ ] **Frontend Dockerfile** (`kubernetes/dockerfiles/frontend.Dockerfile`)
  - [ ] AI-generated using: __________
  - [ ] Multi-stage build (builder + runtime)
  - [ ] Base image: node:18-alpine
  - [ ] Non-root user configured
  - [ ] Exposes port 3000
  - [ ] Standalone output mode
  - [ ] Human reviewed and approved

- [ ] **Backend Dockerfile** (`kubernetes/dockerfiles/backend.Dockerfile`)
  - [ ] AI-generated using: __________
  - [ ] Base image: python:3.11-slim
  - [ ] Dependencies installed from requirements.txt
  - [ ] Non-root user configured
  - [ ] Exposes port 8000
  - [ ] Health check on /health endpoint
  - [ ] Human reviewed and approved

### Docker Image Building

- [ ] **Frontend image built**
  - [ ] Command: `docker build -f kubernetes/dockerfiles/frontend.Dockerfile -t todo-frontend:1.0.0 ../todo_phase3/frontend`
  - [ ] Build successful: Yes / No
  - [ ] Image size: __________ MB (target: < 200MB)

- [ ] **Backend image built**
  - [ ] Command: `docker build -f kubernetes/dockerfiles/backend.Dockerfile -t todo-backend:1.0.0 ../todo_phase3/backend`
  - [ ] Build successful: Yes / No
  - [ ] Image size: __________ MB (target: < 500MB)

### Local Container Testing

- [ ] **Frontend container test**
  - [ ] Container starts successfully
  - [ ] `curl http://localhost:3000` returns 200 OK

- [ ] **Backend container test**
  - [ ] Container starts successfully
  - [ ] `curl http://localhost:8000/health` returns healthy status

---

## Kubernetes Cluster Setup

### Minikube Cluster

- [ ] **Start Minikube**
  - [ ] Command: `minikube start --cpus=2 --memory=4096 --disk-size=20gb`
  - [ ] Cluster started successfully
  - [ ] `kubectl cluster-info` shows cluster running

- [ ] **Create namespace**
  - [ ] Command: `kubectl create namespace todo-app`
  - [ ] Namespace created
  - [ ] Verified: `kubectl get namespaces | grep todo-app`

- [ ] **Load images into Minikube**
  - [ ] Frontend: `minikube image load todo-frontend:1.0.0`
  - [ ] Backend: `minikube image load todo-backend:1.0.0`
  - [ ] Verified: `minikube image ls | grep todo`

---

## Kubernetes Manifests Deployment

### Configuration Files

- [ ] **ConfigMap** created
  - [ ] File: `kubernetes/manifests/configmap.yaml`
  - [ ] Applied: `kubectl apply -f kubernetes/manifests/configmap.yaml -n todo-app`

- [ ] **Secret** created
  - [ ] File: `kubernetes/manifests/secrets.yaml`
  - [ ] Secrets base64-encoded
  - [ ] Applied: `kubectl apply -f kubernetes/manifests/secrets.yaml -n todo-app`
  - [ ] ⚠️ NOT committed to Git

### Deployments

- [ ] **Frontend Deployment** created
  - [ ] File: `kubernetes/manifests/frontend-deployment.yaml`
  - [ ] 2 replicas configured
  - [ ] Resources: requests (100m CPU, 256Mi memory), limits (500m CPU, 512Mi memory)
  - [ ] Liveness/readiness probes on /
  - [ ] Applied successfully

- [ ] **Backend Deployment** created
  - [ ] File: `kubernetes/manifests/backend-deployment.yaml`
  - [ ] 1 replica configured
  - [ ] Resources: requests (200m CPU, 512Mi memory), limits (1000m CPU, 1Gi memory)
  - [ ] Liveness/readiness probes on /health
  - [ ] Environment from ConfigMap and Secret
  - [ ] Applied successfully

### Services

- [ ] **Frontend Service** created
  - [ ] File: `kubernetes/manifests/frontend-service.yaml`
  - [ ] Type: NodePort
  - [ ] NodePort: 30080
  - [ ] Port: 3000
  - [ ] Applied successfully

- [ ] **Backend Service** created
  - [ ] File: `kubernetes/manifests/backend-service.yaml`
  - [ ] Type: NodePort
  - [ ] NodePort: 30800
  - [ ] Port: 8000
  - [ ] Applied successfully

---

## Deployment Verification

### Pod Status

- [ ] **Pods running**
  - [ ] 2 frontend pods in Running state
  - [ ] 1 backend pod in Running state
  - [ ] All pods ready within 3 minutes
  - [ ] Command: `kubectl get pods -n todo-app`

- [ ] **No errors in events**
  - [ ] Command: `kubectl get events -n todo-app --sort-by='.lastTimestamp'`
  - [ ] No CrashLoopBackOff
  - [ ] No ImagePullBackOff

### Service Status

- [ ] **Services created**
  - [ ] Frontend service has NodePort 30080
  - [ ] Backend service has NodePort 30800
  - [ ] Command: `kubectl get svc -n todo-app`

### Application Accessibility

- [ ] **Frontend accessible**
  - [ ] URL: http://localhost:30080
  - [ ] Loads within 30 seconds
  - [ ] UI renders correctly

- [ ] **Backend health endpoint**
  - [ ] URL: http://localhost:30800/health
  - [ ] Returns 200 OK
  - [ ] Returns healthy status JSON

### End-to-End Testing

- [ ] **Complete user workflow**
  1. [ ] Login with Phase III credentials
  2. [ ] Send chat message to AI
  3. [ ] Create task via chat
  4. [ ] View tasks page
  5. [ ] Complete task
  6. [ ] Delete task
  - [ ] All functionality works identically to Phase III

### Resilience Testing

- [ ] **Pod recreation test**
  - [ ] Delete one frontend pod
  - [ ] Kubernetes recreates it within 30 seconds
  - [ ] Application remains accessible
  - [ ] Command: `kubectl delete pod <pod-name> -n todo-app`

---

## Performance Metrics

### Deployment Timing

- [ ] **Deployment time**: __________ minutes (target: < 10 minutes)
  - [ ] From `minikube start` to application accessible

- [ ] **Pod startup time**: __________ minutes (target: < 3 minutes)
  - [ ] From `helm install` to all pods Running

- [ ] **Application readiness**: __________ seconds (target: < 30 seconds)
  - [ ] From pods Running to application fully functional

### Resource Usage

- [ ] **Image sizes**
  - [ ] Frontend: __________ MB (target: < 200MB)
  - [ ] Backend: __________ MB (target: < 500MB)

- [ ] **Pod resource usage** (run `kubectl top pods -n todo-app`)
  - [ ] Frontend pods within limits
  - [ ] Backend pod within limits
  - [ ] CPU: __________ / __________
  - [ ] Memory: __________ / __________

---

## Helm Chart Checklist (User Story 3)

### Helm Chart Structure

- [ ] **Chart scaffolded**
  - [ ] Command: `helm create kubernetes/helm-chart/todo-chatbot`

- [ ] **Chart.yaml customized**
  - [ ] Name: todo-chatbot
  - [ ] Version: 1.0.0
  - [ ] AppVersion: 1.0.0
  - [ ] Description added

- [ ] **Templates created**
  - [ ] frontend-deployment.yaml with Helm templating
  - [ ] backend-deployment.yaml with Helm templating
  - [ ] frontend-service.yaml with Helm templating
  - [ ] backend-service.yaml with Helm templating
  - [ ] configmap.yaml with Helm templating
  - [ ] secrets.yaml with Helm templating

- [ ] **values.yaml configured**
  - [ ] Frontend settings (image, replicas, resources)
  - [ ] Backend settings (image, replicas, resources)
  - [ ] Config variables
  - [ ] Secret placeholders

- [ ] **values-local.yaml created**
  - [ ] Actual secrets from .env
  - [ ] Added to .gitignore

- [ ] **Template helpers** (_helpers.tpl)
  - [ ] todo-chatbot.name
  - [ ] todo-chatbot.fullname
  - [ ] todo-chatbot.labels

### Helm Validation

- [ ] **Lint passed**
  - [ ] Command: `helm lint kubernetes/helm-chart/todo-chatbot/`
  - [ ] No errors or warnings

- [ ] **Dry-run successful**
  - [ ] Command: `helm install todo-chatbot kubernetes/helm-chart/todo-chatbot/ --dry-run --debug -n todo-app -f kubernetes/helm-chart/todo-chatbot/values-local.yaml`
  - [ ] All templates render correctly

- [ ] **Template rendering verified**
  - [ ] All values substituted correctly
  - [ ] No syntax errors

### Helm Lifecycle Testing

- [ ] **Install successful**
  - [ ] Command: `helm install todo-chatbot kubernetes/helm-chart/todo-chatbot/ -n todo-app -f kubernetes/helm-chart/todo-chatbot/values-local.yaml --create-namespace`
  - [ ] Release created
  - [ ] All resources deployed

- [ ] **Upgrade successful**
  - [ ] Modified values-local.yaml (e.g., replicas: 2 → 3)
  - [ ] Command: `helm upgrade todo-chatbot kubernetes/helm-chart/todo-chatbot/ -n todo-app -f kubernetes/helm-chart/todo-chatbot/values-local.yaml`
  - [ ] Changes applied

- [ ] **Rollback successful**
  - [ ] Command: `helm rollback todo-chatbot -n todo-app`
  - [ ] Previous state restored
  - [ ] Application still works

---

## Documentation Checklist

- [ ] **Quickstart guide** (`specs/001-k8s-local-deployment/quickstart.md`)
  - [ ] Prerequisites listed
  - [ ] Step-by-step deployment instructions
  - [ ] Troubleshooting section

- [ ] **AI prompts log** (`specs/001-k8s-local-deployment/ai-prompts-log.md`)
  - [ ] All AI interactions documented
  - [ ] Prompts, outputs, and validations recorded

- [ ] **Architecture documentation** (`specs/001-k8s-local-deployment/deployment-architecture.md`)
  - [ ] Updated with final deployed state
  - [ ] Component counts correct
  - [ ] Port numbers documented

- [ ] **Helm chart README** (`kubernetes/helm-chart/todo-chatbot/README.md`)
  - [ ] Installation instructions
  - [ ] Customization guide
  - [ ] Troubleshooting tips

---

## Automation Scripts

- [ ] **build-images.sh** (`kubernetes/scripts/build-images.sh`)
  - [ ] Builds frontend and backend images
  - [ ] Error handling included
  - [ ] Image size validation

- [ ] **deploy.sh** (`kubernetes/scripts/deploy.sh`)
  - [ ] Checks prerequisites
  - [ ] Starts Minikube if needed
  - [ ] Loads images
  - [ ] Installs Helm chart
  - [ ] Waits for pods ready
  - [ ] Displays access URLs

- [ ] **validate.sh** (`kubernetes/scripts/validate.sh`)
  - [ ] Checks pod status
  - [ ] Tests health endpoints
  - [ ] Verifies NodePort accessibility
  - [ ] Runs smoke tests

---

## Git and Version Control

- [ ] **.gitignore updated**
  - [ ] values-local.yaml excluded
  - [ ] *.tar excluded
  - [ ] *.log excluded
  - [ ] rendered-manifests.yaml excluded

- [ ] **All Phase IV artifacts committed**
  - [ ] Dockerfiles
  - [ ] Kubernetes manifests
  - [ ] Helm chart (except values-local.yaml)
  - [ ] Documentation
  - [ ] Automation scripts

- [ ] **Descriptive commit message**
  - [ ] Commit: "Phase IV: Local Kubernetes deployment infrastructure complete"

---

## Sign-Off

**Phase IV Deployment Status**: ⬜ Not Started / 🔄 In Progress / ✅ Complete

**Completed By**: __________________
**Date**: __________________
**Notes**:

---

**Last Updated**: 2026-01-28
