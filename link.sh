if [ "$EUID" -ne 0 ]; then
echo -e "\033[1;31mHey dude, run me as root!\033[0m"
exit 1
fi
banner00() {
clear
figlet -k LinkLayer | lolcat
echo -e "\033[1;34m  VPN Manager\033[0m | \033[1;33m3.2 Public | @voltsshx | @lstunnels\033[0m"
echo -e "\033[1;36m╰═════════════════════════════════════════════════════╯\033[0m"
echo ""
}
banner() {
clear
figlet -k LinkLayer | lolcat
echo -e "\033[1;34m  VPN Manager\033[0m | \033[1;33m3.2 Public | @voltsshx | @lstunnels\033[0m"
echo -e "\033[1;36m╰═════════════════════════════════════════════════════╯\033[0m"
echo ""
server_ip=$(curl -s https://api.ipify.org)
domainer=$(cat /etc/lnklyr/cfg/domain)
oscode=$(lsb_release -ds)
os_arch=$(uname -m) # Corrected from 'uname -i'
isp=$(wget -qO- ipinfo.io/org)
ram=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
cpu=$(top -bn1 | awk '/Cpu/ { cpu = 100 - $8 "%"; print cpu }')
echo -e "\033[1;36m IP: $server_ip  | ISP: $isp\033[0m"
echo -e "\033[1;35m OS: $oscode | Arch: $os_arch | RAM: $ram | CPU: $cpu\033[0m"
echo -e "\033[1;36m•═══════════════════════════════════════════════════•\033[0m"
echo -e "\033[1;35m// Active Protocols\033[0m // \033[1;36m$domainer\033[0m"
declare -A protocol_ports0=(
["http"]=80
["httptls"]=443
["httpdual"]=8000
)
declare -A protocol_ports1=(
["tls"]=8001
["http"]=8002
["udp"]=36718
)
output0=""
output1=""
for protocol0 in "${!protocol_ports0[@]}"; do
port0=${protocol_ports0[$protocol0]}
output0+="• $protocol0 : $port0 | "
done
for protocol1 in "${!protocol_ports1[@]}"; do
port1=${protocol_ports1[$protocol1]}
output1+="• $protocol1 : $port1 | "
done
echo -e "\033[1;33m $output0\033[0m"
echo -e "\033[1;36m ───────────────────────────────────────────────────•\033[0m"
echo -e "\033[1;33m $output1\033[0m"
echo -e "\033[1;36m•═══════════════════════════════════════════════════•\033[0m"
obfs_key=$(cat /etc/lnklyr/cfg/obfs_key)
service_state=$(systemctl is-active lnklyr-server 2>/dev/null)
if [[ $service_state == "active" ]]; then
service_status="\033[1;32mService: \033[0m\033[1;33m$service_state\033[0m"
else
service_status="\033[1;31mService: \033[0mDisabled"
fi
echo -e "\n\033[1;33m OBFS Key: \033[0m$obfs_key  | $service_status"
echo -e "\033[1;36m ───────────────────────────────────────────────────•\033[0m"
}
banner1() {
clear
figlet -k LinkLayer | lolcat
echo -e "\033[1;34m  VPN Manager\033[0m | \033[1;33m3.2 Public | @voltsshx | @lstunnels\033[0m"
echo -e "\033[1;36m╰═════════════════════════════════════════════════════╯\033[0m"
echo ""
server_ip=$(curl -s https://api.ipify.org)
oscode=$(lsb_release -ds)
os_arch=$(uname -m)  # Corrected from 'uname -i'
isp=$(wget -qO- ipinfo.io/org)
ram=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
cpu=$(top -bn1 | awk '/Cpu/ { printf "%.2f%%", 100 - $8 }')
echo -e "\033[1;36m IP: $server_ip  | ISP: $isp\033[0m"
echo -e "\033[1;35m OS: $oscode | Arch: $os_arch | RAM: $ram | CPU: $cpu\033[0m"
echo -e "\033[1;36m•═══════════════════════════════════════════════════•\033[0m"
echo -e "\033[1;35m // Active Protocols \033[0m"
obfs_key=$(cat /etc/lnklyr/cfg/obfs_key)
service_state=$(systemctl is-active lnklyr-server 2>/dev/null)
if [[ $service_state == "active" ]]; then
service_status="\033[1;32mService: \033[0m\033[1;33m$service_state\033[0m"
else
service_status="\033[1;31mService: \033[0mDisabled"
fi
echo -e "\033[1;33m OBFS Key: \033[0m$obfs_key  | $service_status"
echo -e "\033[1;36m ───────────────────────────────────────────────────•\033[0m"
}
uninstallation() {
banner00
echo "Please wait..."
sleep 5
service linklayer stop &>/dev/null
service linklayer disable &>/dev/null
rm -rf /etc/lnklyr
rm -rf /usr/bin/link
rm -rf /usr/share/lnklyr
rm -rf /var/log/linklayer.log
rm -rf /etc/systemd/system/linklayer.service &>/dev/null
while IFS= read -r username; do
userdel -r "$username"
done < <(grep -oP '^user[0-9]+:' /etc/passwd | cut -d: -f1)
echo ""
echo "Please wait..."
sleep 3
echo "Uninstallation complete."
echo ""
}
menu() {
echo ""
echo -e "        \033[1;41m+QUICK MENU+\033[0m\n\
────────────────────────────────────────•"
echo -e "\e[36m 01⎬➤ 👤 Create Account"
echo -e "\e[36m 02⎬➤ 🔒 Change Password"
echo -e "\e[36m 03⎬➤ ❌ Remove Account"
echo -e "\e[36m 04⎬➤ 🔄 Renew Account"
echo -e "\e[36m 05⎬➤ 🔖 Account Details"
echo -e "\e[36m 06⎬➤ ⌛️ Check Active Protocols"
echo -e "\e[36m 07⎬➤ 🔌 Force Restart LinkLayer"
echo -e "\e[36m 08⎬➤ 🔄 Restart VPS"
echo -e "\e[36m 09⎬➤ 🌐 Online Accounts (not implemeted)"
echo -e "\e[36m 10⎬➤ 💾 Backup/Restore (not implemeted)"
echo -e "\e[36m 11⎬➤ 🚮 Uninstall"
echo -e "\e[36m 00⎬➤ ↪️  Exit"
echo -e "────────────────────────────────────────•\033[0m"
echo ""
}
call_menu() {
while true; do
banner
menu
read -p "Enter your choice: " choice
case $choice in
1)
clear
atom
read -n 1 -s -r -p "  Press any key to return ↩︎"
;;
2)
clear
zuko
read -n 1 -s -r -p "  Press any key to return ↩︎"
;;
3)
clear
killie
read -n 1 -s -r -p "  Press any key to return ↩︎"
;;
4)
clear
azure
read -n 1 -s -r -p "  Press any key to return ↩︎"
;;
5)
clear
info
read -n 1 -s -r -p "  Press any key to return ↩︎"
;;
6)
banner
echo -e "\n\033[1;33m   Active Protocols\033[0m"
echo -e "\033[1;36m───────────────────────────────────────────────────\033[0m"
lsof -i :80,443,8000,8001,8002,8990,36718 | awk 'NR==1{print; next} {print "\033[1;34m・ " $0 "\033[0m"}'
echo -e "\033[1;36m───────────────────────────────────────────────────\033[0m"
echo -e ""
read -n 1 -s -r -p "  Press any key to return ↩︎"
;;
7)
banner
if [[ $service_state == "active" ]]; then
systemctl restart lnklyr-server &>/dev/null
echo -e "\nService restarted successfully."
sleep 3
else
systemctl enable lnklyr-server &>/dev/null
systemctl start lnklyr-server &>/dev/null
echo -e "\nService force started successfully."
sleep 3
fi
;;
8)
banner
echo -e "reboot in 3 secs..."
sleep 3
reboot
;;
11)
banner
uninstallation
sleep 2
clear
exit 0
;;
0)
echo ""
echo "Exiting..."
clear
exit 0
;;
*)
echo ""
echo "Invalid choice. Please select a valid option."
;;
esac
done
}
call_menu
