# Environment Variables Setup Guide

## 🔐 Secure Environment Variable Management

### Local Development Setup

1. **Copy the example file:**
   ```bash
   cp .env.example .env
   ```

2. **Fill in your actual values in `.env`:**
   ```bash
   # Your actual values (NEVER commit this file!)
   DOCKERHUB_USERNAME=your-actual-username
   DOCKERHUB_TOKEN=dckr_pat_your-actual-token
   GITHUB_PERSONAL_ACCESS_TOKEN=ghp_your-actual-token
   # ... etc
   ```

3. **The `.env` file is automatically ignored by git** - it will never be committed.

### Production/CI Environment Variables

For production and CI/CD, use **GitHub Secrets** instead of `.env` files:

1. Go to your repository: **Settings** → **Secrets and variables** → **Actions**

2. Add these secrets:
   - `DOCKERHUB_USERNAME`
   - `DOCKERHUB_TOKEN`
   - `KUBE_CONFIG` (base64 encoded)
   - `DJANGO_SECRET_KEY`

3. Reference them in GitHub Actions:
   ```yaml
   env:
     DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
     DOCKERHUB_TOKEN: ${{ secrets.DOCKERHUB_TOKEN }}
   ```

### Environment Variables Reference

| Variable | Purpose | Local Dev | CI/CD |
|----------|---------|-----------|--------|
| `DOCKERHUB_USERNAME` | Docker Hub login | `.env` | GitHub Secret |
| `DOCKERHUB_TOKEN` | Docker Hub token | `.env` | GitHub Secret |
| `GITHUB_PERSONAL_ACCESS_TOKEN` | Runner setup only | `.env` | Not needed |
| `KUBE_CONFIG` | Kubernetes access | `.env` | GitHub Secret |
| `DJANGO_SECRET_KEY` | Django security | `.env` | GitHub Secret |
| `DEBUG` | Django debug mode | `.env` | Environment specific |

### Security Best Practices

✅ **DO:**
- Use `.env` files for local development
- Use GitHub Secrets for CI/CD
- Use different secrets for staging/production
- Rotate secrets regularly
- Use least-privilege access

❌ **DON'T:**
- Commit `.env` files to git
- Share secrets in chat/email
- Use production secrets in development
- Hardcode secrets in code
- Use weak or default secrets

### Troubleshooting

**Problem: "Environment variable not found"**
- Check if `.env` file exists and has correct values
- Verify variable names match exactly (case sensitive)
- For CI/CD, check GitHub Secrets are set correctly

**Problem: "Permission denied"**
- Verify tokens have correct permissions
- Check token expiration dates
- Ensure secrets are not expired

### Recovery from Exposed Secrets

If secrets were accidentally exposed:

1. **Immediately revoke the exposed secrets:**
   - Docker Hub: Settings → Security → Access Tokens
   - GitHub: Settings → Developer settings → Personal access tokens

2. **Generate new secrets**

3. **Update all environments:**
   - Local `.env` file
   - GitHub Secrets
   - Any production deployments

4. **Monitor for unauthorized usage**