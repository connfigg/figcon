FROM debian:bookworm-slim

RUN apt update && apt install -y \
    nginx curl ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

RUN mkdir -p /usr/local/etc/xray /run/nginx /xray-configs

COPY nginx.conf /etc/nginx/nginx.conf
COPY xray-vless.json /xray-configs/xray-vless.json
COPY xray-vmess.json /xray-configs/xray-vmess.json
COPY xray-trojan.json /xray-configs/xray-trojan.json
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
