# Cloud Native Todo Chatbot - Phase IV Constitution

**Project**: Todo Chatbot - Local Kubernetes Deployment
**Phase**: IV (Infrastructure & Deployment)
**Scope**: Deploy Phase III application to local Kubernetes cluster
**Approach**: AI-Assisted, Spec-Driven Development

---

## Core Principles

### I. Spec-Driven Infrastructure Development (NON-NEGOTIABLE)

**Workflow Order (Strict Enforcement)**:
1. **Specification First** - Define what infrastructure is needed and why
2. **Planning Second** - Design the architecture and deployment strategy
3. **Task Breakdown Third** - Break down into testable implementation tasks
4. **AI-Assisted Implementation** - Use AI DevOps tools (Gordon, kubectl-ai, kagent)
5. **Human Approval** - Review and approve at each stage

**Mandatory Artifacts**:
- Infrastructure specification (spec.md)
- Deployment plan with architecture diagrams (plan.md)
- Task breakdown with acceptance criteria (tasks.md)
- Helm charts and Kubernetes manifests
- AI prompts used for generation
- Deployment and rollback procedures

**Rules**:
- No manual Dockerfile or Kubernetes manifest creation without spec approval
- All infrastructure changes must be traceable to requirements
- AI tools must be preferred over manual creation
- Every deployment decision must be documented with rationale

---

### II. AI-First DevOps Tooling

**Primary Tools (Use in Order of Preference)**:

1. **Docker AI Agent (Gordon)** - Dockerfile generation and optimization
   - Preferred for: Dockerfiles, multi-stage builds, image optimization
   - Usage: `docker ai "create optimized Dockerfile for Next.js frontend"`
   - Purpose: Leverage AI for containerization best practices

2. **kubectl-ai** - Kubernetes resource generation and troubleshooting
   - Preferred for: Deployments, Services, ConfigMaps, Secrets, Helm charts
   - Usage: `kubectl ai "create deployment for backend with 1 replica"`
   - Purpose: Generate idiomatic Kubernetes YAML

3. **kagent** - Cluster analysis and optimization
   - Preferred for: Cluster health checks, resource optimization, debugging
   - Usage: `kagent analyze deployment backend`
   - Purpose: AI-powered cluster intelligence

4. **Claude Code** - Orchestration, documentation, and workflow automation
   - Preferred for: Spec creation, plan generation, task management, PHR creation
   - Purpose: Overall project coordination and knowledge capture

**Human Role**:
- Review and approve AI-generated artifacts
- Provide clarifications when AI requests input
- Execute deployment commands
- Verify outcomes and test functionality
- NO manual coding or manifest creation

---

### III. Cloud-Native Best Practices (MANDATORY)

**Containerization Standards**:
- Multi-stage Docker builds for minimal image sizes
- Non-root user execution in containers
- Health check endpoints in all services
- Environment-based configuration (12-factor app)
- Immutable infrastructure - rebuild, don't patch
- Container image tagging strategy: `<service>:<version>` (e.g., `backend:1.0.0`)

**Kubernetes Resource Standards**:
- Resource requests and limits defined for all containers
- Liveness and readiness probes configured
- ConfigMaps for configuration (no hardcoded values)
- Secrets for sensitive data (base64 encoded)
- Services for stable endpoints
- Deployments for stateless workloads
- NodePort services for local development access

**Security Requirements**:
- No secrets in Docker images or Git repository
- Secrets managed via Kubernetes Secrets
- Container images scanned for vulnerabilities (if available)
- Least privilege principle - minimal permissions
- Network policies (Phase V consideration)

**High Availability Principles**:
- Frontend: minimum 2 replicas (for load distribution)
- Backend: 1 replica (stateless, can scale later)
- Rolling update strategy (maxSurge: 1, maxUnavailable: 0)
- Pod disruption budgets (future enhancement)

---

### IV. Helm Chart Management

**Chart Structure (Mandatory)**:
```
todo-chatbot-chart/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default configuration values
├── templates/
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── configmap.yaml
│   ├── secrets.yaml
│   └── _helpers.tpl        # Template helpers
└── README.md               # Chart documentation
```

**Values Hierarchy**:
- `values.yaml` - Defaults for all environments
- `values-dev.yaml` - Local development overrides
- `values-prod.yaml` - Production overrides (future)

**Helm Principles**:
- All Kubernetes resources managed through Helm
- Values parameterized for environment flexibility
- Chart versioned alongside application code
- Atomic installs and upgrades (rollback on failure)
- Helm hooks for pre/post deployment tasks (if needed)

**Chart Generation**:
- Prefer kubectl-ai for initial chart scaffolding
- Use Helm best practices (labels, selectors, naming conventions)
- Include NOTES.txt for post-install instructions

---

### V. Local Development Environment

**Platform Requirements**:
- **Kubernetes**: Minikube or Docker Desktop Kubernetes
- **Container Runtime**: Docker Desktop
- **Package Manager**: Helm 3.x
- **Operating System**: Windows (with WSL2 or native), Linux, or macOS

