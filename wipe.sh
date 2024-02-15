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
echo "          💚 WIPE....SETTING UP YOUR FIREWALL 💚    "
echo "             ╰┈➤💚 Resleeved Net Firewall 💚          "
echo -e "$NC"
apt-get update && apt-get upgrade
apt update && apt upgrade
apt install wget -y
apt install nano -y
apt-get install tcpdump
ufw disable
apt-get remove --auto-remove ufw
apt-get purge ufw
apt-get purge --auto-remove ufw
apt-get remove ufw
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X 
iptables -Z
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X
apt-get install iptables
apt-get install iptables-persistent
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT
ip6tables -F
ip6tables -X 
ip6tables -Z
ip6tables -t nat -F
ip6tables -t nat -X
ip6tables -t mangle -F
ip6tables -t mangle -X
ip6tables -t raw -F
ip6tables -t raw -X
netfilter-persistent save
netfilter-persistent reload
netfilter-persistent start
cd /root
clear
systemctl stop custom-server.service
rm -f /etc/systemd/system/custom-server.service
rm -rf /root/udp
rm -rf /usr/bin/udp
systemctl stop udpgw.service
rm -f /etc/systemd/system/udpgw.service
rm -f /usr/bin/udpgw
systemctl stop hysteria-server.service
rm -f /etc/systemd/system/hysteria-server.service
rm -rf /root/hy
systemctl stop x-ui.service
rm -rf /etc/systemd/system/x-ui.service
rm -rf /usr/local/x-ui
rm -rf /usr/bin/x-ui
rm -rf /etc/x-ui
rm -rf /root/dnstt
rm -rf /root/iodine-0.7.0
echo -e "$YELLOW"
echo "           💚 FIREWALL CONFIGURED 💚      "
echo "              ╰┈➤💚 Active 💚             "
echo -e "$NC"
exit 1
