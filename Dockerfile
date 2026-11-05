FROM alpine:latest

# Install Nginx, curl, unzip, tzdata, and dos2unix
RUN apk add --no-cache nginx curl unzip tzdata dos2unix

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

# Ensure Nginx HTML directory exists
RUN mkdir -p /usr/share/nginx/html

# Copy Configuration files & AI Panel HTML
COPY x-ray.json /etc/xray/x-ray.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html
COPY entrypoint.sh /entrypoint.sh

# Fix line endings and set execution permissions
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
