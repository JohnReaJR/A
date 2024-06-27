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
echo "          💚 WIPE....RESETTING YOUR MACHINE 💚    "
echo "            ╰┈➤💚 Resleeved Net Reset 💚          "
echo -e "$NC"
apt-get update && apt-get upgrade
apt update && apt upgrade
ufw disable
apt-get remove ufw
apt-get remove --auto-remove ufw
apt-get purge ufw
apt-get purge --auto-remove ufw
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
systemctl disable custom-server.service
rm -rf /etc/systemd/system/custom-server.service
systemctl stop request-server.service
systemctl disable request-server.service
rm -rf /etc/systemd/system/request-server.service
rm -rf /root/udp
rm -rf /usr/bin/udp
systemctl stop udpgw.service
systemctl disable udpgw.service
rm -rf /etc/systemd/system/udpgw.service
rm -rf /usr/bin/udpgw
systemctl stop hysteria-server.service
systemctl disable hysteria-server.service
rm -rf /etc/systemd/system/hysteria-server.service
rm -rf /root/hy
cd /root
systemctl stop x-ui.service
systemctl disable x-ui.service
rm -rf /etc/systemd/system/x-ui.service
rm -rf /usr/local/x-ui
rm -rf /usr/bin/x-ui
rm -rf /etc/x-ui
cd /root
rm -rf /root/dnstt
rm -rf go
rm -rf /root/iodine-0.7.0
mita stop
systemctl stop mita
systemctl disable mita
rm -rf /etc/mita
rm -rf /usr/bin/mita
rm -rf /root/mita_1.15.1_amd64.deb
rm -rf /root/Mita_Config_Server.json
userdel --remove mita
cd /root
rm -rf dns2tcp
rm -rf /var/empty/dns2tcp/
rm -rf /var/empty
apt-get remove dns2tcp
apt-get remove --auto-remove dns2tcp
apt-get purge dns2tcp
apt-get purge --auto-remove dns2tcp
cd /root
systemctl stop iodined
apt-get remove iodine
apt-get remove --auto-remove iodine
apt-get purge iodine
apt-get purge --auto-remove iodine
rm -rf /usr/local/sbin/iodined
rm -rf /usr/local/sbin/iodine
userdel --remove iodine
cd /root
systemctl stop lnk-server.service
systemctl disable lnk-server.service
rm -rf /etc/systemd/system/lnk-server.service
rm -rf /etc/M
rm -rf /usr/bin/link
systemctl stop tcp-server.service
systemctl disable tcp-server.service
rm -rf /etc/systemd/system/tcp-server.service
rm -rf /usr/bin/tcp-linux-amd64
systemctl stop stunnel4.service
systemctl disable stunnel4.service
rm -rf /etc/stunnel
rm -rf /etc/default/stunnel4
rm -rf /etc/systemd/system/stunnel4.service
apt-get remove stunnel4
apt-get remove --auto-remove stunnel4
apt-get purge stunnel4
apt-get purge --auto-remove stunnel4
userdel --remove stunnel4
cd /root
systemctl stop dnstt-server.service
systemctl disable dnstt-server.service
rm -rf /etc/systemd/system/dnstt-server.service
rm -rf /usr/bin/dnstt-linux-amd64
rm -rf /usr/bin/server.pub
rm -rf /usr/bin/server.key
rm -rf .config
rm -rf snap
rm -rf .cache
rm -rf .ssh
rm -rf .local
apt-get remove
apt-get autoremove
apt-get clean
apt-get autoclean
cd /root
systemctl daemon-reload
echo -e "$YELLOW"
echo "           💚 FIREWALL CONFIGURED 💚      "
echo "              ╰┈➤💚 Active 💚             "
echo -e "$NC"
X
exit 1
