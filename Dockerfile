FROM alpine:3.20

# Pag‑install ng mga kailangan
RUN apk update && apk add --no-cache \
    nginx \
    wget \
    ca‑certificates \
    tzdata

# I‑download ang Xray
RUN wget -O /tmp/xray.zip https://github.com/XTLS/Xray‑core/releases/download/v25.10.15/Xray‑core‑linux‑amd64.zip && \
    unzip /tmp/xray.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm -f /tmp/xray.zip

# Mga folder
RUN mkdir -p /etc/xray /usr/share/nginx/html

# Kopyahin ang mga file
COPY x‑ray.json /etc/xray/x‑ray.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /

# I‑check ang config at bigyan ng permiso
RUN chmod +x /entrypoint.sh && \
    xray check -config /etc/xray/x‑ray.json

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
