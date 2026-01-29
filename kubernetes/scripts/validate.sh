#!/bin/bash
# validate.sh - Validate Todo Chatbot deployment
# Usage: ./validate.sh

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
NAMESPACE="todo-app"
FRONTEND_PORT=30080
BACKEND_PORT=30800

echo "========================================"
echo "   Todo Chatbot - Validation Script"
echo "========================================"
echo ""

# Test counter
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Helper functions
test_start() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -n "  [$TOTAL_TESTS] $1... "
}

test_pass() {
    PASSED_TESTS=$((PASSED_TESTS + 1))
    echo -e "${GREEN}✓ PASS${NC}"
}

test_fail() {
    FAILED_TESTS=$((FAILED_TESTS + 1))
    echo -e "${RED}✗ FAIL${NC}"
    if [ -n "$1" ]; then
        echo -e "      ${RED}$1${NC}"
    fi
}

# Step 1: Check cluster connectivity
echo -e "${YELLOW}[1/6]${NC} Checking cluster connectivity..."

test_start "kubectl can connect to cluster"
if kubectl cluster-info > /dev/null 2>&1; then
    test_pass
else
    test_fail "Run 'minikube start' to start the cluster"
fi

test_start "Namespace '${NAMESPACE}' exists"
if kubectl get namespace "${NAMESPACE}" > /dev/null 2>&1; then
    test_pass
else
    test_fail "Namespace not found"
fi

echo ""

# Step 2: Check pod status
echo -e "${YELLOW}[2/6]${NC} Checking pod status..."

test_start "Frontend pods are running"
FRONTEND_RUNNING=$(kubectl get pods -n "${NAMESPACE}" -l app=frontend -o jsonpath='{.items[?(@.status.phase=="Running")].metadata.name}' | wc -w)
if [ "${FRONTEND_RUNNING}" -gt 0 ]; then
    test_pass
    echo "      Found ${FRONTEND_RUNNING} running frontend pod(s)"
else
    test_fail "No running frontend pods found"
fi

test_start "Backend pods are running"
BACKEND_RUNNING=$(kubectl get pods -n "${NAMESPACE}" -l app=backend -o jsonpath='{.items[?(@.status.phase=="Running")].metadata.name}' | wc -w)
if [ "${BACKEND_RUNNING}" -gt 0 ]; then
    test_pass
    echo "      Found ${BACKEND_RUNNING} running backend pod(s)"
else
    test_fail "No running backend pods found"
fi

test_start "All pods are ready"
NOT_READY=$(kubectl get pods -n "${NAMESPACE}" -o jsonpath='{.items[?(@.status.conditions[?(@.type=="Ready")].status!="True")].metadata.name}' | wc -w)
if [ "${NOT_READY}" -eq 0 ]; then
    test_pass
else
    test_fail "${NOT_READY} pod(s) are not ready"
    kubectl get pods -n "${NAMESPACE}" -o wide | grep -v "Running\|Completed" || true
fi

echo ""

# Step 3: Check services
echo -e "${YELLOW}[3/6]${NC} Checking services..."

test_start "Frontend service exists"
if kubectl get svc -n "${NAMESPACE}" | grep -q "frontend"; then
    test_pass
else
    test_fail "Frontend service not found"
fi

test_start "Backend service exists"
if kubectl get svc -n "${NAMESPACE}" | grep -q "backend"; then
    test_pass
else
    test_fail "Backend service not found"
fi

test_start "Frontend service has NodePort ${FRONTEND_PORT}"
FRONTEND_NODEPORT=$(kubectl get svc -n "${NAMESPACE}" -o jsonpath='{.items[?(@.metadata.name contains "frontend")].spec.ports[0].nodePort}')
if [ "${FRONTEND_NODEPORT}" == "${FRONTEND_PORT}" ]; then
    test_pass
else
    test_fail "Expected ${FRONTEND_PORT}, got ${FRONTEND_NODEPORT}"
fi

