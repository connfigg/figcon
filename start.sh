#!/bin/bash

# === PUMILI KA NG ISA — alisin ang # sa tapat ng gusto mo ===

# --- VLESS (Recommended) ---
cp /xray-configs/xray-vless.json /usr/local/etc/xray/config.json

# --- VMess (alisin ang # sa ibaba, lagyan ng # sa VLESS) ---
# cp /xray-configs/xray-vmess.json /usr/local/etc/xray/config.json

# --- Trojan (alisin ang # sa ibaba, lagyan ng # sa VLESS) ---
# cp /xray-configs/xray-trojan.json /usr/local/etc/xray/config.json

# Start Xray
/usr/local/bin/xray run -config /usr/local/etc/xray/config.json &
XRAY_PID=$!
sleep 2

# Start Nginx
nginx -g 'daemon off;' &
NGINX_PID=$!

trap "kill $XRAY_PID $NGINX_PID; exit 0" SIGTERM SIGINT
wait
