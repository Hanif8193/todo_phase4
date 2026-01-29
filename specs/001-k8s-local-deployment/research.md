# Phase 0 Research: AI Tools and Best Practices

**Feature**: Local Kubernetes Deployment for Todo Chatbot
**Date**: 2026-01-28
**Status**: Complete

---

## Executive Summary

This document resolves all technical unknowns from the implementation plan and establishes best practices for Phase IV deployment. Key findings:
- Docker AI (Gordon) availability varies; Claude Code fallback strategy defined
- kubectl-ai provides comprehensive Kubernetes manifest generation
- kagent optional; kubectl native tools sufficient for local deployment
- Multi-stage Docker builds validated for Next.js and FastAPI
- Resource sizing optimized for local Minikube constraints
- Helm chart generation strategy combines kubectl-ai + manual customization

---

## R1: Docker AI (Gordon) Availability Assessment

### Decision
Use **Claude Code with expert Dockerfile generation** as primary approach, with Docker AI (Gordon) as optional enhancement if available.

### Rationale
- Docker AI (Gordon) is a preview feature in Docker Desktop (as of early 2024)
- Availability varies by Docker Desktop version and platform
- Claude Code can generate production-quality Dockerfiles with explicit best practices
- Human review ensures optimization regardless of generation method

### Implementation Strategy

**Option 1: Docker AI Available**
```bash
# Test availability
docker ai --version

# If available, use for initial generation:
docker ai "create optimized multi-stage Dockerfile for Next.js 14..."
```

**Option 2: Claude Code Generation (Primary)**
```
# Detailed prompt to Claude Code:
"Generate a production-ready multi-stage Dockerfile for Next.js 14 with:
- Builder stage: node:18-alpine base, npm ci, build standalone
- Runtime stage: copy standalone output only, minimal dependencies
- Non-root user (node), expose 3000, health check on /
- Target size < 200MB"
```

**Validation Process** (same for both):
1. Generate Dockerfile
2. Build: `docker build -t test-image .`
3. Check size: `docker images test-image`
4. Run: `docker run -p 3000:3000 test-image`
5. Test health: `curl http://localhost:3000`
6. Review and iterate if needed

### Alternatives Considered
- **Manual Dockerfile creation**: Rejected due to "no manual coding" constraint
- **Online Dockerfile generators**: Rejected due to lack of customization and quality control

### Outcome
**Primary tool**: Claude Code with expert guidance
**Optional enhancement**: Docker AI if available
**Quality gate**: Human review + build/run validation

---

## R2: kubectl-ai Installation and Configuration

### Decision
Use **kubectl-ai via krew plugin manager** for Kubernetes manifest generation.

### Rationale
- kubectl-ai provides AI-powered manifest generation with context awareness
- Integrates seamlessly with kubectl workflow
- Supports various resource types (Deployments, Services, ConfigMaps, etc.)
- Can generate Helm-compatible templates with proper syntax

### Installation Instructions

**Method 1: krew (Recommended)**
```bash
# Install krew if not already installed
# Windows (PowerShell)
(New-Object Net.WebClient).DownloadFile("https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-windows_amd64.tar.gz", "$env:TEMP\krew.tar.gz")

# Linux/macOS
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-{OS}_{ARCH}.tar.gz"

# Install kubectl-ai plugin
kubectl krew install ai

# Verify installation
kubectl ai --version
```

**Method 2: Direct Binary Download**
```bash
# Download from GitHub releases
# https://github.com/sozercan/kubectl-ai/releases

# Place in PATH
# Windows: C:\Program Files\kubectl-plugins\
# Linux/macOS: /usr/local/bin/

# Make executable (Linux/macOS)
chmod +x kubectl-ai
```

### Usage Examples

**Generate Deployment**:
```bash
kubectl ai "create deployment for backend with 1 replica, python image, port 8000"
```

**Generate Service**:
```bash
kubectl ai "create NodePort service for frontend on port 30080"
```

**Generate Helm Template**:
```bash
kubectl ai "create Kubernetes deployment with Helm templating for values.yaml"
```

### Capabilities Validated
✅ Deployment generation with resource limits
✅ Service generation with NodePort
✅ ConfigMap and Secret generation
✅ Helm template syntax support
✅ Label and selector best practices

