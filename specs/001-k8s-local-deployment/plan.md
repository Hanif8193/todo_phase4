# Implementation Plan: Local Kubernetes Deployment for Todo Chatbot

**Branch**: `001-k8s-local-deployment` | **Date**: 2026-01-28 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-k8s-local-deployment/spec.md`

---

## Summary

Deploy the existing Phase III Todo Chatbot application (Next.js frontend + FastAPI backend) to a local Kubernetes cluster using Minikube. All infrastructure artifacts (Dockerfiles, Kubernetes manifests, Helm charts) will be generated using AI tools (Docker AI/Gordon, kubectl-ai, kagent) with human review and approval only. The deployment will expose services via NodePort (frontend: 30080, backend: 30800) for local access. This plan follows strict spec-driven, AI-assisted workflow with zero manual coding.

**Primary Requirement**: Containerize and deploy Phase III application to local Kubernetes with Helm packaging, AI-generated artifacts, and complete documentation.

**Technical Approach**: Six-phase deployment pipeline: Environment Validation → Containerization → Cluster Setup → Helm Chart Generation → Deployment → Verification. Each phase uses AI tools as first-class citizens with documented prompts and outputs.

---

## Technical Context

**Language/Version**:
- Frontend: Node.js 18.x / Next.js 14.x (TypeScript 5.x)
- Backend: Python 3.11+ / FastAPI 0.109+

**Primary Dependencies**:
- Frontend: Next.js, React 18, Tailwind CSS, TypeScript
- Backend: FastAPI, SQLModel, OpenAI SDK, PyJWT, asyncpg, Uvicorn
- Infrastructure: Docker 24.x, Kubernetes 1.28+ (Minikube), Helm 3.x

**Storage**:
- External Neon PostgreSQL (not in Kubernetes cluster)
- Connection managed via Kubernetes Secrets

**Testing**:
- Infrastructure validation: `docker build`, `helm lint`, `kubectl apply --dry-run`
- Deployment verification: Health check endpoints, end-to-end user workflow
- Resilience testing: Pod deletion and auto-recovery

**Target Platform**:
- Local development environment (Windows/Linux/macOS)
- Kubernetes via Minikube or Docker Desktop
- External database access required

**Project Type**:
- Web application (frontend + backend services)
- Infrastructure-as-code with Helm packaging

**Performance Goals**:
- Deployment time: < 10 minutes
- Pod startup time: < 3 minutes
- Application ready: < 30 seconds after pods running
- Image build time: Frontend < 5 minutes, Backend < 3 minutes

**Constraints**:
- Frontend image size: < 200MB
- Backend image size: < 500MB
- Resource usage: Frontend < 500m CPU / 512Mi RAM, Backend < 1 CPU / 1Gi RAM
- Zero manual coding: All artifacts AI-generated
- Local-only deployment: No cloud resources

**Scale/Scope**:
- Frontend: 2 replicas for load distribution
- Backend: 1 replica (stateless, can scale later)
- Single namespace: `todo-app`
- NodePort access only (no Ingress)

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*

### ✅ Principle I: Spec-Driven Infrastructure Development
- [x] Specification created and validated (spec.md with 16/16 quality checks passed)
- [x] Planning phase follows specification requirements
- [x] All infrastructure changes traceable to spec requirements
- [x] AI tools preferred over manual creation (Docker AI, kubectl-ai, kagent)

### ✅ Principle II: AI-First DevOps Tooling
- [x] Plan includes Docker AI (Gordon) for Dockerfile generation
- [x] Plan includes kubectl-ai for Kubernetes manifest generation
- [x] Plan includes kagent for cluster analysis
- [x] Human role limited to review and approval
- [x] All AI prompts will be documented in ai-prompts-log.md

### ✅ Principle III: Cloud-Native Best Practices
- [x] Multi-stage Docker builds planned for image optimization
- [x] Non-root user execution specified
- [x] Health check endpoints required
- [x] Resource requests and limits defined
- [x] Rolling update strategy specified (maxSurge: 1, maxUnavailable: 0)

### ✅ Principle IV: Helm Chart Management
- [x] Helm chart structure defined (Chart.yaml, values.yaml, templates/)
- [x] Values parameterization planned
- [x] Chart versioning strategy defined (semantic versioning 1.0.0)
- [x] Atomic installs and rollback capability planned

### ✅ Principle V: Local Development Environment
- [x] Minikube/Docker Desktop Kubernetes specified
- [x] Namespace: `todo-app`
- [x] NodePort access: 30080 (frontend), 30800 (backend)
- [x] Minimum resources: 2 CPU cores, 4GB RAM documented

**Constitution Status**: ✅ **ALL GATES PASSED** - Proceeding to Phase 0 Research

---

## Project Structure

### Documentation (this feature)

```text
specs/001-k8s-local-deployment/
├── spec.md                      # Feature specification (COMPLETE)
├── plan.md                      # This file - implementation plan (IN PROGRESS)
├── research.md                  # Phase 0 output - AI tool research
├── deployment-architecture.md   # Phase 1 output - architecture diagram
├── helm-chart-design.md         # Phase 1 output - Helm chart structure
├── ai-prompts-log.md            # Phase 1 output - All AI prompts used
├── quickstart.md                # Phase 1 output - Deployment runbook
├── checklists/
│   ├── requirements.md          # Specification validation (COMPLETE)
│   └── deployment.md            # Phase 2 output - Deployment checklist
└── tasks.md                     # Phase 2 output (/sp.tasks command)
```

### Infrastructure (repository root)

```text
# Existing Phase III application structure (unchanged)
backend/
├── src/
│   ├── api/              # FastAPI endpoints
│   ├── models/           # Database models
│   ├── services/         # Business logic (AgentService, ConversationService)
│   ├── mcp_server/       # MCP tools (add_task, complete_task, etc.)
│   ├── auth/             # JWT authentication
│   ├── database/         # Database connection
│   ├── config.py         # Configuration
│   └── main.py           # FastAPI app entry point
├── requirements.txt      # Python dependencies
└── start.py              # Application starter

