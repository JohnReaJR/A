#!/bin/bash
is_number() {
    [[ $1 =~ ^[0-9]+$ ]]
}
YELLOW='\033[1;33m'
RED='\033[1;31m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
NC='\033[0m'
if [ "$(whoami)" != "root" ]; then
    echo "Error: This script must be run as root."
    exit 1
fi
cd /root
clear
echo -e "$CYAN   A   $YELLOW SSS  $RED H   H"
echo -e "$CYAN  A A  $YELLOW S    $RED H   H"
echo -e "$CYAN AAAAA $YELLOW SSS  $RED HHHHH"
echo -e "$CYAN A   A $YELLOW     S$RED H   H"
echo -e "$CYAN A   A $YELLOW SSSS $RED H   H"
echo ""
echo -e "$YELLOW
Special Protocols installer by AhmedSCRIPT Hacker and Mahboub"
echo "Version : 2.1"
echo -e "$NC
Select an option"
echo "1. Install FastDNS"
echo "2. Install KCP"
echo "3. Install ASH UDP Punch Hole"
echo "4. Install ASH DNSTT"
echo "5. Exit"
selected_option=0

while [ $selected_option -lt 1 ] || [ $selected_option -gt 5 ]; do
    echo -e "$YELLOW"
    echo "Select a number from 1 to 5:"
    echo -e "$NC"
    read input

    # Check if input is a number
    if [[ $input =~ ^[0-9]+$ ]]; then
        selected_option=$input
    else
        echo -e "$YELLOW"
        echo "Invalid input. Please enter a valid number."
        echo -e "$NC"
    fi