### Limitations Identified
- Helm chart scaffolding generates individual manifests, not full chart structure
- Manual Chart.yaml and values.yaml creation needed
- Template helpers (_helpers.tpl) require manual definition

### Fallback Strategy
If kubectl-ai unavailable:
1. Use `helm create` to scaffold chart structure
2. Use Claude Code to generate individual templates
3. Manually integrate templates into Helm chart

### Outcome
**Primary tool**: kubectl-ai for manifest generation
**Supplementary**: helm create for chart scaffolding
**Quality gate**: helm lint validation

---

## R3: kagent Availability and Use Cases

### Decision
**kagent is optional** for Phase IV. Use native kubectl commands for cluster analysis.

### Rationale
- kagent provides AI-powered cluster analysis and optimization
- Not essential for initial deployment success
- Native kubectl tools (get, describe, top, logs) sufficient for local development
- Can be added in future phases for production optimization

### Alternative Analysis Tools

**kubectl native commands**:
```bash
# Pod status and events
kubectl get pods -n todo-app -o wide
kubectl describe pod <pod-name> -n todo-app
kubectl get events -n todo-app --sort-by='.lastTimestamp'

# Resource usage (requires metrics-server)
kubectl top pods -n todo-app
kubectl top nodes

# Logs and debugging
kubectl logs -f -n todo-app <pod-name>
kubectl exec -it -n todo-app <pod-name> -- /bin/sh
```

**Helm status commands**:
```bash
helm status todo-chatbot -n todo-app
helm get values todo-chatbot -n todo-app
helm history todo-chatbot -n todo-app
```

**Minikube dashboard** (optional GUI):
```bash
minikube dashboard
```

### kagent Use Cases (Future Enhancement)
If kagent becomes available:
- Automated resource optimization recommendations
- Cluster health scoring
- Deployment best practice validation
- Security posture analysis

### Outcome
**Decision**: Skip kagent for Phase IV
**Alternative**: Document kubectl analysis commands in troubleshooting guide
**Future enhancement**: Evaluate kagent for Phase V (production deployment)

---

## R4: Multi-Stage Docker Build Best Practices

### Decision
Use **two-stage builds** for both frontend and backend with optimized base images.

### Next.js Frontend Pattern

**Recommended Approach**:
```dockerfile
# Stage 1: Builder
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Runner
FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
USER nextjs
EXPOSE 3000
CMD ["node", "server.js"]
```

**Key Optimizations**:
- ✅ Use Next.js standalone output (minimal dependencies)
- ✅ node:18-alpine base (smaller than node:18)
- ✅ Separate COPY package*.json for layer caching
- ✅ Non-root user (nextjs UID 1001)
- ✅ Multi-stage reduces final image by ~70%

**Expected Size**: 120-180MB (vs 600MB+ for non-optimized)

### FastAPI Backend Pattern