frontend/
├── app/
│   ├── login/            # Login page
│   ├── register/         # Registration page
│   ├── chat/             # Chat interface
│   └── tasks/            # Task management
├── components/           # Reusable UI components
├── lib/                  # Utilities (auth.ts, api.ts)
├── package.json          # Node.js dependencies
└── next.config.mjs       # Next.js configuration

# New Phase IV infrastructure (to be created)
kubernetes/
├── dockerfiles/
│   ├── frontend.Dockerfile    # Generated by Docker AI (Phase 1)
│   └── backend.Dockerfile     # Generated by Docker AI (Phase 1)
├── helm-chart/
│   ├── Chart.yaml             # Generated by kubectl-ai (Phase 1)
│   ├── values.yaml            # Generated by kubectl-ai (Phase 1)
│   ├── values-dev.yaml        # Local overrides (Phase 1)
│   ├── templates/
│   │   ├── frontend-deployment.yaml    # Generated by kubectl-ai (Phase 1)
│   │   ├── frontend-service.yaml       # Generated by kubectl-ai (Phase 1)
│   │   ├── backend-deployment.yaml     # Generated by kubectl-ai (Phase 1)
│   │   ├── backend-service.yaml        # Generated by kubectl-ai (Phase 1)
│   │   ├── configmap.yaml              # Generated by kubectl-ai (Phase 1)
│   │   ├── secrets.yaml                # Generated by kubectl-ai (Phase 1)
│   │   ├── _helpers.tpl                # Generated by kubectl-ai (Phase 1)
│   │   └── NOTES.txt                   # Post-install instructions (Phase 1)
│   └── README.md              # Chart documentation (Phase 1)
└── scripts/
    ├── build-images.sh        # Image build automation (Phase 1)
    ├── deploy.sh              # Deployment automation (Phase 2)
    └── validate.sh            # Validation automation (Phase 2)
