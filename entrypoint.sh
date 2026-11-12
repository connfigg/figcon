#!/bin/sh

# Kuhaon ang PORT gikan sa Cloud Run environment (default 8080)
LISTEN_PORT="${PORT:-8080}"

# I-update ang listening port sa nginx.conf base sa Cloud Run PORT
sed -i "s/listen 8080;/listen ${LISTEN_PORT};/g" /etc/nginx/nginx.conf

echo "=== Starting Xray Core ==="
/usr/local/bin/xray run -config /etc/xray/x-ray.json &

# Hatagan nato og 3 segundos ang Xray aron malinawon nga maka-start ug maablihan ang mga ports
echo "Waiting for Xray core to initialize..."
sleep 6

echo "=== Starting Nginx ==="
exec nginx -g 'daemon off;'
