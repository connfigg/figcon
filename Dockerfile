FROM alpine:latest

# 1. I-install ang mga kailangan
RUN apk add --no-cache nginx curl unzip tzdata dos2unix

# 2. I-download ang Xray-core at Geodata files sa tamang direktoryo
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then XRAY_ARCH="64"; \
    elif [ "$ARCH" = "aarch64" ]; then XRAY_ARCH="arm64-v8a"; \
    else XRAY_ARCH="64"; fi && \
    curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-${XRAY_ARCH}.zip && \
    mkdir -p /usr/local/bin /usr/local/share/xray && \
    unzip /tmp/xray.zip -d /tmp/xray && \
    mv /tmp/xray/xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    # I-save ang geoip.dat at geosite.dat sa /usr/local/share/xray/ kung saan awtomatikong hinahanap ng Xray
    curl -L -o /usr/local/share/xray/geoip.dat https://github.com/XTLS/Xray-rules-dat/releases/latest/download/geoip.dat && \
    curl -L -o /usr/local/share/xray/geosite.dat https://github.com/XTLS/Xray-rules-dat/releases/latest/download/geosite.dat && \
    rm -rf /tmp/xray.zip /tmp/xray

# 3. I-link din sa /usr/local/bin para sigurado
RUN ln -s /usr/local/share/xray/geoip.dat /usr/local/bin/geoip.dat && \
    ln -s /usr/local/share/xray/geosite.dat /usr/local/bin/geosite.dat

# Nginx HTML directory
RUN mkdir -p /usr/share/nginx/html

# Kopyahin ang mga configuration files at HTML
COPY x-ray.json /etc/xray/x-ray.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html
COPY entrypoint.sh /entrypoint.sh

# Ayusin ang line endings at permissions
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
