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
echo "          💚 IPTABLES....SETTING UP YOUR FIREWALL 💚    "
echo "             ╰┈➤💚 Resleeved Net Firewall 💚          "
echo -e "$NC"
cd /root
rm -f /etc/sysctl.conf
sysctl net.ipv4.conf.all.rp_filter=0
sysctl net.ipv4.conf.$(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1).rp_filter=0
echo "net.ipv4.ip_forward=1
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.$(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1).rp_filter=0" > /etc/sysctl.conf
sysctl -p
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
sysctl -w vm.swappiness=10
sysctl -w vm.dirty_ratio=60
sysctl -w vm.dirty_background_ratio=2
sysctl -w net.ipv4.tcp_max_tw_buckets=1440000
sysctl -w net.core.netdev_max_backlog=65536
sysctl -w net.netfilter.nf_conntrack_max=1048576
sysctl -w net.ipv4.tcp_max_syn_backlog=4096
sysctl -w net.ipv4.tcp_synack_retries=2
sysctl -w net.ipv4.tcp_syncookies=0
sysctl -w net.ipv4.ip_local_port_range=1024
sysctl -w net.ipv4.tcp_keepalive_time=300
sysctl -w net.ipv4.tcp_keepalive_probes=5
sysctl -w net.ipv4.tcp_keepalive_intvl=15
sysctl -w net.ipv4.tcp_rfc1337=1
sysctl -w net.ipv4.tcp_fin_timeout=1
sysctl -w net.core.somaxconn=65535
sysctl -w net.core.optmem_max=25165824
sysctl -w net.core.default_qdisc=fq_codel
sysctl -w net.ipv4.tcp_slow_start_after_idle=0
sysctl -w net.ipv4.tcp_congestion_control=htcp
echo "net.core.rmem_max=16777216" >> /etc/sysctl.conf
echo "net.core.wmem_max=16777216" >> /etc/sysctl.conf
echo "net.core.somaxconn=65535" >> /etc/sysctl.conf
echo "net.netfilter.nf_conntrack_max=1048576" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog=4096" >> /etc/sysctl.conf
echo "net.ipv4.tcp_adv_win_scale=3" >> /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_tw_buckets=1440000" >> /etc/sysctl.conf
echo "net.core.netdev_budget=500" >> /etc/sysctl.conf
echo "net.core.netdev_max_backlog=65536" >> /etc/sysctl.conf
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.dirty_ratio=60" >> /etc/sysctl.conf
echo "vm.dirty_background_ratio=2" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
echo -e "$YELLOW"
echo "           💚 FIREWALL CONFIGURED 💚      "
echo "              ╰┈➤💚 Active 💚             "
echo -e "$NC"
exit 1
