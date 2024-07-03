#!/bin/bash

default_int="$(ip route list |grep default |grep -o -P '\b[a-z]+\d+\b')" #Because net-tools in debian, ubuntu are obsolete already

SERVER_PORT_XRAY='443'

echo "[*] DNSTT Server AUTH.."

read -p "NS Domains : " -e -i dns.jaquematedns.xyz DnsNS

echo "[*] DNSTT"

apt install git -y;

wget -c https://[Log in to view URL] -O /usr/local/bin/dnstt-server;
chmod +x /usr/local/bin/dnstt-server
clear

echo 'DNSTT SERVICE'

cat <<EOF > /etc/systemd/system/dnstt-service.service

[Unit]
Description=Daemonize DNSTT Tunnel Server
Wants=network.target
After=network.target
[Service]
ExecStart=/usr/local/bin/dnstt-server -udp :5300 -privkey 926d2e559047d381dfb6f66e020ce5e1f4d9199d3eea71ac9681112b0a2031f6 $DnsNS 127.0.0.1:$SERVER_PORT_XRAY
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start dnstt-service
systemctl enable --now dnstt-service
clear

echo 'Iptables Services'

cat <<EOF > /etc/systemd/system/hashes-iptables.service

[Unit]
Description=Iptables reboot
Before=network.target
[Service]
Type=oneshot
ExecStart=/usr/sbin/iptables -I INPUT -p udp --dport 5300 -j ACCEPT
ExecStart=/usr/sbin/iptables -t nat -I PREROUTING -i $default_int -p udp --dport 0:65535 -j REDIRECT --to-ports 5300
ExecStart=/usr/sbin/ip6tables -I INPUT -p udp --dport 5300 -j ACCEPT
ExecStart=/usr/sbin/ip6tables -t nat -I PREROUTING -i $default_int -p udp --dport 0:65535 -j REDIRECT --to-ports 5300
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start hashes-iptables.service
systemctl enable --now hashes-iptables.service
clear
