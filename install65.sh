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
      💚 MIERU UDP INSTALLER 💚      
       ╰┈➤ 💚 Resleeved Net 💚               "
echo -e "$NC
Select an option"
echo "1. Install MIERU UDP"
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
        echo "     💚 MIERU UDP AUTO INSTALLATION 💚      "
        echo "        ╰┈➤💚 Installing Binaries 💚           "
        echo -e "$NC"
        #Install Badvpn
        cd /root
        apt-get remove
        apt-get autoremove
        apt-get clean
        apt-get autoclean
        systemctl stop udpgw.service
        systemctl disable udpgw.service
        rm -rf /etc/systemd/system/udpgw.service
        rm -rf /usr/bin/udpgw
        cd /usr/bin
        wget https://github.com/JohnReaJR/A/releases/download/V1/udpgw
        chmod 755 udpgw
        cat <<EOF >/etc/systemd/system/udpgw.service
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
        echo -e "$NC"
        #mieru services
        iptables -I INPUT -p tcp --dport 10000 -j ACCEPT
        iptables -t nat -I PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p tcp --dport 10000 -j DNAT --to-destination :10000
        netfilter-persistent save
        netfilter-persistent reload
        netfilter-persistent start
        cd /root
        mita stop
        systemctl stop mita
        systemctl disable mita
        rm -rf /etc/mita
        rm -rf /usr/bin/mita
        rm -rf /root/mita_1.15.1_amd64.deb
        rm -rf /root/Mita_Config_Server.json
        curl -LSO https://github.com/enfein/mieru/releases/download/v1.15.1/mita_1.15.1_amd64.deb
        sudo dpkg -i mita_1.15.1_amd64.deb
        sudo usermod -a -G mita root
        cat <<EOF >/root/Mita_Config_Server.json
{ "portBindings": [ { "port": 10000, "protocol": "TCP" } ], "users": [ { "name": "Resleeved", "password": "Resleeved" } ] }
EOF
        #Start Services
        chmod 755 /root/Mita_Config_Server.json
        mita apply config Mita_Config_Server.json
        mita start
        echo -e "$YELLOW"
        echo " ╰┈➤ 💚 MIERU UDP SUCCESSFULLY INSTALLED 💚       "
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
