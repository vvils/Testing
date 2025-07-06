#!/bin/bash

# Django Entrypoint Script
# Runs migrations before starting the server in all environments

set -e  # Exit on any error

echo "🗃️ Running Django migrations..."

# Create any new migrations
python manage.py makemigrations --noinput

# Apply all migrations
python manage.py migrate --noinput

# Collect static files (for production)
if [ "$DJANGO_SETTINGS_MODULE" != "django_config.settings" ] || [ "$DEBUG" = "False" ]; then
    echo "📁 Collecting static files..."
    python manage.py collectstatic --noinput
fi

echo "✅ Django initialization complete!"
echo "🚀 Starting server..."

# Execute the main command (runserver, gunicorn, etc.)
exec "$@"