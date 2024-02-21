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
      💚 HTTP CUSTOM UDP INSTALLER 💚      
       ╰┈➤ 💚 Resleeved Net 💚               "
echo -e "$NC
Select an option"
echo "1. Install HTTP CUSTOM UDP"
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
        echo "     💚 HTTP CUSTOM UDP AUTO INSTALLATION 💚      "
        echo "        ╰┈➤💚 Installing Binaries 💚           "
        echo -e "$NC"
        cd /root
        curl -LSO https://github.com/enfein/mieru/releases/download/v1.14.0/mita_1.14.0_amd64.deb
        
        rm -rf /root/config.json
        cat <<EOF >/root/udp/config.json
{
  "listen": ":443",
  "stream_buffer": 16777216,
  "receive_buffer": 33554432,
  "auth": {
    "mode": "passwords"
  }
}
EOF
        # [+config+]
        chmod 755 /root/udp/config.json

        cat <<EOF >/etc/systemd/system/custom-server.service
[Unit]
Description=UDP Custom by InFiNitY

[Service]
User=root
Type=simple
ExecStart=/root/udp/custom-linux-amd64 server
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2

[Install]
WantedBy=default.target
EOF
        #Start Services
        systemctl enable custom-server.service
        systemctl start custom-server.service
        
        #Install Badvpn
        cd /root
        systemctl stop udpgw.service
        systemctl disable udpgw.service
        rm -rf /etc/systemd/system/udpgw.service
        rm -rf /usr/bin/udpgw
        cd /usr/bin
        wget http://github.com/JohnReaJR/A/releases/download/V1/udpgw
        chmod 755 udpgw
        
        cat <<EOF >/etc/systemd/system/udpgw.service
[Unit]
[Unit]
Description=UDPGW Gateway Service by InFiNitY 
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/screen -dmS udpgw /bin/udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 100
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
        #start badvpn
        systemctl enable udpgw.service
        systemctl start udpgw.service
        echo -e "$YELLOW"
        echo "     💚 P2P SERVICE INITIALIZED 💚     "
        echo "     ╰┈➤💚 Badvpn Activated 💚         "
        echo " ╰┈➤ 💚 HTTP CUSTOM UDP SUCCESSFULLY INSTALLED 💚       "
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