```

**Structure Decision**: This is a web application with existing frontend and backend services. Phase IV adds containerization and orchestration infrastructure under a new `kubernetes/` directory. The Phase III source code remains unchanged. All Dockerfiles, Helm charts, and automation scripts will be AI-generated and stored in the `kubernetes/` directory for clear separation of application code and infrastructure code.

---

## Complexity Tracking

> **No violations detected** - All constitution principles are followed without exceptions.

---

## Phase 0: Research & AI Tool Validation

**Objective**: Validate AI tool availability, research best practices, and resolve any unknowns from Technical Context.

### Research Tasks

#### R1: Docker AI (Gordon) Availability Assessment

**Question**: Is Docker AI (Gordon) available in the local environment? What are fallback options?

**Research Action**:
```bash
# Check Docker AI availability
docker ai --version

# If not available, check Docker Desktop version
docker version

# Research alternative: Use Claude Code to generate Dockerfiles with review
```

**Expected Outcome**: Document whether Gordon is available. If not, plan to use Claude Code with explicit Dockerfile generation prompts and manual review.

**Documented In**: `research.md` section "Docker AI Tool Assessment"

---

#### R2: kubectl-ai Installation and Configuration

**Question**: How to install kubectl-ai? What are its capabilities for Helm chart generation?

**Research Action**:
```bash
# Check if kubectl-ai is installed
kubectl ai --version

# If not installed, research installation:
# Option 1: kubectl plugin manager (krew)
kubectl krew install ai

# Option 2: Direct installation from GitHub releases
# https://github.com/sozercan/kubectl-ai
```

**Expected Outcome**: Installation instructions and verification that kubectl-ai supports Helm chart scaffolding.

**Documented In**: `research.md` section "kubectl-ai Setup Guide"

---

#### R3: kagent Availability and Use Cases

**Question**: Is kagent available? What specific analysis can it perform for this deployment?

**Research Action**:
```bash
# Check kagent availability
kagent version

# Research capabilities:
# - Cluster resource analysis
# - Pod optimization recommendations
# - Deployment health checks
```

**Expected Outcome**: Document kagent capabilities or identify alternatives (kubectl top, kubectl describe, manual analysis).

**Documented In**: `research.md` section "kagent Analysis Capabilities"

---

#### R4: Multi-Stage Docker Build Best Practices

**Question**: What are the optimal multi-stage build patterns for Next.js and FastAPI?

**Research Action**:
- Next.js: Builder stage (dependencies + build) → Runtime stage (standalone output)
- FastAPI: Builder stage (pip install) → Runtime stage (copy site-packages)
- Base image selection: node:18-alpine for Next.js, python:3.11-slim for FastAPI

**Expected Outcome**: Document recommended Dockerfile patterns to guide AI generation prompts.

**Documented In**: `research.md` section "Multi-Stage Build Patterns"

---

#### R5: Kubernetes Resource Sizing for Local Minikube

**Question**: What are appropriate resource requests/limits for local development?

**Research Action**:
- Minikube default resources: 2 CPUs, 2GB RAM (can be increased)
- Frontend pod: 100m CPU request, 500m limit / 256Mi request, 512Mi limit
- Backend pod: 200m CPU request, 1000m limit / 512Mi request, 1Gi limit
- Total: ~1.3 CPU / ~1.8GB RAM for 3 pods (2 frontend + 1 backend)

**Expected Outcome**: Validated resource specifications that fit in constrained local environment.

**Documented In**: `research.md` section "Resource Sizing Strategy"

---

#### R6: Helm Chart Generation with kubectl-ai

**Question**: Can kubectl-ai scaffold a complete Helm chart or only individual manifests?

**Research Action**:
```bash
# Test kubectl-ai Helm capabilities
kubectl ai "generate helm chart for web application"

