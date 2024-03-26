#!/bin/bash
HOST='195.35.10.163'
USER='Nimata'
PASS='Nimata'
DBNAME='Nimata'
PORT_TCP='1194'
PORT_UDP='53'
YELLOW='\033[1;33m'
NC='\033[0m'
if [ "$(whoami)" != "root" ]; then
    echo "Error: This script must be run as root."
    exit 1
fi
cd /root
clear
echo -e "$YELLOW"
echo "          💚 IPTABLES....SETTING UP YOUR FIREWALL 💚    "
echo "             ╰┈➤💚 Resleeved Net Firewall 💚          "
echo -e "$NC"
cd /root
apt-get remove
apt-get autoremove
apt-get clean
apt-get autoclean
#INSTALL OVPN
apt install openvpn
mkdir -p /etc/openvpn/easy-rsa/keys
mkdir -p /etc/openvpn/login
mkdir -p /etc/openvpn/server
mkdir -p /var/www/html/stat
touch /etc/openvpn/server.conf
touch /etc/openvpn/server2.conf

echo 'DNS=1.1.1.1
DNSStubListener=no' >> /etc/systemd/resolved.conf

echo '#Openvpn Configuration by MTK Developer :)
dev tun
port PORT_UDP
proto udp
server 10.10.0.0 255.255.0.0
ca /etc/openvpn/easy-rsa/keys/ca.crt
cert /etc/openvpn/easy-rsa/keys/server.crt
key /etc/openvpn/easy-rsa/keys/server.key
dh none
ncp-disable
tls-server
tls-version-min 1.2
tls-cipher TLS-ECDHE-RSA-WITH-AES-128-GCM-SHA256
cipher none
auth none
persist-key
persist-tun
ping-timer-rem
compress lz4-v2
keepalive 10 120
reneg-sec 86400
user nobody
group nogroup
client-to-client
duplicate-cn
username-as-common-name
verify-client-cert none
script-security 3
auth-user-pass-verify "/etc/openvpn/login/auth_vpn" via-env #
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "compress lz4-v2"
push "persist-key"
push "persist-tun"
client-connect /etc/openvpn/login/connect.sh
client-disconnect /etc/openvpn/login/disconnect.sh
log /etc/openvpn/server/udpserver.log
status /etc/openvpn/server/udpclient.log
status-version 2
verb 3' > /etc/openvpn/server.conf

sed -i "s|PORT_UDP|$PORT_UDP|g" /etc/openvpn/server.conf

echo '#Openvpn Configuration by MTK Developer :)
dev tun
port PORT_TCP
proto tcp
server 10.20.0.0 255.255.0.0
ca /etc/openvpn/easy-rsa/keys/ca.crt
cert /etc/openvpn/easy-rsa/keys/server.crt
key /etc/openvpn/easy-rsa/keys/server.key
dh none
ncp-disable
tls-server
tls-version-min 1.2
tls-cipher TLS-ECDHE-RSA-WITH-AES-128-GCM-SHA256
cipher none
auth none
persist-key
persist-tun
ping-timer-rem
compress lz4-v2
keepalive 10 120
reneg-sec 86400
user nobody
group nogroup
client-to-client
duplicate-cn
username-as-common-name
verify-client-cert none
script-security 3
auth-user-pass-verify "/etc/openvpn/login/auth_vpn" via-env #
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "compress lz4-v2"
push "persist-key"
push "persist-tun"
client-connect /etc/openvpn/login/connect.sh
client-disconnect /etc/openvpn/login/disconnect.sh
log /etc/openvpn/server/tcpserver.log
status /etc/openvpn/server/tcpclient.log
status-version 2
verb 3' > /etc/openvpn/server2.conf

sed -i "s|PORT_TCP|$PORT_TCP|g" /etc/openvpn/server2.conf

cat <<EOF >/etc/openvpn/login/config.sh
#!/bin/bash
HOST='DBHOST'
USER='DBUSER'
PASS='DBPASS'
DB='DBNAME'
EOF

