# Phase IV Quick Reference Card

**Version**: 1.0.0
**Date**: 2026-01-28
**Status**: Infrastructure Complete ✅

---

## 🚀 Quick Start (5 Minutes)

```bash
# 1. Install tools (if needed - see INSTALL_TOOLS.md)
# 2. Configure secrets
cd kubernetes/helm-chart/todo-chatbot
cp values-local.yaml.example values-local.yaml
# Edit values-local.yaml with your secrets

# 3. Deploy everything
cd ../../scripts
./deploy.sh

# 4. Validate deployment
./validate.sh

# 5. Access application
# Frontend: http://localhost:30080
# Backend:  http://localhost:30800
```

---

## 📁 Key Files

| File | Purpose |
|------|---------|
| `INSTALL_TOOLS.md` | Tool installation guide (Minikube, Helm) |
| `PHASE_IV_PROGRESS.md` | Detailed completion report |
| `specs/001-k8s-local-deployment/quickstart.md` | Comprehensive deployment guide (20+ pages) |
| `kubernetes/scripts/deploy.sh` | Automated deployment script |
| `kubernetes/scripts/validate.sh` | Post-deployment validation |
| `kubernetes/helm-chart/todo-chatbot/values-local.yaml` | **Your secrets** (create from .example) |

---

## 🛠️ Essential Commands

### Deployment
```bash
cd kubernetes/scripts

# Full automated deployment
./deploy.sh

# Just build images
./build-images.sh

# Validate existing deployment
./validate.sh
```

### Helm Operations
```bash
# Install
helm install todo-chatbot kubernetes/helm-chart/todo-chatbot \
  -n todo-app -f kubernetes/helm-chart/todo-chatbot/values-local.yaml

# Upgrade
helm upgrade todo-chatbot kubernetes/helm-chart/todo-chatbot \
  -n todo-app -f kubernetes/helm-chart/todo-chatbot/values-local.yaml

# Rollback
helm rollback todo-chatbot -n todo-app

# Uninstall
helm uninstall todo-chatbot -n todo-app
```

### Kubernetes Operations
```bash
# View pods
kubectl get pods -n todo-app

# View services
kubectl get svc -n todo-app

# View logs (frontend)
kubectl logs -f -n todo-app -l app=frontend

# View logs (backend)
kubectl logs -f -n todo-app -l app=backend

# Describe pod
kubectl describe pod <pod-name> -n todo-app

# View events
kubectl get events -n todo-app --sort-by='.lastTimestamp'

# Delete pod (will recreate)
kubectl delete pod <pod-name> -n todo-app
```

### Minikube Operations
```bash
# Start cluster
minikube start --cpus=2 --memory=4096 --disk-size=20gb

# Stop cluster
minikube stop

# Delete cluster
minikube delete

# View cluster status
minikube status

# Get cluster IP
minikube ip

# SSH into cluster
minikube ssh

# Load image
minikube image load <image-name>

# List images
minikube image ls
```

### Docker Operations
```bash
# Build frontend
docker build -f kubernetes/dockerfiles/frontend.Dockerfile \
  -t todo-frontend:1.0.0 ../todo_phase3/frontend

# Build backend
docker build -f kubernetes/dockerfiles/backend.Dockerfile \
  -t todo-backend:1.0.0 ../todo_phase3/backend

# View images
docker images | grep todo

# Remove image
docker rmi todo-frontend:1.0.0
```

---

## 🔧 Troubleshooting Quick Fixes

| Issue | Quick Fix |
|-------|-----------|
| **Docker daemon not running** | Start Docker Desktop from Start menu |
| **Pods in CrashLoopBackOff** | Check logs: `kubectl logs <pod-name> -n todo-app`<br>Verify secrets in values-local.yaml |
| **ImagePullBackOff** | Load images: `minikube image load <image>` |
| **Cannot access localhost:30080** | Verify Minikube running: `minikube status`<br>Check service: `kubectl get svc -n todo-app` |
| **Port already in use** | Find process: `netstat -ano \| findstr :30080`<br>Or change port in values-local.yaml |
| **Helm install fails** | Lint chart: `helm lint kubernetes/helm-chart/todo-chatbot`<br>Check values: verify values-local.yaml exists |
| **Database connection error** | Verify DATABASE_URL in values-local.yaml<br>Check database is running and accessible |

---

## 📊 Access URLs

