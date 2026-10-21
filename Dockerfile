FROM alpine:latest

# Install Nginx & Xray
RUN apk add --no-cache nginx xray

# Copy Configuration files
COPY x-ray.json /etc/xray/x-ray.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# Create Decoy Landing Page (Fake Corporate / Maintenance Page)
RUN mkdir -p /usr/share/nginx/html && \
    echo '<!DOCTYPE html><html><head><title>Welcome to Web Portal</title><style>body{font-family:sans-serif;text-align:center;padding:50px;background:#f4f4f9;color:#333;}h1{font-size:40px;color:#0056b3;}p{font-size:18px;}</style></head><body><h1>System Operational</h1><p>Welcome to our cloud service gateway. All systems are running smoothly.</p></body></html>' > /usr/share/nginx/html/index.html

RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
