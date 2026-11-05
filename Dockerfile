FROM alpine:latest

# I‑install ang mga kailangan
RUN apk add --no-cache nginx curl unzip tzdata dos2unix

# I‑download ang Xray‑core ug geo data → diretso sa /etc/xray
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then XRAY_ARCH="64"; \
    elif [ "$ARCH" = "aarch64" ]; then XRAY_ARCH="arm64-v8a"; \
    else XRAY_ARCH="64"; fi && \
    curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-${XRAY_ARCH}.zip && \
    mkdir -p /usr/local/bin /etc/xray /var/log && \
    unzip /tmp/xray.zip -d /tmp/xray && \
    mv /tmp/xray/xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    curl -L -o /etc/xray/geoip.dat https://github.com/XTLS/Xray-rules-dat/releases/latest/download/geoip.dat && \
    curl -L -o /etc/xray/geosite.dat https://github.com/XTLS/Xray-rules-dat/releases/latest/download/geosite.dat && \
    rm -rf /tmp/xray.zip /tmp/xray

# HTML folder
RUN mkdir -p /usr/share/nginx/html

# Kopyaha ang mga file
COPY x-ray.json /etc/xray/x-ray.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html
COPY entrypoint.sh /entrypoint.sh

# Ayusa ang permissions ug i‑test ang Xray config
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh
RUN xray run -config /etc/xray/x-ray.json -test

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
