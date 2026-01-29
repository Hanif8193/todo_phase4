#!/bin/bash
# build-images.sh - Automate Docker image building for Todo Chatbot
# Usage: ./build-images.sh

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
FRONTEND_DOCKERFILE="../dockerfiles/frontend.Dockerfile"
BACKEND_DOCKERFILE="../dockerfiles/backend.Dockerfile"
FRONTEND_CONTEXT="../../todo_phase3/frontend"
BACKEND_CONTEXT="../../todo_phase3/backend"
FRONTEND_IMAGE="todo-frontend:1.0.0"
BACKEND_IMAGE="todo-backend:1.0.0"
MAX_FRONTEND_SIZE_MB=200
MAX_BACKEND_SIZE_MB=500

echo "========================================"
echo "   Todo Chatbot - Image Builder"
echo "========================================"
echo ""

# Check if Docker is running
echo -e "${YELLOW}[1/6]${NC} Checking Docker daemon..."
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}✗ Error: Docker daemon is not running${NC}"
    echo "Please start Docker Desktop and try again."
    exit 1
fi
echo -e "${GREEN}✓ Docker daemon is running${NC}"
echo ""

# Build frontend image
echo -e "${YELLOW}[2/6]${NC} Building frontend image..."
echo "  Image: ${FRONTEND_IMAGE}"
echo "  Context: ${FRONTEND_CONTEXT}"
echo "  Dockerfile: ${FRONTEND_DOCKERFILE}"
echo ""

if docker build \
    -f "${FRONTEND_DOCKERFILE}" \
    -t "${FRONTEND_IMAGE}" \
    "${FRONTEND_CONTEXT}"; then
    echo -e "${GREEN}✓ Frontend image built successfully${NC}"
else
    echo -e "${RED}✗ Frontend image build failed${NC}"
    exit 1
fi
echo ""

# Build backend image
echo -e "${YELLOW}[3/6]${NC} Building backend image..."
echo "  Image: ${BACKEND_IMAGE}"
echo "  Context: ${BACKEND_CONTEXT}"
echo "  Dockerfile: ${BACKEND_DOCKERFILE}"
echo ""

if docker build \
    -f "${BACKEND_DOCKERFILE}" \
    -t "${BACKEND_IMAGE}" \
    "${BACKEND_CONTEXT}"; then
    echo -e "${GREEN}✓ Backend image built successfully${NC}"
else
    echo -e "${RED}✗ Backend image build failed${NC}"
    exit 1
fi
echo ""

# Validate image sizes
echo -e "${YELLOW}[4/6]${NC} Validating image sizes..."

# Get frontend image size in MB
FRONTEND_SIZE_BYTES=$(docker images "${FRONTEND_IMAGE}" --format "{{.Size}}" | sed 's/MB//' | sed 's/GB/*1024/' | bc 2>/dev/null || echo "0")
FRONTEND_SIZE_MB=$(docker inspect "${FRONTEND_IMAGE}" --format='{{.Size}}' | awk '{print int($1/1024/1024)}')

echo "  Frontend: ${FRONTEND_SIZE_MB}MB (target: <${MAX_FRONTEND_SIZE_MB}MB)"

if [ "${FRONTEND_SIZE_MB}" -gt "${MAX_FRONTEND_SIZE_MB}" ]; then
    echo -e "${YELLOW}⚠ Warning: Frontend image exceeds target size${NC}"
else
    echo -e "${GREEN}✓ Frontend image size is within target${NC}"
fi

# Get backend image size in MB
BACKEND_SIZE_MB=$(docker inspect "${BACKEND_IMAGE}" --format='{{.Size}}' | awk '{print int($1/1024/1024)}')

echo "  Backend: ${BACKEND_SIZE_MB}MB (target: <${MAX_BACKEND_SIZE_MB}MB)"

if [ "${BACKEND_SIZE_MB}" -gt "${MAX_BACKEND_SIZE_MB}" ]; then
    echo -e "${YELLOW}⚠ Warning: Backend image exceeds target size${NC}"
else
    echo -e "${GREEN}✓ Backend image size is within target${NC}"
fi
echo ""

# Load images into Minikube (if Minikube is running)
echo -e "${YELLOW}[5/6]${NC} Checking Minikube status..."
if command -v minikube &> /dev/null && minikube status > /dev/null 2>&1; then
    echo "  Minikube is running. Loading images..."

    if minikube image load "${FRONTEND_IMAGE}"; then
        echo -e "${GREEN}✓ Frontend image loaded into Minikube${NC}"
    else
        echo -e "${YELLOW}⚠ Warning: Failed to load frontend image into Minikube${NC}"
    fi

    if minikube image load "${BACKEND_IMAGE}"; then
        echo -e "${GREEN}✓ Backend image loaded into Minikube${NC}"
    else
        echo -e "${YELLOW}⚠ Warning: Failed to load backend image into Minikube${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Minikube is not running. Skipping image load.${NC}"
    echo "  Run 'minikube start' and then load images manually:"
    echo "  - minikube image load ${FRONTEND_IMAGE}"
    echo "  - minikube image load ${BACKEND_IMAGE}"
fi
echo ""

# Summary
echo -e "${YELLOW}[6/6]${NC} Build Summary"
echo "========================================"
echo -e "${GREEN}✓ All images built successfully${NC}"
echo ""
echo "Images:"
echo "  - ${FRONTEND_IMAGE} (${FRONTEND_SIZE_MB}MB)"
echo "  - ${BACKEND_IMAGE} (${BACKEND_SIZE_MB}MB)"
echo ""
echo "Next steps:"
echo "  1. Ensure Minikube is running: minikube start"
echo "  2. Deploy with Helm: cd ../helm-chart/todo-chatbot && helm install todo-chatbot . -n todo-app -f values-local.yaml"
echo "  3. Or use deploy.sh: ./deploy.sh"
echo ""
echo -e "${GREEN}Done!${NC}"
