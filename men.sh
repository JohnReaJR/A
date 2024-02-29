#!/bin/bash
[[ $1 != "" ]] && id="$1" || id="es"
barra="\033[1;34m =================================== \033[1;37m"
_cores="./cores"
_dr="./idioma"
[[ "$(echo ${txt[0]})" = "" ]] && source idioma_geral

instala_ovpn () {
parametros_iniciais () {
#Verification of System
if [[ "$EUID" -ne 0 ]]; then
	echo -e "$barra"
	echo " Sorry, you need to run this as root"
	echo -e "$barra"
	read -p " Enter"
	exit
fi

if [[ ! -e /dev/net/tun ]]; then
	echo -e "$barra"
	echo " The TUN device is not available"
	echo -e "$barra"
	read -p " Enter" 
	exit
fi
if [[ -e /etc/debian_version ]]; then
OS="debian"
VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
IPTABLES='/etc/iptables/iptables.rules'
SYSCTL='/etc/sysctl.conf'
 [[ "$VERSION_ID" != 'VERSION_ID="7"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="8"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="9"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="14.04"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="16.04"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="17.10"' ]] && {
 echo " Sua versão do Debian / Ubuntu não é suportada."
 while [[ $CONTINUE != @(y|Y|s|S|n|N) ]]; do
 read -p "Continuar ? [y/n]: " -e CONTINUE
 done
 [[ "$CONTINUE" = @(n|N) ]] && return 2
 }
else
echo -e "$barra\n\033[1;33m $(source trans -b pt:${id} "Parece que você não está executando este instalador em um sistema Debian ou Ubuntu")\n$barra"
return 1
fi
#Pega Interface
NIC=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
echo -e "$barra\n\033[1;33m $(source trans -b pt:${id} "Sistema Preparado Para Receber o OPENVPN")\n$barra"
}
add_repo () {
#INSTALACAO E UPDATE DO REPOSITORIO
# Debian 7
if [[ "$VERSION_ID" = 'VERSION_ID="7"' ]]; then
echo "deb http://build.openvpn.net/debian/openvpn/stable wheezy main" > /etc/apt/sources.list.d/openvpn.list
wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add - > /dev/null 2>&1
# Debian 8
elif [[ "$VERSION_ID" = 'VERSION_ID="8"' ]]; then
echo "deb http://build.openvpn.net/debian/openvpn/stable jessie main" > /etc/apt/sources.list.d/openvpn.list
wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add - > /dev/null 2>&1
# Ubuntu 14.04
elif [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
echo "deb http://build.openvpn.net/debian/openvpn/stable trusty main" > /etc/apt/sources.list.d/openvpn.list
wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add - > /dev/null 2>&1
fi
}
coleta_variaveis () {
	#Instal
	echo -e " $(source trans -b pt:${id} "Responda as perguntas para iniciar a instalacao")"
	echo -e " $(source trans -b pt:${id} "Responda corretamente")\n$barra "
	echo -e " \033[1;33m$(source trans -b pt:${id} "Primeiro precisamos do ip de sua maquina, este ip esta correto?")\033[0m"
	# Autodetect IP address and pre-fill for the user
	IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
	read -p " IP address: " -e -i $IP IP
	# If $IP is a private IP address, the server must be behind NAT
	if echo "$IP" | grep -qE '^(10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.|192\.168)'; then
		echo
		echo " \033[1;33m$(source trans -b en:${id} This server is behind NAT. What is the public IPv4 address or hostname?)"
		read -p " Public IP address / hostname: " -e PUBLICIP
	fi
	echo -e "$barra\n \033[1;31m$(source trans -b es:${id} "Elegir el tipo de protocolo para") OPENVPN"
	echo -e " \033[1;31m$(source trans -b pt:${id} "A menos que o UDP esteja bloqueado, você não deve usar o TCP (mais lento)")\n$barra"
	#PROTOCOLO
	while [[ $PROTOCOL != @(UDP|TCP) ]]; do
	read -p " Protocol [UDP/TCP]: " -e -i TCP PROTOCOL
	done
	[[ $PROTOCOL = "UDP" ]] && PROTOCOL=udp
	[[ $PROTOCOL = "TCP" ]] && PROTOCOL=tcp
	echo -e "$barra\n \033[1;33m$(source trans -b pt:${id} "Qual porta voce deseja usar?")\033[0m\n$barra"
	read -p " Port: " -e -i 1194 PORT
	#DNS
	echo -e "$barra\n \033[1;33m$(source trans -b pt:${id} "Qual DNS voce deseja usar?")\n$barra"
	echo "   1) Usar DNS del sistema"
	echo "   2) Cloudflare (Anycast: worldwide)"
	echo "   3) Quad9 (Anycast: worldwide)"
	echo "   4) FDN (France)"
	echo "   5) DNS.WATCH (Germany)"
	echo "   6) OpenDNS (Anycast: worldwide)"
	echo "   7) Google (Anycast: worldwide)"
	echo "   8) Yandex Basic (Russia)"
	echo "   9) AdGuard DNS (Russia)"
	while [[ $DNS != @(1|2|3|4|5|6|7|8|9) ]]; do
	read -p " DNS [1-9]: " -e -i 1 DNS
	done
	#CIPHER
	echo -e "$barra\n \033[1;33m$(source trans -b es:${id} "Elegir el tipo de codificacion para el canal de datos:")\n$barra"
	echo "   1) AES-128-CBC"
	echo "   2) AES-192-CBC"
	echo "   3) AES-256-CBC"
	echo "   4) CAMELLIA-128-CBC"
	echo "   5) CAMELLIA-192-CBC"
	echo "   6) CAMELLIA-256-CBC"
	echo "   7) SEED-CBC"
	while [[ $CIPHER != @(1|2|3|4|5|6|7) ]]; do
	read -p " Cipher [1-7]: " -e -i 1 CIPHER
	done
	case $CIPHER in
	1) CIPHER="cipher AES-128-CBC";;
	2) CIPHER="cipher AES-192-CBC";;
	3) CIPHER="cipher AES-256-CBC";;
	4) CIPHER="cipher CAMELLIA-128-CBC";;
	5) CIPHER="cipher CAMELLIA-192-CBC";;
	6) CIPHER="cipher CAMELLIA-256-CBC";;
	7) CIPHER="cipher SEED-CBC";;
	esac
	echo -e "$barra\n \033[1;33m$(source trans -b pt:${id} "Estamos prontos para configurar seu servidor OpenVPN")\n$barra"
	read -n1 -r -p " Enter to Continue..."
	echo -e "$barra"
	}
