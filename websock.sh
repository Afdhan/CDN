#!/bin/bash

cd /root

figlet -f slant Install WS | lolcat
# Install Template
wget -q -O /usr/local/bin/ws-drop "#"
wget -q -O /usr/local/bin/ws-ovpn "#"
wget -q -O /usr/local/bin/ws-tls "#"

chmod +x /usr/local/bin/ws-drop
chmod +x /usr/local/bin/ws-ovpn
chmod +x /usr/local/bin/ws-tls

figlet -f slant Configurating CDN | lolcat

# Dropbear
cat > /etc/systemd/system/ws-dropbear.service << END
[Unit]
Description=SSH Over CDN WS Dropbear
Documentation=https://dhans-project.xyz
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/ws-drop
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

# OpenVPN
cat > /etc/systemd/system/ws-openvpn.service << END
[Unit]
Description=SSH Over CDN WS OpenVPN
Documentation=https://dhans-project.xyz
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/ws-ovpn
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

# Stunnel
cat > /etc/systemd/system/ws-stunnel.service << END
[Unit]
Description=SSH Over CDN WS Stunnel
Documentation=https://dhans-project.xyz
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/ws-tls
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

# Exec Start
systemctl daemon-reload

# Activated
systemctl enable ws-dropbear.service
systemctl enable ws-openvpn.service
systemctl enable ws-stunnel.service

# Restatt
systemctl restart ws-dropbear.service
systemctl restart ws-openvpn.service
systemctl restart ws-stunnel.service

