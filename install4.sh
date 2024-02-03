        #!/bin/bash
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
        echo "        ╰┈➤💚 Installing TCP Binaries 💚          "
        echo -e "$NC"
        apt-get update && apt-get upgrade
        apt update && apt upgrade
        iptables -P INPUT ACCEPT
        iptables -P FORWARD ACCEPT
        iptables -P OUTPUT ACCEPT
        iptables -F
        iptables -X 
        iptables -Z
        iptables -t nat -F
        iptables -t nat -X
        iptables -t mangle -F
        iptables -t mangle -X
        iptables -t raw -F
        iptables -t raw -X
        apt-get install iptables
        apt-get install iptables-persistent
        ip6tables -P INPUT ACCEPT
        ip6tables -P FORWARD ACCEPT
        ip6tables -P OUTPUT ACCEPT
        ip6tables -F
        ip6tables -X 
        ip6tables -Z
        ip6tables -t nat -F
        ip6tables -t nat -X
        ip6tables -t mangle -F
        ip6tables -t mangle -X
        ip6tables -t raw -F
        ip6tables -t raw -X
        echo -e "$YELLOW"
        echo "TCP...INSTALLING"
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
        while true; do
            echo -e "$YELLOW"
            read -p "Binding TCP Ports : from port : " first_number
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
            read -p "Binding TCP Ports : from port : $first_number to port : " second_number
            echo -e "$NC"
            if is_number "$second_number" && [ "$second_number" -gt "$first_number" ] && [ "$second_number" -lt 65536 ]; then
                break
            else
                echo -e "$YELLOW"
                echo "Invalid input. Please enter a valid number greater than $first_number and less than 65536."
                echo -e "$NC"
            fi
        done
        mkdir tcp
        cd tcp
        http_script="/root/tcp/sshProxy_linux_amd64"
        if [ ! -e "$http_script" ]; then
            wget https://github.com/CassianoDev/sshProxy/releases/download/v1.1/sshProxy_linux_amd64
        fi
        chmod 755 sshProxy_linux_amd64
        screen -dmS ssh_proxy ./sshProxy_linux_amd64 -addr :"$http_port" dstAddr 127.0.0.1:22
        iptables -t nat -A PREROUTING -p tcp --dport "$first_number":"$second_number" -j REDIRECT --to-port "$http_port"
        netfilter-persistent save
        netfilter-persistent reload
        netfilter-persistent start
        echo -e "$YELLOW"
        echo "TCP SUCCESSFULLY INSTALLED"
        echo -e "$NC"
        exit 1
        ;;
esac