parametros_iniciais # BREVE VERIFICACAO
coleta_variaveis # COLETA VARIAVEIS PARA INSTALAÇÃO
add_repo # ATUALIZA REPOSITÓRIO OPENVPN E INSTALA OPENVPN
# Cria Diretorio
[[ ! -d /etc/openvpn ]] && mkdir /etc/openvpn
# Install openvpn
echo -ne "\033[1;31m [ ! ] apt-get update"
apt-get update -q > /dev/null 2>&1 && echo -e "\033[1;32m [OK]"
echo -ne "\033[1;31m [ ! ] apt-get install openvpn curl openssl"
apt-get install -qy openvpn curl > /dev/null 2>&1 && echo -e "\033[1;32m [OK]"
# IP Address
SERVER_IP=$(wget -qO- ipv4.icanhazip.com)
if [[ -z "${SERVER_IP}" ]]; then
    SERVER_IP=$(ip a | awk -F"[ /]+" '/global/ && !/127.0/ {print $3; exit}')
fi
# Generate CA Config
echo -ne "\033[1;31m [ ! ] Generating CA Config"
(
openssl dhparam -out /etc/openvpn/dh.pem 2048 > /dev/null 2>&1
openssl genrsa -out /etc/openvpn/ca-key.pem 2048 > /dev/null 2>&1
chmod 600 /etc/openvpn/ca-key.pem > /dev/null
openssl req -new -key /etc/openvpn/ca-key.pem -out /etc/openvpn/ca-csr.pem -subj /CN=OpenVPN-CA/ > /dev/null 2>&1
openssl x509 -req -in /etc/openvpn/ca-csr.pem -out /etc/openvpn/ca.pem -signkey /etc/openvpn/ca-key.pem -days 365 > /dev/null 2>&1
echo 01 > /etc/openvpn/ca.srl
) && echo -e "\033[1;32m [OK]"
# Gerando server.con
echo -ne "\033[1;31m [ ! ] Generating Server Config"
(
case $DNS in
1)
i=0
grep -v '#' /etc/resolv.conf | grep 'nameserver' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | while read line; do
dns[$i]="push \"dhcp-option DNS $line\""
done
if [[ ! "${dns[@]}" ]]; then
dns[0]='push "dhcp-option DNS 8.8.8.8"'
dns[1]='push "dhcp-option DNS 8.8.4.4"'
fi
;;
2)
dns[0]='push "dhcp-option DNS 1.0.0.1"'
dns[1]='push "dhcp-option DNS 1.1.1.1"'
;;
3)
dns[0]='push "dhcp-option DNS 9.9.9.9"'
dns[1]='push "dhcp-option DNS 1.1.1.1"'
;;
4)
dns[0]='push "dhcp-option DNS 80.67.169.40"'
dns[1]='push "dhcp-option DNS 80.67.169.12"'
;;
5)
dns[0]='push "dhcp-option DNS 84.200.69.80"'
dns[1]='push "dhcp-option DNS 84.200.70.40"'
;;
6)
dns[0]='push "dhcp-option DNS 208.67.222.222"'
dns[1]='push "dhcp-option DNS 208.67.220.220"'
;;
7)
dns[0]='push "dhcp-option DNS 8.8.8.8"'
dns[1]='push "dhcp-option DNS 8.8.4.4"'
;;
8)
dns[0]='push "dhcp-option DNS 77.88.8.8"'
dns[1]='push "dhcp-option DNS 77.88.8.1"'
;;
9)
dns[0]='push "dhcp-option DNS 176.103.130.130"'
dns[1]='push "dhcp-option DNS 176.103.130.131"'
;;
esac
cat > /etc/openvpn/server.conf <<EOF
server 10.8.0.0 255.255.255.0
verb 3
duplicate-cn
key client-key.pem
ca ca.pem
cert client-cert.pem
dh dh.pem
keepalive 10 120
persist-key
persist-tun
comp-lzo
float
push "redirect-gateway def1 bypass-dhcp"
${dns[0]}
${dns[1]}