sed -i "s|DBHOST|$HOST|g" /etc/openvpn/login/config.sh
sed -i "s|DBUSER|$USER|g" /etc/openvpn/login/config.sh
sed -i "s|DBPASS|$PASS|g" /etc/openvpn/login/config.sh
sed -i "s|DBNAME|$DBNAME|g" /etc/openvpn/login/config.sh

/bin/cat <<"EOF" >/etc/openvpn/login/auth_vpn
#!/bin/bash
. /etc/openvpn/login/config.sh
Query="SELECT user_name FROM users WHERE user_name='$username' AND auth_vpn=md5('$password') AND status='live' AND is_freeze=0 AND is_ban=0 AND (duration > 0 OR vip_duration > 0 OR private_duration > 0)"
user_name=`mysql -u $USER -p$PASS -D $DB -h $HOST -sN -e "$Query"`
[ "$user_name" != '' ] && [ "$user_name" = "$username" ] && echo "user : $username" && echo 'authentication ok.' && exit 0 || echo 'authentication failed.'; exit 1
EOF

#client-connect file
cat <<'EOF' >/etc/openvpn/login/connect.sh
#!/bin/bash
. /etc/openvpn/login/config.sh
##set status online to user connected
server_ip=SERVER_IP
datenow=`date +"%Y-%m-%d %T"`
tm="$(date +%s)"
dt="$(date +'%Y-%m-%d %H:%M:%S')"
timestamp="$(date +'%FT%TZ')"
##set status online to user connected
bandwidth_check=`mysql -u $USER -p$PASS -D $DB -h $HOST --skip-column-name -e "SELECT bandwidth_logs.username FROM bandwidth_logs WHERE bandwidth_logs.username='$common_name' AND bandwidth_logs.status='online'"`
if [ "$bandwidth_check" == 1 ]; then
mysql -u $USER -p$PASS -D $DB -h $HOST -e "UPDATE bandwith_logs SET server_ip='$trusted_ip', server_port='$trusted_port', timestamp='$timestamp', ipaddress='$trusted_ip:$trusted_port', username='$common_name', time_in='$tm', since_connected='$time_ascii', bytes_received='$bytes_received', bytes_sent='$bytes_sent' WHERE username='$common_name' AND status='online' AND server_port='$trusted_port' "
mysql -u $USER -p$PASS -D $DB -h $HOST -e "UPDATE users SET is_connected='1', device_connected='1', active_address='$server_ip', active_date='$datenow' WHERE user_name='$common_name' "
else
mysql -u $USER -p$PASS -D $DB -h $HOST -e "INSERT INTO bandwidth_logs (server_ip, server_port, timestamp, ipaddress, since_connected, username, bytes_received, bytes_sent, time_in, status, time) VALUES ('$trusted_ip','$trusted_port','$timestamp','$trusted_ip:$trusted_port','$time_ascii','$common_name','$bytes_received','$bytes_sent','$dt','online','$tm') "
mysql -u $USER -p$PASS -D $DB -h $HOST -e "UPDATE users SET is_connected='1', device_connected='1', active_address='$server_ip', active_date='$datenow' WHERE user_name='$common_name' "
fi
EOF
sed -i "s|SERVER_IP|$server_ip|g" /etc/openvpn/login/connect.sh

#TCP client-disconnect file
cat <<'EOF' >/etc/openvpn/login/disconnect.sh
#!/bin/bash
. /etc/openvpn/login/config.sh
server_ip=SERVER_IP
tm="$(date +%s)"
dt="$(date +'%Y-%m-%d %H:%M:%S')"
timestamp="$(date +'%FT%TZ')"
mysql -u $USER -p$PASS -D $DB -h $HOST -e "UPDATE bandwidth_logs SET bytes_received='$bytes_received',bytes_sent='$bytes_sent',time_out='$dt', status='offline' WHERE username='$common_name' AND status='online'"
mysql -u $USER -p$PASS -D $DB -h $HOST -e "UPDATE users SET is_connected='0', active_address='', active_date='' WHERE user_name='$common_name' "
EOF
sed -i "s|SERVER_IP|$server_ip|g" /etc/openvpn/login/disconnect.sh

