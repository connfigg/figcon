FROM alpine:3.19

RUN apk add --no-cache nginx curl bash tzdata supervisor

RUN mkdir -p /var/log/xray /var/log/nginx /var/log/supervisord /etc/xray /usr/share/nginx/html /run/nginx

RUN XRAY_VERSION=$(curl -s "https://api.github.com/repos/XTLS/Xray-core/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    curl -L -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip" && \
    mkdir -p /usr/local/bin/xray /usr/local/share/xray && \
    unzip /tmp/xray.zip -d /tmp/xray_extract && \
    mv /tmp/xray_extract/xray /usr/local/bin/xray/ && \
    mv /tmp/xray_extract/geoip.dat /usr/local/share/xray/ && \
    mv /tmp/xray_extract/geosite.dat /usr/local/share/xray/ && \
    chmod +x /usr/local/bin/xray/xray && \
    rm -rf /tmp/xray.zip /tmp/xray_extract

COPY nginx.conf /etc/nginx/nginx.conf
COPY xray.json /etc/xray/config.json
COPY index.html /usr/share/nginx/html/index.html
COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
