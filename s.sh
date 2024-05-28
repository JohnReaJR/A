#!/bin/bash
#Release: v.5
udp_dir='/root/sh'
source $udp_dir/module

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Local Module
#source ./module/module
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

request_public_ip=$(grep -m 1 -oE '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' <<<"$(wget -T 10 -t 1 -4qO- "http://ip1.dynupdate.no-ip.com/" || curl -m 10 -4Ls "http://ip1.dynupdate.no-ip.com/")")
  
#======= CONFIGURATION OF SSH UDP ACCOUNTS =======

data_user() {
  cat_users=$(cat "/etc/passwd" | grep 'home' | grep 'false' | grep -v 'syslog' | grep -v '::/' | grep -v 'hwid\|token')
  [[ -z "$(echo "${cat_users}" | head -1)" ]] && print_center -verm2 "${a96:-NO REGISTERED SSH USERS}" && return 1
  dat_us=$(printf '%-13s%-14s%-10s%-4s%-6s%s' "${a48:-User}" "${a49:-Pass}" "${a97:-Date}" "${a98:-Days}" 'Lmt' 'Stat')
  msg -azu "  $dat_us"
  msg -bar

  i=1

  while read line; do
    u=$(echo "$line" | awk -F ':' '{print $1}')

    fecha=$(chage -l "$u" | sed -n '4p' | awk -F ': ' '{print $2}')

    mes_dia=$(echo $fecha | awk -F ',' '{print $1}' | sed 's/ //g')
    ano=$(echo $fecha | awk -F ', ' '{printf $2}' | cut -c 3-)
    us=$(printf '%-12s' "$u")

    pass=$(echo "$line" | awk -F ':' '{print $5}' | cut -d ',' -f2)
    [[ "${#pass}" -gt '12' ]] && pass="${a99:-Discount}"
    pass="$(printf '%-12s' "$pass")"

    unset stat
    if [[ $(passwd --status $u | cut -d ' ' -f2) = "P" ]]; then
      stat="$(msg -verd "ULK")"
    else
      stat="$(msg -verm2 "BLK")"
    fi

    Limit=$(echo "$line" | awk -F ':' '{print $5}' | cut -d ',' -f1)
    [[ "${#Limit}" = "1" ]] && Limit=$(printf '%2s%-4s' "$Limit") || Limit=$(printf '%-6s' "$Limit")

    echo -ne "$(msg -verd "$i")$(msg -verm2 "-")$(msg -azu "${us}") $(msg -azu "${pass}")"
    if [[ $(echo $fecha | awk '{print $2}') = "" ]]; then
      exp="$(printf '%8s%-2s' '[X]')"
      exp+="$(printf '%-6s' '[X]')"
      echo " $(msg -verm2 "$fecha")$(msg -verd "$exp")$(echo -e "$stat")"
    else
      if [[ $(date +%s) -gt $(date '+%s' -d "${fecha}") ]]; then
        exp="$(printf '%-5s' "Exp")"
        echo " $(msg -verm2 "$mes_dia/$ano")  $(msg -verm2 "$exp")$(msg -ama "$Limit")$(echo -e "$stat")"
      else
        EXPTIME="$(($(($(date '+%s' -d "${fecha}") - $(date +%s))) / 86400))"
        [[ "${#EXPTIME}" = "1" ]] && exp="$(printf '%2s%-3s' "$EXPTIME")" || exp="$(printf '%-5s' "$EXPTIME")"
        echo " $(msg -verm2 "$mes_dia/$ano")  $(msg -verd "$exp")$(msg -ama "$Limit")$(echo -e "$stat")"
      fi
    fi
    let i++
  done <<<"$cat_users"
}

# ======== user Details ====

detail_user() {
  clear
  active_users=('' $(show_users))
  if [[ -z ${active_users[@]} ]]; then
    msg -bar
    print_center -verm2 "${a62:-No registered user}"
    msg -bar
    sleep 3
    return
  else
    msg -bar
    print_center -ama "${a63:-DETAILS OF USERS}"
    msg -bar
  fi
  data_user
  msg -bar
  enter
}

#======== user block ======

block_user() {
  clear
  active_users=('' $(show_users))
  msg -bar
  print_center -ama "${a9:-BLOCK/UNBLOCK USERS}"
  msg -bar
  data_user
  back

  print_center -ama "${a52:-Type a Username from the list}"
  msg -bar
  unset selection
  while [[ ${selection} = "" ]]; do
    msg -nazu "${a53:-Please type a username}: " && read selection
    del 1
  done

  [[ ${selection} = "0" ]] && return
  if [[ ! $(print_center -ama "${selection}" | egrep '[^0-9]') ]]; then
    user_del="${active_users[$selection]}"
  else
    user_del="$selection"
  fi
  [[ -z $user_del ]] && {
    msg -verm "${a54:-Error, Invalid User}"
    msg -bar
    return 1
  }
  [[ ! $(echo ${active_users[@]} | grep -w "$user_del") ]] && {
    msg -verm "${a54:-Error, Invalid User}"
    msg -bar
    return 1
  }

  msg -nama "   ${a48:-Username}: $user_del >>>> "

  if [[ $(passwd --status $user_del | cut -d ' ' -f2) = "P" ]]; then
    pkill -u $user_del &>/dev/null
    droplim=$(droppids | grep -w "$user_del" | awk '{print $2}')
    kill -9 $droplim &>/dev/null
    usermod -L $user_del &>/dev/null
    sleep 2
    msg -verm2 "${a60:-Blocked}"
  else
    usermod -U $user_del
    sleep 2
    msg -verd "${a61:-Unblocked}"
  fi
  msg -bar
  sleep 3
}

#======== user remover =========

renew_user_fun() {
  #nome dias
  datexp=$(date "+%F" -d " + $2 days") && valid=$(date '+%C%y-%m-%d' -d " + $2 days")
  if chage -E $valid $1; then
    print_center -ama "${a100:-Renewed User Successfully}"
  else
    print_center -verm "${a101:-Error, Renewal failed!}"
  fi
}

renew_user() {
  clear
  active_users=('' $(show_users))
  msg -bar
  print_center -ama "${a8:-RENEW USERS}"
  msg -bar
  data_user
  back

  print_center -ama "${a52:-Type a Username from the list}"
  msg -bar
  unset selection
  while [[ -z ${selection} ]]; do
    msg -nazu "${a53:-Select an Option}: " && read selection
    del 1
  done

  [[ ${selection} = "0" ]] && return
  if [[ ! $(print_center -ama "${selection}" | egrep '[^0-9]') ]]; then
    useredit="${active_users[$selection]}"
  else
    useredit="$selection"
  fi

  [[ -z $useredit ]] && {
    msg -verm "${a54:-Error, Invalid User}"
    msg -bar
    sleep 3
    return 1
  }

  [[ ! $(print_center -ama ${active_users[@]} | grep -w "$useredit") ]] && {
    msg -verm "${a54:-Error, Invalid User}"
    msg -bar
    sleep 3
    return 1
  }

  while true; do
    msg -ne "${a58:-New Duration}: $useredit"
    read -p ": " userdays
    if [[ -z "$userdays" ]]; then
      print_center -ama -e '\n\n\n'
      err_fun 7 && continue
    elif [[ "$userdays" != +([0-9]) ]]; then
      print_center -ama -e '\n\n\n'
      err_fun 8 && continue
    elif [[ "$userdays" -gt "360" ]]; then
      print_center -ama -e '\n\n\n'
      err_fun 9 && continue
    fi
    break
  done
  msg -bar
  renew_user_fun "${useredit}" "${userdays}"
  msg -bar
  sleep 3
}

#======== remove client =========

droppids() {
  port_dropbear=$(ps aux | grep 'dropbear' | awk NR==1 | awk '{print $17;}')
  log=/var/log/auth.log
  loginsukses='Password auth succeeded'
  pids=$(ps ax | grep 'dropbear' | grep " $port_dropbear" | awk -F " " '{print $1}')
  for pid in $pids; do
    pidlogs=$(grep $pid $log | grep "$loginsukses" | awk -F" " '{print $3}')
    i=0
    for pidend in $pidlogs; do
      let i=i+1
    done
    if [ $pidend ]; then
      login=$(grep $pid $log | grep "$pidend" | grep "$loginsukses")
      PID=$pid
      user=$(print_center -ama $login | awk -F" " '{print $10}' | sed -r "s/'/ /g")
      waktu=$(print_center -ama $login | awk -F" " '{print $2"-"$1,$3}')
      while [ ${#waktu} -lt 13 ]; do
        waktu=$waktu" "
      done
      while [ ${#user} -lt 16 ]; do
        user=$user" "
      done
      while [ ${#PID} -lt 8 ]; do
        PID=$PID" "
      done
      print_center -ama "$user $PID $waktu"
    fi
  done
}

rm_user() {
  pkill -u $1
  droplim=$(droppids | grep -w "$1" | awk '{print $2}')
  kill -9 $droplim &>/dev/null
  userdel --force "$1" &>/dev/null
  msj=$?
}

show_users() {
  for u in $(cat /etc/passwd | grep 'home' | grep 'false' | grep -v 'syslog' | grep -v 'hwid' | grep -v 'token' | grep -v '::/' | awk -F ':' '{print $1}'); do
    print_center -ama "$u"
  done
}

remove_user() {
  clear
  active_users=('' $(show_users))
  msg -bar
  print_center -ama "${a7:-REMOVE USERS}"
  msg -bar
  data_user
  back

  print_center -ama "${a52:-Type or Select a User}"
  msg -bar
  unset selection
  while [[ -z ${selection} ]]; do
    msg -nazu "${a53:-Please type a username}: " && read selection
    tput cuu1 && tput dl1
  done
  [[ ${selection} = "0" ]] && return
  if [[ ! $(print_center -ama "${selection}" | egrep '[^0-9]') ]]; then
    user_del="${active_users[$selection]}"
  else
    user_del="$selection"
  fi
  [[ -z $user_del ]] && {
    msg -verm "${a54:-Error, Invalid User}"
    msg -bar
    return 1
  }
  [[ ! $(echo ${active_users[@]} | grep -w "$user_del") ]] && {
    msg -verm "${a54:-Error, Invalid User}"
    msg -bar
    return 1
  }

  print_center -ama "${a55:-Selected User}: $user_del"
  rm_user "$user_del"
  if [[ $msj = 0 ]]; then
    print_center -verd "[${a56:-Removed}]"
  else
    print_center -verm "[${a57:-Not Removed}]"
  fi
  enter
}

#========create client =============

add_user() {
  Fecha=$(date +%d-%m-%y-%R)
  [[ $(cat /etc/passwd | grep $1: | grep -vi [a-z]$1 | grep -v [0-9]$1 >/dev/null) ]] && return 1
  valid=$(date '+%C%y-%m-%d' -d " +$3 days")
  osl_v=$(openssl version | awk '{print $2}')
  osl_v=${osl_v:0:5}
  if [[ $osl_v = '1.1.1' ]]; then
    pass=$(openssl passwd -6 $2)
  else
    pass=$(openssl passwd -1 $2)
  fi
  useradd -M -s /bin/false -e ${valid} -K PASS_MAX_DAYS=$3 -p ${pass} -c $4,$2 $1 &>/dev/null
  msj=$?
}

new_user() {
  clear
  active_users=('' $(show_users))
  msg -bar
  print_center -ama "${a6:-CREATE USER ACCOUNT}"
  msg -bar
  data_user
  back

  while true; do
    msg -ne " ${a41:-Username}: "
    read nameuser
    nameuser="$(echo $nameuser | sed 'y/áÁàÀãÃâÂéÉêÊíÍóÓõÕôÔúÚñÑçÇªº/aAaAaAaAeEeEiIoOoOoOuUnNcCao/')"
    nameuser="$(echo $nameuser | sed -e 's/[^a-z0-9 -]//ig')"
    if [[ -z $nameuser ]]; then
      err_fun 1 && continue
    elif [[ "${nameuser}" = "0" ]]; then
      return
    elif [[ "${#nameuser}" -lt "4" ]]; then
      err_fun 2 && continue
    elif [[ "${#nameuser}" -gt "12" ]]; then
      err_fun 3 && continue
    elif [[ "$(echo ${active_users[@]} | grep -w "$nameuser")" ]]; then
      err_fun 14 && continue
    fi
    break
  done

  while true; do
    msg -ne " ${a42:-Password}"
    read -p ": " userpass
    userpass="$(echo $userpass | sed 'y/áÁàÀãÃâÂéÉêÊíÍóÓõÕôÔúÚñÑçÇªº/aAaAaAaAeEeEiIoOoOoOuUnNcCao/')"
    if [[ -z $userpass ]]; then
      err_fun 4 && continue
    elif [[ "${#userpass}" -lt "4" ]]; then
      err_fun 5 && continue
    elif [[ "${#userpass}" -gt "12" ]]; then
      err_fun 6 && continue
    fi
    break
  done

  while true; do
    msg -ne " ${a43:-Number of Days}"
    read -p ": " userdays
    if [[ -z "$userdays" ]]; then
      err_fun 7 && continue
    elif [[ "$userdays" != +([0-9]) ]]; then
      err_fun 8 && continue
    elif [[ "$userdays" -gt "360" ]]; then
      err_fun 9 && continue
    fi
    break
  done

  while true; do
    msg -ne " ${a44:-Connection Limit}"
    read -p ": " limiteuser
    if [[ -z "$limiteuser" ]]; then
      err_fun 11 && continue
    elif [[ "$limiteuser" != +([0-9]) ]]; then
      err_fun 12 && continue
    elif [[ "$limiteuser" -gt "999" ]]; then
      err_fun 13 && continue
    fi
    break
  done

  add_user "${nameuser}" "${userpass}" "${userdays}" "${limiteuser}"
  clear
  msg -bar
  if [[ $msj = 0 ]]; then
    print_center -verd "${a45:-User Created Successfully}"
  else
    print_center -verm2 "${a46:-Error, user not created}"
    enter
    return 1
  fi
  msg -bar
  msg -ne " ${a47:-Server IP}: " && msg -ama "    $request_public_ip"
  msg -ne " ${a48:-Username}: " && msg -ama "         $nameuser"
  msg -ne " ${a49:-Password}: " && msg -ama "         $userpass"
  msg -ne " ${a50:-Number of Days}: " && msg -ama "   $userdays"
  msg -ne " ${a44:-Connection Limit}: " && msg -ama " $limiteuser"
  msg -ne " ${a51:-Expiration Date}: " && msg -ama "$(date "+%F" -d " + $userdays days")"
  enter
}
  print_center -ama "${a12:-Resleeved Net Menu}"
  msg -bar3
  echo " $(msg -verd "[1]") $(msg -verm2 '>') $(msg -verd "${a6:-Create User}")"
  echo " $(msg -verd "[2]") $(msg -verm2 '>') $(msg -verm2 "${a7:-Remove User}")"
  echo " $(msg -verd "[3]") $(msg -verm2 '>') $(msg -ama "${a8:-Renew User}")"
  echo " $(msg -verd "[4]") $(msg -verm2 '>') $(msg -blu "${a9:-Block/Unlock User}")"
  echo " $(msg -verd "[5]") $(msg -verm2 '>') $(msg -verm3 "${a10:-User Details}")"
  echo " $(msg -verd "[6]") $(msg -verm2 '>') $(msg -teal "${a11:-Limit Accounts}")"
  msg -bar3
  back
  # option=$(selection_fun $num)
  read -p " ⇢  Enter your selection: " option

  case $option in
  1) new_user ;;
  2) remove_user ;;
  3) renew_user ;;
  4) block_user ;;
  5) detail_user ;;
  6) limiter ;;
  7) menu_main ;;
  esac
}

# [MAIN MENU]A
menu_main() {
  main_title "\033[3;40m${a10:-• SSH ACCOUNTS} •"
  print_center -ama 'Release: v.5'
  print_center -ama 'Resleeved Net'
  msg -bar
  # print options menu
  print_center -ama "${a12:-Resleeved Net UDP}"
  msg -bar3
  exit2home

  # prompt user for option selection
  read -p " ⇢  Enter your selection: " option

  # handle option selection
  case $option in
  1)
    Menu_UDP_REQUEST
    ;;
  0)
    exit
    ;;
  esac
}
done