**Cluster Configuration**:
- Cluster name: `todo-chatbot-local`
- Namespace: `todo-app`
- Ingress: Not required (NodePort access)
- Persistent storage: Not required (stateless app)

**Access Strategy**:
- Frontend: NodePort 30080 → `http://localhost:30080`
- Backend: NodePort 30800 → `http://localhost:30800`
- No Ingress controller needed for Phase IV

**Resource Constraints**:
- Frontend container: CPU 100m, Memory 256Mi (requests), CPU 500m, Memory 512Mi (limits)
- Backend container: CPU 200m, Memory 512Mi (requests), CPU 1, Memory 1Gi (limits)
- Total cluster: ~2 CPU cores, ~4GB RAM minimum

---

### VI. Deployment Workflow (Step-by-Step)

**Phase 1: Preparation**
1. Verify Kubernetes cluster is running (`kubectl cluster-info`)
2. Verify Docker daemon is running (`docker ps`)
3. Verify Helm is installed (`helm version`)
4. Create namespace (`kubectl create namespace todo-app`)

**Phase 2: Build Container Images**
1. Use Docker AI (Gordon) to generate Dockerfiles
2. Review and approve Dockerfiles
3. Build images locally (`docker build -t <image> .`)
4. Tag images with versions
5. Verify images (`docker images`)

**Phase 3: Generate Helm Chart**
1. Use kubectl-ai to scaffold Helm chart
2. Review generated templates
3. Customize values.yaml with environment-specific settings
4. Validate chart (`helm lint ./todo-chatbot-chart`)

**Phase 4: Deploy to Kubernetes**
1. Install Helm chart (`helm install todo-chatbot ./todo-chatbot-chart -n todo-app`)
2. Verify deployment (`kubectl get all -n todo-app`)
3. Check pod logs (`kubectl logs -n todo-app <pod-name>`)
4. Test health endpoints

**Phase 5: Verification & Testing**
1. Access frontend via NodePort (`http://localhost:30080`)
2. Access backend via NodePort (`http://localhost:30800`)
3. Test end-to-end flow (login, chat, tasks)
4. Verify AI chat functionality
5. Verify database connectivity

**Phase 6: Documentation**
1. Create deployment runbook
2. Document AI prompts used
3. Create rollback procedures
4. Document troubleshooting steps

---

### VII. Quality Gates (Must Pass Before Phase Complete)

**Specification Stage**:
- [ ] Infrastructure requirements clearly defined
- [ ] Success criteria measurable and testable
- [ ] User stories prioritized (P1, P2, P3)
- [ ] Edge cases and failure scenarios documented
- [ ] Spec approved by user

**Planning Stage**:
- [ ] Architecture diagram created
- [ ] Component dependencies mapped
- [ ] Resource sizing calculated
- [ ] Deployment strategy defined
- [ ] Rollback procedures documented
- [ ] Plan approved by user

**Implementation Stage**:
- [ ] Dockerfiles generated via AI and reviewed
- [ ] Docker images build successfully
- [ ] Helm chart scaffolded via AI
- [ ] All Kubernetes resources validated (`helm lint`)
- [ ] Deployment successful (`helm install`)
- [ ] All pods in Running state
- [ ] Health checks passing

**Testing Stage**:
- [ ] Frontend accessible via browser
- [ ] Backend API responding correctly
- [ ] Frontend-backend integration working
- [ ] AI chat functionality working
- [ ] Task CRUD operations working
- [ ] Database connectivity verified
- [ ] No errors in pod logs

**Documentation Stage**:
- [ ] Deployment runbook created
- [ ] AI prompts documented
- [ ] Rollback procedures documented
- [ ] Troubleshooting guide created
- [ ] PHR (Prompt History Record) created

---

### VIII. Observability & Debugging

**Logging Requirements**:
- All containers log to stdout/stderr
- Structured JSON logging preferred
- Log levels: DEBUG, INFO, WARNING, ERROR, CRITICAL
- Logs accessible via `kubectl logs -n todo-app <pod>`

**Health Checks**:
- Frontend: `GET /` returns 200 OK
- Backend: `GET /health` returns 200 OK with status JSON
- Readiness probe: Same as liveness (for now)
- Liveness probe: Check every 10s, fail after 3 consecutive failures

**Monitoring (Phase IV - Basic)**:
- Manual checks via `kubectl get pods -n todo-app`
- Manual log inspection via `kubectl logs`
- Resource usage via `kubectl top pods -n todo-app` (if metrics-server installed)
- Advanced monitoring (Prometheus, Grafana) deferred to Phase V

**Troubleshooting Commands**:
```bash
# Check cluster status
kubectl cluster-info
kubectl get nodes

# Check application status
kubectl get all -n todo-app
kubectl describe pod <pod-name> -n todo-app
kubectl logs -n todo-app <pod-name> --follow

# Debug failed deployments
kubectl get events -n todo-app --sort-by='.lastTimestamp'
helm status todo-chatbot -n todo-app
helm get values todo-chatbot -n todo-app

# Access container shell (for debugging)
kubectl exec -it -n todo-app <pod-name> -- /bin/sh

# Port forwarding (alternative to NodePort)
kubectl port-forward -n todo-app <pod-name> 8080:8000
```

