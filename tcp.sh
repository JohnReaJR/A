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
echo "        ╰┈➤💚 Installing DNS2TCP Binaries 💚          "
echo -e "$NC"
cd /root
rm -rf dns2tcp
rm -rf /var/empty/dns2tcp/
rm -rf /var/empty
apt-get remove dns2tcp
apt-get remove --auto-remove dns2tcp
apt-get purge dns2tcp
apt-get purge --auto-remove dns2tcp
apt-get install dns2tcp
if lsof -i :53 | grep -q ":53"; then
    echo -e "$YELLOW"
    echo "Error : there is a program that already uses the port 53"
    echo -e "$NC"
    exit 1
fi
cd /root
mkdir dns2tcp
cd dns2tcp
mkdir /var/empty
mkdir /var/empty/dns2tcp
echo -e "$YELLOW"
read -p "Your Nameserver: " nameserver
read -p "Your key: " key
echo -e "$NC"
file_path="/root/dns2tcp/dns2tcpdrc"
json_content=$(cat <<EOF
listen = 0.0.0.0
port = 53
user = Nimata
chroot = /var/empty/dns2tcp/
domain = $nameserver
key = $key
resources = ssh:127.0.0.1:22,socks:127.0.0.1:1082,http:127.0.0.1:3128
EOF
)
echo "$json_content" > "$file_path"
dns2tcpd -d 1 -f dns2tcpdrc
echo -e "$YELLOW"
echo "           💚 DNS2TCP INSTALLED 💚      "
echo "           ╰┈➤💚 Active 💚             "
echo -e "$NC"
exit 1
