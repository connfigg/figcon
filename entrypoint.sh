#!/bin/sh
mkdir -p /var/log/xray /var/log/nginx /var/log/supervisord /run/nginx
exec /usr/sbin/supervisord -c /etc/supervisord.conf