cat << EOF > /etc/openvpn/easy-rsa/keys/ca.crt
-----BEGIN CERTIFICATE-----
MIIFBDCCA+ygAwIBAgIUUmdgPaIpFzVfyrlKjuKAdPPOZOswDQYJKoZIhvcNAQEL
BQAwgaoxCzAJBgNVBAYTAlBIMQswCQYDVQQIEwJNQTEWMBQGA1UEBxMNQW50aXBv
bG8gQ2l0eTESMBAGA1UEChMJVEtOZXR3b3JrMRIwEAYDVQQLEwlUS05lcndvcmsx
FTATBgNVBAMTDFRLTmV0d29yayBDQTESMBAGA1UEKRMJVEtOZXR3b3JrMSMwIQYJ
KoZIhvcNAQkBFhRlcmljbGF5bGF5QGdtYWlsLmNvbTAeFw0yMjA5MjAwMzUzMDda
Fw0zMjA5MTcwMzUzMDdaMIGqMQswCQYDVQQGEwJQSDELMAkGA1UECBMCTUExFjAU
BgNVBAcTDUFudGlwb2xvIENpdHkxEjAQBgNVBAoTCVRLTmV0d29yazESMBAGA1UE
CxMJVEtOZXJ3b3JrMRUwEwYDVQQDEwxUS05ldHdvcmsgQ0ExEjAQBgNVBCkTCVRL
TmV0d29yazEjMCEGCSqGSIb3DQEJARYUZXJpY2xheWxheUBnbWFpbC5jb20wggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCdQ4Q5U25/QyOPi9s7X9GrzKYh
huF5twr7rneZrJPWKy7rDDvhpUOqTyv/FI3PX3BbZKbXOnFGxFyNpkqnL/5nyoxa
ma5WeYgcCN4PHmUd46bOX7HFl7ydHo+OutDM9xP8g8VOfFDjiNjlcpI0qTkBOm2k
um5Bx7Z6CxDblT+iXAQ1Pv0F7EYclKcAxSlEwG/phdXTkshx7wsqzilorouLoZ4N
iB+Sv7vWQY1i0HS3IOv9xG0xTW5LKt3ub5ZrkIs+JBXlyR3L953i3OzP3uQ9gQcL
/w/6XSN1opR3NYfFpL4QsSVJDRiASU9oWyuyZ2K/hiFdMG9vpwjMomEINDRxAgMB
AAGjggEeMIIBGjAdBgNVHQ4EFgQU22vZfsw2ER5n6EWwByaIF/aL86swgeoGA1Ud
IwSB4jCB34AU22vZfsw2ER5n6EWwByaIF/aL86uhgbCkga0wgaoxCzAJBgNVBAYT
AlBIMQswCQYDVQQIEwJNQTEWMBQGA1UEBxMNQW50aXBvbG8gQ2l0eTESMBAGA1UE
ChMJVEtOZXR3b3JrMRIwEAYDVQQLEwlUS05lcndvcmsxFTATBgNVBAMTDFRLTmV0
d29yayBDQTESMBAGA1UEKRMJVEtOZXR3b3JrMSMwIQYJKoZIhvcNAQkBFhRlcmlj
bGF5bGF5QGdtYWlsLmNvbYIUUmdgPaIpFzVfyrlKjuKAdPPOZOswDAYDVR0TBAUw
AwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAFxk8YMHYAjggbj6T8HliynV/fMEbhZxx
HIpQyUmOhUOf1LidztC6w/cpO7Cx+esobwfgxGFnx854cnDHZ77/MmZHiGV3Rn91
rmv3xPc0FFiH+Cb4IVXtaPr1hUE45Eey+Odpy3Tj9wOC29lS4P5q9GgcnuNXj4Db
W/jcb2uW3xcdHPj1slhy4Wl/h6Qe5vHqp2jOfMZISKiF3keTAiYnXJWTsSPeOkOD
NvgKUnh6Z3K8NaUlw0SyhzMVwKDKExmMQUcHXAtF2JDrQwerB29jQBd+iFNVV3in
Pz2wHWMTqDV4pSJL4APX/Y9TC7jsi7d0rq9+gmOOFp1OAe11PSTamg==
-----END CERTIFICATE-----
EOF

