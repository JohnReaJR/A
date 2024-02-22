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
        cd /root
        mita stop
        systemctl stop mita
        systemctl disable mita
        rm -rf /etc/mita
        rm -rf /usr/bin/mita
        rm -rf /root/mita_1.14.0_amd64.deb
        rm -rf /root/Mita_Config_Server.json
        curl -LSO https://github.com/enfein/mieru/releases/download/v1.14.0/mita_1.14.0_amd64.deb
        sudo dpkg -i mita_1.14.0_amd64.deb
        sudo usermod -a -G mita root
        cat <<EOF >/root/Mita_Config_Server.json
        { "portBindings" : [ { "portRange" : "20000-50000", "protocol" : "TCP" }, { "port" : 10000 , "protocol" : "TCP" } ], "users" : [ { "name" : "Resleeved" , "password" : "Resleeved" } ], "loggingLevel" : "INFO" , "mtu" : 1400 }
        EOF
        # [+config+]
        chmod 755 /root/Mita_Config_Server.json
        #Start Services
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
