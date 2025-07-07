#!/bin/bash

# Port Forward Helper Script
# This script provides easy access to staging and production environments via port forwarding

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function usage() {
    echo "Usage: $0 [staging|production|stop]"
    echo ""
    echo "Commands:"
    echo "  staging     - Port forward staging environment to localhost:3001"
    echo "  production  - Port forward production environment to localhost:3002"
    echo "  stop        - Stop all port forwarding processes"
    echo ""
    echo "Examples:"
    echo "  $0 staging"
    echo "  $0 production"
    echo "  $0 stop"
}

function check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        echo -e "${RED}Error: kubectl is not installed or not in PATH${NC}"
        exit 1
    fi
}

function stop_port_forwards() {
    echo -e "${YELLOW}Stopping all port forwarding processes...${NC}"
    pkill -f "kubectl port-forward.*staging" 2>/dev/null || true
    pkill -f "kubectl port-forward.*production" 2>/dev/null || true
    echo -e "${GREEN}All port forwarding processes stopped${NC}"
}

function start_staging() {
    echo -e "${YELLOW}Starting port forward for staging environment...${NC}"
    
    # Check if service exists
    if ! kubectl get service simple-app-staging-service -n staging &> /dev/null; then
        echo -e "${RED}Error: Staging service not found. Make sure the staging environment is deployed.${NC}"
        exit 1
    fi
    
    # Stop any existing port forwards
    pkill -f "kubectl port-forward.*staging" 2>/dev/null || true
    
    echo -e "${GREEN}Port forwarding staging to localhost:3001${NC}"
    echo -e "${GREEN}Visit: http://localhost:3001${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop${NC}"
    
    kubectl port-forward service/simple-app-staging-service 3001:3001 -n staging
}

function start_production() {
    echo -e "${YELLOW}Starting port forward for production environment...${NC}"
    
    # Check if service exists
    if ! kubectl get service simple-app-service -n production &> /dev/null; then
        echo -e "${RED}Error: Production service not found. Make sure the production environment is deployed.${NC}"
        exit 1
    fi
    
    # Stop any existing port forwards
    pkill -f "kubectl port-forward.*production" 2>/dev/null || true
    
    echo -e "${GREEN}Port forwarding production to localhost:3002${NC}"
    echo -e "${GREEN}Visit: http://localhost:3002${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop${NC}"
    
    kubectl port-forward service/simple-app-service 3002:8000 -n production
}

# Main script
check_kubectl

case "${1:-}" in
    staging)
        start_staging
        ;;
    production)
        start_production
        ;;
    stop)
        stop_port_forwards
        ;;
    -h|--help)
        usage
        ;;
    *)
        echo -e "${RED}Error: Invalid argument${NC}"
        echo ""
        usage
        exit 1
        ;;
esac