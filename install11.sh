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
Hysteria V2 Installer by Resleeved"
echo "Version : 1"
echo -e "$NC
Select an option"
echo "1. Install UDP Hysteria V2"
echo "2. Exit"
selected_option=0

while [ $selected_option -lt 1 ] || [ $selected_option -gt 2 ]; do
    echo -e "$YELLOW"
    echo "Select a number from 1 to 2:"
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
        echo "Installing UDP Hysteria ..."
        echo -e "$NC"
        systemctl stop hysteria-server.service
        rm -f /etc/systemd/system/hysteria-server.service
        rm -rf /root/hy
        mkdir hy
        cd hy
        udp_script="/root/hy/hysteria-linux-amd64"
        if [ ! -e "$udp_script" ]; then
            wget github.com/apernet/hysteria/releases/download/app/v2.0.0/hysteria-linux-amd64
        fi
        chmod 755 hysteria-linux-amd64
        openssl ecparam -genkey -name prime256v1 -out ca.key
        openssl req -new -x509 -days 36500 -key ca.key -out ca.crt -subj "/CN=bing.com"
        while true; do
            echo -e "$YELLOW"
            read -p "Obfs : " obfs
            echo -e "$NC"
            if [ ! -z "$obfs" ]; then
            break
            fi
        done
        while true; do
            echo -e "$YELLOW"
            read -p "Auth Str : " auth_str
            echo -e "$NC"
            if [ ! -z "$auth_str" ]; then
            break
            fi
        done
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
        file_path="/root/hy/config.yaml"
        json_content=$(cat <<-EOF
listen: :$remote_udp_port
tls:
  cert: ca.crt
  key: ca.key
obfs:
  type: salamander
  salamander:
    password: $obfs
quic:
  initStreamReceiveWindow: 16777216
  maxStreamReceiveWindow: 16777216
  initConnReceiveWindow: 33554432
  maxConnReceiveWindow: 33554432
auth:
  type: password
  password: $auth_str
masquerade:
  type: proxy
  proxy:
    url: https://bing.com
    rewriteHost: true
EOF
)
        echo "$json_content" > "$file_path"
        if [ ! -e "$file_path" ]; then
            echo -e "$YELLOW"
            echo "Error: Unable to save the config.yaml file"
            echo -e "$NC"
            exit 1
        fi
        sudo debconf-set-selections <<< "iptables-persistent iptables-persistent/autosave_v4 boolean true"
        sudo debconf-set-selections <<< "iptables-persistent iptables-persistent/autosave_v6 boolean true"

        while true; do
            echo -e "$YELLOW"
            read -p "Binding UDP Ports : from port : " first_number
            echo -e "$NC"
            if is_number "$first_number" && [ "$first_number" -ge 1 ] && [ "$first_number" -le 65534 ]; then
                break
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number between 1 and 65534."
                echo -e "$NC"
            fi
        done
        while true; do
            echo -e "$YELLOW"
            read -p "Binding UDP Ports : from port : $first_number to port : " second_number
            echo -e "$NC"
            if is_number "$second_number" && [ "$second_number" -gt "$first_number" ] && [ "$second_number" -lt 65536 ]; then
                break
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number greater than $first_number and less than 65536."
                echo -e "$NC"
            fi
        done
        # [+config+]
        chmod +x /root/hy/config.yaml

        cat <<EOF >/etc/systemd/system/hysteria-server.service
[Unit]
After=network.target nss-lookup.target

[Service]
User=root
WorkingDirectory=/root/hy
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
ExecStart=/root/hy/hysteria-linux-amd64 server -c /root/hy/config.yaml
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=2
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
EOF
        #Start Services
        iptables -t nat -A PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport "$first_number":"$second_number" -j DNAT --to-destination :$remote_udp_port
        ip6tables -t nat -A PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport "$first_number":"$second_number" -j DNAT --to-destination :$remote_udp_port
        iptables -A INPUT -p udp --dport $remote_udp_port -j ACCEPT
        ip6tables -A INPUT -p udp --dport $remote_udp_port -j ACCEPT
        netfilter-persistent save
        netfilter-persistent reload
        netfilter-persistent start
        systemctl enable hysteria-server.service
        systemctl start hysteria-server.service
        cd /root
        rm .bash_history && history -c && history -w
        echo -e "$YELLOW"
        echo "    💚 UDP HYSTERIA V2 INSTALLED SUCCESSFULLY 💚        "
        echo "      ╰┈➤💚 Telegram >>> t.me/Am_The_Last_Envoy    "
        echo -e "$NC"
        exit 1
        ;;
    2)
        echo -e "$YELLOW"
        echo "Welcome To Resleeved Net"
        echo -e "$NC"
        exit 1
        ;;
esac
