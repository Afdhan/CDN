#!/bin/bash
# Trojan Go Auto Setup 
# =========================

# Domain 
domain=$(cat /etc/v2ray/domain)

# Uuid Service
uuid=$(cat /proc/sys/kernel/random/uuid)

# Trojan Go Akun 
mkdir -p /etc/go-go/
touch /etc/go-go/akun.conf

# Installing Trojan Go
mkdir -p /etc/go-go/
chmod 755 /etc/go-go/
touch /etc/go-go/trojan-go.pid
wget -O /usr/local/bin/trojan-go https://raw.githubusercontent.com/Afdhan/CDN/main/A/I/U/E/O/trojan-go
wget -O /usr/local/bin/geoip.dat https://raw.githubusercontent.com/Afdhan/CDN/main/A/I/U/E/O/geoip.dat
wget -O /usr/local/bin/geosite.dat https://raw.githubusercontent.com/Afdhan/CDN/main/A/I/U/E/O/geosite.dat
chmod +x /usr/local/bin/trojan-go

# Service
cat > /etc/systemd/system/trojan-go.service << END
[Unit]
Description=Trojan-Go - An unidentifiable mechanism that helps you bypass GFW
Documentation=https://p4gefau1t.github.io/trojan-go/
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/local/bin/trojan-go -config /etc/go-go/config.json
Restart=on-failure
RestartSec=10s
LimitNOFILE=infinity
[Install]
WantedBy=multi-user.target
END

# Config
cat > /etc/go-go/config.json << END
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 1995,
    "remote_addr": "127.0.0.1",
    "remote_port": 81,
    "password": [
        "$uuid"
    ],
    "ssl": {
        "cert": "/etc/v2ray/v2ray.crt", 
        "key": "/etc/v2ray/v2ray.key", 
        "sni": "$domain"
    },
    "router": {
        "enabled": true,
        "block": [
            "geoip:private"
        ],
        "geoip": "/usr/local/bin/geoip.dat",
        "geosite": "/usr/local/bin/geosite.dat"
    }
}
END

iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 1995 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 1995 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Starting
systemctl daemon-reload
systemctl enable trojan-go
systemctl start trojan-go

wget -O /usr/bin/trgo https://raw.githubusercontent.com/Afdhan/CDN/main/A/I/U/E/O/add-trogo.sh
chmod +x /usr/bin/trgo
