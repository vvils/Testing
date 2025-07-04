# Docker, Docker Compose & Kubernetes Commands Reference

## 🐳 Docker Commands

### Basic Docker Commands
```bash
# Build an image
docker build -t myapp:latest .

# Run a container
docker run -d -p 8080:80 myapp:latest

# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Stop a container
docker stop <container_id>

# Remove a container
docker rm <container_id>

# Remove all stopped containers
docker container prune

# List images
docker images

# Remove an image
docker rmi <image_id>

# Remove all unused images
docker image prune -a

# View container logs
docker logs <container_id>

# Follow logs in real-time
docker logs -f <container_id>

# Execute command in running container
docker exec -it <container_id> /bin/bash

# Copy files from/to container
docker cp <container_id>:/path/to/file ./local/path
docker cp ./local/file <container_id>:/path/to/file
```

### Docker Registry Commands
```bash
# Login to Docker Hub
docker login

# Login to private registry
docker login registry.example.com

# Tag an image for registry
docker tag myapp:latest username/myapp:latest

# Push image to registry
docker push username/myapp:latest

# Pull image from registry
docker pull username/myapp:latest

# Search images
docker search nginx
```

### Docker System Commands
```bash
# View Docker system info
docker system df

# Clean up everything (containers, images, networks, volumes)
docker system prune -a --volumes

# View Docker daemon info
docker info

# View Docker version
docker version
```

### Docker Network Commands
```bash
# List networks
docker network ls

# Create a network
docker network create my-network

# Inspect a network
docker network inspect my-network

# Connect container to network
docker network connect my-network <container_id>

# Remove a network
docker network rm my-network
```

### Docker Volume Commands
```bash
# List volumes
docker volume ls

# Create a volume
docker volume create my-volume

# Inspect a volume
docker volume inspect my-volume

# Remove a volume
docker volume rm my-volume

# Remove all unused volumes
docker volume prune
```

## 🐙 Docker Compose Commands

### Basic Docker Compose Commands
```bash
# Start services
docker-compose up

# Start services in background
docker-compose up -d

# Stop services
docker-compose down

# View running services
docker-compose ps

# View service logs
docker-compose logs

# View logs for specific service
docker-compose logs <service_name>

# Follow logs
docker-compose logs -f

# Rebuild services
docker-compose build

# Rebuild and start services
docker-compose up --build

# Execute command in service
docker-compose exec <service_name> /bin/bash

# Scale services
docker-compose up --scale web=3
```

### Docker Compose Configuration
```bash
# Use specific compose file
docker-compose -f docker-compose.prod.yml up

# Use multiple compose files
docker-compose -f docker-compose.yml -f docker-compose.override.yml up

# Validate compose file
docker-compose config

# Show compose configuration
docker-compose config --services
```

### Docker Compose Management
```bash
# Pause services
docker-compose pause

# Unpause services
docker-compose unpause

# Restart services
docker-compose restart

# Pull latest images
docker-compose pull

# Remove stopped containers
docker-compose rm

# Remove all containers and networks
docker-compose down --volumes --remove-orphans
```

## ☸️ Kubernetes Commands

### Basic kubectl Commands
```bash
# Get cluster info
kubectl cluster-info

# Get nodes
kubectl get nodes

# Get all resources
kubectl get all

# Get resources in specific namespace
kubectl get all -n <namespace>

# Describe a resource
kubectl describe pod <pod_name>

# Get resource in YAML format
kubectl get pod <pod_name> -o yaml

# Get resource in JSON format
kubectl get pod <pod_name> -o json
```

### Pod Management
```bash
# Get pods
kubectl get pods

# Get pods with labels
kubectl get pods -l app=myapp

# Get pods with wide output
kubectl get pods -o wide

# Watch pods
kubectl get pods -w

# Delete a pod
kubectl delete pod <pod_name>

# Force delete a pod
kubectl delete pod <pod_name> --force --grace-period=0

# Execute command in pod
kubectl exec -it <pod_name> -- /bin/bash

# Copy files from/to pod
kubectl cp <pod_name>:/path/to/file ./local/path
kubectl cp ./local/file <pod_name>:/path/to/file
```

### Deployment Management
```bash
# Get deployments
kubectl get deployments

# Create deployment from file
kubectl apply -f deployment.yaml

# Update deployment
kubectl set image deployment/<deployment_name> <container_name>=<new_image>

# Scale deployment
kubectl scale deployment <deployment_name> --replicas=3

# Rollout status
kubectl rollout status deployment/<deployment_name>

# Rollback deployment
kubectl rollout undo deployment/<deployment_name>

# Rollback to specific revision
kubectl rollout undo deployment/<deployment_name> --to-revision=2

# Pause rollout
kubectl rollout pause deployment/<deployment_name>

# Resume rollout
kubectl rollout resume deployment/<deployment_name>

# View rollout history
kubectl rollout history deployment/<deployment_name>
```

