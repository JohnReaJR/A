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
echo -e "$YELLOW
      💚 OVPN UDP INSTALLER 💚      
       ╰┈➤ 💚 Resleeved Net 💚               "
echo -e "$NC
Select an option"
echo "1. Install OVPN UDP"
echo "2. Exit"
selected_option=0

while [ $selected_option -lt 1 ] || [ $selected_option -gt 2 ]; do
    echo -e "$YELLOW"
    echo "Select a number from 1 to 2:"
    echo -e "$NC"
    read input

    # Check if input is a number
    if [[ $input =~ ^[0-9]+$ ]]; then
        selected_option=$input
    else
        echo -e "$YELLOW"
        echo "Invalid input. Please enter a valid number."
        echo -e "$NC"
    fi
done
clear
case $selected_option in
    1)
        echo -e "$YELLOW"
        echo "     💚 HTTP CUSTOM UDP AUTO INSTALLATION 💚      "
        echo "        ╰┈➤💚 Installing Binaries 💚           "
        echo -e "$NC"
if [[ ! -e /etc/openvpn ]]; then
 mkdir -p /etc/openvpn
 else
 rm -rf /etc/openvpn/*
fi
mkdir -p /etc/openvpn/server
mkdir -p /etc/openvpn/client

cat <<'EOFovpn1' > /etc/openvpn/server/server_tcp.conf
port 110
dev tun
proto tcp
ca /etc/openvpn/ca.crt
cert /etc/openvpn/bonvscripts.crt
key /etc/openvpn/bonvscripts.key
dh none
persist-tun
persist-key
persist-remote-ip
duplicate-cn
cipher none
ncp-disable
auth none
comp-lzo
tun-mtu 1500
reneg-sec 0
plugin PLUGIN_AUTH_PAM /etc/pam.d/login
verify-client-cert none
username-as-common-name
max-clients 4080
topology subnet
server 172.29.0.0 255.255.240.0
push "redirect-gateway def1"
keepalive 5 30
status /etc/openvpn/tcp_stats.log
log /etc/openvpn/tcp.log
verb 2
script-security 2
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
push "dhcp-option DNS 1.0.0.1"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DNS 8.8.8.8"
EOFovpn1
cat <<'EOFovpn2' > /etc/openvpn/server/server_udp.conf
port 25222
dev tun
proto udp
ca /etc/openvpn/ca.crt
cert /etc/openvpn/bonvscripts.crt
key /etc/openvpn/bonvscripts.key
dh none
persist-tun
persist-key
persist-remote-ip
duplicate-cn
cipher none
ncp-disable
auth none
comp-lzo
tun-mtu 1500
float
fast-io
reneg-sec 0
plugin PLUGIN_AUTH_PAM /etc/pam.d/login
verify-client-cert none
username-as-common-name
max-clients 4080
topology subnet
server 172.29.16.0 255.255.240.0
push "redirect-gateway def1"
keepalive 5 30
status /etc/openvpn/udp_stats.log
log /etc/openvpn/udp.log
verb 2
script-security 2
push "dhcp-option DNS 1.0.0.1"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DNS 8.8.8.8"
EOFovpn2
cat <<'EOFovpn3' > /etc/openvpn/server/ec_server_tcp.conf
port 25980
proto tcp
dev tun
ca /etc/openvpn/ec_ca.crt
cert /etc/openvpn/ec_bonvscripts.crt
key /etc/openvpn/ec_bonvscripts.key
dh none
persist-tun
persist-key
persist-remote-ip
duplicate-cn
cipher none
ncp-disable
auth none
compress lz4
push "compress lz4"
tun-mtu 1500
reneg-sec 0
plugin PLUGIN_AUTH_PAM /etc/pam.d/login
verify-client-cert none
username-as-common-name
max-clients 4080
topology subnet
server 172.29.32.0 255.255.240.0
push "redirect-gateway def1"
keepalive 5 30
tls-server
tls-version-min 1.2
tls-cipher TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256
status /etc/openvpn/ec_tcp_stats.log
log /etc/openvpn/ec_tcp.log
verb 2
script-security 2
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
push "dhcp-option DNS 1.0.0.1"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DNS 8.8.8.8"
EOFovpn3
cat <<'EOFovpn4' > /etc/openvpn/server/ec_server_udp.conf
port 25985
proto udp
dev tun
ca /etc/openvpn/ec_ca.crt
cert /etc/openvpn/ec_bonvscripts.crt
key /etc/openvpn/ec_bonvscripts.key
dh none
persist-tun
persist-key
persist-remote-ip
duplicate-cn
cipher none
ncp-disable
auth none
compress lz4
push "compress lz4"
tun-mtu 1500
float
fast-io
reneg-sec 0
plugin PLUGIN_AUTH_PAM /etc/pam.d/login
verify-client-cert none
username-as-common-name
max-clients 4080
topology subnet
server 172.29.48.0 255.255.240.0
push "redirect-gateway def1"
keepalive 5 30
tls-server
tls-version-min 1.2
tls-cipher TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256
status /etc/openvpn/ec_udp_stats.log
log /etc/openvpn/ec_udp.log
verb 2
script-security 2
push "dhcp-option DNS 1.0.0.1"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DNS 8.8.8.8"
EOFovpn4

mkdir /etc/openvpn/easy-rsa
mkdir /etc/openvpn/easy-rsa-ec

curl -4skL "https://raw.githubusercontent.com/EskalarteDexter/Autoscript/main/DebianNew/bonvscripts-easyrsa.zip" -o /etc/openvpn/easy-rsa/rsa.zip 2> /dev/null
curl -4skL "https://raw.githubusercontent.com/EskalarteDexter/Autoscript/main/DebianNew/bonvscripts-easyrsa-ec.zip" -o /etc/openvpn/easy-rsa-ec/rsa.zip 2> /dev/null

unzip -qq /etc/openvpn/easy-rsa/rsa.zip -d /etc/openvpn/easy-rsa
unzip -qq /etc/openvpn/easy-rsa-ec/rsa.zip -d /etc/openvpn/easy-rsa-ec

rm -f /etc/openvpn/easy-rsa/rsa.zip
rm -f /etc/openvpn/easy-rsa-ec/rsa.zip

cd /etc/openvpn/easy-rsa
chmod +x easyrsa
./easyrsa build-server-full server nopass &> /dev/null
cp pki/ca.crt /etc/openvpn/ca.crt
cp pki/issued/server.crt /etc/openvpn/bonvscripts.crt
cp pki/private/server.key /etc/openvpn/bonvscripts.key

cd /etc/openvpn/easy-rsa-ec
chmod +x easyrsa
./easyrsa build-server-full server nopass &> /dev/null
cp pki/ca.crt /etc/openvpn/ec_ca.crt
cp pki/issued/server.crt /etc/openvpn/ec_bonvscripts.crt
cp pki/private/server.key /etc/openvpn/ec_bonvscripts.key

cd ~/ && echo '' > /var/log/syslog

cat <<'NUovpn' > /etc/openvpn/server/server.conf
 ### Do not overwrite this script if you didnt know what youre doing ###
 #
 # New Update are now released, OpenVPN Server
 # are now running both TCP and UDP Protocol. (Both are only running on IPv4)
 # But our native server.conf are now removed and divided
 # Into two different configs base on their Protocols:
 #  * OpenVPN TCP (located at /etc/openvpn/server/server_tcp.conf
 #  * OpenVPN UDP (located at /etc/openvpn/server/server_udp.conf
 # 
 # Also other logging files like
 # status logs and server logs
 # are moved into new different file names:
 #  * OpenVPN TCP Server logs (/etc/openvpn/server/tcp.log)
 #  * OpenVPN UDP Server logs (/etc/openvpn/server/udp.log)
 #  * OpenVPN TCP Status logs (/etc/openvpn/server/tcp_stats.log)
 #  * OpenVPN UDP Status logs (/etc/openvpn/server/udp_stats.log)
 #
 # Since config file name changes, systemctl/service identifiers are changed too.
 # To restart TCP Server: systemctl restart openvpn-server@server_tcp
 # To restart UDP Server: systemctl restart openvpn-server@server_udp
 #
 # Server ports are configured base on env vars
 # executed/raised from this script (OpenVPN_TCP_Port/OpenVPN_UDP_Port)
 #
 # Enjoy the new update
 # Script Updated by Bonveio
NUovpn

wget -qO /etc/openvpn/b.zip 'https://raw.githubusercontent.com/EskalarteDexter/Autoscript/main/DebianNew/openvpn_plugin64'
unzip -qq /etc/openvpn/b.zip -d /etc/openvpn
rm -f /etc/openvpn/b.zip

ovpnPluginPam="$(find /usr -iname 'openvpn-*.so' | grep 'auth-pam' | head -n1)"
if [[ -z "$ovpnPluginPam" ]]; then
 sed -i "s|PLUGIN_AUTH_PAM|/etc/openvpn/openvpn-auth-pam.so|g" /etc/openvpn/server/*.conf
else
 sed -i "s|PLUGIN_AUTH_PAM|$ovpnPluginPam|g" /etc/openvpn/server/*.conf
fi

sed -i '/net.ipv4.ip_forward.*/d' /etc/sysctl.conf
sed -i '/#net.ipv4.ip_forward.*/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_forward.*/d' /etc/sysctl.d/*
sed -i '/#net.ipv4.ip_forward.*/d' /etc/sysctl.d/*
echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/20-openvpn.conf
sysctl --system &> /dev/null

sed -i 's|ExecStart=.*|ExecStart=/usr/sbin/openvpn --status %t/openvpn-server/status-%i.log --status-version 2 --suppress-timestamps --config %i.conf|g' /lib/systemd/system/openvpn-server\@.service
systemctl daemon-reload
echo -e "$YELLOW"
echo "  Restarting OpenVPN UDP  "
echo -e "$NC"
systemctl restart openvpn &> /dev/null
systemctl start openvpn-server@server_tcp &>/dev/null
systemctl start openvpn-server@server_udp &>/dev/null
systemctl enable openvpn-server@server_tcp &> /dev/null
systemctl enable openvpn-server@server_udp &> /dev/null

systemctl start openvpn-server@ec_server_tcp &> /dev/null
systemctl start openvpn-server@ec_server_udp &> /dev/null
systemctl enable openvpn-server@ec_server_tcp &> /dev/null
systemctl enable openvpn-server@ec_server_udp &> /dev/null
exit 1
;;
    2)
        echo -e "$YELLOW"
        echo "Welcome To Resleeved Net"
        echo -e "$NC"
        exit 1
        ;;
esac
