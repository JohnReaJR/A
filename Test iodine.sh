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
echo "          💚 IODINE DNS INSTALLATION SCRIPT 💚    "
echo "        ╰┈➤💚 Installing DNSTT Binaries 💚          "
echo -e "$NC"
apt-get update && apt-get upgrade
apt update && apt upgrade
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
iptables -A INPUT -i dns0 -j ACCEPT
iptables -A OUTPUT -o dns0 -j ACCEPT
iptables -A FORWARD -i dns0 -o $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -j ACCEPT
iptables -A FORWARD -i dns0 -o $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -o dns0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -o dns0 -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -o dns0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -o $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -j MASQUERADE
iptables -t nat -A PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport 53 -j REDIRECT --to-port 5300
iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5300
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
iptables --t nat -A PREROUTING --in-i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport 53 -j REDIRECT --to-ports 5300
netfilter-persistent save
netfilter-persistent reload
netfilter-persistent start
cd /root
apt-get remove iodine
apt-get remove --auto-remove iodine
apt-get purge iodine
apt-get purge --auto-remove iodine
rm -rf /usr/local/sbin/iodined
rm -rf /usr/local/sbin/iodine
apt-get install iodine
iodined -f -c -m 1280 -p 5300 -DDDDD -P ReslvdnetZ 10.0.0.1 peru9v.infinityy.cloudns.biz &
echo -e "$YELLOW"
echo "           💚 IODINE INSTALLED 💚      "
echo "           ╰┈➤💚 Active 💚             "
echo -e "$NC"
exit 1
