#!/bin/sh

# Ensure log directories exist
mkdir -p /var/log/xray /var/log/nginx /run/nginx

# Start Xray in the background
echo "Starting Xray-core..."
/usr/local/bin/xray/xray run -config /etc/xray/config.json &

# Start Nginx in the foreground (keeps container alive and listens to PORT 8080)
echo "Starting Nginx..."
exec nginx -g "daemon off;"
