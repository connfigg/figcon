#!/bin/sh
LISTEN_PORT="${PORT:-8080}"
sed -i "s/listen 8080;/listen ${LISTEN_PORT};/g" /etc/nginx/nginx.conf

echo "🚀 Nagsisimula ang Xray…"
xray run -config /etc/xray/x-ray.json > /var/log/xray.log 2>&1 &
XRAY_PID=$!
sleep 6

if ! kill -0 "$XRAY_PID" 2>/dev/null; then
  echo "❌ HINDI NAGSIMULA ANG Xray"
  echo "📋 Xray Error Log:"
  cat /var/log/xray.log
  exit 1
fi

echo "✅ Tumatakbo ang Xray, PID: $XRAY_PID"
exec nginx -g 'daemon off;'
