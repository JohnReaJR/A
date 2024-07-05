clear
database="/etc/M/layers/authy/accounts.db"
fun_multilogin() {
(
while read user; do
[[ $(grep -wc "$user" $database) != '0' ]] && limit="$(grep -w $user $database | cut -d' ' -f2)" || limit='1'
conssh="$(ps -u $user | grep sshd | wc -l)"
[[ "$conssh" -gt "$limit" ]] && {
pkill -u $user
}
done <<<"$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd)"
) &
}
while true; do
echo 'Checking...'
fun_multilogin > /dev/null 2>&1
sleep 15s
done