cat << EOF > /etc/openvpn/easy-rsa/keys/server.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1 (0x1)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=PH, ST=MA, L=Antipolo City, O=TKNetwork, OU=TKNerwork, CN=TKNetwork CA/name=TKNetwork/emailAddress=ericlaylay@gmail.com
        Validity
            Not Before: Sep 20 03:54:08 2022 GMT
            Not After : Sep 17 03:54:08 2032 GMT
        Subject: C=PH, ST=CA, L=Antipolo City, O=TKNetwork, OU=TKNerwork, CN=TKNetwork/name=TKNetwork/emailAddress=ericlaylay@gmail.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:b5:eb:a1:de:45:39:54:a9:12:db:91:b0:68:ac:
                    77:39:7e:4d:ee:5c:ae:6c:2f:57:a7:70:a6:19:39:
                    19:b0:46:75:6d:50:81:9d:3c:43:5a:21:49:84:b1:
                    fa:68:67:2e:05:ba:ec:e1:08:3b:70:07:77:32:03:
                    19:65:7c:af:d5:10:97:8a:3a:af:11:66:ee:42:b2:
                    90:b5:1a:34:28:55:76:0f:a3:ac:f3:e9:1d:fc:d7:
                    5f:7c:89:50:3b:7e:0f:49:61:97:b7:79:b5:c6:29:
                    2a:c5:e3:ef:38:43:77:12:cb:06:d0:e1:2c:4a:38:
                    fe:0a:33:ec:2c:b7:79:bf:b9:fa:d7:ea:2c:9f:02:
                    4f:10:eb:0a:6f:05:5a:50:01:dc:50:93:71:03:b9:
                    63:34:53:9e:30:9d:23:64:66:e8:9c:73:19:85:39:
                    b6:79:b4:55:1d:9d:2a:e0:df:4c:b2:5a:c2:e9:0e:
                    59:a2:3a:70:34:6a:9c:8a:09:34:1d:5e:29:a9:b6:
                    5b:16:ce:9e:c5:6c:50:d6:4d:10:09:60:f6:c9:00:
                    81:29:e3:a1:4c:10:fb:fe:a5:14:d6:b5:2a:e0:72:
                    50:2f:50:dc:bc:34:8d:ca:e2:fb:78:06:4d:b5:cd:
                    fe:9a:cd:2a:b7:c9:79:32:66:4a:bf:d3:d0:04:25:
                    9e:d5
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            Netscape Cert Type: 
                SSL Server
            Netscape Comment: 
                Easy-RSA Generated Server Certificate
            X509v3 Subject Key Identifier: 
                28:1D:A2:5E:3A:50:2C:3A:E0:B0:54:57:D6:11:02:FC:D6:1F:FF:35
            X509v3 Authority Key Identifier: 
                keyid:DB:6B:D9:7E:CC:36:11:1E:67:E8:45:B0:07:26:88:17:F6:8B:F3:AB
                DirName:/C=PH/ST=MA/L=Antipolo City/O=TKNetwork/OU=TKNerwork/CN=TKNetwork CA/name=TKNetwork/emailAddress=ericlaylay@gmail.com
                serial:52:67:60:3D:A2:29:17:35:5F:CA:B9:4A:8E:E2:80:74:F3:CE:64:EB

            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
            X509v3 Key Usage: 
                Digital Signature, Key Encipherment
            X509v3 Subject Alternative Name: 
                DNS:[server]
    Signature Algorithm: sha256WithRSAEncryption
         0c:5a:d1:93:48:73:de:35:f0:1b:b5:88:71:be:ce:04:e0:f7:
         c3:b1:ef:48:05:2f:20:ff:68:6c:e6:10:0f:d2:65:6b:57:e4:
         cc:36:af:4c:ec:d4:0c:46:4c:76:5a:7d:20:74:92:67:41:5f:
         74:27:3b:48:39:51:65:ff:86:3b:1b:6a:15:b1:11:99:45:cd:
         03:0e:e2:46:5d:c0:19:e0:07:0c:18:1e:6e:a1:f6:f2:32:b5:
         3d:91:27:0a:e8:ae:e5:22:a0:f1:87:9f:b8:ba:d8:eb:6b:2b:
         82:8d:e4:2e:66:0a:2a:1f:f6:bb:ee:6a:92:8f:c7:77:0d:ee:
         68:96:58:ce:52:c5:6a:c5:7a:24:fd:ee:83:ba:0b:4e:28:b6:
         92:60:f1:ce:24:bc:9e:a5:ca:73:d3:cc:69:48:a4:8b:31:c3:
         7f:41:d1:31:2d:1e:e8:c7:4f:5d:d6:c1:e8:8d:b7:44:49:0a:
         5a:6c:ea:44:a3:70:19:12:2d:a9:d1:90:bd:3a:3d:4b:85:c0:
         35:d0:03:94:1f:de:68:1c:a0:5d:f0:b9:6c:40:68:97:1a:25:
         c1:5a:a0:cc:a9:51:68:d5:37:be:74:e4:23:0a:fd:74:92:54:
         9e:2f:fc:65:56:d1:27:3b:05:01:b4:c1:b4:a9:10:8d:70:30:
         a0:b6:74:55
