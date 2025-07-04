# Staging to Production Workflow Guide

## 🔄 **Complete Workflow Overview**

```
Development → Staging → Testing → Production → Monitoring
     ↓           ↓         ↓         ↓           ↓
   Local     Deploy    Verify    Deploy    Monitor
   Testing   to Staging  Staging  to Prod   Production
```

## 🚨 **What Happens When There's a Problem in Staging**

### **Scenario 1: Staging Deployment Fails**

**What happens:**
1. CI/CD pipeline detects the failure
2. Staging deployment stops
3. Production deployment is **NOT triggered**
4. You get notified of the failure

**How to fix it:**

#### **Step 1: Identify the Problem**
```bash
# Check staging deployment status
kubectl get deployments -n staging

# Check staging pods
kubectl get pods -n staging

# Check staging logs
kubectl logs -l app=simple-app-staging -n staging

# Describe the deployment for detailed error info
kubectl describe deployment simple-app-staging -n staging
```

#### **Step 2: Common Issues and Fixes**

**Issue: Image pull error**
```bash
# Check if image exists
docker pull wilsonw321/simple-app:staging-abc123

# Rebuild and push the image
docker build -t wilsonw321/simple-app:staging-abc123 .
docker push wilsonw321/simple-app:staging-abc123
```

**Issue: Health check failing**
```bash
# Check if health endpoint is accessible
kubectl port-forward service/simple-app-staging-service 8081:80 -n staging
curl http://localhost:8081/health.html

# Check health endpoint logs
kubectl logs -l app=simple-app-staging -n staging
```

**Issue: Resource constraints**
```bash
# Check resource usage
kubectl top pods -n staging

# Increase resource limits in kubernetes-staging.yaml
```

#### **Step 3: Fix and Redeploy**
```bash
# Make your fixes in the code
# Commit and push to trigger new staging deployment
git add .
git commit -m "Fix staging issue: [describe the fix]"
git push origin feature-branch
```

### **Scenario 2: Staging Works but Tests Fail**

**What happens:**
1. Staging deployment succeeds
2. Automated tests run against staging
3. If tests fail, production deployment is **NOT triggered**
4. You need to fix the issues and redeploy

**How to fix it:**

#### **Step 1: Run Tests Locally**
```bash
# Test your application locally first
docker build -t test-app .
docker run -p 8080:80 test-app

# Run your test suite
# npm test
# pytest
# etc.
```

#### **Step 2: Fix Issues and Redeploy**
```bash
# Fix the issues in your code
# Commit and push to trigger new staging deployment
git add .
git commit -m "Fix failing tests: [describe the fix]"
git push origin feature-branch
```

## ✅ **What Happens When Staging Succeeds**

### **Scenario 1: Pull Request to Main/Master**

**Workflow:**
1. ✅ Staging deployment succeeds
2. ✅ All tests pass
3. ✅ Code review approved
4. ✅ Merge to main/master
5. 🚀 **Automatic production deployment triggered**

### **Scenario 2: Direct Push to Main/Master**

**Workflow:**
1. ✅ Staging deployment succeeds
2. ✅ All tests pass
3. 🚀 **Automatic production deployment triggered**

## 🚀 **Production Deployment Process**

### **Step 1: Build Production Image**
```bash
# CI/CD automatically builds and tags the image
docker build -t wilsonw321/simple-app:latest .
docker build -t wilsonw321/simple-app:$GITHUB_SHA .
docker push wilsonw321/simple-app:latest
docker push wilsonw321/simple-app:$GITHUB_SHA
```

### **Step 2: Deploy to Production**
```bash
# Apply production configuration
kubectl apply -f k8s/kubernetes.yaml

# Update production deployment with new image
kubectl set image deployment/simple-app simple-app=wilsonw321/simple-app:$GITHUB_SHA -n default

# Wait for rollout to complete
kubectl rollout status deployment/simple-app -n default --timeout=300s
```

