#!/bin/bash
is_number() {
    [[ $1 =~ ^[0-9]+$ ]]
}
YELLOW='\033[1;33m'
NC='\033[0m'
if [ "$(whoami)" != "root" ]; then
    echo "Error: This script must be run as root."
    exit 1
fi
cd /root
clear
echo -e "$YELLOW
Hysteria Installer by Resleeved"
echo "Version : 1.0"
echo -e "$NC
Select an option"
echo "1. Install UDP Hysteria"
echo "2. Exit"
selected_option=0

while [ $selected_option -lt 1 ] || [ $selected_option -gt 2 ]; do
    echo "Select a number from 1 to 2:"
    read input

    # Check if input is a number
    if [[ $input =~ ^[0-9]+$ ]]; then
        selected_option=$input
    else
        echo "Invalid input. Please enter a valid number."
    fi
done
clear
case $selected_option in
    1)
        echo "Installing UDP Hysteria ..."
        apt-get update && apt-get upgrade
        apt install wget -y
        apt install nano -y
        apt install net-tools
        mkdir hy
        cd hy
        udp_script="/root/hy/hysteria-linux-amd64"
        if [ ! -e "$udp_script" ]; then
            wget github.com/apernet/hysteria/releases/download/v1.3.5/hysteria-linux-amd64
        fi
        chmod 755 hysteria-linux-amd64
        openssl ecparam -genkey -name prime256v1 -out ca.key
        openssl req -new -x509 -days 36500 -key ca.key -out ca.crt -subj "/CN=bing.com"
        while true; do
            read -p "Obfs : " obfs
            if [ ! -z "$obfs" ]; then
            break
            fi
        done
        while true; do
            read -p "Auth Str : " auth_str
            if [ ! -z "$auth_str" ]; then
            break
            fi
        done
        file_path="/root/hy/config.json"
        json_content='{"listen":":10000","protocol":"udp","cert":"/root/hy/ca.crt","key":"/root/hy/ca.key","up":"100 Mbps","up_mbps":100,"down":"100 Mbps","down_mbps":100,"disable_udp":false,"obfs":"'"$obfs"'","auth_str":"'"$auth_str"'"}'
        echo "$json_content" > "$file_path"
        if [ ! -e "$file_path" ]; then
            echo "Error: Unable to save the config.json file"
            exit 1
        fi
        sudo debconf-set-selections <<< "iptables-persistent iptables-persistent/autosave_v4 boolean true"
        sudo debconf-set-selections <<< "iptables-persistent iptables-persistent/autosave_v6 boolean true"
        apt -y install iptables-persistent
        while true; do
            read -p "Binding UDP Ports : from port : " first_number
            if is_number "$first_number" && [ "$first_number" -ge 1 ] && [ "$first_number" -le 65534 ]; then
                break
            else
                echo "Invalid input. Please enter a valid number between 1 and 65534."
            fi
        done
        while true; do
            read -p "Binding UDP Ports : from port : $first_number to port : " second_number
            if is_number "$second_number" && [ "$second_number" -gt "$first_number" ] && [ "$second_number" -lt 65536 ]; then
                break
            else
                echo "Invalid input. Please enter a valid number greater than $first_number and less than 65536."
            fi
        done
        iptables -t nat -A PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport "$first_number":"$second_number" -j DNAT --to-destination :36712
        ip6tables -t nat -A PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport "$first_number":"$second_number" -j DNAT --to-destination :36712
        sysctl net.ipv4.conf.all.rp_filter=0
        sysctl net.ipv4.conf.$(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1).rp_filter=0 
        echo "net.ipv4.ip_forward = 1
        net.ipv4.conf.all.rp_filter=0
        net.ipv4.conf.$(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1).rp_filter=0" > /etc/sysctl.conf
        sysctl -p
        sudo iptables-save > /etc/iptables/rules.v4
        sudo ip6tables-save > /etc/iptables/rules.v6
        nohup ./hysteria-linux-amd64 server>hysteria.log 2>&1 &
        cat hysteria.log
        echo "UDP Hysteria installed successfully, please check the logs above"
        echo "IP Address :"
        curl icanhazip.com
        exit 1
        ;;
    2)
        echo "Exiting..."
        exit 1
        ;;
esac