**Recommended Approach**:
```dockerfile
# Stage 1: Builder (optional for Python, but good practice)
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Runner
FROM python:3.11-slim AS runner
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends libpq5 && \
    rm -rf /var/lib/apt/lists/* && \
    addgroup --system --gid 1001 appuser && \
    adduser --system --uid 1001 appuser
COPY --from=builder /root/.local /home/appuser/.local
COPY --chown=appuser:appuser ./src ./src
USER appuser
ENV PATH=/home/appuser/.local/bin:$PATH
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health')"
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Key Optimizations**:
- ✅ python:3.11-slim (smaller than standard python:3.11)
- ✅ --no-cache-dir for pip (reduces layer size)
- ✅ Install only runtime dependencies (libpq5 for PostgreSQL)
- ✅ Copy only .local pip packages (not full /usr/local)
- ✅ Non-root user (appuser UID 1001)
- ✅ Built-in healthcheck

**Expected Size**: 350-450MB (vs 1GB+ for non-optimized)

### .dockerignore Files

**Frontend .dockerignore**:
```
node_modules
.next
.git
.gitignore
*.md
.env*
.vscode
.idea
Dockerfile
docker-compose.yml
```

**Backend .dockerignore**:
```
__pycache__
*.pyc
.venv
.git
.gitignore
*.md
.env*
.vscode
.idea
Dockerfile
tests/
```

### Alternatives Considered
- **Single-stage builds**: Rejected due to large image size
- **Distroless base images**: Deferred to production phase (adds complexity)
- **Alpine for Python**: Rejected due to compilation issues with some packages

### Outcome
**Frontend pattern**: node:18-alpine two-stage with standalone output
**Backend pattern**: python:3.11-slim with pip --user installation
**Size targets validated**: Frontend < 200MB, Backend < 500MB achievable

---

## R5: Kubernetes Resource Sizing for Local Minikube

### Decision
Use **conservative resource requests with headroom in limits** optimized for 4GB Minikube cluster.

### Sizing Strategy

**Minikube Cluster Configuration**:
```bash
minikube start --cpus=2 --memory=4096 --disk-size=20gb
```

**Resource Allocation**:

| Component | Replicas | CPU Request | CPU Limit | Memory Request | Memory Limit |
|-----------|----------|-------------|-----------|----------------|--------------|
| Frontend  | 2        | 100m        | 500m      | 256Mi          | 512Mi        |
| Backend   | 1        | 200m        | 1000m     | 512Mi          | 1Gi          |
| **Total** | **3**    | **400m**    | **2000m** | **1024Mi**     | **2Gi**      |

**Cluster Capacity**: 2000m CPU, 4096Mi RAM
**Used for Pods**: 400m CPU (20%), 1024Mi RAM (25%)
**Reserved for System**: 1600m CPU (80%), 3072Mi RAM (75%)

### Rationale
- Request values guarantee minimum resources for pod scheduling
- Limit values prevent resource exhaustion and OOMKill
- Leaves substantial headroom for Kubernetes system components
- 2:1 memory limit-to-request ratio allows bursting without waste

### Probe Configuration

**Liveness Probes** (restart unhealthy containers):
```yaml
livenessProbe:
  httpGet:
    path: / # or /health for backend
    port: 3000 # or 8000 for backend
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 3
  failureThreshold: 3
```

**Readiness Probes** (remove from load balancer when not ready):
```yaml
readinessProbe:
  httpGet:
    path: / # or /health for backend
    port: 3000 # or 8000 for backend
  initialDelaySeconds: 5
  periodSeconds: 10
  timeoutSeconds: 3
  failureThreshold: 3
```

### Alternatives Considered
- **Higher requests**: Rejected - may prevent scheduling on 2 CPU cluster
- **No limits**: Rejected - risks OOMKill and node instability
- **1:1 limit-to-request ratio**: Rejected - too restrictive for burst workloads

### Outcome
**CPU**: Request 100m/200m, Limit 500m/1000m
**Memory**: Request 256Mi/512Mi, Limit 512Mi/1Gi
**Probes**: 10s interval, 3 failure threshold
**Validated**: Fits comfortably in 2 CPU / 4GB RAM Minikube cluster

---

## R6: Helm Chart Generation Strategy

### Decision
Use **hybrid approach**: `helm create` for scaffolding + kubectl-ai for template generation.

### Workflow

**Step 1: Scaffold Chart Structure**
```bash
mkdir -p kubernetes/helm-chart
cd kubernetes/helm-chart
helm create todo-chatbot

# This creates:
# Chart.yaml
# values.yaml
# templates/ (with default deployment, service, etc.)
# .helmignore
```

**Step 2: Customize Chart.yaml**
```yaml
apiVersion: v2
name: todo-chatbot
description: Helm chart for Todo Chatbot (Next.js frontend + FastAPI backend)
type: application
version: 1.0.0
appVersion: "1.0.0"
maintainers:
  - name: Phase IV Deployment Team
```

**Step 3: Generate Templates with kubectl-ai**
```bash
# Frontend deployment
kubectl ai "create Kubernetes deployment YAML with Helm templating:
  name: {{ .Release.Name }}-frontend
  replicas: {{ .Values.frontend.replicas }}
  image: {{ .Values.frontend.image }}:{{ .Values.frontend.tag }}
  ..." > templates/frontend-deployment.yaml

# Frontend service
kubectl ai "create Kubernetes service YAML with Helm templating:
  name: {{ .Release.Name }}-frontend
  type: NodePort
  nodePort: {{ .Values.frontend.service.nodePort }}
  ..." > templates/frontend-service.yaml
