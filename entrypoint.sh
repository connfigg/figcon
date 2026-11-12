#!/bin/sh

# Kuhaon ang PORT gikan sa Cloud Run environment (default 8080)
LISTEN_PORT="${PORT:-8080}"

# I-update ang listening port sa nginx.conf base sa Cloud Run PORT
sed -i "s/listen 8080;/listen ${LISTEN_PORT};/g" /etc/nginx/nginx.conf

echo "=== Testing Xray Configuration ==="
/usr/local/bin/xray -test -config /etc/xray/x-ray.json

if [ $? -ne 0 ]; then
    echo "=== XRAY CONFIG TEST FAILED ==="
    exit 1
fi

echo "=== Starting Xray Core ==="
/usr/local/bin/xray run -config /etc/xray/x-ray.json &

# Paminawon nato og 1 segundos
sleep 1

echo "=== Starting Nginx ==="
exec nginx -g 'daemon off;'
