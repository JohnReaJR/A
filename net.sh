#!/bin/bash
YELLOW='\033[1;33m'
NC='\033[0m'
if [ "$(whoami)" != "root" ]; then
    echo "Error: This script must be run as root."
    exit 1
fi
cd /root
clear
echo -e "$YELLOW"
echo "          💚 WARP....SETTING UP YOUR FIREWALL 💚    "
echo "             ╰┈➤💚 Resleeved Net Firewall 💚          "
echo -e "$NC"
cd /root
rm -rf /etc/dnsmasq.conf
  cat >/etc/dnsmasq.conf << EOF
#!/usr/bin/env bash
server=8.8.8.8
server=1.1.1.1
# ----- WARP ----- #
# > Youtube Premium
server=/googlevideo.com/8.8.8.8
server=/youtube.com/8.8.8.8
server=/youtubei.googleapis.com/8.8.8.8
server=/fonts.googleapis.com/8.8.8.8
server=/yt3.ggpht.com/8.8.8.8
server=/gstatic.com/8.8.8.8

# > Custom ChatGPT
ipset=/openai.com/warp
ipset=/ai.com/warp

# > IP api
ipset=/ip.sb/warp
ipset=/ip.gs/warp
ipset=/ifconfig.co/warp
ipset=/ip-api.com/warp

# > Custom Website
ipset=/www.cloudflare.com/warp
ipset=/googlevideo.com/warp
ipset=/youtube.com/warp
ipset=/youtubei.googleapis.com/warp
ipset=/fonts.googleapis.com/warp
ipset=/yt3.ggpht.com/warp

# > Netflix
ipset=/fast.com/warp
ipset=/netflix.com/warp
ipset=/netflix.net/warp
ipset=/nflxext.com/warp
ipset=/nflximg.com/warp
ipset=/nflximg.net/warp
ipset=/nflxso.net/warp
ipset=/nflxvideo.net/warp
ipset=/239.255.255.250/warp

# > TVBAnywhere+
ipset=/uapisfm.tvbanywhere.com.sg/warp

# > Disney+
ipset=/bamgrid.com/warp
ipset=/disney-plus.net/warp
ipset=/disneyplus.com/warp
ipset=/dssott.com/warp
ipset=/disneynow.com/warp
ipset=/disneystreaming.com/warp
ipset=/cdn.registerdisney.go.com/warp

# > TikTok
ipset=/byteoversea.com/warp
ipset=/ibytedtos.com/warp
ipset=/ipstatp.com/warp
ipset=/muscdn.com/warp
ipset=/musical.ly/warp
ipset=/tiktok.com/warp
ipset=/tik-tokapi.com/warp
ipset=/tiktokcdn.com/warp
ipset=/tiktokv.com/warp
EOF


echo -e "$YELLOW"
echo "           💚 FIREWALL CONFIGURED 💚      "
echo "              ╰┈➤💚 Active 💚             "
echo -e "$NC"
exit 1