test_start "Backend service has NodePort ${BACKEND_PORT}"
BACKEND_NODEPORT=$(kubectl get svc -n "${NAMESPACE}" -o jsonpath='{.items[?(@.metadata.name contains "backend")].spec.ports[0].nodePort}')
if [ "${BACKEND_NODEPORT}" == "${BACKEND_PORT}" ]; then
    test_pass
else
    test_fail "Expected ${BACKEND_PORT}, got ${BACKEND_NODEPORT}"
fi

echo ""

# Step 4: Test health endpoints
echo -e "${YELLOW}[4/6]${NC} Testing health endpoints..."

test_start "Backend health endpoint responds"
if curl -f -s "http://localhost:${BACKEND_PORT}/health" > /dev/null 2>&1; then
    test_pass
    HEALTH_RESPONSE=$(curl -s "http://localhost:${BACKEND_PORT}/health")
    echo "      Response: ${HEALTH_RESPONSE}"
else
    test_fail "Health endpoint not accessible"
fi

test_start "Frontend is accessible"
if curl -f -s "http://localhost:${FRONTEND_PORT}/" > /dev/null 2>&1; then
    test_pass
else
    test_fail "Frontend not accessible at http://localhost:${FRONTEND_PORT}"
fi

echo ""

# Step 5: Resource validation
echo -e "${YELLOW}[5/6]${NC} Checking resource configuration..."

test_start "ConfigMap exists"
if kubectl get configmap -n "${NAMESPACE}" | grep -q "config"; then
    test_pass
else
    test_fail "ConfigMap not found"
fi

test_start "Secret exists"
if kubectl get secret -n "${NAMESPACE}" | grep -q "secret"; then
    test_pass
else
    test_fail "Secret not found"
fi

echo ""

# Step 6: Quick smoke tests
echo -e "${YELLOW}[6/6]${NC} Running smoke tests..."

test_start "Backend root endpoint responds"
if curl -f -s "http://localhost:${BACKEND_PORT}/" | grep -q "AI-Powered Todo Chatbot"; then
    test_pass
else
    test_fail "Backend root endpoint test failed"
fi

test_start "Backend API docs accessible (if enabled)"
if curl -f -s "http://localhost:${BACKEND_PORT}/docs" > /dev/null 2>&1; then
    test_pass
    echo "      API docs available at http://localhost:${BACKEND_PORT}/docs"
else
    echo -e "${YELLOW}⚠ SKIP${NC} (API docs may be disabled in production)"
fi

echo ""

# Summary
echo "========================================"
echo "          Validation Summary"
echo "========================================"
echo ""
echo "Total Tests:  ${TOTAL_TESTS}"
echo -e "Passed:       ${GREEN}${PASSED_TESTS}${NC}"
if [ "${FAILED_TESTS}" -gt 0 ]; then
    echo -e "Failed:       ${RED}${FAILED_TESTS}${NC}"
else
    echo -e "Failed:       ${FAILED_TESTS}"
fi
echo ""

if [ "${FAILED_TESTS}" -eq 0 ]; then
    echo -e "${GREEN}✓ All validations passed!${NC}"
    echo ""
    echo "🌐 Access your application:"
    echo -e "  Frontend:      ${BLUE}http://localhost:${FRONTEND_PORT}${NC}"
    echo -e "  Backend API:   ${BLUE}http://localhost:${BACKEND_PORT}${NC}"
    echo -e "  Backend Docs:  ${BLUE}http://localhost:${BACKEND_PORT}/docs${NC}"
    echo -e "  Health Check:  ${BLUE}http://localhost:${BACKEND_PORT}/health${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some validations failed${NC}"
    echo ""
    echo "Troubleshooting:"
    echo "  1. Check pod logs:    kubectl logs -n ${NAMESPACE} <pod-name>"
    echo "  2. Describe pods:     kubectl describe pod -n ${NAMESPACE} <pod-name>"
    echo "  3. Check events:      kubectl get events -n ${NAMESPACE} --sort-by='.lastTimestamp'"
    echo "  4. Verify secrets:    Ensure values-local.yaml has correct credentials"
    echo ""
    exit 1
fi
