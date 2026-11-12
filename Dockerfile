FROM alpine:3.19

# Install Nginx, curl, bash, tzdata, and supervisord
RUN apk add --no-cache nginx curl bash tzdata supervisor

# Create ALL required directories FIRST
RUN mkdir -p /var/log/xray /usr/share/nginx/html /etc/xray \
    /var/log/supervisord /var/log/nginx /run/nginx

# Download and install official Xray binary
RUN XRAY_VERSION=$(curl -s "https://api.github.com/repos/XTLS/Xray-core/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    curl -L -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip" && \
    mkdir -p /usr/local/bin/xray /usr/local/share/xray && \
    unzip /tmp/xray.zip -d /tmp/xray_extract && \
    mv /tmp/xray_extract/xray /usr/local/bin/xray/ && \
    mv /tmp/xray_extract/geoip.dat /usr/local/share/xray/ && \
    mv /tmp/xray_extract/geosite.dat /usr/local/share/xray/ && \
    chmod +x /usr/local/bin/xray/xray && \
    rm -rf /tmp/xray.zip /tmp/xray_extract

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY xray.json /etc/xray/config.json
COPY index.html /usr/share/nginx/html/index.html
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 8080

# Make sure directories exist with correct permissions
RUN chmod 755 /var/log/supervisord /var/log/xray /var/log/nginx

ENTRYPOINT ["/usr/sbin/supervisord", "-c", "/etc/supervisord.conf"]
