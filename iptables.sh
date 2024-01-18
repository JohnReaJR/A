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
echo "🧡 IPTABLES......🧡 SETTING UP YOUR FIREWALL....🧡"
echo -e "$NC"

time_reboot(){
  print_center -ama "${a92:-System/Server Reboot In} $1 ${a93:-Seconds}"
  REBOOT_TIMEOUT="$1"
  
  while [ $REBOOT_TIMEOUT -gt 0 ]; do
     print_center -ne "-$REBOOT_TIMEOUT-\r"
     sleep 1
     : $((REBOOT_TIMEOUT--))
  done
  reboot
}
apt-get update && apt-get upgrade
apt update && apt upgrade
apt install wget -y
apt install nano -y
ufw disable
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
apt-get install iptables-persistent
iptables -A INPUT -j ACCEPT
iptables -A OUTPUT -j ACCEPT
iptables -A FORWARD -j ACCEPT
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
netfilter-persistent save
echo -e "$YELLOW"
echo "🧡 FIREWALL CONFIGURED.....🧡"
echo "💚 REBOOTING........💚"
echo -e "$NC"
time_reboot 10