# Alternative: Use helm create command with AI-assisted template customization
helm create todo-chatbot-chart
```

**Expected Outcome**: Determine whether to use kubectl-ai for full chart generation or helm create + AI-assisted editing.

**Documented In**: `research.md` section "Helm Chart Generation Strategy"

---

#### R7: Health Check Endpoint Verification

**Question**: Do Phase III frontend and backend have health check endpoints?

**Research Action**:
```bash
# Check backend health endpoint
# Expected: GET /health returns 200 OK

# Check frontend health endpoint
# Expected: GET / returns 200 OK (Next.js default)

# Review Phase III code:
cat ../todo_phase3/backend/src/main.py | grep -A5 "/health"
```

**Expected Outcome**: Confirm health endpoints exist or identify need to add them before containerization.

**Documented In**: `research.md` section "Health Check Verification"

---

#### R8: External Database Connection from Kubernetes

**Question**: How should database connection strings be managed for external Neon PostgreSQL?

**Research Action**:
- Kubernetes Secret for DATABASE_URL (base64 encoded)
- Backend deployment references secret as environment variable
- ConfigMap for non-sensitive config (OPENAI_API_KEY placeholder, LOG_LEVEL, etc.)

**Expected Outcome**: Document secret creation strategy and environment variable injection pattern.

**Documented In**: `research.md` section "External Database Integration"

---

### Research Output

**Deliverable**: `specs/001-k8s-local-deployment/research.md`

This file will contain:
- Docker AI availability status and fallback plan
- kubectl-ai installation instructions
- kagent capabilities or alternatives
- Multi-stage Dockerfile patterns for Next.js and FastAPI
- Resource sizing recommendations
- Helm chart generation strategy
- Health check endpoint verification results
- Database secret management approach

**Phase 0 Complete When**: All research tasks completed, all NEEDS CLARIFICATION resolved, research.md reviewed and approved.

---

## Phase 1: Design & Infrastructure Artifacts

**Objective**: Generate all infrastructure artifacts (Dockerfiles, Kubernetes manifests, Helm charts) using AI tools. Document all prompts and outputs.

**Prerequisites**: Phase 0 research.md complete, AI tools validated or alternatives identified.

---

### Design Task D1: Deployment Architecture Diagram

**Goal**: Create visual representation of deployment architecture.

**AI Tool**: Claude Code (this session) with Mermaid diagram generation

**Prompt**:
```
Create a deployment architecture diagram using Mermaid syntax showing:
1. Local machine with Docker Desktop and Minikube
2. Kubernetes cluster with namespace: todo-app
3. Frontend deployment (2 replicas) with NodePort service (30080)
4. Backend deployment (1 replica) with NodePort service (30800)
5. External Neon PostgreSQL database
6. ConfigMap and Secret resources
7. Traffic flow: Browser → NodePort → Service → Pods → External DB
```

**Expected Output**: Mermaid diagram code that renders deployment architecture

**Saved To**: `specs/001-k8s-local-deployment/deployment-architecture.md`

**Acceptance**: Diagram clearly shows all components, connections, and NodePort access pattern

---

### Design Task D2: Frontend Dockerfile Generation

**Goal**: Generate optimized multi-stage Dockerfile for Next.js frontend.

**AI Tool**: Docker AI (Gordon) if available, otherwise Claude Code with expert guidance

**Prompt (if Docker AI available)**:
```bash
docker ai "Create a multi-stage Dockerfile for a Next.js 14 frontend application.
Requirements:
- Base image: node:18-alpine
- Builder stage: Install dependencies and build Next.js
- Runtime stage: Use standalone output for minimal image size
- Target size: < 200MB
- Run as non-root user (node)
- Expose port 3000
- Health check: GET / returns 200
- Working directory: /app
- Environment variables via build args: NEXT_PUBLIC_API_URL"
```

**Alternative Prompt (Claude Code)**:
```
Generate a production-ready multi-stage Dockerfile for Next.js 14 with:
- Builder stage: COPY package*.json, npm ci, COPY source, npm run build
- Runtime stage: Copy standalone output only, node:18-alpine base
- Non-root user execution
- Image size optimization (remove dev dependencies, use .dockerignore)
- Environment variable support for NEXT_PUBLIC_API_URL
```

**Expected Output**: Dockerfile with ~15-25 lines, two stages (builder + runtime)

**Saved To**: `kubernetes/dockerfiles/frontend.Dockerfile`

**Acceptance**:
- Builds successfully: `docker build -f kubernetes/dockerfiles/frontend.Dockerfile -t todo-frontend:1.0.0 ./frontend`
- Image size < 200MB: `docker images todo-frontend:1.0.0`
- Container runs: `docker run -p 3000:3000 todo-frontend:1.0.0`

---

### Design Task D3: Backend Dockerfile Generation

**Goal**: Generate optimized Dockerfile for FastAPI backend.

**AI Tool**: Docker AI (Gordon) if available, otherwise Claude Code

**Prompt (if Docker AI available)**:
```bash
docker ai "Create a Dockerfile for a FastAPI backend application with Python 3.11.
Requirements:
- Base image: python:3.11-slim
- Install dependencies from requirements.txt
- Copy source code to /app
- Run as non-root user
- Expose port 8000
- Health check: GET /health returns 200
- Use uvicorn as ASGI server
- Command: uvicorn src.main:app --host 0.0.0.0 --port 8000"
```

**Alternative Prompt (Claude Code)**:
```
Generate a production-ready Dockerfile for FastAPI backend with:
- Base: python:3.11-slim
- Install system dependencies (if needed for asyncpg: libpq-dev)
- Copy requirements.txt and pip install --no-cache-dir
- Copy src/ directory
- Create non-root user and switch to it
- Expose 8000
- CMD uvicorn with appropriate flags
```

**Expected Output**: Dockerfile with ~10-15 lines

**Saved To**: `kubernetes/dockerfiles/backend.Dockerfile`

**Acceptance**:
- Builds successfully: `docker build -f kubernetes/dockerfiles/backend.Dockerfile -t todo-backend:1.0.0 ./backend`
- Image size < 500MB: `docker images todo-backend:1.0.0`
- Container runs with health check: `docker run -p 8000:8000 -e DATABASE_URL=postgresql://... todo-backend:1.0.0`

