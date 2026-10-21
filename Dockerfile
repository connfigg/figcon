FROM alpine:latest

# Install Nginx, curl, unzip, and tzdata
RUN apk add --no-cache nginx curl unzip tzdata

# Download and Install Xray-core directly from GitHub releases
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then XRAY_ARCH="64"; \
    elif [ "$ARCH" = "aarch64" ]; then XRAY_ARCH="arm64-v8a"; \
    else XRAY_ARCH="64"; fi && \
    curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-${XRAY_ARCH}.zip && \
    mkdir -p /usr/local/bin /usr/local/share/xray && \
    unzip /tmp/xray.zip -d /tmp/xray && \
    mv /tmp/xray/xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm -rf /tmp/xray.zip /tmp/xray

# Copy Configuration files
COPY x-ray.json /etc/xray/x-ray.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# Create Decoy Landing Page
RUN mkdir -p /usr/share/nginx/html && \
    echo '<!DOCTYPE html><html><head><title>Welcome to Web Portal</title><style>body{font-family:sans-serif;text-align:center;padding:50px;background:#f4f4f9;color:#333;}h1{font-size:40px;color:#0056b3;}p{font-size:18px;}</style></head><body><h1>System Operational</h1><p>Welcome to our cloud service gateway. All systems are running smoothly.</p></body></html>' > /usr/share/nginx/html/index.html

RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
