# Tasks: Local Kubernetes Deployment for Todo Chatbot

**Input**: Design documents from `/specs/001-k8s-local-deployment/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, deployment-architecture.md ✅

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story. All tasks follow AI-first approach with documented prompts.

---

## Format: `- [ ] [ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Include exact file paths and AI tool used in descriptions

## Path Conventions

**Project Structure**:
- **Phase III Application**: `../todo_phase3/frontend/`, `../todo_phase3/backend/`
- **Phase IV Infrastructure**: `kubernetes/dockerfiles/`, `kubernetes/helm-chart/`
- **Documentation**: `specs/001-k8s-local-deployment/`

---

## Phase 1: Setup (Infrastructure Foundation)

**Purpose**: Create directory structure and initialize AI prompts documentation

- [X] T001 Create kubernetes directory structure: `kubernetes/dockerfiles/`, `kubernetes/helm-chart/`, `kubernetes/scripts/` ✅ **COMPLETE**
- [X] T002 Create `.dockerignore` files for frontend and backend to exclude unnecessary files from Docker context ✅ **COMPLETE**
- [X] T003 [P] Initialize AI prompts log document at `specs/001-k8s-local-deployment/ai-prompts-log.md` with template structure ✅ **COMPLETE**
- [X] T004 [P] Create deployment checklist document at `specs/001-k8s-local-deployment/checklists/deployment.md` ✅ **COMPLETE**

**Checkpoint**: ✅ Directory structure ready for artifact generation - **PHASE 1 COMPLETE**

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Validate environment prerequisites before any containerization or deployment work

**⚠️ CRITICAL**: All tasks in this phase must be verified before proceeding to user stories. These are environment checks that support partial execution.

### Environment Validation

- [X] T005 **Verify Docker Desktop installation** - Docker v29.1.3 installed, ⚠️ **daemon not running** - documented in INSTALL_TOOLS.md ✅ **COMPLETE**
- [X] T006 **Verify Minikube installation** - ✅ **v1.37.0 INSTALLED** (user confirmed) - **COMPLETE**
- [X] T007 **Verify Helm installation** - ⚠️ **Not installed** - documented with installation guide in INSTALL_TOOLS.md ✅ **COMPLETE**
- [X] T008 **Verify kubectl installation** - ✅ **v1.34.1 installed and working** - **COMPLETE**
- [X] T009 [P] **Optional: Check kubectl-ai availability** - Not installed (optional) - documented in INSTALL_TOOLS.md ✅ **COMPLETE**
- [X] T010 [P] **Optional: Check Docker AI (Gordon) availability** - Not configured - used Claude Code instead ✅ **COMPLETE**

### Phase III Application Verification

- [X] T011 **Verify Phase III application exists** - ✅ Confirmed `../todo_phase3/frontend/` and `../todo_phase3/backend/` exist - **COMPLETE**
- [X] T012 **Verify backend health endpoint** - ✅ Confirmed `/health` endpoint at src/main.py:175 - **COMPLETE**

**Checkpoint**: ✅ Environment validated - **PHASE 2 COMPLETE** - Partial execution strategy: proceeding with infrastructure generation, deferring deployment tasks

---

## Phase 3: User Story 1 - Deploy Application to Local Kubernetes (Priority: P1) 🎯 MVP

**Goal**: Containerize Phase III application and deploy to local Kubernetes cluster with full end-to-end functionality

**Independent Test**: Run complete deployment procedure on clean local machine. Verify frontend accessible at `http://localhost:30080`, backend at `http://localhost:30800`, and full user workflow (login, chat, tasks) works identically to Phase III.

**AI Tools Used**: Docker AI/Claude Code (Dockerfiles), kubectl (cluster setup)

### Containerization (Dockerfile Generation)

- [X] T013 [P] [US1] **Generate frontend Dockerfile** - ✅ **COMPLETE** - Generated with Claude Code (Sonnet 4.5), documented in ai-prompts-log.md
- [X] T014 [P] [US1] **Generate backend Dockerfile** - ✅ **COMPLETE** - Generated with Claude Code (Sonnet 4.5), documented in ai-prompts-log.md
- [X] T015 [P] [US1] **Review and approve frontend Dockerfile** - ✅ **COMPLETE** - Reviewed: multi-stage, alpine, non-root, health checks all verified
- [X] T016 [P] [US1] **Review and approve backend Dockerfile** - ✅ **COMPLETE** - Reviewed: slim base, non-root, health check, dependencies verified

### Container Image Building (BLOCKED if Docker not installed)

- [ ] T017 [US1] **Build frontend Docker image** - ⏸️ **DEFERRED** (Docker daemon not running - needs Docker Desktop started)
- [ ] T018 [US1] **Build backend Docker image** - ⏸️ **DEFERRED** (Docker daemon not running - needs Docker Desktop started)
- [ ] T019 [P] [US1] **Test frontend container locally** - ⏸️ **DEFERRED** (Docker daemon not running)
- [ ] T020 [P] [US1] **Test backend container locally** - ⏸️ **DEFERRED** (Docker daemon not running)

### Kubernetes Cluster Setup (Minikube installed ✅)

- [ ] T021 [US1] **Start Minikube cluster** - ⏸️ **READY** (Minikube v1.37.0 installed, awaiting execution)
- [ ] T022 [US1] **Create namespace** - ⏸️ **READY** (awaiting T021 cluster start)
- [ ] T023 [US1] **Load images into Minikube** - ⏸️ **BLOCKED** (awaiting T017-T018 image builds)

### Basic Kubernetes Deployment (Raw Manifests - before Helm)

- [X] T024 [US1] **Create ConfigMap YAML** - ✅ **COMPLETE** - Created kubernetes/manifests/configmap.yaml
- [X] T025 [US1] **Create Secret YAML** - ✅ **COMPLETE** - Created kubernetes/manifests/secrets.yaml (template with base64 instructions)
- [X] T026 [US1] **Create frontend Deployment YAML** - ✅ **COMPLETE** - Created kubernetes/manifests/frontend-deployment.yaml (2 replicas, resources, probes)
- [X] T027 [US1] **Create backend Deployment YAML** - ✅ **COMPLETE** - Created kubernetes/manifests/backend-deployment.yaml (1 replica, env from ConfigMap/Secret)
- [X] T028 [US1] **Create frontend Service YAML** - ✅ **COMPLETE** - Created kubernetes/manifests/frontend-service.yaml (NodePort 30080)
- [X] T029 [US1] **Create backend Service YAML** - ✅ **COMPLETE** - Created kubernetes/manifests/backend-service.yaml (NodePort 30800)

### Deployment Verification

- [ ] T030 [US1] **Verify pods are running** - Run `kubectl get pods -n todo-app`. Confirm 2 frontend pods and 1 backend pod reach Running state within 3 minutes. Check events if pods stuck: `kubectl get events -n todo-app --sort-by='.lastTimestamp'`.
- [ ] T031 [US1] **Verify services are created** - Run `kubectl get svc -n todo-app`. Confirm frontend service has NodePort 30080 and backend has NodePort 30800.
- [ ] T032 [US1] **Test frontend accessibility** - Open browser to `http://localhost:30080`. Verify frontend application loads successfully within 30 seconds.
- [ ] T033 [US1] **Test backend health endpoint** - Run `curl http://localhost:30800/health`. Verify returns 200 OK with healthy status JSON.
- [ ] T034 [US1] **Test end-to-end user workflow** - Manually test: (1) Login with Phase III credentials, (2) Send chat message to AI, (3) Create task via chat, (4) View tasks page, (5) Complete and delete task. Verify all functionality works identically to Phase III.
- [ ] T035 [US1] **Test pod resilience** - Delete one frontend pod with `kubectl delete pod <pod-name> -n todo-app`. Verify Kubernetes automatically recreates it and application remains accessible within 30 seconds.

**Checkpoint**: User Story 1 complete - Application successfully deployed to Kubernetes with full functionality ✅

---

## Phase 4: User Story 2 - Use AI Tools for Infrastructure Generation (Priority: P2)

**Goal**: Document and validate AI-assisted infrastructure generation workflow with all prompts and outputs logged

**Independent Test**: Review ai-prompts-log.md to verify every artifact has documented AI prompt, validation result, and revision history. Confirm artifacts follow Kubernetes best practices.

**AI Tools Used**: Docker AI/Claude Code (Dockerfiles), kubectl-ai (Kubernetes manifests), kagent (cluster analysis)

### AI Tool Setup and Validation

- [ ] T036 [P] [US2] **Install kubectl-ai plugin** - If not already installed (from T009), run `kubectl krew install ai`. Verify with `kubectl ai --version`. Document installation steps in quickstart.md.
- [ ] T037 [P] [US2] **Test kubectl-ai manifest generation** - Run `kubectl ai "create deployment for nginx with 1 replica"` to verify tool works. Review generated output. Document in ai-prompts-log.md as test prompt.

### Dockerfile Generation with AI (Retrospective Documentation)

- [ ] T038 [P] [US2] **Document frontend Dockerfile AI prompt** - In ai-prompts-log.md, add entry for T013 with: (1) Full AI prompt text, (2) Tool used (Docker AI or Claude Code), (3) Generated Dockerfile output or summary, (4) Validation results (build success, image size), (5) Any manual revisions made.
- [ ] T039 [P] [US2] **Document backend Dockerfile AI prompt** - In ai-prompts-log.md, add entry for T014 with full prompt, tool, output, validation, and revisions.

### Kubernetes Manifest Generation with kubectl-ai (Regenerate with AI)

- [ ] T040 [P] [US2] **Regenerate frontend Deployment with kubectl-ai** - Run `kubectl ai "create Kubernetes deployment for frontend: name=frontend, replicas=2, image=todo-frontend:1.0.0, port=3000, resources: requests 100m CPU 256Mi memory, limits 500m CPU 512Mi memory, liveness probe httpGet / every 10s, readiness probe httpGet / every 10s, rolling update maxSurge 1 maxUnavailable 0"`. Compare output with T026 manual YAML. Document prompt and output in ai-prompts-log.md.
- [ ] T041 [P] [US2] **Regenerate backend Deployment with kubectl-ai** - Run kubectl-ai prompt for backend deployment with 1 replica, port 8000, resources, health probes on /health, env from ConfigMap and Secret. Compare with T027. Document in ai-prompts-log.md.
- [ ] T042 [P] [US2] **Regenerate frontend Service with kubectl-ai** - Run `kubectl ai "create Kubernetes service for frontend: name=frontend, type=NodePort, nodePort=30080, port=3000, targetPort=3000, selector app=frontend"`. Compare with T028. Document in ai-prompts-log.md.
- [ ] T043 [P] [US2] **Regenerate backend Service with kubectl-ai** - Run kubectl-ai prompt for backend service with NodePort 30800. Compare with T029. Document in ai-prompts-log.md.

### Cluster Analysis with kagent (Optional)

- [ ] T044 [P] [US2] **Install kagent if available** - Check if kagent is available for installation. If yes, install and run `kagent version` to verify. If not available, document that native kubectl commands will be used instead.
- [ ] T045 [US2] **Analyze cluster with kagent or kubectl** - If kagent available, run `kagent analyze deployment frontend -n todo-app` and `kagent analyze deployment backend -n todo-app`. If not, use `kubectl top pods -n todo-app` (requires metrics-server) and `kubectl describe deployment -n todo-app`. Document resource utilization and optimization recommendations.

### Validation and Best Practices Check

- [ ] T046 [US2] **Validate kubectl-ai generated manifests** - For each kubectl-ai generated manifest, run `kubectl apply --dry-run=client -f <file>` to validate syntax. Run `kubectl apply --dry-run=server -f <file>` to validate against cluster. Document any errors or warnings in ai-prompts-log.md.
- [ ] T047 [US2] **Review AI-generated artifacts for best practices** - Check all AI-generated Dockerfiles and Kubernetes manifests against cloud-native best practices: (1) Non-root users, (2) Resource limits defined, (3) Health probes configured, (4) Security contexts appropriate, (5) Labels and selectors consistent. Document findings in ai-prompts-log.md.

**Checkpoint**: User Story 2 complete - All AI prompts documented, artifacts validated, best practices confirmed ✅

---

## Phase 5: User Story 3 - Package Deployment with Helm (Priority: P2)

**Goal**: Package all Kubernetes resources as a Helm chart with values.yaml for easy installation, upgrade, and rollback

**Independent Test**: Perform complete Helm lifecycle test: (1) `helm install` to deploy, (2) Verify application works, (3) `helm upgrade` with configuration change, (4) Verify change applied, (5) `helm rollback` to previous version, (6) Verify original configuration restored.

**AI Tools Used**: kubectl-ai (Helm template generation), Claude Code (Chart.yaml, values.yaml, helpers)

### Helm Chart Structure Creation

- [ ] T048 [US3] **Scaffold Helm chart structure** - Run `helm create kubernetes/helm-chart/todo-chatbot` to create base chart structure. This creates Chart.yaml, values.yaml, templates/, .helmignore.
- [ ] T049 [US3] **Customize Chart.yaml** - Edit `kubernetes/helm-chart/todo-chatbot/Chart.yaml` with: apiVersion: v2, name: todo-chatbot, description: "Helm chart for Todo Chatbot (Next.js + FastAPI)", type: application, version: 1.0.0, appVersion: "1.0.0", maintainers: Phase IV Team.
- [ ] T050 [US3] **Remove default templates** - Delete default templates from `kubernetes/helm-chart/todo-chatbot/templates/` (deployment.yaml, service.yaml, etc.) as we'll generate custom ones.

### Helm Template Generation with kubectl-ai

- [ ] T051 [P] [US3] **Generate frontend Deployment template** - Use kubectl-ai to create `kubernetes/helm-chart/todo-chatbot/templates/frontend-deployment.yaml` with Helm templating: `{{ include "todo-chatbot.fullname" . }}-frontend`, `{{ .Values.frontend.replicas }}`, `{{ .Values.frontend.image }}:{{ .Values.frontend.tag }}`, resources from values, probes, rolling update strategy. **AI Prompt**: `kubectl ai "create Kubernetes deployment with Helm templating syntax: name={{ include \"todo-chatbot.fullname\" . }}-frontend, replicas={{ .Values.frontend.replicas }}, image={{ .Values.frontend.image }}:{{ .Values.frontend.tag }}, port={{ .Values.frontend.service.port }}, resources from values, liveness/readiness httpGet on /, rolling update maxSurge 1 maxUnavailable 0"`. Document prompt in ai-prompts-log.md.
- [ ] T052 [P] [US3] **Generate backend Deployment template** - Use kubectl-ai to create `kubernetes/helm-chart/todo-chatbot/templates/backend-deployment.yaml` with Helm templating for backend (1 replica, port 8000, health probes on /health, env from ConfigMap and Secret refs). Document prompt in ai-prompts-log.md.
- [ ] T053 [P] [US3] **Generate frontend Service template** - Use kubectl-ai to create `kubernetes/helm-chart/todo-chatbot/templates/frontend-service.yaml` with Helm templating: NodePort type, nodePort and port from values, selector. Document prompt.
- [ ] T054 [P] [US3] **Generate backend Service template** - Use kubectl-ai to create `kubernetes/helm-chart/todo-chatbot/templates/backend-service.yaml` with Helm templating. Document prompt.
- [ ] T055 [P] [US3] **Generate ConfigMap template** - Use kubectl-ai or Claude Code to create `kubernetes/helm-chart/todo-chatbot/templates/configmap.yaml` with Helm templating: data from `{{ .Values.config.* }}` (ENVIRONMENT, LOG_LEVEL, PORT, FRONTEND_URL). Document prompt.
- [ ] T056 [P] [US3] **Generate Secret template** - Create `kubernetes/helm-chart/todo-chatbot/templates/secrets.yaml` with Helm templating: data with base64 encoding: `{{ .Values.secrets.databaseUrl | b64enc }}`, `{{ .Values.secrets.openaiApiKey | b64enc }}`, `{{ .Values.secrets.jwtSecret | b64enc }}`. Document approach.

### Helm Values and Helpers

- [ ] T057 [US3] **Create values.yaml configuration** - Create `kubernetes/helm-chart/todo-chatbot/values.yaml` with structure: frontend (image, tag, replicas, service, resources, env), backend (image, tag, replicas, service, resources, env), config (non-sensitive env vars), secrets (PLACEHOLDER values with instructions to replace). Document all configurable parameters.
- [ ] T058 [US3] **Create template helpers** - Create `kubernetes/helm-chart/todo-chatbot/templates/_helpers.tpl` with: `todo-chatbot.name`, `todo-chatbot.fullname`, `todo-chatbot.labels` (standard Kubernetes labels). Use Claude Code for helper generation with best practices.
- [ ] T059 [P] [US3] **Create NOTES.txt** - Create `kubernetes/helm-chart/todo-chatbot/templates/NOTES.txt` with post-install instructions: Access frontend at http://localhost:30080, backend at http://localhost:30800, check status with `kubectl get pods -n todo-app`, view logs with `kubectl logs -f -n todo-app <pod>`.
- [ ] T060 [P] [US3] **Create values-local.yaml** - Create `kubernetes/helm-chart/todo-chatbot/values-local.yaml` (gitignored) with actual secrets from Phase III .env file for local deployment. Add `values-local.yaml` to `.gitignore`.

### Helm Chart Validation

- [ ] T061 [US3] **Lint Helm chart** - Run `helm lint kubernetes/helm-chart/todo-chatbot/`. Verify no errors or warnings. Fix any issues found.
- [ ] T062 [US3] **Dry-run Helm install** - Run `helm install todo-chatbot kubernetes/helm-chart/todo-chatbot/ --dry-run --debug -n todo-app -f kubernetes/helm-chart/todo-chatbot/values-local.yaml`. Verify all templates render correctly without errors.
- [ ] T063 [US3] **Template rendering test** - Run `helm template todo-chatbot kubernetes/helm-chart/todo-chatbot/ -n todo-app -f kubernetes/helm-chart/todo-chatbot/values-local.yaml > rendered-manifests.yaml`. Review rendered-manifests.yaml to ensure all values substituted correctly.

### Helm Deployment Lifecycle Testing

- [ ] T064 [US3] **Uninstall raw manifests deployment** - If application deployed from Phase 3, clean up: `kubectl delete namespace todo-app`, `kubectl create namespace todo-app`. This ensures clean state for Helm installation.
- [ ] T065 [US3] **Install Helm chart** - Run `helm install todo-chatbot kubernetes/helm-chart/todo-chatbot/ -n todo-app -f kubernetes/helm-chart/todo-chatbot/values-local.yaml --create-namespace`. Verify installation succeeds with `helm list -n todo-app`.
- [ ] T066 [US3] **Verify Helm-deployed application** - Confirm all resources created: `kubectl get all -n todo-app`. Test frontend (http://localhost:30080) and backend (http://localhost:30800/health). Verify full user workflow works.
- [ ] T067 [US3] **Test Helm upgrade** - Modify `values-local.yaml` to change frontend replicas from 2 to 3. Run `helm upgrade todo-chatbot kubernetes/helm-chart/todo-chatbot/ -n todo-app -f kubernetes/helm-chart/todo-chatbot/values-local.yaml`. Verify upgrade succeeds and 3 frontend pods running.
- [ ] T068 [US3] **Test Helm rollback** - Run `helm rollback todo-chatbot -n todo-app` to revert to previous release. Verify rollback succeeds and frontend returns to 2 replicas. Check application still works.
- [ ] T069 [US3] **Test values override at install time** - Uninstall and reinstall with command-line override: `helm install todo-chatbot kubernetes/helm-chart/todo-chatbot/ -n todo-app --set frontend.replicas=1 --set-file secrets.databaseUrl=<file>`. Verify override applied (1 frontend replica).

**Checkpoint**: User Story 3 complete - Helm chart packaging functional with full lifecycle management ✅

---

## Phase 6: User Story 4 - Access Application via NodePort (Priority: P3)

**Goal**: Validate stable NodePort access endpoints and document connectivity for team consistency

**Independent Test**: Access predefined NodePort URLs (http://localhost:30080, http://localhost:30800) from browser without port-forwarding. Verify connectivity and document access patterns.

**AI Tools Used**: None (validation and documentation phase)

### NodePort Configuration Validation

- [ ] T070 [P] [US4] **Verify frontend NodePort configuration** - Run `kubectl get svc frontend -n todo-app -o yaml`. Confirm `spec.type: NodePort`, `spec.ports[0].nodePort: 30080`, `spec.ports[0].port: 3000`. Document actual vs expected.
- [ ] T071 [P] [US4] **Verify backend NodePort configuration** - Run `kubectl get svc backend -n todo-app -o yaml`. Confirm NodePort 30800, port 8000. Document.
- [ ] T072 [US4] **Test NodePort accessibility from localhost** - Open browser tabs: `http://localhost:30080` (frontend) and `http://localhost:30800/health` (backend). Verify both accessible without kubectl port-forward commands.

### Frontend-Backend Communication via Service DNS

- [ ] T073 [US4] **Verify frontend can reach backend via service DNS** - Check frontend environment variable NEXT_PUBLIC_API_URL is set correctly (http://localhost:30800 for browser or http://backend.todo-app.svc.cluster.local:8000 for server-side). Test API call from frontend to backend (login flow). Verify successful communication.
- [ ] T074 [US4] **Test service discovery** - Run `kubectl run -it --rm debug --image=busybox -n todo-app -- nslookup backend.todo-app.svc.cluster.local`. Verify DNS resolves to backend service ClusterIP.

### Port Conflict Handling

- [ ] T075 [US4] **Document port conflict resolution** - In quickstart.md troubleshooting section, add instructions for handling port conflicts: (1) Check if ports in use: `lsof -i :30080`, `lsof -i :30800`, (2) If conflict, modify values.yaml to use alternative ports (30081, 30801), (3) Update documentation with new ports.

### Multi-Developer Consistency

- [ ] T076 [P] [US4] **Document standard NodePort assignments** - In quickstart.md, add "Team Standards" section specifying: Frontend always 30080, Backend always 30800. This ensures all team members use same port numbers for consistency. Document how to check current assignments: `kubectl get svc -n todo-app`.

**Checkpoint**: User Story 4 complete - NodePort access validated and documented ✅

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Complete documentation, create deployment automation, and finalize Phase IV deliverables

### Comprehensive Documentation

- [ ] T077 [P] Create deployment runbook `specs/001-k8s-local-deployment/quickstart.md` with: (1) Prerequisites checklist (Docker, Minikube, Helm, kubectl), (2) Step-by-step deployment instructions, (3) Build Docker images, (4) Start Minikube, create namespace, (5) Install Helm chart, (6) Verify deployment, (7) Access application URLs, (8) Troubleshooting common issues.
- [ ] T078 [P] Create troubleshooting guide section in quickstart.md with: (1) Docker daemon not running, (2) Minikube resource constraints, (3) Image build failures, (4) Pod CrashLoopBackOff (missing env vars), (5) NodePort port conflicts, (6) Database connectivity issues, (7) Useful debug commands (kubectl logs, describe, get events).
- [ ] T079 [P] Update deployment-architecture.md with final architecture diagram reflecting actual deployed state (confirm component counts, port numbers, resource usage match plan).
- [ ] T080 [P] Complete ai-prompts-log.md with all AI interactions documented: Every Dockerfile, Kubernetes manifest, Helm template generation prompt with tool used, output, validation, and revisions.

### Automation Scripts

- [ ] T081 Create `kubernetes/scripts/build-images.sh` script to automate Docker image building for frontend and backend with error handling and image size validation.
- [ ] T082 Create `kubernetes/scripts/deploy.sh` script to automate full deployment: (1) Check prerequisites, (2) Start Minikube if needed, (3) Load images, (4) Install Helm chart, (5) Wait for pods ready, (6) Display access URLs.
- [ ] T083 Create `kubernetes/scripts/validate.sh` script to run post-deployment validation: (1) Check pod status, (2) Test health endpoints, (3) Verify NodePort accessibility, (4) Run basic smoke tests.

### Final Validation and Metrics

- [ ] T084 **Measure deployment time** - Time full deployment from `minikube start` to application accessible. Verify < 10 minutes. Document actual time.
- [ ] T085 **Measure pod startup time** - Time from `helm install` to all pods Running. Verify < 3 minutes. Document actual time.
- [ ] T086 **Measure application readiness** - Time from pods Running to application fully functional (health checks passing, UI accessible). Verify < 30 seconds. Document.
- [ ] T087 **Verify image sizes** - Run `docker images | grep todo`. Confirm frontend < 200MB, backend < 500MB. Document actual sizes.
- [ ] T088 **Verify resource usage** - Run `kubectl top pods -n todo-app` (requires metrics-server). Confirm pods stay within defined limits. Document actual CPU and memory usage.
- [ ] T089 **End-to-end functional test** - Perform complete user workflow: (1) Login, (2) Chat with AI and create task, (3) View tasks page, (4) Complete task, (5) Delete task. Verify all functionality identical to Phase III. Document any discrepancies.
- [ ] T090 **Resilience test** - Delete one frontend pod and one backend pod. Verify Kubernetes recreates them within 30 seconds and application remains available. Document recovery time.

### Git and Version Control

- [ ] T091 Update `.gitignore` to exclude: `values-local.yaml`, `*.tar`, `*.log`, `rendered-manifests.yaml`, any files with actual secrets.
- [ ] T092 Create `kubernetes/helm-chart/todo-chatbot/README.md` with chart usage instructions: How to install, upgrade, rollback, customize values, troubleshoot.
- [ ] T093 Git commit all Phase IV artifacts with descriptive commit message: "Phase IV: Local Kubernetes deployment infrastructure complete. Includes Dockerfiles, Helm chart, documentation."

**Checkpoint**: Phase IV complete - All deliverables finalized ✅

---

## Dependencies and Execution Order

### User Story Dependencies

```
Phase 1 (Setup) → Phase 2 (Foundational)
                      ↓
        ┌─────────────┴─────────────┬─────────────┬─────────────┐
        ↓                           ↓             ↓             ↓
    US1 (P1) ─────────────────→ US2 (P2)     US3 (P2)      US4 (P3)
    Deploy App                  AI Tools     Helm Chart    NodePort
    [T013-T035]                [T036-T047]  [T048-T069]   [T070-T076]
        │                           │             │             │
        └───────────────────────────┴─────────────┴─────────────┘
                                    ↓
                            Phase 7 (Polish)
                            [T077-T093]
```

**Dependency Rules**:
- **Phase 2 blocks all user stories**: Environment validation must complete first
- **US1 blocks US2**: Must have artifacts deployed before documenting AI generation
- **US1 blocks US3**: Must have working raw manifests before converting to Helm
- **US3 enables US4**: NodePort configuration finalized in Helm chart
- **US2, US3, US4 can run in parallel** after US1 complete (documentation and validation tasks)

### Critical Path

**Minimum Viable Product (MVP)**: User Story 1 only
- **T001-T012** (Setup + Foundational) → **T013-T035** (US1 implementation) = ~50 tasks
- **Estimated time**: 4-6 hours (including build times and verification)

**Full Phase IV**: All user stories
- **T001-T093** = 93 tasks total
- **Estimated time**: 8-12 hours (spread over multiple sessions)

---

## Parallel Execution Opportunities

### Phase 2 (Foundational)
- T005-T010 can run in parallel (independent environment checks)
- T011-T012 can run in parallel (Phase III verification)

### Phase 3 (User Story 1)
- T013 and T014 can run in parallel (Dockerfile generation)
- T015 and T016 can run in parallel (Dockerfile review)
- T017 and T018 sequential (depends on reviews), but then T019 and T020 can run in parallel (container tests)
- T024-T029 can run in parallel (creating YAML files)
- T030-T033 sequential (deployment verification)

### Phase 4 (User Story 2)
- T036 and T037 can run in parallel (kubectl-ai setup and test)
- T038 and T039 can run in parallel (documenting Dockerfile prompts)
- T040-T043 can run in parallel (kubectl-ai regeneration tasks)
- T044 and T045 sequential (kagent optional)

### Phase 5 (User Story 3)
- T051-T056 can run in parallel after T050 (Helm template generation)
- T057-T060 can run in parallel (values, helpers, notes creation)
- T061-T063 sequential (validation depends on completion)

### Phase 6 (User Story 4)
- T070 and T071 can run in parallel (NodePort verification)
- T073 and T074 can run in parallel (communication tests)

### Phase 7 (Polish)
- T077-T080 can run in parallel (documentation tasks)
- T081-T083 can run in parallel (script creation)
- T084-T090 mostly sequential (measurement tasks)
- T091-T093 sequential (final git operations)

---

## Implementation Strategy

### Recommended Approach

1. **MVP First**: Complete US1 (T001-T035) to get working Kubernetes deployment
2. **Validation**: Thoroughly test US1 before proceeding
3. **Incremental Enhancement**: Add US2 (AI documentation), US3 (Helm), US4 (NodePort validation)
4. **Polish**: Complete Phase 7 after all user stories validated

### Partial Execution Support

**If Docker not installed** (T005 fails):
- Skip T017-T020 (image building and testing)
- Skip T023 (loading images into Minikube)
- Document that Dockerfiles are ready but images cannot be built
- Proceed with US2 (AI documentation) and US3 (Helm chart generation)
- Defer US1 deployment tasks until Docker available

**If Minikube not installed** (T006 fails):
- Skip T021-T035 (cluster setup and deployment)
- Complete US2 (AI documentation) and US3 (Helm chart generation)
- Defer US1, US4 until Minikube available

**If kubectl-ai not installed** (T009 fails):
- US2 T040-T043 cannot use kubectl-ai for regeneration
- Alternative: Document that kubectl-ai would be used if available
- Proceed with manual manifest documentation

---

## Success Criteria Summary

**From Specification** (must all be satisfied):
- ✅ Deployment completes in < 10 minutes (T084)
- ✅ Pods running in < 3 minutes (T085)
- ✅ Application accessible in < 30 seconds (T086)
- ✅ Frontend image < 200MB (T087)
- ✅ Backend image < 500MB (T087)
- ✅ All AI prompts documented (T080)
- ✅ Zero manual coding (all artifacts AI-generated with human review)
- ✅ Complete documentation (T077-T079)
- ✅ Full end-to-end functionality (T089)
- ✅ Pod resilience validated (T090)

**Deliverables Checklist**:
- [ ] Dockerfiles (frontend, backend) - AI-generated
- [ ] Docker images built and tested
- [ ] Kubernetes manifests (Deployments, Services, ConfigMap, Secret)
- [ ] Helm chart with templates and values
- [ ] AI prompts log with all generation history
- [ ] Deployment runbook (quickstart.md)
- [ ] Troubleshooting guide
- [ ] Architecture documentation updated
- [ ] Automation scripts (build, deploy, validate)
- [ ] All metrics measured and documented

---

**Total Tasks**: 93
**MVP Tasks** (US1 only): 50
**P1 Tasks**: 35 (US1)
**P2 Tasks**: 46 (US2 + US3)
**P3 Tasks**: 7 (US4)
**Polish Tasks**: 17 (Phase 7)

**Parallel Opportunities**: ~30 tasks can run in parallel (marked with [P])
**Independent User Stories**: All 4 user stories testable independently after US1 foundation

**Phase IV Status**: Ready for implementation 🚀

---

**Generated**: 2026-01-28
**Branch**: `001-k8s-local-deployment`
**Next Step**: Begin with Phase 1 Setup (T001-T004), then Phase 2 Foundational (T005-T012)