user nobody
group nogroup

${CIPHER}
proto ${PROTOCOL}
port $PORT
dev tun
status openvpn-status.log
EOF
PLUGIN=$(find / | grep openvpn-plugin-auth-pam.so | head -1) && [[ $(echo ${PLUGIN}) != "" ]] && {
echo "client-to-client
client-cert-not-required
username-as-common-name
plugin $PLUGIN login" >> /etc/openvpn/server.conf
}
) && echo -e "\033[1;32m [OK]"

# Generate Client Config
echo -ne "\033[1;31m [ ! ] Generating Client Config"
(
openssl genrsa -out /etc/openvpn/client-key.pem 2048 > /dev/null 2>&1
chmod 600 /etc/openvpn/client-key.pem
openssl req -new -key /etc/openvpn/client-key.pem -out /etc/openvpn/client-csr.pem -subj /CN=OpenVPN-Client/ > /dev/null 2>&1
openssl x509 -req -in /etc/openvpn/client-csr.pem -out /etc/openvpn/client-cert.pem -CA /etc/openvpn/ca.pem -CAkey /etc/openvpn/ca-key.pem -days 36525 > /dev/null 2>&1
) && echo -e "\033[1;32m [OK]"
teste_porta () {
  echo -ne " \033[1;31m$(source trans -b es:${id} "Verificando: ")"
  sleep 1s
  [[ ! $(mportas | grep $1) ]] && {
    echo -e " \033[1;33m$(source trans -b es:${id} "Abriendo un Puerto en Python")"
    cd /etc/adm-lite
    [[ $(screen -h|wc -l) -lt '30' ]] && apt-get install screen -y 
    screen -dmS screen python ./openproxy.py "$1"    
    } || {
    echo -e "\033[1;32m [Pass]"
    return 1
    }
   }