---

### IX. Versioning & Release Strategy

**Image Versioning**:
- Format: `<service>:<major>.<minor>.<patch>` (e.g., `backend:1.0.0`)
- Phase IV initial release: `v1.0.0` for all services
- Tag images with both version and `latest` for convenience
- No `latest` tag in production (future)

**Helm Chart Versioning**:
- Chart follows semantic versioning: `1.0.0`
- `appVersion` in `Chart.yaml` matches application version
- Increment chart version on any template changes

**Git Branching**:
- Feature branch: `001-ai-todo-chatbot` (already exists)
- Tag releases: `v1.0.0-k8s-local` after successful deployment

**Rollback Strategy**:
```bash
# List releases
helm list -n todo-app

# Rollback to previous version
helm rollback todo-chatbot <revision> -n todo-app

# Rollback to specific revision
helm rollback todo-chatbot 1 -n todo-app
```

---

### X. Technology Constraints (Non-Negotiable)

**Must Use**:
- Kubernetes (Minikube or Docker Desktop)
- Docker for containerization
- Helm 3.x for package management
- Docker AI Agent (Gordon) for Dockerfile generation
- kubectl-ai for Kubernetes manifest generation
- kagent for cluster analysis

**Must NOT Use (Phase IV)**:
- Cloud providers (AWS, GCP, Azure) - local only
- Managed Kubernetes services (EKS, GKE, AKS)
- Ingress controllers (use NodePort instead)
- Persistent volumes (application is stateless with external DB)
- Service mesh (Istio, Linkerd) - deferred to future phase
- CI/CD pipelines (manual deployment for Phase IV)

**Database Strategy**:
- Continue using Neon PostgreSQL (external managed service)
- No database in Kubernetes cluster (Phase IV)
- Database connection via environment variables (in ConfigMap/Secret)

**Frontend-Backend Communication**:
- Frontend configured via environment variable (`NEXT_PUBLIC_API_URL`)
- Backend URL: `http://localhost:30800` (NodePort service)
- No service mesh or Ingress required

---

### XI. Simplicity & Minimalism (YAGNI Principle)

**Start Simple**:
- Single namespace (`todo-app`)
- No Ingress (NodePort sufficient for local)
- No persistent volumes (external database)
- No StatefulSets (application is stateless)
- No HorizontalPodAutoscaler (manual scaling sufficient)
- No NetworkPolicies (Phase V enhancement)

**Avoid Over-Engineering**:
- Don't create abstractions for one-time operations
- Don't add features not explicitly required
- Don't optimize prematurely
- Focus on working deployment first, optimize later

**Defer to Future Phases**:
- Service mesh (Istio/Linkerd)
- Advanced observability (Prometheus, Grafana, Jaeger)
- CI/CD automation (GitHub Actions, ArgoCD)
- Multi-environment deployments (dev, staging, prod)
- Cloud deployment (AWS EKS, GCP GKE)
- Secrets management (Vault, Sealed Secrets)

---

### XII. Documentation Standards

**Required Documentation**:
1. **Infrastructure Specification** (`specs/phase4-k8s-deployment/spec.md`)
   - User stories for deployment scenarios
   - Functional requirements for infrastructure
   - Success criteria (measurable)

2. **Deployment Plan** (`specs/phase4-k8s-deployment/plan.md`)
   - Architecture diagram
   - Component breakdown
   - Deployment strategy
   - Resource sizing
   - Risk analysis

3. **Task Breakdown** (`specs/phase4-k8s-deployment/tasks.md`)
   - Granular tasks with acceptance criteria
   - Dependency ordering
   - Test cases for each task

4. **Deployment Runbook** (`docs/deployment-runbook.md`)
   - Step-by-step deployment instructions
   - Prerequisites checklist
   - Verification steps
   - Rollback procedures

5. **AI Prompts Log** (`docs/ai-prompts-used.md`)
   - All Docker AI (Gordon) prompts
   - All kubectl-ai prompts
   - All kagent commands
   - Rationale for each prompt

6. **Troubleshooting Guide** (`docs/troubleshooting.md`)
   - Common issues and solutions
   - Debug commands
   - Useful kubectl and helm commands

**Prompt History Records (PHRs)**:
- Create PHR after each major milestone
- Store in `history/prompts/phase4-k8s-deployment/`
- Include: user intent, AI response, artifacts created, outcomes

---

## Governance & Compliance

### Amendment Process
- Constitution changes require user approval
- Major changes trigger new ADR (Architecture Decision Record)
- All amendments versioned and dated

### Enforcement
- All PRs and commits must comply with this constitution
- AI agents must reference constitution principles in reasoning
- Human reviewers verify compliance before approval

### Success Measurement
- All quality gates passed
- Application deployed successfully to local Kubernetes
- End-to-end functionality verified
- Documentation complete and accurate
- AI prompts documented for reproducibility

---

**Version**: 1.0.0
**Ratified**: 2026-01-28
**Last Amended**: 2026-01-28
**Phase**: IV - Local Kubernetes Deployment
**Next Review**: After Phase IV completion or upon significant architectural change
