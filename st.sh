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
        echo "          💚 STUNNEL INSTALLATION SCRIPT 💚    "
        echo "          ╰┈➤💚 Installing STUNNEL 💚        "
        echo -e "$NC"
        cd /root
        systemctl stop stunnel4.service
        systemctl disable stunnel4.service
        rm -rf /etc/stunnel
        rm -rf /etc/default/stunnel4
        rm -rf /etc/systemd/system/stunnel4.service
        apt-get remove stunnel4
        apt-get remove --auto-remove stunnel4
        cd /root
        clear
        apt install stunnel4 -y
        cd /etc/stunnel
        openssl ecparam -genkey -name prime256v1 -out key.pem
        openssl req -new -x509 -days 36500 -key key.pem -out cert.pem -subj "/CN=bing.com" && cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
        cd /root
        cat << EOF >/etc/stunnel/stunnel.conf
cert = /etc/stunnel/stunnel.pem
client = no
sslVersion = TLSv1.2

socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[ssh]
accept = 51
connect = 127.0.0.1:22
[socks]
accept = 50
connect = 127.0.0.1:80
EOF
        rm -rf /etc/default/stunnel4
        cat << EOF >/etc/default/stunnel4
FILES="/etc/stunnel/*.conf"                                               
OPTIONS=""
ENABLED=1
PPP_RESTART=1                                                                                                                                                                                 
RLIMITS=""
EOF
        cat << EOF >/etc/systemd/system/stunnel4.service
[Unit]
[Unit]
Description=STUNNEL Gateway
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/stunnel4
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
        
        iptables -A INPUT -p tcp --dport 51 -j ACCEPT
        iptables -A INPUT -p tcp --dport 50 -j ACCEPT
        netfilter-persistent save
        netfilter-persistent reload
        netfilter-persistent start
        systemctl daemon-reload
        sudo systemctl enable stunnel4.service
        sudo systemctl start stunnel4.service
        echo -e "$YELLOW"
        echo "    💚 STUNNEL INSTALLATION DONE 💚   "
        echo "    ╰┈➤💚 STUNNEL Running 💚       "
        echo -e "$NC"
        X
        exit 1
        ;;
esac
