if [ "$EUID" -ne 0 ]; then
echo -e "\033[1;31mHey dude, run me as root!\033[0m"
exit 1
fi
banner1() {
clear
figlet -k LinkLayer | lolcat
echo -e "\033[1;34m   ResleevedNet v.5 \033[0m  | \033[1;33m v.5 Release  | ResleevedNet \033[0m"
echo -e "\033[1;36m╰═════════════════════════════════════════════════════╯\033[0m"
server_ip=$(curl -s https://api.ipify.org)
echo -e "\n\033[1;33m OBFS Key: \033[0m$(cat /etc/M/cfg/obfs_key)"
echo -e "\033[1;36m ───────────────────────────────────────────────────•\033[0m"
}
banner1
echo -e "\033[1;33mCreate Account \033[0m"
echo -e "\033[1;36m•═══════════════════════════════════════════════════•\033[0m"
echo -e "\033[1;31mALERT: Password must not be less than 3 characters.\033[0m"
echo -ne "\033[1;32m"
read -p"Username: " username
if [[ -z "$username" ]]; then
echo -e "\033[1;31mError: Username cannot be empty.\033[0m"
exit 1
fi
echo -ne "\033[1;32m"
read -p "Password: " password
if [[ -z "$password" ]]; then
echo -e "\033[1;31mError: Password cannot be empty.\033[0m"
exit 1
elif [[ ${#password} -lt 3 ]]; then
echo -e "\033[1;31mError: Password must be at least 3 characters long.\033[0m"
exit 1
fi
read -p "Number of days until expiration: " days
if [[ -z "$days" || ! "$days" =~ ^[0-9]+$ || "$days" -lt 1 ]]; then
echo -e "\033[1;31mError: Please enter a valid number of days (greater than 0).\033[0m"
exit 1
fi
read -p "Connection limit: " connection_limit
if [[ -z "$connection_limit" || ! "$connection_limit" =~ ^[0-9]+$ || "$connection_limit" -lt 1 ]]; then
echo -e "\033[1;31mError: Please enter a valid connection limit (greater than 0).\033[0m"
exit 1
fi
expiration_date=$(date -d "+$days days" "+%Y-%m-%d")
useraexpiration_date=$(date -d "+$days days" "+%Y-%m-%d")
useradd -e "$expiration_date" -s /bin/false -M "$username" >/dev/null 2>&1
hashed_password=$(openssl passwd -1 "$password")
usermod --password "$hashed_password" "$username"
chage -E "$expiration_date" "$username"
mkdir -p /etc/M/layers/authy/passwds
echo "$username:$password:$connection_limit" >> /etc/M/layers/authy/accounts.txt
echo "\033[0m"
echo "$password" >/etc/M/layers/authy/passwds/$username
echo "$username $connection_limit" >>/etc/M/layers/authy/accounts.db
clear
banner1
echo ""
echo -e "\033[1;34m・ Account Details"
echo -e "\033[1;36m•═══════════════════════════════════════════════════•\033[0m"
echo -e "\033[1;34m・ Note: All Protocols use same account details!"
echo -e "\033[1;34m・・・・・・・・"
echo -e "\033[1;36m•═══════════════════════════════════════════════════•\033[0m"
echo -e "\e[36m・ Domain           ➤  \033[1;31m$(cat /etc/M/cfg/domain)"
echo -e "\e[36m・ Server IP        ➤  \033[1;31m$server_ip"
echo -e "\e[36m・ Username         ➤  \033[1;31m$username"
echo -e "\e[36m・ Password         ➤  \033[1;31m$password"
echo -e "\e[36m・ OBFS Key         ➤  \033[1;31m$(cat /etc/M/cfg/obfs_key)"
echo -e "\e[36m・ Expiration Date  ➤  \033[1;31m$expiration_date\033[0m"
echo -e "\e[36m・ Connection Limit ➤  \033[1;31m$connection_limit\033[0m"
echo ""
echo -e "\033[1;33mTelegram: @ResleevedNet \033[0m"
echo -e "\033[1;33mChannel: @Am_The_Last_Envoy \033[0m"
sleep 1
