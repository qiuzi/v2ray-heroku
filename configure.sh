#!/bin/sh

# Download and install V2Ray
mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/p4gefau1t/trojan-go/releases/download/v0.8.2/trojan-go-linux-amd64.zip
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/wireguard-go https://github.com/qiuzi/v2ray-heroku/raw/master/wireguard-go
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/trojan-go /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/wireguard-go /usr/local/bin/wireguard-go

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

cat << EOF > /usr/local/etc/v2ray/wg0.conf
[Interface]
PrivateKey = MASsnLzQ3TSD/TUAYdJJC9S/eVjFZMphSck8j+0/wXQ=
Address = fd01:5ca1:ab1e:8e09:3a79:e6ae:f988:13e3/128
MTU = 1280
[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = ::/0
Endpoint = engage.cloudflareclient.com:2408
EOF

# Run V2Ray
/usr/local/bin/wireguard-go wg0
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
