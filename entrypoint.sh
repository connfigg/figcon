#!/bin/sh

# Kuhaon ang PORT gikan sa Cloud Run environment (default 8080)
LISTEN_PORT="${PORT:-8080}"

# I-update ang listening port sa nginx.conf base sa Cloud Run PORT
sed -i "s/listen 8080;/listen ${LISTEN_PORT};/g" /etc/nginx/nginx.conf

echo "=== Starting Xray Core ==="
/usr/local/bin/xray run -config /etc/xray/x-ray.json > /tmp/xray.log 2>&1 &

# Paminawon nato og 2 segundos ang Xray kung ni-crash ba
sleep 2

echo "=== Xray Log Output ==="
cat /tmp/xray.log

echo "=== Starting Nginx ==="
exec nginx -g 'daemon off;'