| Service | URL | Purpose |
|---------|-----|---------|
| **Frontend** | http://localhost:30080 | Main application UI |
| **Backend API** | http://localhost:30800 | API endpoints |
| **API Docs** | http://localhost:30800/docs | Swagger documentation |
| **Health Check** | http://localhost:30800/health | Backend health status |

---

## 🔑 Required Secrets

Create `kubernetes/helm-chart/todo-chatbot/values-local.yaml` with:

```yaml
secrets:
  # PostgreSQL connection string
  databaseUrl: "postgresql+asyncpg://user:pass@host:5432/db"

  # OpenAI API key (from platform.openai.com)
  openaiApiKey: "sk-..."

  # Generate with: openssl rand -hex 32
  betterAuthSecret: "your-auth-secret-here"
  jwtSecret: "your-jwt-secret-here"

  # Optional: Anthropic API key
  anthropicApiKey: "sk-ant-..."
```

---

## 📈 Success Checklist

- [ ] Docker Desktop running
- [ ] Minikube installed and started
- [ ] Helm installed
- [ ] kubectl configured
- [ ] values-local.yaml created with actual secrets
- [ ] Images built successfully
- [ ] Pods running (2 frontend + 1 backend)
- [ ] Services accessible on NodePorts
- [ ] Health check returns 200 OK
- [ ] Frontend loads in browser
- [ ] Can login and use application

---

## 📚 Documentation Index

1. **INSTALL_TOOLS.md** - Install Minikube and Helm (15-20 min)
2. **PHASE_IV_PROGRESS.md** - What's been completed (62% done)
3. **specs/.../quickstart.md** - Full deployment guide (20+ pages)
4. **specs/.../ai-prompts-log.md** - AI generation documentation
5. **kubernetes/helm-chart/todo-chatbot/README.md** - Helm chart guide

---

## 🆘 Getting Help

**Errors during deployment?**
→ Check `specs/001-k8s-local-deployment/quickstart.md` Troubleshooting section (15+ scenarios)

**Tool installation issues?**
→ See `INSTALL_TOOLS.md` for platform-specific instructions

**Helm chart customization?**
→ See `kubernetes/helm-chart/todo-chatbot/README.md`

**Still stuck?**
→ Check logs: `kubectl logs -n todo-app <pod-name>`
→ Check events: `kubectl get events -n todo-app`
→ Run validation: `./kubernetes/scripts/validate.sh`

---

## ⚡ Pro Tips

1. **Always run validate.sh** after deployment changes
2. **Keep values-local.yaml secure** - never commit to git
3. **Use the scripts** - they handle all edge cases
4. **Check logs first** when troubleshooting
5. **Minikube tunnel** if NodePort doesn't work: `minikube tunnel`
6. **Clean start**: `minikube delete && minikube start` for hard reset

---

## 🎯 Performance Targets

| Metric | Target | How to Measure |
|--------|--------|---------------|
| Deployment time | < 10 min | `time ./deploy.sh` |
| Pod startup | < 3 min | `kubectl get pods -n todo-app -w` |
| Frontend image | < 200 MB | `docker images \| grep frontend` |
| Backend image | < 500 MB | `docker images \| grep backend` |
| Health response | < 1 sec | `curl -w "@%{time_total}s" http://localhost:30800/health` |

---

## 🔄 Common Workflows

### First-Time Setup
```bash
# 1. Install tools
# See INSTALL_TOOLS.md

# 2. Configure
cd kubernetes/helm-chart/todo-chatbot
cp values-local.yaml.example values-local.yaml
# Edit secrets

# 3. Deploy
cd ../../scripts
./deploy.sh
```

### Daily Development
```bash
# Start Minikube
minikube start

# Deploy changes
cd kubernetes/scripts
./deploy.sh

# Check status
./validate.sh
```

### Update Configuration
```bash
# 1. Edit values-local.yaml
# 2. Upgrade release
helm upgrade todo-chatbot kubernetes/helm-chart/todo-chatbot \
  -n todo-app -f kubernetes/helm-chart/todo-chatbot/values-local.yaml
```

### Clean Shutdown
```bash
# Uninstall application
helm uninstall todo-chatbot -n todo-app

# Stop Minikube
minikube stop

# (Optional) Delete cluster
minikube delete
```

---

**Last Updated**: 2026-01-28
**Quick Reference Version**: 1.0
**Deployment Ready**: ✅