done
clear
case $selected_option in
    1)
        echo -e "$YELLOW"
        echo "Installing FastDNS ..."
        echo -e "$NC"
        mkdir fastdns
        cd fastdns
        fastdns_script="/root/fastdns/dnstunnel_server"
        if [ ! -e "$fastdns_script" ]; then
            wget --header="Authorization: token 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" https://raw.githubusercontent.com/ASHANTENNA/Special-Installer/main/dnstunnel_server
        fi
        chmod 755 dnstunnel_server
        license="/root/fastdns/tcat_dns.license"
        if [ ! -e "$license" ]; then
            wget --header="Authorization: token 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" https://raw.githubusercontent.com/ASHANTENNA/Special-Installer/main/tcat_dns.license
        fi
        while true; do
            echo -e "$YELLOW"
            read -p "Remote FastDNS Port : " remote_udp_port
            echo -e "$NC"
            if is_number "$remote_udp_port" && [ "$remote_udp_port" -ge 1 ] && [ "$remote_udp_port" -le 65534 ]; then
                if netstat -tulnp | grep -q "::$remote_udp_port"; then
                    echo -e "$YELLOW"
                    echo "Error : the selected port has already been used"
                    echo -e "$NC"
                else
                    break
                fi
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number between 1 and 65534."
                echo -e "$NC"
            fi
        done
        while true; do
            echo -e "$YELLOW"
            read -p "Target UDP Port : " target_udp
            echo -e "$NC"
            if is_number "$target_udp" && [ "$target_udp" -ge 1 ] && [ "$target_udp" -le 65534 ]; then
                break
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number between 1 and 65534."
                echo -e "$NC"
            fi
        done
        screen -dmS fastdns ./dnstunnel_server -listen 0.0.0.0:"$remote_udp_port" -forward 127.0.0.1:"$target_udp" -key tcat_dns.license
        lsof -i :"$remote_udp_port"
        echo "FastDNS installed successfully, please check the logs above"
        echo "IP Address :"
        curl ipv4.icanhazip.com
        exit 1
        ;;
    2)
        echo -e "$YELLOW"
        echo "Installing KCP ..."
        echo -e "$NC"
        mkdir tcp2udp
        cd tcp2udp
        tcp2udp_script="/root/tcp2udp/server"
        if [ ! -e "$tcp2udp_script" ]; then
            wget --header="Authorization: token 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" https://raw.githubusercontent.com/ASHANTENNA/Special-Installer/main/server
        fi
        chmod 755 server
        while true; do
            echo -e "$YELLOW"
            read -p "Remote UDP Port : " remote_udp_port
            echo -e "$NC"
            if is_number "$remote_udp_port" && [ "$remote_udp_port" -ge 1 ] && [ "$remote_udp_port" -le 65534 ]; then
                if netstat -tulnp | grep -q "::$remote_udp_port"; then
                    echo -e "$YELLOW"
                    echo "Error : the selected port has already been used"
                    echo -e "$NC"
                else
                    break
                fi
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number between 1 and 65534."
                echo -e "$NC"
            fi
        done
        while true; do
            echo -e "$YELLOW"
            read -p "Target TCP Port : " target_tcp_port
            echo -e "$NC"
            if is_number "$target_tcp_port" && [ "$target_tcp_port" -ge 1 ] && [ "$target_tcp_port" -le 65534 ]; then
                break
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number between 1 and 65534."
                echo -e "$NC"
            fi
        done
        file_path="/root/tcp2udp/script.sh"
        json_content=$(cat <<-EOF
    while true; do
        ./server -listen 0.0.0.0:$remote_udp_port -forward 127.0.0.1:$target_tcp_port
    done
EOF
)
        echo "$json_content" > "$file_path"
        if [ ! -e "$file_path" ]; then
            echo -e "$YELLOW"
            echo "Error: Unable to save the script file"
            echo -e "$NC"
            exit 1
        fi
        chmod 755 script.sh
        screen -dmS tcp2udp ./script.sh
        lsof -i :"$remote_udp_port"
        echo -e "$YELLOW"
        echo "KCP installed successfully, please check the logs above"
        echo "IP Address :"
        curl ipv4.icanhazip.com
        echo -e "$NC"
        exit 1
        ;;
    3)
        echo -e "$YELLOW"
        echo "Installing ASH UDP Punch Hole ..."
        echo -e "$NC"
        mkdir ashudppunchhole
        cd ashudppunchhole
        udppunchhole_script="/root/ashudppunchhole/ashpunchholed-linux-amd64"
        if [ ! -e "$udppunchhole_script" ]; then
            wget --header="Authorization: token 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" https://raw.githubusercontent.com/ASHANTENNA/Special-Installer/main/ashpunchholed-linux-amd64
        fi
        chmod 755 ashpunchholed-linux-amd64
        while true; do
            echo -e "$YELLOW"
            read -p "Remote UDP Punch Hole Port : " remote_udp_port
            echo -e "$NC"
            if is_number "$remote_udp_port" && [ "$remote_udp_port" -ge 1 ] && [ "$remote_udp_port" -le 65534 ]; then
                if netstat -tulnp | grep -q "::$remote_udp_port"; then
                    echo -e "$YELLOW"
                    echo "Error : the selected port has already been used"
                    echo -e "$NC"
                else
                    break
                fi
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number between 1 and 65534."
                echo -e "$NC"
            fi
        done
        while true; do
            echo -e "$YELLOW"
            read -p "Target UDP Port : " target_udp
            echo -e "$NC"
            if is_number "$target_udp" && [ "$target_udp" -ge 1 ] && [ "$target_udp" -le 65534 ]; then
                break
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number between 1 and 65534."
                echo -e "$NC"
            fi
        done
        screen -dmS udpph ./ashpunchholed-linux-amd64 -listen 0.0.0.0:"$remote_udp_port" -forward 127.0.0.1:"$target_udp"
        lsof -i :"$remote_udp_port"
        echo "ASH UDP Punch Hole installed successfully, please check the logs above"
        echo "IP Address :"
        curl ipv4.icanhazip.com
        exit 1
        ;;
    4)
        echo -e "$YELLOW"
        echo "Installing ASH DNSTT ..."
        echo -e "$NC"
        mkdir ashdnstt
        cd ashdnstt
        ashdnstt_script="/root/ashdnstt/ashdnstt-server-linux-amd64"
        if [ ! -e "$ashdnstt_script" ]; then
            wget --header="Authorization: token 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" https://raw.githubusercontent.com/ASHANTENNA/Special-Installer/main/ashdnstt-server-linux-amd64
        fi
        chmod 755 ashdnstt-server-linux-amd64
        echo -e "$YELLOW"
        echo "Private Key :"
        echo "3f351791845c977ac7871d6f87a6d7bd73adae6924cbc6f9a0b9fec9181a05b3"
        echo "Public key :"
        echo "e5d2a44b70474c6ffd35e4128480ba89865daba4bc3db369f9c8fb0ab0236905"
        read -p ""
        read -p "Nameserver : " ns
        echo -e "$NC"
        while true; do
            echo -e "$YELLOW"
            read -p "Target UDP Port : " target_udp
            echo -e "$NC"
            if is_number "$target_udp" && [ "$target_udp" -ge 1 ] && [ "$target_udp" -le 65534 ]; then
                break
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number between 1 and 65534."
                echo -e "$NC"
            fi
        done
        while true; do
            echo -e "$YELLOW"
            read -p "Target TCP Port : " target_tcp
            echo -e "$NC"
            if is_number "$target_tcp" && [ "$target_tcp" -ge 1 ] && [ "$target_tcp" -le 65534 ]; then
                break
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number between 1 and 65534."
                echo -e "$NC"
            fi
        done
        iptables -I INPUT -p udp --dport 5300 -j ACCEPT
        iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
        screen -dmS ashdnstt ./ashdnstt-server-linux-amd64 -listen :5300 -privkey 3f351791845c977ac7871d6f87a6d7bd73adae6924cbc6f9a0b9fec9181a05b3 -nameserver "$ns" -forwardudp 127.0.0.1:"$target_udp" -forwardtcp 127.0.0.1:"$target_tcp"
        lsof -i :5300
        echo "ASH DNSTT installed successfully, please check the logs above"
        echo "IP Address :"
        curl ipv4.icanhazip.com
        exit 1
        ;;
    5)
        echo -e "$YELLOW"
        echo "Good Bye"
        echo -e "$NC"
        exit 1
        ;;
esac
