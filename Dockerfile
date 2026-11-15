FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y --no-install-recommends \
    nginx \
    curl \
    ca-certificates \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Manila

# ✅ Gamitin ulit ang official script — may RETRY para hindi mag-fail agad
RUN set -eux; \
    for i in 1 2 3; do \
        bash -c "$(curl -L --connect-timeout 30 --max-time 120 https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install && break || sleep 5; \
    done

# Create directories
RUN mkdir -p /usr/local/etc/xray /run/nginx

# Copy config files
COPY nginx.conf /etc/nginx/nginx.conf
COPY xray.json /usr/local/etc/xray/config.json
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