---

### Design Task D4: Helm Chart Scaffolding

**Goal**: Generate Helm chart structure with all required templates.

**AI Tool**: kubectl-ai or helm create + AI-assisted customization

**Approach 1 (kubectl-ai)**:
```bash
kubectl ai "Generate a Helm chart for a web application with:
- Chart name: todo-chatbot
- Frontend deployment: 2 replicas, image todo-frontend:1.0.0
- Backend deployment: 1 replica, image todo-backend:1.0.0
- Frontend service: NodePort 30080
- Backend service: NodePort 30800
- ConfigMap for environment variables
- Secret for database credentials
- Include values.yaml with all configurable parameters"
```

**Approach 2 (helm create + customization)**:
```bash
# Create base chart
helm create kubernetes/helm-chart/todo-chatbot

# Then use kubectl-ai to generate individual templates:
kubectl ai "create Kubernetes deployment for frontend:
- Name: frontend
- Replicas: 2
- Image: {{ .Values.frontend.image }}:{{ .Values.frontend.tag }}
- Port: 3000
- Resource limits: 500m CPU, 512Mi memory
- Health checks: liveness and readiness on /"

kubectl ai "create Kubernetes service for frontend:
- Name: frontend
- Type: NodePort
- NodePort: 30080
- Target port: 3000
- Selector: app=frontend"
```

**Expected Output**: Complete Helm chart structure as defined in Project Structure section

**Saved To**: `kubernetes/helm-chart/` directory

**Acceptance**:
- Chart validates: `helm lint kubernetes/helm-chart/`
- Dry-run succeeds: `helm install todo-chatbot kubernetes/helm-chart/ --dry-run --debug`
- All templates render correctly

---

### Design Task D5: values.yaml Configuration

**Goal**: Define all configurable values for the Helm chart.

**AI Tool**: kubectl-ai or Claude Code

