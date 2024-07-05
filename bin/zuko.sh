if [ "$EUID" -ne 0 ]; then
echo -e "\033[1;31mHey dude, run me as root!\033[0m"
exit 1
fi
banner1() {
clear
figlet -k LinkLayer | lolcat
echo -e "\033[1;34m   ResleevedNet v.5 \033[0m  | \033[1;33m v.5 Release  | ResleevedNet \033[0m"
echo -e "\033[1;36m╰═════════════════════════════════════════════════════╯\033[0m"
}
banner1
echo -e "\033[1;33m Update Account Password\033[1;33m"
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
echo -e "\033[1;33m Accounts   &   Passwords \033[0m"
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
_userT=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody)
i=0
unset _userPass
while read _user; do
i=$(expr $i + 1)
_oP=$i
[[ $i == [1-9] ]] && i=0$i && oP+=" 0$i"
if [[ -e "/etc/M/layers/authy/passwds/$_user" ]]; then
_senha="$(cat /etc/M/layers/authy/passwds/$_user)"
else
_senha='Null'
fi
suser=$(echo -e "\033[1;32m(\033[1;36m$i\033[1;32m) \033[1;37m \033[1;32m$_user\033[0m")
ssenha=$(echo -e "\033[1;36mPassword\033[1;32m: $_senha")
printf '%-60s%s\n' "$suser" "$ssenha"
_userPass+="\n${_oP}:${_user}"
done <<< "${_userT}"
num_user=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody | wc -l)
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
echo -ne "\033[1;32mEnter or select a user \033[1;33m(\033[1;36m1\033[1;32m-\033[1;36m$num_user\033[1;33m)\033[1;37m: "
read option
user=$(echo -e "${_userPass}" | grep -E "\b$option\b" | cut -d: -f2)
if [[ -z $option ]]; then
echo "Empty or invalid field!"
exit 1
elif [[ -z $user ]]; then
echo "You entered an empty or invalid name!"
sleep 1
echo "Try again"
sleep 5
exit 1
fi
if [[ ! $(grep -c "^$user:" /etc/passwd) -eq 0 ]]; then
echo -ne "\033[1;32m"
read -p "New Password for $user : " password
sizepass=${#password}
if [[ ${#password} -lt 3 ]]; then
echo "Empty or invalid password! Use at least 3 characters."
sleep 1
echo "Try again"
sleep 5
exit 1
else
ps x | grep $user | grep -v grep | grep -v pt > /tmp/rem
if [[ $(grep -c $user /tmp/rem) -eq 0 ]]; then
hashed_password=$(openssl passwd -1 "$password")
usermod --password "$hashed_password" "$user"
echo -e "\033[1;36mPassword for $user Changed.\033[0m"
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
echo "$password" > /etc/M/layers/authy/passwds/$user
exit 0
else
echo "Account logged in. Disconnecting..."
pkill -f $user
hashed_password=$(openssl passwd -1 "$password")
usermod --password "$hashed_password" "$user"
echo -e "\033[1;36mPassword for $user Changed.\033[0m"
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
echo "$password" > /etc/M/layers/authy/passwds/$user
exit 0
fi
fi
else
echo "The Account $user does not exist!"
exit 1
fi
