if [ "$EUID" -ne 0 ]; then
echo -e "\033[1;31mHey dude, run me as root!\033[0m"
exit 1
fi
banner1() {
clear
figlet -k LinkLayer | lolcat
echo -e "\033[1;34m   ResleevedNet v.5 \033[0m  | \033[1;33m v.5 Release  | ResleevedNet \033[0m"
echo -e "\033[1;36m╰═════════════════════════════════════════════════════╯\033[0m"
echo ""
}
remove_user() {
banner1
echo -e "\033[1;33m Remove Account ⌯  \033[1;33m"
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
echo -e "\033[1;33m List Of Accounts Available: \033[0m"
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
_userT=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody)
i=0
unset _userPass
while read _username; do
i=$(expr $i + 1)
_oP=$i
[[ $i == [1-9] ]] && i=0$i && oP+=" 0$i"
echo -e "\033[1;32m(\033[1;36m$i\033[1;32m) \033[1;37m \033[1;32m$_username\033[0m"
_userPass+="\n${_oP}:${_username}"
done <<< "${_userT}"
num_user=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody | wc -l)
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
echo -ne "\033[1;32mEnter or select an account \033[1;33m(\033[1;36m1\033[1;32m-\033[1;36m$num_user\033[1;33m)\033[1;37m: "
read option
username=$(echo -e "${_userPass}" | grep -E "\b$option\b" | cut -d: -f2)
if [[ -z $option ]]; then
echo " ・ User is empty or invalid!   "
sleep 3
remove_user
elif [[ -z $username ]]; then
echo "・ User is empty or invalid! "
sleep 3
remove_user
else
if cat /etc/passwd | grep -w $username > /dev/null; then
echo ""
pkill -f "$username" > /dev/null 2>&1
userdel --remove $username > /dev/null 2>&1
echo -e "\E[41;1;37m・ User $username successfully removed! \E[0m"
grep -v ^$username[[:space:]] /etc/M/layers/authy/accounts.db > /tmp/ph ; cat /tmp/ph > /etc/M/layers/authy/accounts.db
rm /etc/M/layers/authy/passwds/$username 1>/dev/null 2>/dev/null
exit 1
elif [[ "$(cat "$database"| grep -w $username| wc -l)" -ne "0" ]]; then
ps x | grep $username | grep -v grep | grep -v pt > /tmp/rem
if [[ `grep -c $username /tmp/rem` -eq 0 ]]; then
userdel --remove $username > /dev/null 2>&1
echo ""
echo -e "\E[41;1;37m・ Account $username successfully removed! \E[0m"
grep -v ^$username[[:space:]] /etc/M/layers/authy/accounts.db > /tmp/ph ; cat /tmp/ph > /etc/M/layers/authy/accounts.db
rm /etc/M/layers/authy/passwds/$username 1>/dev/null 2>/dev/null
remove_user
else
echo ""
echo "・ Account logged out. Disconnecting..."
pkill -f "$username" > /dev/null 2>&1
userdel --remove $username > /dev/null 2>&1
echo -e "\E[41;1;37m・ Account $username successfully removed! \E[0m"
grep -v ^$username[[:space:]] /etc/M/layers/authy/accounts.db > /tmp/ph ; cat /tmp/ph > /etc/M/layers/authy/accounts.db
rm /etc/M/layers/authy/passwds/$username 1>/dev/null 2>/dev/null
sudo userdel -r "$username" 1>/dev/null 2>/dev/null
if [[ -e /etc/openvpn/server.conf ]]; then
remove_ovp $username
fi
remove_user
fi
else
echo "・ The User $username does not exist!"
fi
fi
}
remove_user
