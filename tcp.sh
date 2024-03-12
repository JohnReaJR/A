#!/bin/bash
YELLOW='\033[1;33m'
NC='\033[0m'
if [ "$(whoami)" != "root" ]; then
    echo "Error: This script must be run as root."
    exit 1
fi
cd /root
clear
echo -e "$YELLOW"
echo "          💚 DNS2TCP INSTALLATION SCRIPT 💚    "
echo "        ╰┈➤💚 Installing DNSTT Binaries 💚          "
echo -e "$NC"
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport 53 -j REDIRECT --to-ports 5300
ip6tables -I INPUT -p udp --dport 5300 -j ACCEPT
ip6tables -t nat -I PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport 53 -j REDIRECT --to-ports 5300
netfilter-persistent save
netfilter-persistent reload
netfilter-persistent start
cd /root
apt-get remove dns2tcp
apt-get install dns2tcp
echo -e "$YELLOW"
read -p "In this step, you will uncomment DNS and write DNS=1.1.1.1 and uncomment DNSStubListener and write DNSStubListener=no"
echo -e "$NC"
nano /etc/systemd/resolved.conf
echo -e "$YELLOW"
read -p "by tapping 'Enter', you make sure that you have uncomment DNS=1.1.1.1 and DNSStubListener=no"
echo -e "$NC"
if lsof -i :53 | grep -q ":53"; then
    echo -e "$YELLOW"
    echo "Error : there is a program that already uses the port 53"
    echo -e "$NC"
    exit 1
fi
systemctl restart systemd-resolved
mkdir dns2tcp
cd dns2tcp
mkdir /var/empty
mkdir /var/empty/dns2tcp
adduser ashtunnel
echo -e "$YELLOW"
read -p "Your Nameserver: " nameserver
read -p "Your key: " key
echo -e "$NC"
file_path="/root/dns2tcp/dns2tcpdrc"
json_content=$(cat <<EOF
listen = 0.0.0.0
port = 53
user = ashtunnel
chroot = /var/empty/dns2tcp/
domain = $nameserver
key = $key
resources = ssh:127.0.0.1:22
EOF
)
echo "$json_content" > "$file_path"
dns2tcpd -d 1 -f dns2tcpdrc
echo -e "$YELLOW"
echo "           💚 DNS2TCP INSTALLED 💚      "
echo "           ╰┈➤💚 Active 💚             "
echo -e "$NC"
exit 1
