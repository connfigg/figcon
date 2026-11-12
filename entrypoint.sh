#!/bin/sh

# Kuhaon ang PORT gikan sa Cloud Run environment (default 8080)
LISTEN_PORT="${PORT:-8080}"

# I-update ang listening port sa nginx.conf base sa Cloud Run
sed -i "s/listen 8080;/listen ${LISTEN_PORT};/g" /etc/nginx/nginx.conf

# Padaganon ang Xray sa background
/usr/local/bin/xray run -config /etc/xray/x-ray.json &

# Padaganon ang Nginx sa foreground aron magpabiling buhi ang container
exec nginx -g 'daemon off;'
