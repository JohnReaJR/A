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
echo -e "\033[1;33m Change Account Expiration Date\033[1;33m"
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
echo -e "\033[1;33m Accounts   &   Expiration Date\033[0m "
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
database="/etc/M/layers/authy/accounts.db"
list_user=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody)
i=0
unset _userPass
while read user; do
i=$(expr $i + 1)
_oP=$i
[[ $i == [1-9] ]] && i=0$i && oP+=" 0$i"
expire="$(chage -l $user | grep -E "Account expires" | cut -d ' ' -f3-)"
if [[ $expire == "never" ]]; then
echo -e "\033[1;32m(\033[1;36m$i\033[1;32m) \033[1;37m \033[1;32m$user\033[0m"
else
databr="$(date -d "$expire" +"%Y%m%d")"
hoje="$(date -d today +"%Y%m%d")"
if [ $hoje -ge $databr ]; then
_user=$(echo -e "\033[1;32m(\033[1;36m$i\033[1;32m) \033[1;37m \033[1;32m$user\033[1;37m")
datanormal="$(echo -e "\033[1;36m$(date -d"$expire" '+%d/%m/%Y')")"
expired=$(echo -e "\033[1;31m・ Expired\033[0m")
printf '%-62s%-20s%s\n' "$_user" "$datanormal" "$expired"
echo "exp" >/tmp/exp
else
_user=$(echo -e "\033[1;32m(\033[1;36m$i\033[1;32m) \033[1;37m \033[1;32m$user\033[1;37m")
datanormal="$(echo -e "\033[1;36m$(date -d"$expire" '+%d/%m/%Y')")"
ative=$(echo -e "\033[1;32m Valid\033[0m")
printf '%-62s%-20s%s\n' "$_user" "$datanormal" "$ative"
fi
fi
_userPass+="\n${_oP}:${user}"
done <<<"${list_user}"
tput sgr0
if [ -a /tmp/exp ]; then
rm /tmp/exp
fi
num_user=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody | wc -l)
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
echo -ne "\033[1;32mEnter or select a user \033[1;33m(\033[1;36m1\033[1;32m-\033[1;36m$num_user\033[1;33m)\033[1;37m: "
read option
if [[ -z $option ]]; then
echo ""
echo "\033[1;31m・Error, Empty or Invalid Username!\033[0m"
exit 1
fi
username=$(echo -e "${_userPass}" | grep -E "\b$option\b" | cut -d: -f2)
if [[ -z $username ]]; then
echo ""
echo "\033[1;31m・Error, Empty or Invalid Username!\033[0m"
echo ""
exit 1
else
if [[ $(grep -c /$username: /etc/passwd) -ne 0 ]]; then
echo -e "\033[1;36mEX:\033[1;33m(\033[1;32mDATE: \033[1;37mDay/Month/Year \033[1;33mOR \033[1;32mDAYS: \033[1;37m30)\033[0m"
echo -ne "\033[1;32mNew date or days for the user \033[1;33m$username: \033[1;37m"
read inputdate
if [[ "$(echo -e "$inputdate" | grep -c "/")" = "0" ]]; then
udata=$(date "+%d/%m/%Y" -d "+$inputdate days")
sysdate="$(echo "$udata" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
else
udata=$(echo -e "$inputdate")
sysdate="$(echo "$inputdate" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
fi
if (date "+%Y-%m-%d" -d "$sysdate" >/dev/null 2>&1); then
if [[ -z $inputdate ]]; then
echo ""
echo "・ You have entered an invalid or non-existent date!"
echo "Enter a valid date in Day/Month/Year format "
echo "For example: 01/01/2025"
echo ""
exit 1
else
if (echo $inputdate | egrep [^a-zA-Z] &>/dev/null); then
today="$(date -d today +"%Y%m%d")"
timemachine="$(date -d "$sysdate" +"%Y%m%d")"
if [ $today -ge $timemachine ]; then
echo ""
echo "・ You have entered an invalid or non-existent date!!"
echo "Enter a valid future date in Day/Month/Year format"
echo "For example: 01/01/2025"
echo ""
exit 1
else
echo -ne "\033[1;32m"
chage -E $sysdate $username
echo -e "\033[1;36mUser Success $username new date: $udata \033[0m"
echo -e "\033[1;36m────────────────────────────────────────────────────•\033[0m"
exit 1
fi
else
echo ""
echo "You have entered an invalid or non-existent date!"
echo "Enter a valid date in Day/Month/Year format"
echo "For example: 01/01/2025"
echo ""
exit 1
fi
fi
else
echo ""
echo "You have entered an invalid or non-existent date!"
echo "Enter a valid date in Day/Month/Year format"
echo "For example: 21/04/2018"
echo ""
exit 1
fi
else
echo " "
echo "・ The user $username does not exist!"
echo " "
exit 1
fi
fi
