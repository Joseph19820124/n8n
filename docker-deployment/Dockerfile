# Custom n8n Docker image with SuperCode node
FROM n8nio/n8n:latest

# Switch to root to install custom nodes
USER root

# Install the SuperCode custom node package
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install @kenkaiii/n8n-nodes-supercode && \
    # Fix permissions
    chown -R node:node /usr/local/lib/node_modules/n8n/node_modules/@kenkaiii

# Switch back to node user
USER node

# Expose the default n8n port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1