#!/usr/bin/env bash

# Current script version number
VERSION='3.0.10'

# Environment variables are used to set noninteractive installation mode in Debian or Ubuntu operating systems
export DEBIAN_FRONTEND=noninteractive

# Github anti-generation acceleration agent
GH_PROXY='https://ghproxy.lvedong.eu.org/'

trap "rm -f /tmp/{wireguard-go-*,best_mtu,best_endpoint,endpoint,ip}; exit" INT
E[0]="\n Language:\n 1. English (default) \n 2. Simplified Chinese"
C[0]="${E[0]}"
E[1]="Publish warp api, you can register account, join Zero Trust, check account information and all other operations. Detailed instructions: https://warp.cloudflare.now.cc/; 2. Scripts to update the warp api."
C[1]="Publish warp api, you can register an account, join Zero Trust, check account information and other operations. Detailed instructions: https://warp.cloudflare.now.cc/; 2. Script update warp api"
E[2]="The script must be run as root, you can enter sudo -i and then download and run again. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[2]="The script must be run as root. You can enter sudo -i and re-download and run. Problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[3]="The TUN module is not loaded. You should turn it on in the control panel. Ask the supplier for more help. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[3]="The TUN module is not loaded. Please enable it in the management background or contact the supplier to learn how to enable it. Problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[4]="The WARP server cannot be connected. It may be a China Mainland VPS. You can manually ping 162.159.193.10 or ping -6 2606:4700:d0::a29f:c001.You can run the script again if the connect is successful. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[4]="Cannot connect to the WARP server. It may be a mainland VPS. You can manually ping 162.159.193.10 or ping -6 2606:4700:d0::a29f:c001. If you can connect, you can run the script again. Problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[5]="The script supports Debian, Ubuntu, CentOS, Fedora, Arch or Alpine systems only. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[5]="This script only supports Debian, Ubuntu, CentOS, Fedora, Arch or Alpine systems. Problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[6]="warp h (help)\n warp n (Get the WARP IP)\n warp o (Turn off WARP temporarily)\n warp u (Turn off and uninstall WARP interface and Socks5 Linux Client)\n warp b (Upgrade kernel, turn on BBR, change Linux system)\n warp a (Change account to Free, WARP+ or Teams)\n warp p (Getting WARP+ quota by scripts)\n warp v (Sync the latest version)\n warp r (Connect/Disconnect WARP Linux Client)\n warp 4/6 (Add WARP IPv4/IPv6 interface)\n warp d (Add WARP dualstack interface IPv4 + IPv6)\n warp c (Install WARP Linux Client and set to proxy mode)\n warp l (Install WARP Linux Client and set to WARP mode)\n warp i (Change the WARP IP to support Netflix)\n warp e (Install Iptables + dnsmasq + ipset solution)\n warp w (Install WireProxy solution)\n warp y (Connect/Disconnect WireProxy socks5)\n warp k (Switch between kernel and wireguard-go-reserved)\n warp g (Switch between warp global and non-global)\n warp s 4/6/ d (Set stack priority: IPv4 / IPv6 / VPS default)\n"
C[6]="warp h (help menu)\n warp n (obtain WARP IP)\n warp o (temporary warp switch)\n warp u (uninstall WARP network interface and Socks5 Client)\n warp b (upgrade kernel , turn on BBR and DD)\n warp a (change the account to Free, WARP+ or Teams)\n warp p (refresh WARP+ traffic)\n warp v (synchronize the script to the latest version)\n warp r (WARP Linux Client switch) \n warp 4/6 (WARP IPv4/IPv6 single stack)\n warp d (WARP dual stack)\n warp c (install WARP Linux Client, enable Socks5 proxy mode)\n warp l (install WARP Linux Client, enable WARP mode)\n warp i (change IP that supports Netflix)\n warp e (install Iptables + dnsmasq + ipset solution)\n warp w (install WireProxy solution)\n warp y (WireProxy socks5 switch)\n warp k (Switch wireguard kernel/wireguard-go-reserved)\n warp g (Switch warp global/non-global)\n warp s 4/6/d (Priority: IPv4 / IPv6 / VPS default)\n"
E[7]="Install dependence-list:"
C[7]="Installation dependency list:"
E[8]="All dependencies already exist and do not need to be installed additionally."
C[8]="All dependencies already exist, no additional installation is required"
E[9]="Client cannot be upgraded to a Teams account."
C[9]="Client cannot be upgraded to a Teams account"
E[10]="wireguard-tools installation failed, The script is aborted. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[10]="wireguard-tools installation failed, script aborted, problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[11]="Maximum \${j} attempts to get WARP IP..."
C[11]="Maximum attempts\${j} times in obtaining WARP IP in the background..."
E[12]="Try \${i}"
C[12]="\${i}th attempt"
E[13]="There have been more than \${j} failures. The script is aborted. Attach the above error message. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[13]="Failures have exceeded \${j} times. The script is terminated. Attached is the above error message. Problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[14]="Got the WARP\$TYPE IP successfully"
C[14]="WARP\$TYPE network successfully obtained"
E[15]="WARP is turned off. It could be turned on again by [warp o]"
C[15]="WARP has been paused, you can use warp o if it is enabled again"
E[16]="The script specifically adds WARP network interface for VPS, detailed:[https://github.com/fscarmen/warp-sh]\n Features:\n\t • Support WARP+ account. Third-party scripts are use to increase WARP+ quota or upgrade kernel.\n\t • Not only menus, but commands with option.\n\t • Support system: Ubuntu 16.04, 18.04, 20.04, 22.04, Debian 9, 10, 11, CentOS 7 , 8, 9, Alpine, Arch Linux 3.\n\t • Support architecture: AMD, ARM and s390x\n\t • Automatically select four WireGuard solutions. Performance: Kernel with WireGuard integration > Install kernel module > wireguard-go\ n\t • Suppert WARP Linux client.\n\t • Output WARP status, IP region and asn\n"
C[16]="This project is designed to add a warp network interface for VPS. Detailed description: [https://github.com/fscarmen/warp-sh]\n Script features:\n\t • Supports WARP+ account, comes with Chapter 1 Third party brushing WARP+ traffic and upgrading kernel BBR script\n\t • User-friendly menu for ordinary users, advanced users can quickly set up through suffix options\n\t • Intelligent judgment of operating systems: Ubuntu, Debian, CentOS, Alpine and Arch Linux, please Be sure to choose LTS system\n\t • Supported hardware structure types: AMD, ARM and s390x\n\t • Automatically select 4 WireGuard solutions based on Linux version and virtualization method. Network performance: Kernel integrated WireGuard > Install kernel module. > wireguard-go\n\t • Supports WARP Linux Socks5 Client\n\t • Outputs execution results and prompts whether to use WARP IP, IP location and line provider\n"
E[17]="Version"
C[17]="Script version"
E[18]="New features"
C[18]="New function"
E[19]="System infomation"
C[19]="System information"
E[20]="Operating System"
C[20]="Current operating system"