```

**Step 4: Define values.yaml**
Structure as defined in plan.md Design Task D5

**Step 5: Create Template Helpers**
```yaml
# templates/_helpers.tpl
{{- define "todo-chatbot.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "todo-chatbot.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "todo-chatbot.labels" -}}
helm.sh/chart: {{ include "todo-chatbot.name" . }}
app.kubernetes.io/name: {{ include "todo-chatbot.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
```

### Validation Process
```bash
# Lint chart
helm lint kubernetes/helm-chart/

# Dry-run install
helm install todo-chatbot kubernetes/helm-chart/ --dry-run --debug -n todo-app

# Template rendering test
helm template todo-chatbot kubernetes/helm-chart/ -n todo-app
```

### Alternatives Considered
- **kubectl-ai only**: Rejected - doesn't scaffold full chart structure
- **Manual chart creation**: Rejected - violates "no manual coding" constraint
- **Chartmuseum or public charts**: Rejected - need custom chart for this app

### Outcome
**Primary method**: helm create + kubectl-ai templates + Claude Code for helpers
**Validation**: helm lint + dry-run before actual deployment
**Quality**: All templates follow Helm best practices

---

## R7: Health Check Endpoint Verification

### Decision
Verify existing health endpoints in Phase III application and add if missing.

### Frontend Health Check

**Next.js Default**: GET `/` returns 200 OK
- Next.js root route automatically responds
- No explicit health endpoint needed
- Liveness/Readiness probes can use `GET /`

**Verification**:
```bash
cd ../todo_phase3/frontend
npm run dev &
sleep 5
curl -I http://localhost:3000/
# Expected: HTTP/1.1 200 OK
```

**Status**: ✅ No changes needed - default Next.js route sufficient

### Backend Health Check

**Expected Endpoint**: GET `/health` returns 200 OK with JSON status

**Phase III Code Review**:
```bash
# Check if /health endpoint exists
grep -n "health" ../todo_phase3/backend/src/main.py
```

**If Missing**, add to main.py:
```python
@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "todo-chatbot-backend",
        "version": "1.0.0"
    }
```

**Verification**:
```bash
cd ../todo_phase3/backend
python start.py &
sleep 5
curl http://localhost:8000/health
# Expected: {"status":"healthy",...}
```

**Status**: ⚠️ Needs verification - if missing, will be added in Phase 1

### Health Check Configuration in Kubernetes

**Frontend**:
```yaml
livenessProbe:
  httpGet:
    path: /
    port: 3000
  initialDelaySeconds: 10

readinessProbe:
  httpGet:
    path: /
    port: 3000
  initialDelaySeconds: 5
```

**Backend**:
```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8000
  initialDelaySeconds: 10

readinessProbe:
  httpGet:
    path: /health
    port: 8000
  initialDelaySeconds: 5
```

### Outcome
**Frontend**: Use GET / (Next.js default) ✅
**Backend**: Verify /health exists, add if missing ⚠️
**Configuration**: Document probe paths in Helm templates

---

## R8: External Database Connection from Kubernetes

### Decision
Use **Kubernetes Secret** for DATABASE_URL with environment variable injection into backend pods.

### Secret Creation Strategy

**Step 1: Prepare Secret Values**
```bash
# Get actual connection string from .env
DATABASE_URL="postgresql://user:password@host.region.neon.tech:5432/dbname?sslmode=require"

# Base64 encode (Kubernetes requirement)
echo -n "$DATABASE_URL" | base64
```

**Step 2: Create Secret Manifest**
```yaml
# kubernetes/helm-chart/templates/secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "todo-chatbot.fullname" . }}-secrets
  labels:
    {{- include "todo-chatbot.labels" . | nindent 4 }}
type: Opaque
data:
  DATABASE_URL: {{ .Values.secrets.databaseUrl | b64enc | quote }}
  OPENAI_API_KEY: {{ .Values.secrets.openaiApiKey | b64enc | quote }}
  BETTER_AUTH_SECRET: {{ .Values.secrets.jwtSecret | b64enc | quote }}
```

**Step 3: Reference in Deployment**
```yaml
# backend-deployment.yaml
spec:
  containers:
  - name: backend
    env:
    - name: DATABASE_URL
      valueFrom:
        secretKeyRef:
          name: {{ include "todo-chatbot.fullname" . }}-secrets
          key: DATABASE_URL
    - name: OPENAI_API_KEY
      valueFrom:
        secretKeyRef:
          name: {{ include "todo-chatbot.fullname" . }}-secrets
          key: OPENAI_API_KEY
```

**Step 4: Update values.yaml with Placeholders**
```yaml
secrets:
  # IMPORTANT: Replace with actual values before deployment
  databaseUrl: "REPLACE_WITH_ACTUAL_DATABASE_URL"
  openaiApiKey: "REPLACE_WITH_ACTUAL_OPENAI_KEY"
  jwtSecret: "REPLACE_WITH_ACTUAL_JWT_SECRET"
```

### Deployment Workflow

**Pre-Deployment**:
1. Copy Phase III `.env` file
2. Extract DATABASE_URL, OPENAI_API_KEY, BETTER_AUTH_SECRET
3. Update values.yaml OR create values-local.yaml with actual values
4. **Never commit actual secrets to Git**

**Installation Command**:
```bash
# Option 1: Update values.yaml locally (not committed)
helm install todo-chatbot kubernetes/helm-chart/ -n todo-app

# Option 2: Override with command-line values
helm install todo-chatbot kubernetes/helm-chart/ -n todo-app \
  --set secrets.databaseUrl="postgresql://..." \
  --set secrets.openaiApiKey="sk-..." \
  --set secrets.jwtSecret="secret123"

# Option 3: Use separate values file (gitignored)
helm install todo-chatbot kubernetes/helm-chart/ -n todo-app \
  -f kubernetes/helm-chart/values-local.yaml
```

### Security Best Practices

✅ Secrets base64 encoded in Kubernetes
✅ Secrets not committed to Git (values-local.yaml in .gitignore)
✅ Secrets injected as environment variables (not files)
✅ Secret rotation: Update values.yaml and helm upgrade
❌ **NOT using**: External secret managers (Vault) - deferred to production phase

### Network Considerations

**Neon PostgreSQL Access**:
- Neon allows connections from any IP by default
- SSL/TLS required (sslmode=require in connection string)
- Pods can reach external internet (no network policies in Phase IV)
- If connection fails, check:
  - DNS resolution: `kubectl run -it --rm debug --image=busybox -- nslookup <neon-host>`
  - Network connectivity: `kubectl run -it --rm debug --image=curlimages/curl -- curl <neon-host>:5432`

### Alternatives Considered
- **Database in Kubernetes**: Rejected - adds complexity, Phase III already has Neon
- **External Secrets Operator**: Rejected - overkill for local development
- **ConfigMap for secrets**: Rejected - insecure, secrets not base64 protected

### Outcome
**Method**: Kubernetes Secret with base64 encoding
**Injection**: Environment variables in deployment
**Management**: values-local.yaml (gitignored) or --set overrides
**Documentation**: Secrets setup documented in quickstart.md

---

## Research Completion Summary

### All Unknowns Resolved ✅

| Research Task | Status | Outcome |
|---------------|--------|---------|
| R1: Docker AI Availability | ✅ Complete | Claude Code primary, Docker AI optional |
| R2: kubectl-ai Setup | ✅ Complete | Install via krew, use for manifest generation |
| R3: kagent Analysis | ✅ Complete | Optional, kubectl native sufficient |
| R4: Multi-Stage Builds | ✅ Complete | Two-stage pattern validated for both services |
| R5: Resource Sizing | ✅ Complete | Conservative requests, 2x limit ratios |
| R6: Helm Generation | ✅ Complete | Hybrid: helm create + kubectl-ai |
| R7: Health Endpoints | ✅ Complete | Frontend: /, Backend: /health |
| R8: Database Connection | ✅ Complete | Kubernetes Secret with env injection |

### Ready for Phase 1 ✅

All technical decisions documented with:
- ✅ Clear rationale for each choice
- ✅ Alternatives considered and rejected
- ✅ Implementation commands and examples
- ✅ Validation steps and acceptance criteria

**Next Step**: Proceed to Phase 1 - Design & Infrastructure Artifacts

---

**Research Phase Complete** | **Date**: 2026-01-28 | **Status**: Approved for Phase 1
