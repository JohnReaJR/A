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
        echo "          💚 DNSTT INSTALLATION SCRIPT 💚    "
        echo "        ╰┈➤💚 Installing DNSTT Binaries 💚          "
        echo -e "$NC"
        apt-get update && apt-get upgrade
        apt update && apt upgrade
        echo -e "$YELLOW"
        echo "Installing HTTP Proxy..."
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
        lsof -i :"$http_port"
        echo -e "$YELLOW"
        echo "HTTP Proxy installed successfully"
        echo -e "$NC"
        exit 1
        ;;
esac
