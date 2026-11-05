#!/bin/bash

echo "[*] Starting Xray Core backend using xray.json..."
/usr/local/bin/xray/xray -config /etc/xray/xray.json &

echo "[*] Starting Nginx web server on port 8080..."
exec nginx -g 'daemon off;'
