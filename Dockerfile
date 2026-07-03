FROM alpine:latest

# ติดตั้ง v2ray
RUN apk add --no-cache curl && \
    curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    mkdir -p /usr/bin/v2ray /etc/v2ray && \
    unzip /tmp/v2ray.zip -d /usr/bin/v2ray && \
    rm -rf /tmp/v2ray.zip

# สร้างไฟล์ Config ของ V2Ray (พอร์ต 10000 รองรับ Websocket)
RUN echo '{\
  "inbounds": [{\
    "port": 10000,\
    "protocol": "vmess",\
    "settings": {\
      "clients": [{"id": "12345678-abcd-1234-abcd-123456789abc", "alterId": 0}]\
    },\
    "streamSettings": {\
      "network": "ws",\
      "wsSettings": {"path": "/chat"}\
    }\
  }],\
  "outbounds": [{"protocol": "freedom", "settings": {}}]\
}' > /etc/v2ray/config.json

CMD ["/usr/bin/v2ray/v2ray", "run", "-config", "/etc/v2ray/config.json"]
