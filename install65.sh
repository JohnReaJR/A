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
        sudo dpkg -i mita_1.14.0_amd64.deb
        sudo usermod -a -G mita root
        
        rm -rf /root/Mita_Config_Server.json
        cat <<EOF >/root/Mita_Config_Server.json
{
    "portBindings": [
        {
            "port": 2000,
            "protocol": "TCP"
        },
        {
            "port": 3000,
            "protocol": "UDP"
        }
    ],
    "users": [
        {
            "name": "iSegaro",
            "password": "EtT7124&1F3R"
        }
    ],
    "loggingLevel": "INFO",
    "mtu": 1480
}
EOF
        # [+config+]
        chmod 755 /root/Mita_Config_Server.json
        #Start Services
        systemctl enable custom-server.service
        systemctl start custom-server.service
        
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
