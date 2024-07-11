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
    💚 UDP REQUEST SOCKSIP INSTALLER 💚"
echo "Version : 1"
echo -e "$NC
Select an option"
echo "1. Install UDP REQUEST SOCKSIP"
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
        echo "   💚 Installing UDP REQUEST SOCKSIP 💚"
        echo -e "$NC"
        apt install -y curl
        apt install -y dos2unix
        apt install -y neofetch
        source <(curl -sSL 'https://raw.githubusercontent.com/JohnReaJR/drako/main/module')
time_reboot() {
  print_center -ama "${a92:-System/Server Reboot In} $1 ${a93:-Seconds}"
  REBOOT_TIMEOUT="$1"

  while [ $REBOOT_TIMEOUT -gt 0 ]; do
    print_center -ne "-$REBOOT_TIMEOUT-\r"
    sleep 1
    : $((REBOOT_TIMEOUT--))
  done
  reboot
}
        #Get Files
        source <(curl -sSL 'https://raw.githubusercontent.com/JohnReaJR/drako/main/module')
        systemctl stop request-server.service
        systemctl disable request-server.service
        rm -rf /etc/systemd/system/request-server.service
        rm -rf /root/udp
        mkdir udp
        cd udp
        wget github.com/JohnReaJR/A/releases/download/V1/request-linux-amd64
        chmod 755 request-linux-amd64
        wget -O /root/udp/module 'https://raw.githubusercontent.com/JohnReaJR/drako/main/module'
        chmod 755 /root/udp/module
        wget -O /root/udp/limiter.sh 'https://raw.githubusercontent.com/JohnReaJR/drako/main/limiter.sh'
        chmod 755 /root/udp/limiter.sh
        cd /root
        rm -rf /usr/bin/udp
        wget -O /usr/bin/udp 'https://raw.githubusercontent.com/JohnReaJR/drako/main/udp' 
        chmod 755 /usr/bin/udp

        #Make Service
        ip_nat=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | sed -n 1p)
        interface=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | grep "$ip_nat" | awk {'print $NF'})
        public_ip=$(grep -m 1 -oE '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' <<<"$(wget -T 10 -t 1 -4qO- "http://ip1.dynupdate.no-ip.com/" || curl -m 10 -4Ls "http://ip1.dynupdate.no-ip.com/")")

        cat <<EOF >/etc/systemd/system/request-server.service
[Unit]
Description=UDP Request Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStart=/root/udp/request-linux-amd64 -ip=$public_ip -net=$interface -mode=system
Restart=always
RestartSec=2
StandardOutput=file:/root/udp/request.log

[Install]
WantedBy=multi-user.target
EOF
        #Start Services
        systemctl enable request-server.service
        systemctl start request-server.service
        
        #Install Badvpn
        cd /root
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
ExecStart=/usr/bin/screen -dmS udpgw /bin/udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 1000
Restart=always
User=root
StandardOutput=file:/usr/bin/udpgw.log

[Install]
WantedBy=multi-user.target
EOF
        #start badvpn
        systemctl enable udpgw.service
        systemctl start udpgw.service
        echo -e "$YELLOW"
        echo "     💚 P2P SERVICE INITIALIZED 💚     "
        echo "     ╰┈➤💚 Badvpn Activated 💚         "
        echo " ╰┈➤ 💚 UDP REQUEST SUCCESSFULLY INSTALLED 💚       "
        echo -e "$NC"
        X
        exit 1
        ;;
    2)
        echo -e "$YELLOW"
        echo "Welcome To Resleeved Net"
        echo -e "$NC"
        exit 1
        ;;
esac
