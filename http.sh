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
        echo -e "$YELLOW"
        echo "          💚 TCP INSTALLATION SCRIPT 💚    "
        echo "          ╰┈➤💚 Installing TCP 💚        "
        echo -e "$NC"
        while true; do
            echo -e "$YELLOW"
            read -p "Remote HTTP Port : " http_port
            echo -e "$NC"
            if is_number "$http_port" && [ "$http_port" -ge 1 ] && [ "$http_port" -le 65535 ]; then
                break
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number between 1 and 65535."
                echo -e "$NC"
            fi
        done
        cd /root
        iptables -t nat -A PREROUTING -p tcp --dport "$http_port" -j REDIRECT --to-port "$http_port"
        iptables -A INPUT -p tcp --dport "$http_port" -j ACCEPT
        netfilter-persistent save
        netfilter-persistent reload
        netfilter-persistent start
        cd /root
        sudo systemctl stop tcp-server.service
        sudo systemctl disable tcp-server.service
        rm -rf /etc/systemd/system/tcp-server.service
        rm -rf /usr/bin/tcp-linux-amd64
        cd /usr/bin
        http_script="/usr/bin/tcp-linux-amd64"
        if [ ! -e "$http_script" ]; then
            wget http://github.com/JohnReaJR/A/releases/download/V1/tcp-linux-amd64
        fi
        chmod 755 tcp-linux-amd64
        cd /root
        ##Tcp Auto Service
        cat <<EOF >/etc/systemd/system/tcp-server.service
[Unit]
Description=TCP PROXY
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/screen -dmS tcp /bin/tcp-linux-amd64 -addr :"$http_port" dstAddr 127.0.0.1:22
Restart=always
User=root
StandardOutput=file:/usr/bin/http.log

[Install]
WantedBy=multi-user.target
EOF
        ##Start Tcp service
        systemctl daemon-reload
        sudo systemctl enable tcp-server.service
        sudo systemctl start tcp-server.service 
        echo -e "$YELLOW"
        echo "    💚 TCP INSTALLATION DONE💚   "
        echo "    ╰┈➤💚 TCP Running 💚       "
        echo -e "$NC"
        X
        exit 1
        ;;
esac
