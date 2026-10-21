#!/bin/sh

# Adjust Nginx port dynamically based on Cloud Run PORT variable
LISTEN_PORT="${PORT:-8080}"
sed -i "s/listen 8080;/listen ${LISTEN_PORT};/g" /etc/nginx/nginx.conf

# Start Xray in background
xray run -config /etc/xray/x-ray.json &

# Start Nginx in foreground
exec nginx -g 'daemon off;'
