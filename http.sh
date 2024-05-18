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
        echo "          💚 TCP INSTALLATION SCRIPT 💚    "
        echo "          ╰┈➤💚 Installing TCP 💚        "
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
        echo -e "$YELLOW"
        read -p "Bind multiple TCP Ports? (y/n): " bind
        echo -e "$NC"
        if [ "$bind" = "y" ]; then
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
        if [ "$bind" = "n" ]; then
            while true; do
            echo -e "$YELLOW"
            read -p "Port Hopping Disabled"
            echo -e "$NC"
            iptables -t nat -A PREROUTING -p tcp --dport "$http_port" -j REDIRECT --to-port "$http_port"
        done
        cd /root
        rm -rf /root/tcp
        mkdir tcp
        cd tcp
        http_script="/root/tcp/sshProxy_linux_amd64"
        if [ ! -e "$http_script" ]; then
            wget https://github.com/CassianoDev/sshProxy/releases/download/v1.1/sshProxy_linux_amd64
        fi
        chmod 755 sshProxy_linux_amd64
        screen -dmS ssh_proxy ./sshProxy_linux_amd64 -addr :"$http_port" dstAddr 127.0.0.1:22
        iptables -t nat -A PREROUTING -p tcp --dport "$first_number":"$second_number" -j REDIRECT --to-port "$http_port"
        iptables -A INPUT -p tcp --dport "$http_port" -j ACCEPT
        netfilter-persistent save
        netfilter-persistent reload
        netfilter-persistent start
        echo -e "$YELLOW"
        echo "    💚 TCP INSTALLATION DONE💚   "
        echo "    ╰┈➤💚 TCP Running 💚       "
        echo -e "$NC"
        exit 1
esac