-----BEGIN CERTIFICATE-----
MIIFazCCBFOgAwIBAgIBATANBgkqhkiG9w0BAQsFADCBqjELMAkGA1UEBhMCUEgx
CzAJBgNVBAgTAk1BMRYwFAYDVQQHEw1BbnRpcG9sbyBDaXR5MRIwEAYDVQQKEwlU
S05ldHdvcmsxEjAQBgNVBAsTCVRLTmVyd29yazEVMBMGA1UEAxMMVEtOZXR3b3Jr
IENBMRIwEAYDVQQpEwlUS05ldHdvcmsxIzAhBgkqhkiG9w0BCQEWFGVyaWNsYXls
YXlAZ21haWwuY29tMB4XDTIyMDkyMDAzNTQwOFoXDTMyMDkxNzAzNTQwOFowgacx
CzAJBgNVBAYTAlBIMQswCQYDVQQIEwJDQTEWMBQGA1UEBxMNQW50aXBvbG8gQ2l0
eTESMBAGA1UEChMJVEtOZXR3b3JrMRIwEAYDVQQLEwlUS05lcndvcmsxEjAQBgNV
BAMTCVRLTmV0d29yazESMBAGA1UEKRMJVEtOZXR3b3JrMSMwIQYJKoZIhvcNAQkB
FhRlcmljbGF5bGF5QGdtYWlsLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBALXrod5FOVSpEtuRsGisdzl+Te5crmwvV6dwphk5GbBGdW1QgZ08Q1oh
SYSx+mhnLgW67OEIO3AHdzIDGWV8r9UQl4o6rxFm7kKykLUaNChVdg+jrPPpHfzX
X3yJUDt+D0lhl7d5tcYpKsXj7zhDdxLLBtDhLEo4/goz7Cy3eb+5+tfqLJ8CTxDr
Cm8FWlAB3FCTcQO5YzRTnjCdI2Rm6JxzGYU5tnm0VR2dKuDfTLJawukOWaI6cDRq
nIoJNB1eKam2WxbOnsVsUNZNEAlg9skAgSnjoUwQ+/6lFNa1KuByUC9Q3Lw0jcri
+3gGTbXN/prNKrfJeTJmSr/T0AQlntUCAwEAAaOCAZswggGXMAkGA1UdEwQCMAAw
EQYJYIZIAYb4QgEBBAQDAgZAMDQGCWCGSAGG+EIBDQQnFiVFYXN5LVJTQSBHZW5l
cmF0ZWQgU2VydmVyIENlcnRpZmljYXRlMB0GA1UdDgQWBBQoHaJeOlAsOuCwVFfW
EQL81h//NTCB6gYDVR0jBIHiMIHfgBTba9l+zDYRHmfoRbAHJogX9ovzq6GBsKSB
rTCBqjELMAkGA1UEBhMCUEgxCzAJBgNVBAgTAk1BMRYwFAYDVQQHEw1BbnRpcG9s
byBDaXR5MRIwEAYDVQQKEwlUS05ldHdvcmsxEjAQBgNVBAsTCVRLTmVyd29yazEV
MBMGA1UEAxMMVEtOZXR3b3JrIENBMRIwEAYDVQQpEwlUS05ldHdvcmsxIzAhBgkq
hkiG9w0BCQEWFGVyaWNsYXlsYXlAZ21haWwuY29tghRSZ2A9oikXNV/KuUqO4oB0
885k6zATBgNVHSUEDDAKBggrBgEFBQcDATALBgNVHQ8EBAMCBaAwEwYDVR0RBAww
CoIIW3NlcnZlcl0wDQYJKoZIhvcNAQELBQADggEBAAxa0ZNIc9418Bu1iHG+zgTg
98Ox70gFLyD/aGzmEA/SZWtX5Mw2r0zs1AxGTHZafSB0kmdBX3QnO0g5UWX/hjsb
ahWxEZlFzQMO4kZdwBngBwwYHm6h9vIytT2RJwroruUioPGHn7i62OtrK4KN5C5m
Ciof9rvuapKPx3cN7miWWM5SxWrFeiT97oO6C04otpJg8c4kvJ6lynPTzGlIpIsx
w39B0TEtHujHT13WweiNt0RJClps6kSjcBkSLanRkL06PUuFwDXQA5Qf3mgcoF3w
uWxAaJcaJcFaoMypUWjVN7505CMK/XSSVJ4v/GVW0Sc7BQG0wbSpEI1wMKC2dFU=
-----END CERTIFICATE-----
EOF

