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
UDP REQUEST SOCKSIP INSTALLER by Resleeved"
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
        echo "Installing UDP REQUEST SOCKSIP..."
        echo -e "$NC"
        apt-get update && apt-get upgrade
        apt install wget -y
        apt install nano -y
        apt install net-tools
        mkdir udp
        cd udp
        wget github.com/JohnReaJR/A/releases/download/V1/request-linux-amd64
        chmod 755 request-linux-amd64

make_service() {
  ip_nat=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | sed -n 1p)
  interface=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | grep "$ip_nat" | awk {'print $NF'})
  public_ip=$(grep -m 1 -oE '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' <<<"$(wget -T 10 -t 1 -4qO- "http://ip1.dynupdate.no-ip.com/" || curl -m 10 -4Ls "http://ip1.dynupdate.no-ip.com/")")

  }


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

[Install]
WantedBy=multi-user.target
EOF
        #Start Services
        apt-get update && apt-get upgrade
        apt install net-tools
        systemctl enable request-server.service
        systemctl start request-server.service
        echo "UDP REQUEST SOCKSIP UP AND RUNNING"
        exit 1
        ;;
    2)
        echo -e "$YELLOW"
        echo "Welcome To Resleeved Net"
        echo -e "$NC"
        exit 1
        ;;
esac
