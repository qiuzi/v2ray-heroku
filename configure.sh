#!/bin/sh

# Download and install V2Ray
mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/p4gefau1t/trojan-go/releases/download/v0.9.1/trojan-go-linux-amd64.zip
#curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/wireguard https://github.com/qiuzi/v2ray-heroku/releases/download/wireguard/wireguard
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
#unzip /tmp/v2ray/wtrojan.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/trojan-go /usr/local/bin/v2ray
#install -m 755 /tmp/v2ray/wireguard /usr/local/bin/wireguard-go

# Remove temporary directory
rm -rf /tmp/v2ray

# V2Ray new configuration
install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": $PORT,
    "remote_addr": "www.apple.com",
    "remote_port": 80,
    "log_level": 0,
    "password": [
	"$UUID"
    ],
"transport_plugin": {
    "enabled": true,
    "type": "plaintext"
  },
    "websocket": {
    "enabled": true,
    "path": "/shop"
    }
}
EOF

install -d /usr/local/etc/wireguard
cat << EOF > /usr/local/etc/wireguard/wg0.conf
[Interface]
PrivateKey = $PrivateKey
Address = $Address
MTU = 1280
[Peer]
PublicKey = $PublicKey
AllowedIPs = ::/0
Endpoint = engage.cloudflareclient.com:2408
EOF
wg-quick up /usr/local/etc/wireguard/wg0.conf wg0
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json