### Service Management
```bash
# Get services
kubectl get services

# Create service
kubectl apply -f service.yaml

# Port forward to service
kubectl port-forward service/<service_name> 8080:80

# Expose deployment as service
kubectl expose deployment <deployment_name> --port=80 --target-port=8080
```

### Ingress Management
```bash
# Get ingress
kubectl get ingress

# Apply ingress
kubectl apply -f ingress.yaml

# Describe ingress
kubectl describe ingress <ingress_name>
```

### Namespace Management
```bash
# Get namespaces
kubectl get namespaces

# Create namespace
kubectl create namespace <namespace_name>

# Switch context to namespace
kubectl config set-context --current --namespace=<namespace_name>

# Get all resources in namespace
kubectl get all -n <namespace_name>
```

### ConfigMap and Secret Management
```bash
# Get configmaps
kubectl get configmaps

# Create configmap from file
kubectl create configmap <config_name> --from-file=config.properties

# Create configmap from literal
kubectl create configmap <config_name> --from-literal=key=value

# Get secrets
kubectl get secrets

# Create secret from file
kubectl create secret generic <secret_name> --from-file=secret.properties

# Create secret from literal
kubectl create secret generic <secret_name> --from-literal=username=admin --from-literal=password=secret
```

### Logs and Debugging
```bash
# View pod logs
kubectl logs <pod_name>

# Follow logs
kubectl logs -f <pod_name>

# View logs from previous container
kubectl logs <pod_name> --previous

# View logs from specific container in multi-container pod
kubectl logs <pod_name> -c <container_name>

# Get events
kubectl get events --sort-by=.metadata.creationTimestamp

# Get events for specific resource
kubectl get events --field-selector involvedObject.name=<pod_name>
```

### Resource Management
```bash
# Get resource usage
kubectl top nodes
kubectl top pods

# Get resource quotas
kubectl get resourcequotas

# Get limit ranges
kubectl get limitranges
```

### Context and Configuration
```bash
# Get contexts
kubectl config get-contexts

# Switch context
kubectl config use-context <context_name>

# Get current context
kubectl config current-context

# View kubeconfig
kubectl config view

# Set cluster
kubectl config set-cluster <cluster_name> --server=<server_url>

# Set credentials
kubectl config set-credentials <user_name> --token=<token>
```

### Advanced Commands
```bash
# Get resources with custom columns
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,IP:.status.podIP

# Get resources with JSONPath
kubectl get pods -o jsonpath='{.items[*].metadata.name}'

# Get resources with go-template
kubectl get pods -o go-template='{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'

# Patch resource
kubectl patch deployment <deployment_name> -p '{"spec":{"replicas":5}}'

# Replace resource
kubectl replace -f deployment.yaml

# Apply with server-side apply
kubectl apply -f deployment.yaml --server-side
```

### Troubleshooting Commands
```bash
# Check if pod is ready
kubectl get pods -o wide

# Check pod events
kubectl describe pod <pod_name>

# Check node resources
kubectl describe node <node_name>

# Check service endpoints
kubectl get endpoints <service_name>

# Check ingress controller
kubectl get pods -n ingress-nginx

# Check cluster events
kubectl get events --all-namespaces

# Check API server
kubectl get apiservices

# Check CRDs
kubectl get crd
```

### Useful Aliases and Shortcuts
```bash
# Add these to your ~/.bashrc or ~/.zshrc
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias ke='kubectl exec -it'
alias kp='kubectl port-forward'
alias kns='kubectl config set-context --current --namespace'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgi='kubectl get ingress'
```

### Quick Reference for Common Tasks

#### Deploy an Application
```bash
# 1. Create namespace
kubectl create namespace myapp

# 2. Apply deployment
kubectl apply -f deployment.yaml -n myapp

# 3. Apply service
kubectl apply -f service.yaml -n myapp

# 4. Apply ingress
kubectl apply -f ingress.yaml -n myapp

# 5. Check status
kubectl get all -n myapp
```

#### Update Application
```bash
# 1. Update image
kubectl set image deployment/myapp myapp=myapp:v2

# 2. Check rollout status
kubectl rollout status deployment/myapp

# 3. Check new pods
kubectl get pods -l app=myapp
```

#### Debug Application
```bash
# 1. Check pod status
kubectl get pods -l app=myapp

# 2. Check pod logs
kubectl logs <pod_name>

# 3. Describe pod for details
kubectl describe pod <pod_name>

# 4. Execute into pod
kubectl exec -it <pod_name> -- /bin/bash
```

#### Clean Up
```bash
# Delete all resources in namespace
kubectl delete namespace myapp

# Delete specific resources
kubectl delete deployment myapp
kubectl delete service myapp-service
kubectl delete ingress myapp-ingress
``` 