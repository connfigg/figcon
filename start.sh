#!/bin/bash

# Start Xray
/usr/local/bin/xray run -config /usr/local/etc/xray/config.json &
XRAY_PID=$!
sleep 2

# Start Nginx
nginx -g 'daemon off;' &
NGINX_PID=$!

trap "kill $XRAY_PID $NGINX_PID; exit 0" SIGTERM SIGINT
wait
