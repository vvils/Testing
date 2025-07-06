# Multi-stage build for Django backend
FROM python:3.11-slim as backend

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY backend/requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend project
COPY backend/ /app/

# Copy entrypoint script explicitly and make it executable
COPY backend/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Create a non-root user for security
RUN adduser --disabled-password --gecos '' appuser
RUN chown -R appuser:appuser /app

# Expose port 8000 for Django
EXPOSE 8000

# Set entrypoint to handle migrations
ENTRYPOINT ["/app/entrypoint.sh"]

# Switch to non-root user AFTER setting entrypoint
USER appuser

# Default command for production
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "django_config.wsgi:application"]
