#!/bin/bash
# deploy.sh - Automate full deployment of Todo Chatbot to Kubernetes
# Usage: ./deploy.sh

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
NAMESPACE="todo-app"
RELEASE_NAME="todo-chatbot"
HELM_CHART_PATH="../helm-chart/todo-chatbot"
VALUES_FILE="${HELM_CHART_PATH}/values-local.yaml"
FRONTEND_IMAGE="todo-frontend:1.0.0"
BACKEND_IMAGE="todo-backend:1.0.0"

echo "========================================"
echo "   Todo Chatbot - Deployment Script"
echo "========================================"
echo ""

# Step 1: Check prerequisites
echo -e "${YELLOW}[1/8]${NC} Checking prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker is not installed${NC}"
    exit 1
fi

if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}✗ Docker daemon is not running${NC}"
    echo "Please start Docker Desktop and try again."
    exit 1
fi
echo -e "${GREEN}✓ Docker is available${NC}"

# Check Minikube
if ! command -v minikube &> /dev/null; then
    echo -e "${RED}✗ Minikube is not installed${NC}"
    echo "Install from: https://minikube.sigs.k8s.io/docs/start/"
    exit 1
fi
echo -e "${GREEN}✓ Minikube is installed${NC}"

# Check Helm
if ! command -v helm &> /dev/null; then
    echo -e "${RED}✗ Helm is not installed${NC}"
    echo "Install from: https://helm.sh/docs/intro/install/"
    exit 1
fi
echo -e "${GREEN}✓ Helm is installed${NC}"

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}✗ kubectl is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ kubectl is installed${NC}"

# Check values file
if [ ! -f "${VALUES_FILE}" ]; then
    echo -e "${RED}✗ values-local.yaml not found${NC}"
    echo "Create it from: ${HELM_CHART_PATH}/values-local.yaml.example"
    exit 1
fi
echo -e "${GREEN}✓ values-local.yaml exists${NC}"

echo ""

# Step 2: Start Minikube if not running
echo -e "${YELLOW}[2/8]${NC} Checking Minikube status..."

if minikube status > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Minikube is already running${NC}"
else
    echo "  Starting Minikube cluster..."
    if minikube start --cpus=2 --memory=4096 --disk-size=20gb; then
        echo -e "${GREEN}✓ Minikube started successfully${NC}"
    else
        echo -e "${RED}✗ Failed to start Minikube${NC}"
        exit 1
    fi
fi

# Verify kubectl can connect
if kubectl cluster-info > /dev/null 2>&1; then
    echo -e "${GREEN}✓ kubectl connected to cluster${NC}"
else
    echo -e "${RED}✗ kubectl cannot connect to cluster${NC}"
    exit 1
fi
echo ""

# Step 3: Create namespace
echo -e "${YELLOW}[3/8]${NC} Setting up namespace..."

if kubectl get namespace "${NAMESPACE}" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Namespace '${NAMESPACE}' already exists${NC}"
else
    if kubectl create namespace "${NAMESPACE}"; then
        echo -e "${GREEN}✓ Namespace '${NAMESPACE}' created${NC}"
    else
        echo -e "${RED}✗ Failed to create namespace${NC}"
        exit 1
    fi
fi
echo ""

# Step 4: Check if images exist
echo -e "${YELLOW}[4/8]${NC} Checking Docker images..."

if docker images "${FRONTEND_IMAGE}" | grep -q "todo-frontend"; then
    echo -e "${GREEN}✓ Frontend image exists${NC}"
else
    echo -e "${YELLOW}⚠ Frontend image not found. Building...${NC}"
    cd ../scripts
    ./build-images.sh
    cd -
fi

if docker images "${BACKEND_IMAGE}" | grep -q "todo-backend"; then
    echo -e "${GREEN}✓ Backend image exists${NC}"
else
    echo -e "${YELLOW}⚠ Backend image not found. Building...${NC}"
    cd ../scripts
    ./build-images.sh
    cd -
fi
echo ""

# Step 5: Load images into Minikube
echo -e "${YELLOW}[5/8]${NC} Loading images into Minikube..."

if minikube image load "${FRONTEND_IMAGE}"; then
    echo -e "${GREEN}✓ Frontend image loaded${NC}"
else
    echo -e "${YELLOW}⚠ Warning: Failed to load frontend image${NC}"
fi

if minikube image load "${BACKEND_IMAGE}"; then
    echo -e "${GREEN}✓ Backend image loaded${NC}"
else
    echo -e "${YELLOW}⚠ Warning: Failed to load backend image${NC}"
fi
echo ""

# Step 6: Install or upgrade Helm chart
echo -e "${YELLOW}[6/8]${NC} Deploying with Helm..."

if helm list -n "${NAMESPACE}" | grep -q "${RELEASE_NAME}"; then
    echo "  Release already exists. Upgrading..."
    if helm upgrade "${RELEASE_NAME}" "${HELM_CHART_PATH}" \
        -n "${NAMESPACE}" \
        -f "${VALUES_FILE}"; then
        echo -e "${GREEN}✓ Helm release upgraded successfully${NC}"
    else
        echo -e "${RED}✗ Helm upgrade failed${NC}"
        exit 1
    fi
else
    echo "  Installing new release..."
    if helm install "${RELEASE_NAME}" "${HELM_CHART_PATH}" \
        -n "${NAMESPACE}" \
        -f "${VALUES_FILE}" \
        --create-namespace; then
        echo -e "${GREEN}✓ Helm release installed successfully${NC}"
    else
        echo -e "${RED}✗ Helm install failed${NC}"
        exit 1
    fi
fi
echo ""

# Step 7: Wait for pods to be ready
echo -e "${YELLOW}[7/8]${NC} Waiting for pods to be ready..."
echo "  This may take a few minutes..."

kubectl wait --for=condition=ready pod \
    -l app.kubernetes.io/instance="${RELEASE_NAME}" \
    -n "${NAMESPACE}" \
    --timeout=180s || true

echo ""
kubectl get pods -n "${NAMESPACE}"
echo ""

# Step 8: Display access URLs
echo -e "${YELLOW}[8/8]${NC} Deployment Summary"
echo "========================================"
echo -e "${GREEN}✓ Deployment completed successfully!${NC}"
echo ""
echo "📦 Deployed Components:"
echo "  - Frontend (Next.js)"
echo "  - Backend (FastAPI)"
echo ""
echo "🌐 Access URLs:"
echo -e "  Frontend:      ${BLUE}http://localhost:30080${NC}"
echo -e "  Backend API:   ${BLUE}http://localhost:30800${NC}"
echo -e "  Backend Docs:  ${BLUE}http://localhost:30800/docs${NC}"
echo -e "  Health Check:  ${BLUE}http://localhost:30800/health${NC}"
echo ""
echo "📊 Useful Commands:"
echo "  Check pods:    kubectl get pods -n ${NAMESPACE}"
echo "  Check services: kubectl get svc -n ${NAMESPACE}"
echo "  View logs:     kubectl logs -f -n ${NAMESPACE} -l app=frontend"
echo "  Helm status:   helm status ${RELEASE_NAME} -n ${NAMESPACE}"
echo ""
echo -e "${GREEN}Done!${NC}"
