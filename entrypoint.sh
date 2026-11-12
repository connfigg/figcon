#!/bin/sh
mkdir -p /var/log/xray /var/log/nginx
exec /usr/sbin/supervisord -c /etc/supervisord.conf