echo -e "$barra\n \033[1;33m$(source trans -b es:${id} "Ahora se necesita el puerto de su Proxy Squid (Socks)")"
echo -e " \033[1;33m$(source trans -b pt:${id} "Se nao Existir Proxy na Porta um Proxy Python sera Aberto!")\n$barra"
while [[ $? != "1" ]]; do
read -p " Confirme un Puerto(Proxy): " -e -i 80 PPROXY
teste_porta $PPROXY
done
cat > /etc/openvpn/client-common.txt <<EOF
client
nobind
dev tun
redirect-gateway def1 bypass-dhcp
remote ${SERVER_IP} ${PORT} ${PROTOCOL}
http-proxy ${SERVER_IP} ${PPROXY}
$CIPHER
comp-lzo yes
keepalive 10 20
float
auth-user-pass
EOF
# Iptables
if [[ ! -f /proc/user_beancounters ]]; then
    N_INT=$(ip a |awk -v sip="$SERVER_IP" '$0 ~ sip { print $7}')
    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o $N_INT -j MASQUERADE
else
    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to-source $SERVER_IP
fi
iptables-save > /etc/iptables.conf
cat > /etc/network/if-up.d/iptables <<EOF
#!/bin/sh
iptables-restore < /etc/iptables.conf
EOF
chmod +x /etc/network/if-up.d/iptables
# Enable net.ipv4.ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward
#Liberando DNS
DDNS=S
agrega_dns () {
echo -e "\033[1;33m $(source trans -b pt:${id} "Digite o DNS que deseja Adicionar")"
read -p " [NewDNS]: " NEWDNS
dns_var=$(cat /etc/hosts|grep -v "$NEWDNS")
echo "127.0.0.1 $NEWDNS" > /etc/hosts
echo "$dns_var" >> /etc/hosts
unset NEWDNS 
}
echo -e "$barra\n \033[1;33m$(source trans -b pt:${id} "Ultima Etapa, Configuracoes DNS")\n$barra"
while [[ $DDNS = @(s|S|y|Y) ]]; do
echo -ne "\033[1;33m"
read -p " Adicionar DNS [S/N]: " -e -i n DDNS
[[ $DDNS = @(s|S|y|Y) ]] && agrega_dns
done
echo -e "$barra"
# REINICIANDO OPENVPN
if [[ "$OS" = 'debian' ]]; then
 if pgrep systemd-journal; then
 sed -i 's|LimitNPROC|#LimitNPROC|' /lib/systemd/system/openvpn\@.service
 sed -i 's|/etc/openvpn/server|/etc/openvpn|' /lib/systemd/system/openvpn\@.service
 sed -i 's|%i.conf|server.conf|' /lib/systemd/system/openvpn\@.service
 #systemctl daemon-reload
 (
 systemctl restart openvpn
 systemctl enable openvpn
 ) > /dev/null 2>&1
 echo -ne
 else
 /etc/init.d/openvpn restart
 fi
else
 if pgrep systemd-journal; then
  (
 systemctl restart openvpn@server.service
 systemctl enable openvpn@server.service
  ) > /dev/null 2>&1
  echo -ne
 else
 service openvpn restart
 chkconfig openvpn on
 fi