**Prompt**:
```
Generate a values.yaml file for the todo-chatbot Helm chart with:

frontend:
  image: todo-frontend
  tag: "1.0.0"
  replicas: 2
  service:
    type: NodePort
    nodePort: 30080
    port: 3000
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
    limits:
      cpu: 500m
      memory: 512Mi
  env:
    NEXT_PUBLIC_API_URL: "http://localhost:30800"

backend:
  image: todo-backend
  tag: "1.0.0"
  replicas: 1
  service:
    type: NodePort
    nodePort: 30800
    port: 8000
  resources:
    requests:
      cpu: 200m
      memory: 512Mi
    limits:
      cpu: 1000m
      memory: 1Gi
  env:
    ENVIRONMENT: "development"
    LOG_LEVEL: "INFO"
    PORT: "8000"

secrets:
  databaseUrl: "REPLACE_WITH_ACTUAL_DATABASE_URL"
  openaiApiKey: "REPLACE_WITH_ACTUAL_OPENAI_KEY"
  jwtSecret: "REPLACE_WITH_ACTUAL_JWT_SECRET"
```

**Expected Output**: values.yaml with ~50-70 lines

**Saved To**: `kubernetes/helm-chart/values.yaml`

**Acceptance**: All values parameterized, no hardcoded sensitive data

---

### Design Task D6: Deployment Templates

**Goal**: Generate Kubernetes Deployment manifests for frontend and backend.

**AI Tool**: kubectl-ai

**Frontend Deployment Prompt**:
```bash
kubectl ai "create Kubernetes deployment manifest using Helm templating:
- Name: {{ include \"todo-chatbot.fullname\" . }}-frontend
- Replicas: {{ .Values.frontend.replicas }}
- Image: {{ .Values.frontend.image }}:{{ .Values.frontend.tag }}
- Container port: {{ .Values.frontend.service.port }}
- Environment variables from ConfigMap: API_URL
- Resource requests and limits from values
- Liveness probe: httpGet on / every 10s
- Readiness probe: httpGet on / every 10s
- Rolling update strategy: maxSurge 1, maxUnavailable 0"
```

**Backend Deployment Prompt**:
```bash
kubectl ai "create Kubernetes deployment manifest using Helm templating:
- Name: {{ include \"todo-chatbot.fullname\" . }}-backend
- Replicas: {{ .Values.backend.replicas }}
- Image: {{ .Values.backend.image }}:{{ .Values.backend.tag }}
- Container port: {{ .Values.backend.service.port }}
- Environment variables from ConfigMap and Secret
- Resource requests and limits from values
- Liveness probe: httpGet on /health every 10s
- Readiness probe: httpGet on /health every 10s
- Rolling update strategy: maxSurge 1, maxUnavailable 0"
```

**Expected Output**: Two deployment YAML files with Helm templating

**Saved To**:
- `kubernetes/helm-chart/templates/frontend-deployment.yaml`
- `kubernetes/helm-chart/templates/backend-deployment.yaml`

**Acceptance**: Templates render correctly with `helm template`, include all required fields

---

### Design Task D7: Service Templates

**Goal**: Generate Kubernetes Service manifests with NodePort configuration.

**AI Tool**: kubectl-ai

**Prompt**:
```bash
kubectl ai "create two Kubernetes service manifests using Helm templating:

Service 1 (Frontend):
- Name: {{ include \"todo-chatbot.fullname\" . }}-frontend
- Type: {{ .Values.frontend.service.type }}
- NodePort: {{ .Values.frontend.service.nodePort }}
- Port: {{ .Values.frontend.service.port }}
- Selector: app=frontend

Service 2 (Backend):
- Name: {{ include \"todo-chatbot.fullname\" . }}-backend
- Type: {{ .Values.backend.service.type }}
- NodePort: {{ .Values.backend.service.nodePort }}
- Port: {{ .Values.backend.service.port }}
- Selector: app=backend"
```

**Expected Output**: Two service YAML files with NodePort configuration

