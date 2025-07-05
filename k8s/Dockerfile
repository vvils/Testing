FROM nginx:alpine

# Install Python for backend functionality
RUN apk add --no-cache python3 py3-pip

# Copy frontend files to nginx directory
COPY frontend/index.html /usr/share/nginx/html/index.html
COPY frontend/style.css /usr/share/nginx/html/style.css
COPY frontend/script.js /usr/share/nginx/html/script.js
COPY frontend/health.html /usr/share/nginx/html/health.html

# Copy backend files
COPY backend/ /app/backend/

# Install Python dependencies (using --break-system-packages for containerized environment)
RUN pip3 install --break-system-packages -r /app/backend/requirements.txt

# Expose port 80 for nginx
EXPOSE 80