fi
apt-get install ufw -y > /dev/null 2>&1
for ufww in $(mportas|awk '{print $2}'); do
ufw allow $ufww > /dev/null 2>&1
done
#Restart OPENVPN
(
killall openvpn 2>/dev/null
systemctl stop openvpn@server.service > /dev/null 2>&1
service openvpn stop > /dev/null 2>&1
sleep 0.1s
cd /etc/openvpn > /dev/null 2>&1
/etc/iptables-openvpn > /dev/null 2>&1
openvpn --config server.conf & > /dev/null 2>&1
) > /dev/null 2>&1
echo -e "$barra\n \033[1;33m$(source trans -b pt:${id} "Openvpn Configurado Com Sucesso!")"
echo -e " \033[1;33m$(source trans -b pt:${id} "Agora Criar Um Usuario Para Gerar um Cliente!")\n$barra"
return 0
}

	
fun_openvpn () {
[[ -e /etc/openvpn/server.conf ]] && {
unset OPENBAR
[[ $(ps x|grep -v grep|grep openvpn) ]] && OPENBAR="\033[1;32mOnline" || OPENBAR="\033[1;31mOffline"
teste_porta () {
echo -ne " \033[1;31m$(source trans -b es:${id} "Verificando: ")"
sleep 1s
[[ ! $(mportas | grep $1) ]] && {
echo -e " \033[1;33m$(source trans -b es:${id} "Abriendo un Puerto en Python")"
cd /etc/adm-lite
[[ $(screen -h|wc -l) -lt '30' ]] && apt-get install screen -y 
screen -dmS screen python ./openproxy.py "$1"    
} || {
	echo -e "\033[1;32m [Pass]"
	return 1
	}
}
echo -e "$barra\n\033[1;33m $(source trans -b pt:${id} "OPENVPN ESTA INSTALADO")\n$barra"
echo -e "\033[1;31m [ 1 ] \033[1;33m $(source trans -b pt:${id} "Remover Openvpn")"
echo -e "\033[1;31m [ 2 ] \033[1;33m $(source trans -b pt:${id} "Editar Cliente Openvpn") \033[1;31m(comand nano)"
echo -e "\033[1;31m [ 3 ] \033[1;33m $(source trans -b es:${id} "INICIAR o DETENER OPENVPN") $OPENBAR\n$barra"
echo -ne "\033[1;33m $(source trans -b pt:${id} "Opcao"): "
read xption
case $xption in 
1)
	echo -e "$barra\n\033[1;33m $(source trans -b pt:${id} "DESINSTALAR OPENVPN")\n$barra"
	(
	ps x |grep openvpn |grep -v grep|awk '{print $1}' | while read pid; do kill -9 $pid; done
	killall openvpn 2>/dev/null
	systemctl stop openvpn@server.service >/dev/null 2>&1 & 
	service openvpn stop > /dev/null 2>&1
	) > /dev/null 2>&1
	#Purge
	if [[ "$OS" = 'debian' ]]; then
	fun_bar "apt-get remove --purge -y openvpn openvpn-blacklist"
	else
	fun_bar "yum remove openvpn -y"
	fi
	tuns=$(cat /etc/modules | grep -v tun) && echo -e "$tuns" > /etc/modules
	rm -f /etc/sysctl.d/30-openvpn-forward.conf
	rm -rf /etc/openvpn && rm -rf /usr/share/doc/openvpn*
	echo -e "$barra\n\033[1;33m $(source trans -b pt:${id} "Procedimento Concluido")\n$barra"
	return 0;;
 2)
   nano /etc/openvpn/client-common.txt
   return 0;;
 3)
	[[ $(ps x|grep -v grep|grep openvpn) ]] && {
	ps x |grep openvpn |grep -v grep|awk '{print $1}' | while read pid; do kill -9 $pid; done
	killall openvpn > /dev/null
	systemctl stop openvpn@server.service > /dev/null 2>&1
	service openvpn stop > /dev/null 2>&1
	echo -e "$barra\n\033[1;31m $(source trans -b es:${id} "OPENVPN Detenido")\n$barra"
	} || {
	(
	ps x |grep openvpn |grep -v grep|awk '{print $1}' | while read pid; do kill -9 $pid; done
	killall openvpn 2>/dev/null
	systemctl stop openvpn@server.service >/dev/null 2>&1 & 
	service openvpn stop > /dev/null 2>&1
	cd /etc/openvpn > /dev/null 2>&1
	/etc/iptables-openvpn > /dev/null 2>&1
	openvpn --config server.conf & > /dev/null 2>&1
	) > /dev/null 2>&1
	echo -e "${barra}"
	read -p " Confirme a Puerto(Proxy): " -e -i 80 PPROXY
	teste_porta $PPROXY
	echo -e "$barra\n\033[1;32m $(source trans -b es:${id} "OPENVPN iniciado")\n$barra"
	}
	return 0;;
 *)
	echo -e "${barra}"
	return 0
 esac
 }
