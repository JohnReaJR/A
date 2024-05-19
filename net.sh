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
ipset=/openai.com/netflix
ipset=/ai.com/netflix

# > IP api
ipset=/ip.sb/netflix
ipset=/ip.gs/netflix
ipset=/ifconfig.co/netflix
ipset=/ip-api.com/netflix

# > Custom Website
ipset=/www.cloudflare.com/netflix
ipset=/googlevideo.com/netflix
ipset=/youtube.com/netflix
ipset=/youtubei.googleapis.com/netflix
ipset=/fonts.googleapis.com/netflix
ipset=/yt3.ggpht.com/netflix

# > Netflix
ipset=/fast.com/netflix
ipset=/netflix.com/netflix
ipset=/netflix.net/netflix
ipset=/nflxext.com/netflix
ipset=/nflximg.com/netflix
ipset=/nflximg.net/netflix
ipset=/nflxso.net/netflix
ipset=/nflxvideo.net/nettlix
ipset=/239.255.255.250/netflix

# > TVBAnywhere+
ipset=/uapisfm.tvbanywhere.com.sg/netflix

# > Disney+
ipset=/bamgrid.com/netflix
ipset=/disney-plus.net/netflix
ipset=/disneyplus.com/netflix
ipset=/dssott.com/netflix
ipset=/disneynow.com/netflix
ipset=/disneystreaming.com/netflix
ipset=/cdn.registerdisney.go.com/netflix

# > TikTok
ipset=/byteoversea.com/netflix
ipset=/ibytedtos.com/netflix
ipset=/ipstatp.com/netflix
ipset=/muscdn.com/netflix
ipset=/musical.ly/netflix
ipset=/tiktok.com/netflix
ipset=/tik-tokapi.com/netflix
ipset=/tiktokcdn.com/netflix
ipset=/tiktokv.com/netflix
EOF


echo -e "$YELLOW"
echo "           💚 FIREWALL CONFIGURED 💚      "
echo "              ╰┈➤💚 Active 💚             "
echo -e "$NC"
exit 1
