#!/bin/bash
echo "=== Starting Unified Development Environment ==="
echo "🌐 Everything through: http://localhost:3000"
echo

echo "🧹 Cleaning up previous containers..."
cd k8s
docker-compose down --remove-orphans

echo "🚀 Starting containers with nginx reverse proxy..."
docker-compose up --build -d

echo "⏳ Waiting for containers to be ready..."
echo "   (Django migrations will run automatically via entrypoint)"
sleep 8

echo "✅ Setup complete!"
echo
echo "🎯 Unified Access Points:"
echo "   Frontend: http://localhost:3000/"
echo "   Backend API: http://localhost:3000/api/test/"
echo "   Django Admin: http://localhost:3000/admin/"
echo
echo "📋 Useful commands:"
echo "   View logs: docker-compose logs -f"
echo "   Stop: docker-compose down"
echo
echo "📊 Attaching to container logs..."
docker-compose logs -f