### **Step 3: Verify Production Deployment**
```bash
# Check deployment status
kubectl get deployments -n default

# Check pod status
kubectl get pods -l app=simple-app -n default

# Test production health endpoint
kubectl port-forward service/simple-app-service 8080:80 -n default
curl http://localhost:8080/health.html
```

## 🔄 **Rollback Process**

### **Automatic Rollback (If Production Deployment Fails)**
```bash
# CI/CD automatically rolls back to previous version
kubectl rollout undo deployment/simple-app -n default
kubectl rollout status deployment/simple-app -n default
```

### **Manual Rollback (If Issues Found After Deployment)**
```bash
# Rollback to previous version
kubectl rollout undo deployment/simple-app -n default

# Rollback to specific version
kubectl rollout undo deployment/simple-app --to-revision=2 -n default

# Check rollout history
kubectl rollout history deployment/simple-app -n default
```

## 📊 **Monitoring and Verification**

### **Staging Monitoring**
```bash
# Check staging status
kubectl get all -n staging

# Monitor staging logs
kubectl logs -f -l app=simple-app-staging -n staging

# Test staging functionality
kubectl port-forward service/simple-app-staging-service 8081:80 -n staging
# Visit http://localhost:8081
```

### **Production Monitoring**
```bash
# Check production status
kubectl get all -n default

# Monitor production logs
kubectl logs -f -l app=simple-app -n default

# Test production functionality
kubectl port-forward service/simple-app-service 8080:80 -n default
# Visit http://localhost:8080
```

## 🛠️ **Manual Deployment Commands**

### **Deploy to Staging Manually**
```bash
# Build and push staging image
docker build -t wilsonw321/simple-app:staging .
docker push wilsonw321/simple-app:staging

# Deploy to staging
kubectl apply -f k8s/kubernetes-staging.yaml
kubectl set image deployment/simple-app-staging simple-app=wilsonw321/simple-app:staging -n staging
kubectl rollout status deployment/simple-app-staging -n staging
```

### **Deploy to Production Manually**
```bash
# Build and push production image
docker build -t wilsonw321/simple-app:latest .
docker push wilsonw321/simple-app:latest

# Deploy to production
kubectl apply -f k8s/kubernetes.yaml
kubectl set image deployment/simple-app simple-app=wilsonw321/simple-app:latest -n default
kubectl rollout status deployment/simple-app -n default
```

## 🔍 **Troubleshooting Commands**

### **Check Deployment Status**
```bash
# Check all deployments
kubectl get deployments --all-namespaces

# Check specific deployment
kubectl describe deployment simple-app -n default
kubectl describe deployment simple-app-staging -n staging
```

### **Check Pod Status**
```bash
# Check all pods
kubectl get pods --all-namespaces

# Check specific pods
kubectl get pods -l app=simple-app -n default
kubectl get pods -l app=simple-app-staging -n staging
```

### **Check Logs**
```bash
# Check application logs
kubectl logs -l app=simple-app -n default
kubectl logs -l app=simple-app-staging -n staging

# Follow logs in real-time
kubectl logs -f -l app=simple-app -n default
```

### **Check Events**
```bash
# Check cluster events
kubectl get events --all-namespaces --sort-by=.metadata.creationTimestamp

# Check namespace-specific events
kubectl get events -n default
kubectl get events -n staging
```

## 📋 **Summary**

### **Staging Issues → Fix Process:**
1. **Identify the problem** using kubectl commands
2. **Fix the code** locally
3. **Test locally** before pushing
4. **Commit and push** to trigger new staging deployment
5. **Verify staging** works before merging to main

### **Staging Success → Production Process:**
1. **Merge to main/master** (triggers production deployment)
2. **CI/CD builds** production image
3. **CI/CD deploys** to production
4. **CI/CD verifies** production deployment
5. **Monitor production** for any issues

### **Production Issues → Rollback Process:**
1. **Automatic rollback** if deployment fails
2. **Manual rollback** if issues found after deployment
3. **Investigate and fix** the issues
4. **Redeploy** when ready

This workflow ensures that only tested, working code reaches production while providing quick feedback and easy rollback capabilities. 