cat << EOF > /etc/openvpn/easy-rsa/keys/server.key
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC166HeRTlUqRLb
kbBorHc5fk3uXK5sL1encKYZORmwRnVtUIGdPENaIUmEsfpoZy4FuuzhCDtwB3cy
AxllfK/VEJeKOq8RZu5CspC1GjQoVXYPo6zz6R381198iVA7fg9JYZe3ebXGKSrF
4+84Q3cSywbQ4SxKOP4KM+wst3m/ufrX6iyfAk8Q6wpvBVpQAdxQk3EDuWM0U54w
nSNkZuiccxmFObZ5tFUdnSrg30yyWsLpDlmiOnA0apyKCTQdXimptlsWzp7FbFDW
TRAJYPbJAIEp46FMEPv+pRTWtSrgclAvUNy8NI3K4vt4Bk21zf6azSq3yXkyZkq/
09AEJZ7VAgMBAAECggEBALI+EPcKtEVy8vsXH9UvRhGa4xhszqlJKYTxJo0IGVdR
cbSNcLFyXjts6e+Nwl+Q2NLcd0N1IWd+qRbjWnrJVC5ad2AEZ4uRYlkPRCFtbzUl
putj3w2Mlsko7HHEyEvCE5A+grxOD//8TeBemAB0ebJ8Ik1+kjqW5LFydjDKBAwI
sYjXpYGkMST9rqG82EToQn9jL5Ncby35Ls3owzWDfd/1Y4NQmk6gO09spoMzWJpS
mSiV+w83QxxJtOgT00O9NuDz9skotW3v2xWTZue0BzMirCTQWPiFRL1476/O9KYD
KUBAcWynC/PE4ub0lMfaesdrggjRoDYvaQp3xLx/6HECgYEA4siN9t7Ogwhf/4X7
BAN+2OSRWRW8tn9wzzNAPzhjs8igm4W+C4lQtMmW9eFOHuRj6TiWp4w36m4cs5VF
eK39mp3/nyd9l68bFjGxw3XZsI/5bTGgcrSVAAAGp65xadI3+1Ozy7OmFoRF/Gkv
X7+/DyWz5nb9yAH/N69vPpVek8sCgYEAzVt4qpMc5tX6tMxCAC1ZUFo8fwSZndmk
jDTgb2G2O1YIqrYHqVjtwMQiDxvBGdkVJuy8QQQHM6YCD3o1Jq56bjvY1IlumXCW
0YeKfSeqfXN/nBCkyZxa79DkQSPeYEjFTFABVe/SEEcasn8HrlyygtFT+nLCcEz/
V1ekP5Mmg98CgYEApsGOEh9XfuZjoIKmRxdC6L15WyYus4sWKmWnMlWGiqZV4sX/
LoB0BdvN01MunGyYQt/Hd8AVRZ5eIHb8tHZL6quPUTo6kZTCuBkme3Fm9vuHDxHU
x0Od5HggbKBK6OMZIwczR+/7iscMp0O5ABEArmSs2iRZC/7b6dhoVn6DIu0CgYA+
tOvHylxM8JI5mxWcUDyxmJxYfOMbnFXuqkbOPBwVSlQjLKpyP8F512o/Cs6QQgV/
eVKS19QLJWoDp+GLCkRAXO39GGo5WHP1T1oulWouHJKe6UYoeiIakMLiUT2aUR5O
CzAdObn/VncEgl2qFIw9/gWSuHA/MoPV++EfuKNOKQKBgDbyYfG3JESaLpaEiPED
UQDv4iVBzaqA3sMpmpA2YRIUZE4ZzSuiVMxGHfhAvueuiMwyzqsLe0BOgCNtJDg3
o4CmMhs3Wlw5FiOru1LxQY//65wi5q8+rNF4DR3oUKoVGb1PD3Gm8ZsxirhMOCrc
sKKWTJk08giHse+yqTKQ05uR
-----END PRIVATE KEY-----
EOF

