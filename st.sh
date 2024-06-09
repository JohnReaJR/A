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
        service stunnel4 stop
        rm -rf /etc/stunnel
        rm -rf /etc/default/stunnel4
        apt-get remove stunnel4
        apt-get remove --auto-remove stunnel4
        cd /root
        clear
        apt install stunnel4 -y
        openssl req -new -x509 -days 36500 -key key.pem -out cert.pem -subj "/CN=bing.com" && cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
        cat << EOF >/etc/stunnel/stunnel.conf
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
connect = 127.0.0.1:443
accept = 50

[dropbear]
connect = 127.0.0.1:22
accept = 51
EOF
        rm -rf /etc/default/stunnel4
        cat << EOF >/etc/default/stunnel4
FILES="/etc/stunnel/*.conf"                                               
OPTIONS=""
PPP_RESTART=1                                                                                                                                                                                 
RLIMITS=""
EOF
        service stunnel4 restart
        echo -e "$YELLOW"
        echo "    💚 STUNNEL INSTALLATION DONE 💚   "
        echo "    ╰┈➤💚 STUNNEL Running 💚       "
        echo -e "$NC"
        exit 1
        ;;
esac
