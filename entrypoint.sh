#!/bin/sh
LISTEN_PORT="${PORT:-8080}"
sed -i "s/listen 8080;/listen ${LISTEN_PORT};/g" /etc/nginx/nginx.conf

echo "🚀 Nagsisimula ang Xray…"
xray run -config /etc/xray/x‑ray.json &
XRAY_PID=$!
sleep 4
if ! kill -0 "$XRAY_PID" 2>/dev/null; then
  echo "❌ HINDI NAGSIMULA ANG Xray"
  exit 1
fi
echo "✅ Tumatakbo ang Xray, PID: $XRAY_PID"

exec nginx -g 'daemon off;'
