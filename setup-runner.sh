#!/bin/bash

# GitHub Actions Self-Hosted Runner Setup Script
# This script sets up a self-hosted GitHub Actions runner for this repository

set -e

echo "🚀 Setting up GitHub Actions Self-Hosted Runner..."

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed. Please install it first:"
    echo "   https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated with GitHub CLI
if ! gh auth status &> /dev/null; then
    echo "❌ You are not authenticated with GitHub CLI."
    echo "   Please run: gh auth login"
    exit 1
fi

# Create actions-runner directory if it doesn't exist
if [ ! -d "actions-runner" ]; then
    mkdir actions-runner
    echo "📁 Created actions-runner directory"
fi

cd actions-runner

# Download the latest runner package (Linux x64)
echo "📦 Downloading GitHub Actions Runner..."
RUNNER_VERSION=$(gh api repos/actions/runner/releases/latest --jq '.tag_name' | sed 's/^v//')
RUNNER_FILE="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

if [ ! -f "$RUNNER_FILE" ]; then
    curl -o "$RUNNER_FILE" -L "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
    echo "✅ Downloaded $RUNNER_FILE"
else
    echo "✅ $RUNNER_FILE already exists"
fi

# Extract the installer (only if not already extracted)
if [ ! -f "config.sh" ]; then
    echo "📂 Extracting runner package..."
    tar xzf "$RUNNER_FILE"
    echo "✅ Extracted runner package"
else
    echo "✅ Runner package already extracted"
fi

# Get repository information
REPO_URL=$(git remote get-url origin | sed 's/\.git$//')
if [[ $REPO_URL == git@* ]]; then
    # Convert SSH URL to HTTPS
    REPO_URL=$(echo $REPO_URL | sed 's/git@github.com:/https:\/\/github.com\//')
fi

echo "🔗 Repository URL: $REPO_URL"

# Get registration token
echo "🔑 Getting registration token..."
REPO_OWNER=$(echo $REPO_URL | sed 's/.*github\.com\///' | cut -d'/' -f1)
REPO_NAME=$(echo $REPO_URL | sed 's/.*github\.com\///' | cut -d'/' -f2)

REGISTRATION_TOKEN=$(gh api \
    --method POST \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/$REPO_OWNER/$REPO_NAME/actions/runners/registration-token" \
    --jq '.token')

if [ -z "$REGISTRATION_TOKEN" ]; then
    echo "❌ Failed to get registration token. Check your permissions."
    exit 1
fi

echo "✅ Got registration token"

# Configure the runner
echo "⚙️ Configuring runner..."
./config.sh --url "$REPO_URL" --token "$REGISTRATION_TOKEN" --name "$(hostname)-runner" --work "_work" --labels "self-hosted,Linux,X64" --unattended

echo "✅ Runner configured successfully!"

echo ""
echo "🎉 GitHub Actions Self-Hosted Runner Setup Complete!"
echo ""
echo "To start the runner:"
echo "   cd actions-runner"
echo "   ./run.sh"
echo ""
echo "To run as a service (recommended for production):"
echo "   sudo ./svc.sh install"
echo "   sudo ./svc.sh start"
echo ""
echo "To check runner status:"
echo "   sudo ./svc.sh status"
echo ""
echo "⚠️  Note: The actions-runner directory should NOT be committed to git."
echo "   It's already excluded by .gitignore"