**Saved To**:
- `kubernetes/helm-chart/templates/frontend-service.yaml`
- `kubernetes/helm-chart/templates/backend-service.yaml`

**Acceptance**: Services expose correct ports, NodePort values match spec (30080, 30800)

---

### Design Task D8: ConfigMap and Secret Templates

**Goal**: Generate ConfigMap for non-sensitive configuration and Secret template.

**AI Tool**: kubectl-ai or Claude Code

**ConfigMap Prompt**:
```bash
kubectl ai "create Kubernetes ConfigMap manifest using Helm templating:
- Name: {{ include \"todo-chatbot.fullname\" . }}-config
- Data:
  - ENVIRONMENT: {{ .Values.backend.env.ENVIRONMENT }}
  - LOG_LEVEL: {{ .Values.backend.env.LOG_LEVEL }}
  - PORT: {{ .Values.backend.env.PORT }}
  - NEXT_PUBLIC_API_URL: {{ .Values.frontend.env.NEXT_PUBLIC_API_URL }}"
```

**Secret Prompt**:
```bash
kubectl ai "create Kubernetes Secret manifest using Helm templating:
- Name: {{ include \"todo-chatbot.fullname\" . }}-secrets
- Type: Opaque
- Data (base64 encoded):
  - DATABASE_URL: {{ .Values.secrets.databaseUrl | b64enc }}
  - OPENAI_API_KEY: {{ .Values.secrets.openaiApiKey | b64enc }}
  - JWT_SECRET: {{ .Values.secrets.jwtSecret | b64enc }}"
```

**Expected Output**: ConfigMap and Secret YAML files

**Saved To**:
- `kubernetes/helm-chart/templates/configmap.yaml`
- `kubernetes/helm-chart/templates/secrets.yaml`

**Acceptance**: Values properly templated, secrets base64 encoded

---

### Design Task D9: Helper Templates and Chart Metadata

**Goal**: Generate Chart.yaml, _helpers.tpl, and NOTES.txt.

**AI Tool**: kubectl-ai or Claude Code

**Chart.yaml Prompt**:
```
Generate Chart.yaml with:
- apiVersion: v2
- name: todo-chatbot
- description: Helm chart for Todo Chatbot application
- type: application
- version: 1.0.0
- appVersion: "1.0.0"
```

**_helpers.tpl Prompt**:
```
Generate Helm template helpers:
- todo-chatbot.fullname: Generate full resource names
- todo-chatbot.name: Chart name
- todo-chatbot.labels: Common labels for all resources
```

**NOTES.txt Prompt**:
```
Generate post-install notes showing:
- How to access frontend: http://localhost:30080
- How to access backend: http://localhost:30800
- How to check deployment status: kubectl get pods -n todo-app
- How to view logs: kubectl logs -f -n todo-app <pod-name>
```

**Expected Output**: Chart.yaml, _helpers.tpl, NOTES.txt

**Saved To**: `kubernetes/helm-chart/`

**Acceptance**: Chart metadata correct, helpers work, notes display after install

---

### Design Task D10: AI Prompts Documentation

**Goal**: Document all AI prompts used and their outputs.

**Format**:
```markdown
# AI Prompts Log - Phase IV Kubernetes Deployment

## Prompt 1: Frontend Dockerfile
**Tool**: Docker AI (Gordon)
**Date**: 2026-01-28
**Prompt**: [full prompt text]
**Output**: [Dockerfile generated or summary]
**Validation**: [build result, image size]
**Revisions**: [any manual corrections needed]

## Prompt 2: Backend Dockerfile
...
```

**Expected Output**: Complete log of all AI interactions

**Saved To**: `specs/001-k8s-local-deployment/ai-prompts-log.md`

**Acceptance**: Every AI-generated artifact has corresponding log entry

---

### Design Task D11: Deployment Runbook (Quickstart)

**Goal**: Create step-by-step deployment guide.

**AI Tool**: Claude Code (this session)