cat << EOF > /etc/openvpn/easy-rsa/keys/dh.pem
-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEAuAz9Bv9pwxWbbb8BQZ/TxfRtI6pStmlhgDbuZbAWj5KL2dHabaHd
xmbijMA3XM0VYzwrtVldeu9ejrJ16fWKDdjkBFxhHXNWyJjz5IqATpujsr9ft0zK
9UZlkSFiJJQj5rZXd7Ls6SyPE6u/lfude12D3GF0uEUg0YPwl9n6J6Hmjo4UZ1HJ
DXfuYxY9CVKEXBfNqxshQw4FuNqZajCCA9dWdYZDOkzcWo2QQYxXBWLwJZZ4EKY9
aNu/vLxRe+2b3gUSkE6KIhN5/2fQyZgVY4NGkTtDIbLlpwQO/ZT/kFwJ8RShWdOo
XarEe9JDuh1eOZcl4ZEbXjC6r3GnuOb/+wIBAg==
-----END DH PARAMETERS-----
EOF

dos2unix /etc/openvpn/login/auth_vpn
dos2unix /etc/openvpn/login/connect.sh
dos2unix /etc/openvpn/login/disconnect.sh
chmod 777 -R /etc/openvpn/
chmod 755 /etc/openvpn/server.conf
chmod 755 /etc/openvpn/server2.conf
chmod 755 /etc/openvpn/login/connect.sh
chmod 755 /etc/openvpn/login/disconnect.sh
chmod 755 /etc/openvpn/login/config.sh
chmod 755 /etc/openvpn/login/auth_vpn
systemctl daemon-reload
systemctl enable openvpn
systemctl start openvpn
echo -e "$YELLOW"
echo "           💚 FIREWALL CONFIGURED 💚      "
echo "              ╰┈➤💚 Active 💚             "
echo -e "$NC"
exit 1
