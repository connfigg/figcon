FROM debian:bookworm-slim

# Set noninteractive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y --no-install-recommends \
    nginx \
    curl \
    ca-certificates \
    tzdata \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set timezone
ENV TZ=Asia/Manila

# Manually download and install Xray (mas maaasahan kaysa sa install script)
RUN set -eux; \
    ARCH="x86_64"; \
    XRAY_VERSION="v24.10.31"; \
    curl -L -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-${ARCH}.zip"; \
    unzip /tmp/xray.zip -d /tmp/xray; \
    mv /tmp/xray/xray /usr/local/bin/xray; \
    chmod +x /usr/local/bin/xray; \
    mkdir -p /usr/local/share/xray /usr/local/etc/xray; \
    mv /tmp/xray/geoip.dat /usr/local/share/xray/; \
    mv /tmp/xray/geosite.dat /usr/local/share/xray/; \
    rm -rf /tmp/xray /tmp/xray.zip

# Create directories
RUN mkdir -p /run/nginx

# Copy config files
COPY nginx.conf /etc/nginx/nginx.conf
COPY xray.json /usr/local/etc/xray/config.json
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
