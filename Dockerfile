FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends \
    nginx \
    curl \
    ca-certificates \
    tzdata \
    unzip \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Manila

# ✅ GUMAMIT NG TAMANG VERSION NUMBER
RUN set -eux; \
    ARCH="x86_64"; \
    XRAY_VERSION="v24.10.30"; \
    curl -L -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-${ARCH}.zip"; \
    unzip /tmp/xray.zip -d /tmp/xray; \
    mv /tmp/xray/xray /usr/local/bin/xray; \
    chmod +x /usr/local/bin/xray; \
    mkdir -p /usr/local/share/xray /usr/local/etc/xray; \
    mv /tmp/xray/geoip.dat /usr/local/share/xray/; \
    mv /tmp/xray/geosite.dat /usr/local/share/xray/; \
    rm -rf /tmp/xray /tmp/xray.zip

RUN mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY xray.json /usr/local/etc/xray/config.json
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