**Content Sections**:
1. Prerequisites Check (Docker, Minikube, Helm, kubectl)
2. Environment Setup (start Minikube, create namespace)
3. Build Container Images
4. Create Kubernetes Secrets (manual step for actual credentials)
5. Install Helm Chart
6. Verify Deployment (check pods, services, health)
7. Access Application (browser URLs)
8. Troubleshooting Common Issues

**Expected Output**: Comprehensive deployment guide with commands

**Saved To**: `specs/001-k8s-local-deployment/quickstart.md`

**Acceptance**: A team member can follow the guide and successfully deploy

---

### Phase 1 Outputs Summary

**Deliverables**:
1. ✅ deployment-architecture.md - Mermaid architecture diagram
2. ✅ kubernetes/dockerfiles/frontend.Dockerfile - AI-generated
3. ✅ kubernetes/dockerfiles/backend.Dockerfile - AI-generated
4. ✅ kubernetes/helm-chart/ - Complete Helm chart structure
5. ✅ ai-prompts-log.md - All AI prompts documented
6. ✅ quickstart.md - Deployment runbook
7. ✅ helm-chart-design.md - Helm chart design decisions

**Phase 1 Complete When**: All artifacts generated, validated (lint/dry-run), and documented. Ready for Phase 2 task breakdown.

---

## Phase 2: Task Breakdown

**Note**: Task breakdown will be created by the `/sp.tasks` command, not by `/sp.plan`.

This plan document ends after Phase 1. The next step is to run `/sp.tasks` to generate:
- Granular implementation tasks
- Task dependencies and ordering
- Acceptance criteria for each task
- Test cases for validation

**Expected Task Categories**:
1. Environment validation tasks (T-001 to T-003)
2. Dockerfile creation and image building (T-004 to T-008)
3. Helm chart generation and validation (T-009 to T-015)
4. Kubernetes deployment and verification (T-016 to T-022)
5. End-to-end testing and documentation (T-023 to T-025)

---

## Risk Mitigation Strategy

### Risk 1: AI Tools Not Available
**Mitigation**: Fallback to Claude Code with expert-guided prompts. Document all generation steps for future automation.

### Risk 2: Image Build Failures
**Mitigation**: Iterative approach - build frontend first, validate, then backend. Use explicit error handling in AI prompts.

### Risk 3: Resource Constraints on Minikube
**Mitigation**: Provide commands to increase Minikube resources (`minikube start --cpus=4 --memory=8192`). Reduce replica counts if needed.

### Risk 4: Database Connectivity from Pods
**Mitigation**: Test connectivity early with a standalone pod before full deployment. Document network requirements.

---

## Success Metrics

All success criteria from spec.md will be validated:
- ✅ Deployment time < 10 minutes (measured with time command)
- ✅ Pods running < 3 minutes (kubectl get pods timestamps)
- ✅ Application accessible < 30 seconds (manual browser test)
- ✅ Frontend image < 200MB (docker images output)
- ✅ Backend image < 500MB (docker images output)
- ✅ AI-generated artifacts (documented in ai-prompts-log.md)
- ✅ Zero manual coding (all changes via AI tools)
- ✅ Complete documentation (quickstart.md can be followed independently)

---

## Next Steps After Plan Approval

1. **Execute Phase 0**: Create research.md with AI tool validation
2. **Execute Phase 1**: Generate all infrastructure artifacts using documented prompts
3. **Run /sp.tasks**: Generate granular task breakdown for implementation
4. **Begin Implementation**: Execute tasks in dependency order with verification at each step

**Plan Status**: ✅ **READY FOR REVIEW AND APPROVAL**

Once approved, proceed with:
```bash
# Create research.md (manual or AI-assisted)
# Create deployment-architecture.md (Mermaid diagram)
# Run AI tools to generate Dockerfiles and Helm chart
# Document all prompts in ai-prompts-log.md
# Create quickstart.md deployment guide

# Then run:
/sp.tasks
```

---

**Plan Complete** | **Date**: 2026-01-28 | **Ready for Phase 0 Execution**
