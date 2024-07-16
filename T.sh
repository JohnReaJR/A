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
E[21]="Kernel"
C[21]="kernel"
E[22]="Architecture"
C[22]="Processor architecture"
E[23]="Virtualization"
C[23]="Virtualization"
E[24]="Client is on"
C[24]="Client is open"
E[25]="Device name"
C[25]="Device name"
E[26]="Curren operating system is \$SYS.\\\n The system lower than \$SYSTEM \${MAJOR[int]} is not supported. Feedback: [https://github.com/fscarmen/ warp-sh/issues]"
C[26]="The current operation is \$SYS\\\n and does not support \$SYSTEM \${MAJOR[int]} The following systems, problem feedback: [https://github.com/fscarmen/warp-sh/ issues]"
E[27]="Local Socks5"
C[27]="Local Socks5"
E[28]="If there is a WARP+ License, please enter it, otherwise press Enter to continue:"
C[28]="If you have a WARP+ License, please enter it. If not, press Enter to continue:"
E[29]="Input errors up to 5 times.The script is aborted."
C[29]="If the input error reaches 5 times, the script will exit"
E[30]="License should be 26 characters, please re-enter WARP+ License. Otherwise press Enter to continue. \(\${i} times remaining\):"
C[30]="License should be 26 characters, please re-enter WARP+ License, press Enter to continue\(remaining\${i} times\):"
E[31]="The new \$KEY_LICENSE is the same as the one currently in use. Does not need to be replaced."
C[31]="The newly entered \$KEY_LICENSE is the same as the one currently in use and does not need to be replaced."
E[32]="Step 1/3: Install dependencies..."
C[32]="Progress 1/3: Installing system dependencies..."
E[33]="Step 2/3: WARP is ready"
C[33]="Progress 2/3: WARP installed"
E[34]="Failed to change port. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[34]="Changing the port failed, problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[35]="Update WARP+ account..."
C[35]="Upgrading WARP+ account..."
E[36]="The upgrade failed, License: \$LICENSE has been activated on more than 5 devices. It script will remain the same account or be switched to a free account."
C[36]="Upgrade failed, License: \$LICENSE has activated more than 5 devices, the original account will be maintained or converted to a free account"
E[37]="Checking VPS infomation..."
C[37]="Checking environment..."
E[38]="Create shortcut [warp] successfully"
C[38]="Create shortcut warp command successfully"
E[39]="Running WARP"
C[39]="Run WARP"
E[40]="Menu choose"
C[40]="Menu options"
E[41]="Congratulations! WARP\$TYPE is turned on. Spend time:\$(( end - start )) seconds.\\\n The script runs today: \$TODAY. Total:\$TOTAL"
C[41]="Congratulations! WARP\$TYPE has been turned on, the total time taken:\$(( end - start )) seconds, the number of times the script has been run today:\$TODAY, the cumulative number of runs:\$TOTAL"
E[42]="The upgrade failed, License: \$LICENSE could not update to WARP+. The script will remain the same account or be switched to a free account."
C[42]="Upgrade failed, License: \$LICENSE cannot be upgraded to WARP+, the original account will be maintained or converted to a free account."
E[43]="Run again with warp [option] [lisence], such as"
C[43]="Use warp [option] [lisence] to run again, such as"
E[44]="WARP installation failed. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[44]="WARP installation failed, problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[45]="WARP interface, Linux Client and Wireproxy have been completely deleted!"
C[45]="WARP network interface, Linux Client and Wireproxy have been completely removed!"
E[46]="Not cleaned up, please reboot and try again."
C[46]="Not cleared, please reboot and try to delete again"
E[47]="Upgrade kernel, turn on BBR, change Linux system by other authors [ylx2016],[https://github.com/ylx2016/Linux-NetSpeed]"
C[47]="Mature works of [ylx2016] used for BBR and DD scripts, address [https://github.com/ylx2016/Linux-NetSpeed], please be familiar with it"
E[48]="Run script"
C[48]="Installation script"
E[49]="Return to main menu"
C[49]="Return to home directory"
E[50]="Choose:"
C[50]="Please select:"
E[51]="Please enter the correct number"
C[51]="Please enter the correct number"
E[52]="Please input WARP+ ID:"
C[52]="Please enter WARP+ ID:"
E[53]="WARP+ ID should be 36 characters, please re-enter \(\${i} times remaining\):"
C[53]="WARP+ ID should be 36 characters, please re-enter \(\${i} times remaining\):"
E[54]="Getting the WARP+ quota by the following 3 authors:\n • [ALIILAPRO], [https://github.com/ALIILAPRO/warp-plus-cloudflare]\n • [mixool], [https: //github.com/mixool/across/tree/master/wireguard]\n • [SoftCreatR], [https://github.com/SoftCreatR/warp-up]\n • Open the 1.1.1.1 app\n • Click on the hamburger menu button on the top-right corner\n • Navigate to: Account > Key\n Important:Refresh WARP+ quota: Three --> Advanced --> Connection options --> Reset keys\n It is best to run script with screen."
C[54]="To brush WARP+ traffic, you can choose the mature works of the following three authors, please be familiar with them:\n • [ALIILAPRO], address [https://github.com/ALIILAPRO/warp-plus-cloudflare]\n • [mixool], at [https://github.com/mixool/across/tree/master/wireguard]\n • [SoftCreatR], at [https://github.com/SoftCreatR/warp-up]\n Download address: https://1.1.1.1/, visit and take care of Apple's external ID\n Obtain the WARP+ ID and fill it in below. Method: Menu 3 in the upper right corner of the App-->Advanced-->Diagnosis-->ID\n Important. : There is no increase in traffic after brushing the script. Processing: Menu 3 in the upper right corner --> Advanced --> Connection options --> Reset encryption key\n It is best to cooperate with screen to run tasks in the background."
E[55]="1. Run [ALIILAPRO] script\n 2. Run [mixool] script\n 3. Run [SoftCreatR] script"
C[55]="1. Run the [ALIILAPRO] script\n 2. Run the [mixool] script\n 3. Run the [SoftCreatR] script"
E[56]="The current Netflix region is \$REGION. Confirm press [y] . If you want another region, please enter the two-digit region abbreviation. \(such as hk,sg. Default is \$REGION\ ):"
C[56]="The current Netflix region is:\$REGION. If you need to unlock the current region, please press [y]. If you need other addresses, please enter the two-digit region abbreviation\(such as hk, sg, default:\$REGION\): "
E[57]="The target quota you want to get. The unit is GB, the default value is 10:"
C[57]="The target traffic value you want to obtain, in GB, just enter a number, the default value is 10:"
E[58]="Local network interface: CloudflareWARP"
C[58]="Local network interface: CloudflareWARP"
E[59]="Cannot find the account file: /etc/wireguard/warp-account.conf, you can reinstall with the WARP+ License"
C[59]="Account file not found:/etc/wireguard/warp-account.conf, you can uninstall and reinstall, enter WARP+ License"
E[60]="Cannot find the configuration file: /etc/wireguard/warp.conf, you can reinstall with the WARP+ License"
C[60]="Configuration file not found: /etc/wireguard/warp.conf, you can uninstall and reinstall, enter WARP+ License"
E[61]="Please Input WARP+ license:"
C[61]="Please enter WARP+ License:"
E[62]="Successfully change to a WARP\$TYPE account"
C[62]="Changed to WARP\$TYPE account"
E[63]="WARP+ quota"
C[63]="Remaining traffic"
E[64]="Successfully synchronized the latest version"
C[64]="Success! The latest script has been synchronized, version number"
E[65]="Upgrade failed. Feedback:[https://github.com/fscarmen/warp-sh/issues]"
C[65]="Upgrade failed, problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[66]="Add WARP IPv4 interface to \${NATIVE[n]} VPS \(bash menu.sh 4\)"
C[66]="Add WARP IPv4 network interface for \${NATIVE[n]} \(bash menu.sh 4\)"
E[67]="Add WARP IPv6 interface to \${NATIVE[n]} VPS \(bash menu.sh 6\)"
C[67]="Add WARP IPv6 network interface for \${NATIVE[n]} \(bash menu.sh 6\)"
E[68]="Add WARP dualstack interface to \${NATIVE[n]} VPS \(bash menu.sh d\)"
C[68]="Add WARP dual-stack network interface for \${NATIVE[n]} \(bash menu.sh d\)"
E[69]="Native dualstack"
C[69]="Native dual stack"
E[70]="WARP dualstack"
C[70]="WARP dual stack"
E[71]="Turn on WARP (warp o)"
C[71]="Open WARP (warp o)"
E[72]="Turn off, uninstall WARP interface, Linux Client and WireProxy (warp u)"
C[72]="Permanently shut down the WARP network interface and remove WARP, Linux Client and WireProxy (warp u)"
E[73]="Upgrade kernel, turn on BBR, change Linux system (warp b)"
C[73]="Upgrade kernel, install BBR, DD script (warp b)"
E[74]="Getting WARP+ quota by scripts (warp p)"
C[74]="Warp WARP+ traffic (warp p)"
E[75]="Sync the latest version (warp v)"
C[75]="Synchronize the latest version (warp v)"
E[76]="Exit"
C[76]="Exit script"
E[77]="Turn off WARP (warp o)"
C[77]="Temporarily close WARP (warp o)"
E[78]="Change the WARP account type (warp a)"
C[78]="Change WARP account (warp a)"
E[79]="Do you uninstall the following dependencies \(if any\)? Please note that this will potentially prevent other programs that are using the dependency from working properly.\\\n\\\n \$UNINSTALL_DEPENDENCIES_LIST"
C[79]="Do you want to uninstall the following dependencies\(if any\)? Please note that this may prevent other programs that are using the dependencies from working properly\\\n\\\n \$UNINSTALL_DEPENDENCIES_LIST"
E[80]="Professional one-click script for WARP to unblock streaming media (Supports multi-platform, multi-mode and TG push)"
C[80]="WARP Unlock Netflix and other streaming media professionals with one click (supports multiple platforms, multiple methods and TG notifications)"
E[81]="Step 3/3: Searching for the best MTU value and endpoint address are ready."
C[81]="Progress 3/3: Finding the optimal MTU value and preferred endpoint address completed"
E[82]="Install CloudFlare Client and set mode to Proxy (bash menu.sh c)"
C[82]="Install CloudFlare Client and set to Proxy mode (bash menu.sh c)"
E[83]="Step 1/3: Installing WARP Client..."
C[83]="Progress 1/3: Installing Client..."
E[84]="Step 2/3: Setting Client Mode"
C[84]="Progress 2/3: Set Client mode"
E[85]="Client was installed.\n connect/disconnect by [warp r].\n uninstall by [warp u]"
C[85]="Linux Client is installed\n Connect/disconnect: warp r\n Uninstall: warp u"
E[86]="Client is working. Socks5 proxy listening on: \$(ss -nltp | grep -E 'warp|wireproxy' | awk '{print \$4}')"
C[86]="Linux Client is running normally. Socks5 proxy monitoring:\$(ss -nltp | grep -E 'warp|wireproxy' | awk '{print \$4}')"
E[87]="Fail to establish Socks5 proxy. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[87]="Creation of Socks5 proxy failed, problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[88]="Connect the client (warp r)"
C[88]="Connect Client (warp r)"
E[89]="Disconnect the client (warp r)"
C[89]="Disconnect Client (warp r)"
E[90]="Client is connected"
C[90]="Client is connected"
E[91]="Client is disconnected. It could be connect again by [warp r]"
C[91]="Client has been disconnected, you can use warp r to connect again"
E[92]="(!!! Already installed, do not select.)"
C[92]="(!!! Already installed, please do not select)"
E[93]="Client is not installed."
C[93]="Client is not installed"
E[94]="Congratulations! WARP\$CLIENT_AC Linux Client is working. Spend time:\$(( end - start )) seconds.\\\n The script runs on today: \$TODAY. Total:\$TOTAL "
C[94]="Congratulations! WARP\$CLIENT_AC Linux Client is working, the total time taken is:\$(( end - start )) seconds, the number of script runs on the day:\$TODAY, the cumulative number of runs:\$TOTAL"
E[95]="The account type is Teams and does not support changing IP\n 1. Change to free (default)\n 2. Change to plus\n 3. Quit"
C[95]="The account type is Teams, changing IP is not supported\n 1. Change to free (default)\n 2. Change to plus\n 3. Exit"
E[96]="Client connecting failure. It may be a CloudFlare IPv4."
C[96]="Client connection failed, possibly CloudFlare IPv4."
E[97]="IPv\$PRIO priority"
C[97]="IPv\$PRIO priority"
E[98]="Uninstall Wireproxy was complete."
C[98]="Wireproxy uninstalled successfully"
E[99]="WireProxy is connected"
C[99]="WireProxy connected"
E[100]="License should be 26 characters, please re-enter WARP+ License. Otherwise press Enter to continue. \(\${i} times remaining\): "
C[100]="License should be 26 characters, please re-enter WARP+ License \(\${i} times remaining\): "
E[101]="Client support amd64 and arm64 only. Curren architecture \$ARCHITECTURE. Official Support List: [https://pkg.cloudflareclient.com/packages/cloudflare-warp]. The script is aborted. Feedback: [https ://github.com/fscarmen/warp-sh/issues]"
C[101]="Client only supports amd64 and arm64 architecture, current architecture\$ARCHITECTURE, official support list: [https://pkg.cloudflareclient.com/packages/cloudflare-warp]. Script aborted, problem feedback: [https ://github.com/fscarmen/warp-sh/issues]"
E[102]="Please customize the WARP+ device name \(Default is \$(hostname)\):"
C[102]="Please customize the WARP+ device name \(default is \$(hostname)\):"
E[103]="Port \$PORT is in use. Please input another Port\(\${i} times remaining\):"
C[103]="\$PORT port is occupied, please use another port\(remaining\${i} times\):"
E[104]="Please customize the Client port (1000-65535. Default to 40000 if it is blank):"
C[104]="Please customize the Client port number (1000-65535, if not entered, it will default to 40000):"
E[105]="Please choose the priority:\n 1. IPv4\n 2. IPv6\n 3. Use initial settings (default)"
C[105]="Please select the priority level:\n 1. IPv4\n 2. IPv6\n 3. Use VPS initial settings (default)"
E[106]="Shared free accounts cannot be upgraded to WARP+ accounts."
C[106]="Shared free accounts cannot be upgraded to WARP+ accounts"
E[107]="Failed registration, using a preset free account."
C[107]="Registration failed, use the default free account"
E[108]="\n 1. WARP Linux Client IP\n 2. WARP WARP IP (Only IPv6 can be brushed when WARP and Client exist at the same time)\n"
C[108]="\n 1. WARP Linux Client IP\n 2. WARP WARP IP (only IPv6 can be flashed when WARP and Client coexist)\n"
E[109]="Socks5 Proxy Client is working now. WARP IPv4 and dualstack interface could not be switch to. The script is aborted. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[109]="Socks5 proxy is running and cannot be converted to WARP IPv4 or dual-stack network interface. The script is aborted. Problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[110]="Socks5 Proxy Client is working now. WARP IPv4 and dualstack interface could not be installed. The script is aborted. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[110]="Socks5 agent is running, WARP IPv4 or dual-stack network interface cannot be installed, the script is aborted, problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[111]="Port must be 1000-65535. Please re-input\(\${i} times remaining\):"
C[111]="The port must be 1000-65535, please re-enter\(remaining\${i} times\):"
E[112]="Client is not installed."
C[112]="Client is not installed"
E[113]="Client is installed. Disconnected."
C[113]="Client is installed and disconnected"
E[114]="WARP\$TYPE Interface is on"
C[114]="WARP\$TYPE network interface is enabled"
E[115]="WARP Interface is on"
C[115]="WARP network interface is enabled"
E[116]="WARP Interface is off"
C[116]="WARP network interface is not enabled"
E[117]="Uninstall WARP Interface was complete."
C[117]="WARP network interface uninstalled successfully"
E[118]="Uninstall WARP Interface was fail."
C[118]="WARP network interface uninstall failed"
E[119]="Uninstall Socks5 Proxy Client was complete."
C[119]="Socks5 Proxy Client uninstalled successfully"
E[120]="Uninstall Socks5 Proxy Client was fail."
C[120]="Socks5 Proxy Client uninstallation failed"
E[121]="Changing Netflix IP is adapted from other authors [luoxue-bot],[https://github.com/luoxue-bot/warp_auto_change_ip]"
C[121]="Change supports Netflix IP adapted from [luoxue-bot]'s mature works, address [https://github.com/luoxue-bot/warp_auto_change_ip], please familiarize yourself"
E[122]="Port change to \$PORT succeeded."
C[122]="Port successfully changed to \$PORT"
E[123]="Change the WARP IP to support Netflix (warp i)"
C[123]="Change the IP that supports Netflix (warp i)"
E[124]="1. Brush WARP IPv4 (default)\n 2. Brush WARP IPv6"
C[124]="1. Flash WARP IPv4 (default)\n 2. Flash WARP IPv6"
E[125]="\$(date +'%F %T') Region: \$REGION Done. IPv\$NF: \$WAN \$COUNTRY \$ASNORG. Retest after 1 hour. Brush ip running time: \$DAY days \$HOUR hours \$MIN minutes \$SEC seconds"
C[125]="\$(date +'%F %T') Region\$REGION is unlocked successfully, IPv\$NF: \$WAN \$COUNTRY \$ASNORG, retest after 1 hour, IP brushing running time : \$DAY days\$HOUR hours\$MIN minutes\$SEC seconds"
E[126]="\$(date +'%F %T') Try \${i}. Failed. IPv\$NF: \$WAN \$COUNTRY \$ASNORG. Retry after \${j} seconds .Brush ip running time:\$DAY days \$HOUR hours \$MIN minutes \$SEC seconds"
C[126]="\$(date +'%F %T') Tried the \${i}th time, failed to unlock, IPv\$NF: \$WAN \$COUNTRY \$ASNORG,\${j} Retest after seconds, run time for brushing IP: \$DAY days\$HOUR hours\$MIN minutes\$SEC seconds"
E[127]="1. with URL file\n 2. with token (Easily available at https://web--public--warp-team-api--coia-mfs4.code.run)\n 3. manual input private key, IPv6 and Client id\n 4. share teams account (default)"
C[127]="1. Through online files\n 2. Using token (can be easily obtained through https://web--public--warp-team-api--coia-mfs4.code.run)\n 3 . Manually enter private key, IPv6 and Client id\n 4. Shared teams account (default)"
E[128]="Token has expired, please re-enter:"
C[128]="Token has timed out, please re-enter:"
E[129]="The current Teams account is unavailable, automatically switch back to the free account"
C[129]="The current Teams account is unavailable and will automatically switch back to a free account"
E[130]="Please confirm\\\n Private key\\\t: \$PRIVATEKEY \${MATCH[0]}\\\n Address IPv6\\\t: \$ADDRESS6/128 \${MATCH [1]}\\\n Client id\\\t: \$CLIENT_ID \${MATCH[2]}"
C[130]="Please confirm Teams information\\\n Private key\\\t: \$PRIVATEKEY \${MATCH[0]}\\\n Address IPv6\\\t: \$ADDRESS6/128 \$ {MATCH[1]}\\\n Client id\\\t: \$CLIENT_ID \${MATCH[2]}"
E[131]="comfirm please enter [y] , and other keys to use free account:"
C[131]="Please press [y] to confirm, and use the free account for other keys:"
E[132]="Is there a WARP+ or Teams account?\n 1. Use free account (default)\n 2. WARP+\n 3. Teams"
C[132]="Select if you have a WARP+ or Teams account\n 1. Use a free account (default)\n 2. WARP+\n 3. Teams"
E[133]="Device name: \$(grep -s 'Device name' /etc/wireguard/info.log | awk '{ print \$NF }')\\\n Quota: \$QUOTA"
C[133]="Device name: \$(grep -s 'Device name' /etc/wireguard/info.log | awk '{ print \$NF }')\\\n Remaining traffic: \$QUOTA"
E[134]="Curren architecture \$(uname -m) is not supported. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[134]="The current architecture \$(uname -m) is not supported yet, problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[135]="( match √ )"
C[135]="(match √)"
E[136]="( mismatch X )"
C[136]="(does not match X)"
E[137]="Cannot find the configuration file: /etc/wireguard/warp.conf. You should install WARP first"
C[137]="The configuration file /etc/wireguard/warp.conf cannot be found, please install WARP first"
E[138]="Install iptable + dnsmasq + ipset. Let WARP only take over the streaming media traffic (Not available for ipv6 only) (bash menu.sh e)"
C[138]="Install iptable + dnsmasq + ipset and let WARP IPv4 only take over streaming traffic (not applicable to IPv6 only VPS) (bash menu.sh e)"
E[139]="Through Iptable + dnsmasq + ipset, minimize the realization of media unblocking such as chatGPT, Netflix, WARP IPv4 only takes over the streaming media traffic, adapted from the mature works of [Anemone],[https:// github.com/acacia233/Project-WARP-Unlock]"
C[139]="Use Iptable + dnsmasq + ipset to minimize the unlocking of media such as chatGPT and Netflix. WARP IPv4 only takes over streaming media traffic. It is adapted from the mature work of [Anemone]. The address is [https://github.com/ acacia233/Project-WARP-Unlock], please be familiar with it"
E[140]="Socks5 Proxy Client on IPv4 VPS is working now. WARP IPv6 interface could not be installed. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[140]="IPv4 only VPS, and the Socks5 proxy is running, the WARP IPv6 network interface cannot be installed, problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[141]="Switch \${WARP_BEFORE[m]} to \${WARP_AFTER1[m]} \${SHORTCUT1[m]}"
C[141]="\${WARP_BEFORE[m]} to \${WARP_AFTER1[m]} \${SHORTCUT1[m]}"
E[142]="Switch \${WARP_BEFORE[m]} to \${WARP_AFTER2[m]} \${SHORTCUT2[m]}"
C[142]="\${WARP_BEFORE[m]} to \${WARP_AFTER2[m]} \${SHORTCUT2[m]}"
E[143]="Change Client or WireProxy port"
C[143]="Change Client or WireProxy port"
E[144]="Install WARP IPv6 interface"
C[144]="Install WARP IPv6 network interface"
E[145]="Client is only supported on CentOS 8 and above. Official Support List: [https://pkg.cloudflareclient.com]. The script is aborted. Feedback: [https://github.com/fscarmen/ warp-sh/issues]"
C[145]="Client only supports CentOS 8 or above systems, official support list: [https://pkg.cloudflareclient.com]. Script aborted, problem feedback: [https://github.com/fscarmen/warp- sh/issues]"
E[146]="Cannot switch to the same form as the current one."
C[146]="Cannot switch to the same current form"
E[147]="Not available for IPv6 only VPS"
C[147]="IPv6 only VPS cannot use this solution"
E[148]="Install wireproxy. Wireguard client that exposes itself as a socks5 proxy or tunnels (bash menu.sh w)"
C[148]="Install wireproxy and let WARP create a socks5 proxy locally (bash menu.sh w)"
E[149]="Congratulations! Wireproxy is working. Spend time:\$(( end - start )) seconds.\\\n The script runs on today: \$TODAY. Total:\$TOTAL"
C[149]="Congratulations! Wireproxy is working, the total time taken is:\$(( end - start )) seconds, the number of times the script has been run today:\$TODAY, and the cumulative number of runs:\$TOTAL"
E[150]="WARP, WARP Linux Client, WireProxy hasn't been installed yet. The script is aborted.\n"
C[150]="WARP, WARP Linux Client, WireProxy are not installed, the script exits\n"
E[151]="1. WARP Linux Client account\n 2. WireProxy account"
C[151]="1. WARP Linux Client account\n 2. WireProxy account"
E[152]="1. WARP account\n 2. WireProxy account"
C[152]="1. WARP account\n 2. WireProxy account"
E[153]="1. WARP account\n 2. WARP Linux Client account"
C[153]="1. WARP account\n 2. WARP Linux Client account"
E[154]="1. WARP account\n 2. WARP Linux Client account\n 3. WireProxy account"
C[154]="1. WARP account\n 2. WARP Linux Client account\n 3. WireProxy account"
E[155]="WARP has not been installed yet."
C[155]="WARP has not been installed yet"
E[156]="(!!! Only supports amd64 and arm64, do not select.)"
C[156]="(!!! Only supports amd64 and arm64, please do not select)"
E[157]="WireProxy has not been installed yet."
C[157]="WireProxy has not been installed yet"
E[158]="WireProxy is disconnected. It could be connect again by [warp y]"
C[158]="Wireproxy has been disconnected, you can use warp y to connect again"
E[159]="WireProxy is on"
C[159]="WireProxy is enabled"
E[160]="WireProxy is not installed."
C[160]="WireProxy is not installed"
E[161]="WireProxy is installed and disconnected"
C[161]="WireProxy is installed and the status is disconnected"
E[162]="Token is invalid, please re-enter:"
C[162]="Token is invalid, please re-enter:"
E[163]="Connect the Wireproxy (warp y)"
C[163]="Connect Wireproxy (warp y)"
E[164]="Disconnect the Wireproxy (warp y)"
C[164]="Disconnect Wireproxy (warp y)"
E[165]="WireProxy Solution. A wireguard client that exposes itself as a socks5 proxy or tunnels. Adapted from the mature works of [pufferffish],[https://github.com/pufferffish/wireproxy]"
C[165]="WireProxy, let WARP propose a socks5 proxy locally. Adapted from [pufferffish]'s mature work, address [https://github.com/pufferffish/wireproxy], please familiarize yourself"
E[166]="WireProxy was installed.\n connect/disconnect by [warp y]\n uninstall by [warp u]"
C[166]="WireProxy is installed\n Connect/Disconnect: warp y\n Uninstall: warp u"
E[167]="WARP iptable was installed.\n connect/disconnect by [warp o]\n uninstall by [warp u]"
C[167]="WARP iptable installed\n Connect/disconnect: warp o\n Uninstall: warp u"
E[168]="Install CloudFlare Client and set mode to WARP (bash menu.sh l)"
C[168]="Install CloudFlare Client and set to WARP mode (bash menu.sh l)"
E[169]="Invalid license. It will remain the same account or be switched to a free account."
C[169]="License is invalid, the original account will be maintained or converted to a free account"
E[170]="Confirm all uninstallation please press [y], other keys do not uninstall by default:"
C[170]="Please press [y] to confirm all uninstallation, other keys will not uninstall by default:"
E[171]="Uninstall dependencies were complete."
C[171]="Dependency uninstallation successful"
E[172]="No suitable solution was found for modifying the warp configuration file warp.conf and the script aborted. When you see this message, please send feedback on the bug to:[https://github.com/fscarmen/ warp-sh/issues]"
C[172]="No suitable solution was found for modifying the warp configuration file warp.conf, and the script was terminated. When you see this message, please report the bug to: [https://github.com/fscarmen/warp -sh/issues]"
E[173]="Current account type is: WARP \$ACCOUNT_TYPE\\\n \$PLUS_QUOTA\\\n \$CHANGE_TYPE"
C[173]="The current account type is: WARP \$ACCOUNT_TYPE\\\n \$PLUS_QUOTA\\\n \$CHANGE_TYPE"
E[174]="1. Continue using the free account without changing.\n 2. Change to WARP+ account.\n 3. Change to Teams account."
C[174]="1. Continue to use the free account without changing\n 2. Change to a WARP+ account\n 3. Change to a Teams account"
E[175]="1. Change to free account.\n 2. Change to WARP+ account.\n 3. Change to another WARP Teams account."
C[175]="1. Change to free account\n 2. Change to WARP+ account\n 3. Change to another Teams account"
E[176]="1. Change to free account.\n 2. Change to another WARP+ account.\n 3. Change to Teams account."
C[176]="1. Change to a free account\n 2. Change to another WARP+ account\n 3. Change to a Teams account"
E[177]="1. Continue using the free account without changing.\n 2. Change to WARP+ account."
C[177]="1. Continue to use the free account without changing\n 2. Change to a WARP+ account"
E[178]="1. Change to free account.\n 2. Change to another WARP+ account."
C[178]="1. Change to free account\n 2. Change to another WARP+ account"
E[179]="Can only be run using \$KERNEL_OR_WIREGUARD_GO."
C[179]="Can only be run using \$KERNEL_OR_WIREGUARD_GO"
E[180]="Install using:\n 1. wireguard kernel (default)\n 2. wireguard-go with reserved"
C[180]="Please select wireguard mode:\n 1. wireguard kernel (default)\n 2. wireguard-go with reserved"
E[181]="\${WIREGUARD_BEFORE} ---\> \${WIREGUARD_AFTER}. Confirm press [y] :"
C[181]="\${WIREGUARD_BEFORE} ---\> \${WIREGUARD_AFTER}, please press [y] to confirm:"
E[182]="Working mode:\n 1. Global (default)\n 2. Non-global"
C[182]="Working mode:\n 1. Global (default)\n 2. Non-global"
E[183]="\${MODE_BEFORE} ---\> \${MODE_AFTER}, Confirm press [y] :"
C[183]="\${MODE_BEFORE} ---\> \${MODE_AFTER}, please press [y] to confirm:"
E[184]="Global"
C[184]="Global"
E[185]="Non-global"
C[185]="Non-global"
E[186]="Working mode: \$GLOBAL_OR_NOT"
C[186]="Working mode: \$GLOBAL_OR_NOT"
E[187]="Failed to change to \$ACCOUNT_CHANGE_FAILED account, automatically switch back to the original account."
C[187]="Failed to change to \$ACCOUNT_CHANGE_FAILED account, automatically switch back to the original account"
E[188]="All endpoints of WARP cannot be connected. Ask the supplier for more help. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[188]="All endpoints of WARP cannot be connected. UDP may be restricted. You can contact the supplier to learn how to enable it. Problem feedback: [https://github.com/fscarmen/warp-sh/issues] "
E[189]="Cannot detect any IPv4 or IPv6. The script is aborted. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[189]="No IPv4 or IPv6 detected. Script aborted, problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[190]="The configuration file warp.conf cannot be found. The script is aborted. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[190]="The configuration file warp.conf cannot be found, the script is aborted, problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
E[191]="Current operating system is: \$SYSTEM, Linux Client only supports Ubuntu, Debian and CentOS. The script is aborted. Feedback: [https://github.com/fscarmen/warp-sh/issues]"
C[191]="The current operating system is: \$SYSTEM. Linux Client only supports Ubuntu, Debian and CentOS. The script is aborted. Problem feedback: [https://github.com/fscarmen/warp-sh/issues]"
# Custom font color, read function
warning() { echo -e "\033[31m\033[01m$*\033[0m"; } # red
error() { echo -e "\033[31m\033[01m$*\033[0m" && exit 1; } # red
info() { echo -e "\033[32m\033[01m$*\033[0m"; } # Green
hint() { echo -e "\033[33m\033[01m$*\033[0m"; } # yellow
reading() { read -rp "$(info "$1")" "$2"; }
text() { grep -q '\$' <<< "${E[$*]}" && eval echo "\$(eval echo "\${${L}[$*]}")" | | eval echo "\${${L}[$*]}"; }

# Check whether Github CDN needs to be enabled. If it can be connected directly, do not use it.
check_cdn() {
  [ -n "$GH_PROXY" ] && wget --server-response --quiet --output-document=/dev/null --no-check-certificate --tries=2 --timeout=3 https://raw .githubusercontent.com/fscarmen/warp-sh/main/README.md >/dev/null 2>&1 && unset GH_PROXY
}

# Statistics on the script’s current day and cumulative number of runs
statistics_of_run-times() {
  local COUNT=$(curl --retry 2 -ksm2 "https://hit.forvps.gq/https://cdn.jsdelivr.net/gh/fscarmen/warp/menu.sh" 2>&1 | grep -m1 -oE "[0-9]+[ ]+/[ ]+[0-9]+") &&
  TODAY=$(awk -F ' ' '{print $1}' <<< "$COUNT") &&
  TOTAL=$(awk -F ' ' '{print $3}' <<< "$COUNT")
}
# To select the language, first determine the language selection in /etc/wireguard/language. If not, let the user choose. The default is English. Solve the problem of Chinese display
select_language() {
  UTF8_LOCALE=$(locale -a 2>/dev/null | grep -iEm1 "UTF-8|utf8")
  [ -n "$UTF8_LOCALE" ] && export LC_ALL="$UTF8_LOCALE" LANG="$UTF8_LOCALE" LANGUAGE="$UTF8_LOCALE"
if [ -s /etc/wireguard/language ]; then
    L=$(cat /etc/wireguard/language)
  else
    L=E && [[ -z "$OPTION" || "$OPTION" = [aclehdpbviw46sg] ]] && hint " $(text 0) \n" && reading " $(text 50) " LANGUAGE
    [ "$LANGUAGE" = 2 ] && L=C
  fi
}

# The script must be run as root
check_root() {
  [ "$(id -u)" != 0 ] && error " $(text 2) "
}

# Determine virtualization
check_virt() {
  if [ "$1" = 'Alpine' ]; then
    VIRT=$(virt-what | tr '\n' ' ')
  else
    [ "$(type -p systemd-detect-virt)" ] && VIRT=$(systemd-detect-virt)
    [[ -z "$VIRT" && -x "$(type -p hostnamectl)" ]] && VIRT=$(hostnamectl | awk '/Virtualization:/{print $NF}')
  fi
}
# Judge the operating system in multiple ways and try until there is value. Only supports Debian 10/11, Ubuntu 18.04/20.04 or CentOS 7/8. If it is not the above operating system, exit the script
# Thanks to Maoda for his technical guidance in optimizing repeated commands. https://github.com/Oreomeow
check_operating_system() {
  if [ -s /etc/os-release ]; then
    SYS="$(grep -i pretty_name /etc/os-release | cut -d \" -f2)"
  elif [ -x "$(type -p hostnamectl)" ]; then
    SYS="$(hostnamectl | grep -i system | cut -d : -f2)"
  elif [ -x "$(type -p lsb_release)" ]; then
    SYS="$(lsb_release -sd)"
  elif [ -s /etc/lsb-release ]; then
    SYS="$(grep -i description /etc/lsb-release | cut -d \" -f2)"
  elif [ -s /etc/redhat-release ]; then
    SYS="$(grep . /etc/redhat-release)"
  elif [ -s /etc/issue ]; then
    SYS="$(grep . /etc/issue | cut -d '\' -f1 | sed '/^[ ]*$/d')"
  fi
# Customize several functions of the Alpine system
  alpine_warp_restart() { wg-quick down warp >/dev/null 2>&1; wg-quick up warp >/dev/null 2>&1; }
  alpine_warp_enable() { echo -e "/usr/bin/tun.sh\nwg-quick up warp" > /etc/local.d/warp.start; chmod +x /etc/local.d/warp.start; rc -update add local; wg-quick up warp >/dev/null 2>&1; }
REGEX=("debian" "ubuntu" "centos|red hat|kernel|alma|rocky" "alpine" "arch linux" "fedora")
  RELEASE=("Debian" "Ubuntu" "CentOS" "Alpine" "Arch" "Fedora")
  EXCLUDE=("---")
  MAJOR=("9" "16" "7" "" "" "37")
  PACKAGE_UPDATE=("apt -y update" "apt -y update" "yum -y update --skip-broken" "apk update -f" "pacman -Sy" "dnf -y update")
  PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install" "apk add -f" "pacman -S --noconfirm" "dnf -y install")
  PACKAGE_UNINSTALL=("apt -y autoremove" "apt -y autoremove" "yum -y autoremove" "apk del -f" "pacman -Rcnsu --noconfirm" "dnf -y autoremove")
  SYSTEMCTL_START=("systemctl start wg-quick@warp" "systemctl start wg-quick@warp" "systemctl start wg-quick@warp" "wg-quick up warp" "systemctl start wg-quick@warp" "systemctl start wg -quick@warp")
  SYSTEMCTL_RESTART=("systemctl restart wg-quick@warp" "systemctl restart wg-quick@warp" "systemctl restart wg-quick@warp" "alpine_warp_restart" "systemctl restart wg-quick@warp" "systemctl restart wg-quick@warp ")
SYSTEMCTL_ENABLE=("systemctl enable --now wg-quick@warp" "systemctl enable --now wg-quick@warp" "systemctl enable --now wg-quick@warp" "alpine_warp_enable" "systemctl enable --now wg- quick@warp" "systemctl enable --now wg-quick@warp")

  for int in "${!REGEX[@]}"; do
    [[ "${SYS,,}" =~ ${REGEX[int]} ]] && SYSTEM="${RELEASE[int]}" && break
  done

  # Customized system for each factory transportation
  if [ -z "$SYSTEM" ]; then
    [ -x "$(type -p yum)" ] && int=2 && SYSTEM='CentOS' || error " $(text 5) "
  fi

  # Determine the main Linux version
  MAJOR_VERSION=$(sed "s/[^0-9.]//g" <<< "$SYS" | cut -d. -f1)

  # First exclude specific systems included in EXCLUDE. Other systems need to be compared with major releases.
  for ex in "${EXCLUDE[@]}"; do [[ ! "${SYS,,}" =~ $ex ]]; done &&
  [[ "$MAJOR_VERSION" -lt "${MAJOR[int]}" ]] && error " $(text 26) "
}
# Install system dependencies and define ping command
check_dependencies() {
  # For alpine systems, upgrade libraries and reinstall dependencies
  if [ "$SYSTEM" = 'Alpine' ]; then
    CHECK_WGET=$(wget 2>&1 | head -n 1)
    grep -qi 'busybox' <<< "$CHECK_WGET" && ${PACKAGE_INSTALL[int]} wget >/dev/null 2>&1
    DEPS_CHECK=("ping" "curl" "grep" "bash" "ip" "python3" "virt-what")
    DEPS_INSTALL=("iputils-ping" "curl" "grep" "bash" "iproute2" "python3" "virt-what")
  else
    # Dependencies required by the three major systems
    DEPS_CHECK=("ping" "wget" "curl" "systemctl" "ip" "python3")
    DEPS_INSTALL=("iputils-ping" "wget" "curl" "systemctl" "iproute2" "python3")
  fi
  warning " $(text 126) "
      wg-quick down warp >/dev/null 2>&1
      [ -s /etc/wireguard/info.log ] && grep -q 'Device name' /etc/wireguard/info.log && local LICENSE=$(cat /etc/wireguard/license) && local NAME=$(awk ' /Device name/{print $NF}' /etc/wireguard/info.log)
      warp_api "cancel" "/etc/wireguard/warp-account.conf" >/dev/null 2>&1
      warp_api "register" > /etc/wireguard/warp-account.conf 2>/dev/null
      # If it was a plus account, upgrade with the same license and modify the account and warp configuration file
      if [[ -n "$LICENSE" && -n "$NAME" ]]; then
        [ -n "$LICENSE" ] && warp_api "license" "/etc/wireguard/warp-account.conf" "$LICENSE" >/dev/null 2>&1
        [ -n "$NAME" ] && warp_api "name" "/etc/wireguard/warp-account.conf" "" "$NAME" >/dev/null 2>&1
        local PRIVATEKEY="$(grep 'private_key' /etc/wireguard/warp-account.conf | cut -d\" -f4)"
        local ADDRESS6="$(grep '"v6.*"$' /etc/wireguard/warp-account.conf | cut -d\" -f4)"
local CLIENT_ID="$(warp_api "convert" "/etc/wireguard/warp-account.conf" "" "" "" "" "file")"
        [ -s /etc/wireguard/warp.conf ] && sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ] \+=[ ]\+\).*\(/128$\)#\1$ADDRESS6\2#g; s#\(.*Reserved[ ]\+=[ ]\+\).*#\ 1$CLIENT_ID#g" /etc/wireguard/warp.conf
        sed -i "s#\([ ]\+\"license\": \"\).*#\1$LICENSE\"#g; s#\"account_type\".*#\"account_type\": \"limited\",#g; s#\([ ]\+\"name\": \"\).*#\1$NAME\"#g" /etc/wireguard/warp-account.conf
      fi
      ss -nltp | grep dnsmasq >/dev/null 2>&1 && systemctl restart dnsmasq >/dev/null 2>&1
      wg-quick up warp >/dev/null 2>&1
      sleep $j
    }
# Detect that the account type is Team and cannot be replaced
    if [ -e /etc/wireguard/info.log ] && ! grep -q 'Device name' /etc/wireguard/info.log; then
      hint "\n $(text 95) \n" && reading " $(text 50) " CHANGE_ACCOUNT
      case "$CHANGE_ACCOUNT" in
        2 )
          UPDATE_ACCOUNT=warp
          change_to_plus
          ;;
        3)
          exit 0
          ;;
        * )
          UPDATE_ACCOUNT=warp
          change_to_free
      esac
    fi

    unset T4 T6
    grep -q "^#.*0\.\0\/0" 2>/dev/null /etc/wireguard/warp.conf && T4=0 || T4=1
    grep -q "^#.*\:\:\/0" 2>/dev/null /etc/wireguard/warp.conf && T6=0 || T6=1
    case "$T4$T6" in
      01 )
        NF='6'
        ;;
      10)
        NF='4'
        ;;
      11)
        change_stack
    esac

    # Detect [global] or [non-global]
    grep -q '^Table' /etc/wireguard/warp.conf && GLOBAL='--interface warp'
[ -z "$EXPECT" ] && input_region
    i=0; j=10
    while true; do
      (( i++ )) || true
      ip_now=$(date +%s); RUNTIME=$((ip_now - ip_start)); DAY=$(( RUNTIME / 86400 )); HOUR=$(( (RUNTIME % 86400 ) / 3600 )); MIN=$ (( (RUNTIME % 86400 % 3600) / 60 )); SEC=$(( RUNTIME % 86400 % 3600 % 60 ))
      [ "$GLOBAL" = '--interface warp' ] && ip_case "$NF" warp non-global || ip_case "$NF" warp
      WAN=$(eval echo \$WAN$NF) && COUNTRY=$(eval echo \$COUNTRY$NF) && ASNORG=$(eval echo \$ASNORG$NF)
      unset RESULT REGION
      for l in ${!RESULT_TITLE[@]}; do
        RESULT[l]=$(curl --user-agent "${UA_Browser}" -$NF $GLOBAL -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https ://www.netflix.com/title/${RESULT_TITLE[l]}")
        [ "${RESULT[l]}" = 200 ] && break
      done
      if [[ "${RESULT[@]}" =~ 200 ]]; then
REGION=$(curl --user-agent "${UA_Browser}" -"$NF" $GLOBAL -fs --max-time 10 --write-out "%{redirect_url}" --output /dev/null " https://www.netflix.com/title/$REGION_TITLE" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g')
        REGION=${REGION:-'US'}
        grep -qi "$EXPECT" <<< "$REGION" && info " $(text 125) " && i=0 && sleep 1h || warp_restart
      else
        warp_restart
      fi
    done
  }

  change_client() {
    client_restart() {
      local CLIENT_MODE=$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i +1)}}')
      # Display uninstall results
  systemctl restart systemd-resolved >/dev/null 2>&1; sleep 3
  ip_case_warp
  info " $(text 45)\n IPv4: $WAN4 $COUNTRY4 $ASNORG4\n IPv6: $WAN6 $COUNTRY6 $ASNORG6 "
}

# Synchronize scripts to the latest version
ver() {
  mkdir -p /tmp; rm -f /tmp/menu.sh
  wget -O /tmp/menu.sh https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh
  if [ -s /tmp/menu.sh ]; then
    mv /tmp/menu.sh /etc/wireguard/
    chmod +x /etc/wireguard/menu.sh
    ln -sf /etc/wireguard/menu.sh /usr/bin/warp
    info " $(text 64):$(grep ^VERSION /etc/wireguard/menu.sh | sed "s/.*=//g") $(text 18):$(grep "${L}\[ 1\]" /etc/wireguard/menu.sh | cut -d \" -f2) "
  else
    error " $(text 65) "
  fi
  exit
}
# Due to the warp bug, sometimes the IP address cannot be obtained. Add the network brush script to run it manually, and set the scheduled task to run automatically after the VPS restarts. i=the current number of attempts, j=the number of attempts to be made.
net() {
  local NO_OUTPUT="$1"
  unset IP4 IP6 WAN4 WAN6 COUNTRY4 COUNTRY6 ASNORG4 ASNORG6 WARPSTATUS4 WARPSTATUS6 TYPE QUOTA
  [ ! -x "$(type -p wg-quick)" ] && error " $(text 10) "
  [ ! -e /etc/wireguard/warp.conf ] && error " $(text 190) "
  local i=1; local j=5
  hint " $(text 11)\n $(text 12) "
  [ "$SYSTEM" != Alpine ] && [[ $(systemctl is-active wg-quick@warp) != 'active' ]] && wg-quick down warp >/dev/null 2>&1
  ${SYSTEMCTL_START[int]} >/dev/null 2>&1
  wg-quick up warp >/dev/null 2>&1
  ss -nltp | grep dnsmasq >/dev/null 2>&1 && systemctl restart dnsmasq >/dev/null 2>&1
PING6='ping -6' && [ -x "$(type -p ping6)" ] && PING6='ping6'
  LAN4=$(ip route get 192.168.193.10 2>/dev/null | awk '{for (i=0; i<NF; i++) if ($i=="src") {print $(i+1) }}')
  LAN6=$(ip route get 2606:4700:d0::a29f:c001 2>/dev/null | awk '{for (i=0; i<NF; i++) if ($i=="src") { print $(i+1)}}')
  if [[ $(ip link show | awk -F': ' '{print $2}') =~ warp ]]; then
    grep -q '#Table' /etc/wireguard/warp.conf && GLOBAL_OR_NOT="$(text 184)" || GLOBAL_OR_NOT="$(text 185)"
    if grep -q '^AllowedIPs.*:\:\/0' 2>/dev/null /etc/wireguard/warp.conf; then
      local NET_6_NONGLOBAL=1
      ip_case 6 warp non-global
    else
      [[ "$LAN6" =~ ^[a-f0-9:]{1,}$ ]] && $PING6 -c2 -w10 2606:4700:d0::a29f:c001 >/dev/null 2>&1 && local NET_6_NONGLOBAL=0 && ip_case 6 warp
    fi
    if grep -q '^AllowedIPs.*0\.\0\/0' 2>/dev/null /etc/wireguard/warp.conf; then
      local NET_4_NONGLOBAL=1
      ip_case 4 warp non-global
    else
[[ "$LAN4" =~ ^([0-9]{1,3}\.){3} ]] && ping -c2 -W3 162.159.193.10 >/dev/null 2>&1 && local NET_4_NONGLOBAL=0 && ip_case 4 warp
    fi
  else
    [[ "$LAN6" =~ ^[a-f0-9:]{1,}$ ]] && INET6=1 && $PING6 -c2 -w10 2606:4700:d0::a29f:c001 >/dev/null 2>&1 && local NET_6_NONGLOBAL=0 && ip_case 6 warp
    [[ "$LAN4" =~ ^([0-9]{1,3}\.){3} ]] && INET4=1 && ping -c2 -W3 162.159.193.10 >/dev/null 2>&1 && local NET_4_NONGLOBAL=0 && ip_case 4 warp
  fi

  until [[ "$TRACE4$TRACE6" =~ on|plus ]]; do
    (( i++ )) || true
    hint " $(text 12) "
    ${SYSTEMCTL_RESTART[int]} >/dev/null 2>&1
    ss -nltp | grep dnsmasq >/dev/null 2>&1 && systemctl restart dnsmasq >/dev/null 2>&1

    case "$NET_6_NONGLOBAL" in
      0 )
        ip_case 6 warp
        ;;
      1 )
        ip_case 6 warp non-global
    esac

    case "$NET_4_NONGLOBAL" in
      0 )
        ip_case 4 warp
        ;;
      1 )
        ip_case 4 warp non-global
    esac
if [ "$i" = "$j" ]; then
      if [ -z "$CONFIRM_TEAMS_INFO" ]; then
        wg-quick down warp >/dev/null 2>&1
        ERROR_MESSAGE=$(wg-quick up warp 2>&1)
        wg-quick down warp >/dev/null 2>&1
        [ -s /etc/resolv.conf.origin ] && cp -f /etc/resolv.conf.origin /etc/resolv.conf
        echo -e " ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓\n $(text 20): $SYS\n\n $(text 21):$(uname -r) "
        error " $(text 13) "
      else
        break
      fi
    fi
  done

  if [[ "$TRACE4$TRACE6" =~ on|plus ]]; then
    TYPE=' Free' && [ -e /etc/wireguard/info.log ] && TYPE=' Teams' && grep -sq 'Device name' /etc/wireguard/info.log && TYPE='+' && check_quota warp info " $(text 14), $(text 186) "
    [ "$NO_OUTPUT" != 'no_output' ] && info " IPv4:$WAN4 $COUNTRY4 $ASNORG4\n IPv6:$WAN6 $COUNTRY6 $ASNORG6 " && [ -n "$QUOTA" ] && info " $(text 25) : $(awk '/Device name/{print $NF}' /etc/wireguard/info.log)\n $(text 63): $QUOTA "
  fi
}

# WARP switch, first check whether it is installed, and then switch to the opposite state according to the current status
onoff() {
  [ ! -x "$(type -p wg-quick)" ] && error " $(text 155) "
  [ -n "$(wg 2>/dev/null)" ] && (wg-quick down warp >/dev/null 2>&1; info " $(text 15) ") || net
}
# Client switch, first check whether it is installed, and then switch to the opposite state according to the current status
client_onoff() {
  [ ! -x "$(type -p warp-cli)" ] && error " $(text 93) "
  if [ "$(warp-cli --accept-tos status | awk '/Status update/{for (i=0; i<NF; i++) if ($i=="update:") {print $(i +1)}}')" = 'Connected' ]; then
    local CLIENT_MODE=$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i +1)}}')
    [ "$CLIENT_MODE" = 'Warp' ] && rule_del >/dev/null 2>&1
    warp-cli --accept-tos disconnect >/dev/null 2>&1
    info " $(text 91) " && exit 0
  else
    warp-cli --accept-tos connect >/dev/null 2>&1; sleep 2
    local CLIENT_MODE=$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i +1)}}')
    if [ "$CLIENT_MODE" = 'WarpProxy' ]; then
      ip_case d client
      local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk '/type/{print $3}')
      [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && check_quota client
[[ $(ss -nltp | awk '{print $NF}' | awk -F \" '{print $2}') =~ warp-svc ]] && info " $(text 90)\n $(text 27 ): $CLIENT_SOCKS5\n WARP$CLIENT_AC IPv4: $CLIENT_WAN4 $CLIENT_COUNTRY4 $CLIENT_ASNORG4\n WARP$CLIENT_AC IPv6: $CLIENT_WAN6 $CLIENT_COUNTRY6 $CLIENT_ASNORG6 "
      [ -n "$QUOTA" ] && info " $(text 63): $QUOTA "
      exit 0

    elif [ "$CLIENT_MODE" = 'Warp' ]; then
      rule_add >/dev/null 2>&1
      ip_case d is_luban
      local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk '/type/{print $3}')
      [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && check_quota client
      [[ $(ip link show | awk -F': ' '{print $2}') =~ CloudflareWARP ]] && info " $(text 90)\n WARP$CLIENT_AC IPv4: $CFWARP_WAN4 $CFWARP_COUNTRY4 $CFWARP_ASNORG4\n WARP $CLIENT_AC IPv6: $CFWARP_WAN6 $CFWARP_COUNTRY6 $CFWARP_ASNORG6 "
      [ -n "$QUOTA" ] && info " $(text 63): $QUOTA "
      exit 0
    fi
  fi
}
# WireProxy switch, first check whether it is installed, and then switch to the opposite state according to the current status
wireproxy_onoff() {
  local NO_OUTPUT="$1"
  unset QUOTA
  [ ! -x "$(type -p wireproxy)" ] && error " $(text 157) " || IS_PUFFERFFISH=is_pufferffish
  if ss -nltp | awk '{print $NF}' | awk -F \" '{print $2}' | grep -q wireproxy; then
    [ "$SYSTEM" = Alpine ] && rc-service wireproxy stop >/dev/null 2>&1 || systemctl stop wireproxy
    [[ ! $(ss -nltp | awk '{print $NF}' | awk -F \" '{print $2}') =~ wireproxy ]] && info " $(text 158) "
  else
    local i=1; local j=3
    hint " $(text 11)\n $(text 12) "
    [ "$SYSTEM" = Alpine ] && rc-service wireproxy start >/dev/null 2>&1 || systemctl start wireproxy; sleep 1
    ip_case d wireproxy
until [[ "$WIREPROXY_TRACE4$WIREPROXY_TRACE6" =~ on|plus ]]; do
      (( i++ )) || true
      hint " $(text 12) "
      [ "$SYSTEM" = Alpine ] && rc-service wireproxy restart >/dev/null 2>&1 || systemctl restart wireproxy; sleep 1
      ip_case d wireproxy
      if [[ "$i" = "$j" ]]; then
        [ "$SYSTEM" = Alpine ] && rc-service wireproxy stop >/dev/null 2>&1 || systemctl stop wireproxy
        [ -z "$CONFIRM_TEAMS_INFO" ] && error " $(text 13) " || break
      fi
    done

    if [[ "$NO_OUTPUT" != 'no_output' && "$WIREPROXY_TRACE4$WIREPROXY_TRACE6" =~ on|plus ]]; then
      [[ $(ss -nltp | awk '{print $NF}' | awk -F \" '{print $2}') =~ wireproxy ]] && info " $(text 99)\n $(text 27): $WIREPROXY_SOCKS5\n WARP$WIREPROXY_ACCOUNT\n IPv4: $WIREPROXY_WAN4 $WIREPROXY_COUNTRY4 $WIREPROXY_ASNORG4\n IPv6: $WIREPROXY_WAN6 $WIREPROXY_COUNTRY6 $WIREPROXY_ASNORG6"
      [ -n "$QUOTA" ] && info " $(text 25): $(awk '/Device name/{print $NF}' /etc/wireguard/info.log)\n $(text 63): $QUOTA "
    fi
  fi
}
# Check the system WARP single and dual stack status. For the sake of speed, first check the situation in the warp configuration file, and then judge the trace
check_stack() {
  if [ -e /etc/wireguard/warp.conf ]; then
    grep -q "^#.*0\.\0\/0" 2>/dev/null /etc/wireguard/warp.conf && T4=0 || T4=1
    grep -q "^#.*\:\:\/0" 2>/dev/null /etc/wireguard/warp.conf && T6=0 || T6=1
  else
    case "$TRACE4" in
      off )
        T4='0'
        ;;
      'on'|'plus' )
        T4='1'
    esac
    case "$TRACE6" in
      off )
        T6='0'
        ;;
      'on'|'plus' )
        T6='1'
    esac
  fi
  CASE=("@0" "0@" "0@0" "@1" "0@1" "1@" "1@0" "1@1" "@")
  for m in ${!CASE[@]}; do
    [ "$T4"@"$T6" = "${CASE[m]}" ] && break
  done
  WARP_BEFORE=("" "" "" "WARP IPv6 only" "WARP IPv6" "WARP IPv4 only" "WARP IPv4" "$(text 70)")
  WARP_AFTER1=("" "" "" "WARP IPv4" "WARP IPv4" "WARP IPv6" "WARP IPv6" "WARP IPv4")
  WARP_AFTER2=("" "" "" "$(text 70)" "$(text 70)" "$(text 70)" "$(text 70)" "WARP IPv6")
  TO1=("" "" "" "014" "014" "106" "106" "114")
  TO2=("" "" "" "01D" "01D" "10D" "10D" "116")
SHORTCUT1=("" "" "" "(warp 4)" "(warp 4)" "(warp 6)" "(warp 6)" "(warp 4)")
  SHORTCUT2=("" "" "" "(warp d)" "(warp d)" "(warp d)" "(warp d)" "(warp 6)")

  # Judgment is used to detect NAT VSP to select the correct configuration file
  if [ "$m" -le 3 ]; then
    NAT=("0@1@" "1@0@1" "1@1@1" "0@1@1")
    for n in ${!NAT[@]}; do [ "$IPV4@$IPV6@$INET4" = "${NAT[n]}" ] && break; done
    NATIVE=("IPv6 only" "IPv4 only" "$(text 69)" "NAT IPv4")
    CONF1=("014" "104" "114" "11N4")
    CONF2=("016" "106" "116" "11N6")
    CONF3=("01D" "10D" "11D" "11ND")
  elif [ "$m" = 8 ]; then
    error "\n $(text 189) \n"
  fi
}
# For CentOS 9 / AlmaLinux 9 / RockyLinux 9 and similar systems, since wg-quick cannot operate openresolv, the /etc/resolv.conf file is processed directly
centos9_resolv() {
  local EXECUTE=$1
  local STACK=$2
  if [ "$EXECUTE" = 'backup' ]; then
    cp -f /etc/resolv.conf{,.origin}
  elif [ "$EXECUTE" = 'generate' ]; then
    [ "$STACK" = '0' ] && echo -e "# Generated by WARP script\nnameserver 2606:4700:4700::1111\nnameserver 2001:4860:4860::8888\nnameserver 2001:4860:4860::8844 \nnameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf || echo -e "# Generated by WARP script\nnameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4\ nnameserver 2606:4700:4700::1111\nnameserver 2001:4860:4860::8888\nnameserver 2001:4860:4860::8844" > /etc/resolv.conf
  elif [ "$EXECUTE" = 'restore' ]; then
    [ -s /etc/resolv.conf.origin ] && mv -f /etc/resolv.conf.origin /etc/resolv.conf
  fi
}
# Online exchange of single and double stacks. First check whether there are options in the menu, then check the passed parameter values, and no two options are displayed.
stack_switch() {
  # WARP single and dual stack switching options
  SWITCH014="/AllowedIPs/s/#//g;s/^.*\:\:\/0/#&/g"
  SWITCH01D="/AllowedIPs/s/#//g"
  SWITCH106="/AllowedIPs/s/#//g;s/^.*0\.\0\/0/#&/g"
  SWITCH10D="/AllowedIPs/s/#//g"
  SWITCH114="/AllowedIPs/s/^.*\:\:\/0/#&/g"
  SWITCH116="/AllowedIPs/s/^.*0\.\0\/0/#&/g"

  [[ "$CLIENT" = [35] && "$SWITCHCHOOSE" = [4D] ]] && error " $(text 109) "
  check_stack
  if [[ "$MENU_CHOOSE" = [12] ]]; then
    TO=$(eval echo "\${TO$MENU_CHOOSE[m]}")
  elif [[ "$SWITCHCHOOSE" = [46D] ]]; then
    [[ "$T4@$T6@$SWITCHCHOOSE" =~ '1@0@4'|'0@1@6'|'1@1@D' ]] && error "\n $(text 146) \ n" || TO="$T4$T6$SWITCHCHOOSE"
  fi
  [ "${#TO}" != 3 ] && error " $(text 172) " || sed -i "$(eval echo "\$SWITCH$TO")" /etc/wireguard/warp.conf
  ${SYSTEMCTL_RESTART[int]}; sleep 1
  net
}
# kernel / wireguard-go with reserved online interchange
kernel_reserved_switch() {
  # First determine whether it can be converted
  case "$KERNEL_ENABLE@$WIREGUARD_GO_ENABLE" in
    0@1 )
      KERNEL_OR_WIREGUARD_GO='wireguard-go with reserved' && error "\n $(text 179) \n"
      ;;
    1@0 )
      KERNEL_OR_WIREGUARD_GO='wireguard kernel' && error "\n $(text 179) \n"
      ;;
    1@1 )
      if grep -q '^#[[:space:]]*add_if' /usr/bin/wg-quick; then
        WIREGUARD_BEFORE='wireguard-go with reserved'; WIREGUARD_AFTER='wireguard kernel'; local CP_FILE=origin
      else
        WIREGUARD_BEFORE='wireguard kernel'; WIREGUARD_AFTER='wireguard-go with reserved'; local CP_FILE=reserved
      fi
reading "\n $(text 181) " CONFIRM_WIREGUARD_CHANGE
      if [ "${CONFIRM_WIREGUARD_CHANGE,,}" = 'y' ]; then
        wg-quick down warp >/dev/null 2>&1
        cp -f /usr/bin/wg-quick.$CP_FILE /usr/bin/wg-quick
        net
      else
        exit
      fi
  esac
}

# Global / non-global online swap
working_mode_switch() {
  # First determine the current working mode
  if grep -q '#Table' /etc/wireguard/warp.conf; then
    MODE_BEFORE="$(text 184)"; MODE_AFTER="$(text 185)"
  else
    MODE_BEFORE="$(text 185)"; MODE_AFTER="$(text 184)"
  fi

  reading "\n $(text 183) " CONFIRM_MODE_CHANGE
  if [ "${CONFIRM_MODE_CHANGE,,}" = 'y' ]; then
    wg-quick down warp >/dev/null 2>&1
    [ "$MODE_AFTER" = "$(text 185)" ] && sed -i "/Table/s/#//g;/NonGlobal/s/#//g" /etc/wireguard/warp.conf || sed -i "s/^Table/#Table/g; /NonGlobal/s/^/#&/g" /etc/wireguard/warp.conf
    net
  else
    exit
  fi
}

# Check system information
check_system_info() {
  info " $(text 37) "
# Determine whether the wireguard kernel is loaded. If not, try again to see if it can be loaded.
  if [ ! -e /sys/module/wireguard ]; then
    [ -s /lib/modules/$(uname -r)/kernel/drivers/net/wireguard/wireguard.ko* ] && [ -x "$(type -p lsmod)" ] && ! lsmod | grep -q wireguard && [ -x "$(type -p modprobe)" ] && modprobe wireguard
    [ -e /sys/module/wireguard ] && KERNEL_ENABLE=1 || KERNEL_ENABLE=0
  else
    KERNEL_ENABLE=1
  fi

  # The TUN module must be loaded, try to open TUN online first. If the attempt is successful, it will be placed in the startup item. If it fails, a prompt will be displayed and the script will exit.
  TUN=$(cat /dev/net/tun 2>&1)
  if [[ "$TUN" =~ 'in bad state'|'in an error state' ]]; then
    WIREGUARD_GO_ENABLE=1
  else
    cat >/usr/bin/tun.sh << EOF
#!/usr/bin/env bash
mkdir -p /dev/net
mknod /dev/net/tun c 10 200 2>/dev/null
[ ! -e /dev/net/tun ] && exit 1
chmod 0666 /dev/net/tun
EOF
    chmod +x /usr/bin/tun.sh
    /usr/bin/tun.sh
    TUN=$(cat /dev/net/tun 2>&1)
    if [[ "$TUN" =~ 'in bad state'|'in an error state' ]]; then
      WIREGUARD_GO_ENABLE=1
      [ "$SYSTEM" != Alpine ] && echo "@reboot root bash /usr/bin/tun.sh" >> /etc/crontab
    else
      WIREGUARD_GO_ENABLE=0
      rm -f /usr/bin/tun.sh
    fi
  fi

  # Determine the machine's native state type
  IPV4=0; IPV6=0
  LAN4=$(ip route get 192.168.193.10 2>/dev/null | awk '{for (i=0; i<NF; i++) if ($i=="src") {print $(i+1) }}')
  LAN6=$(ip route get 2606:4700:d0::a29f:c001 2>/dev/null | awk '{for (i=0; i<NF; i++) if ($i=="src") { print $(i+1)}}')
# First check whether it is non-local, give priority to warp IP, and then native IP
  if [[ $(ip link show | awk -F': ' '{print $2}') =~ warp ]]; then
    GLOBAL_OR_NOT="$(text 185)"
    if grep -q '^AllowedIPs.*:\:\/0' 2>/dev/null /etc/wireguard/warp.conf; then
      STACK=-6 && ip_case 6 warp non-global
    else
      [[ "$LAN6" != "::1" && "$LAN6" =~ ^[a-f0-9:]+$ ]] && INET6=1 && $PING6 -c2 -w10 2606:4700:d0: :a29f:c001 >/dev/null 2>&1 && IPV6=1 && STACK=-6 && ip_case 6 warp
    fi
    if grep -q '^AllowedIPs.*0\.\0\/0' 2>/dev/null /etc/wireguard/warp.conf; then
      STACK=-4 ​​&& ip_case 4 warp non-global
    else
      [[ "$LAN4" =~ ^([0-9]{1,3}\.){3} ]] && INET4=1 && ping -c2 -W3 162.159.193.10 >/dev/null 2>&1 && IPV4=1 && STACK=-4 ​​&& ip_case 4 warp
    fi
  else
    [[ "$LAN6" != "::1" && "$LAN6" =~ ^[a-f0-9:]+$ ]] && INET6=1 && $PING6 -c2 -w10 2606:4700:d0: :a29f:c001 >/dev/null 2>&1 && IPV6=1 && STACK=-6 && ip_case 6 warp
[[ "$LAN4" =~ ^([0-9]{1,3}\.){3} ]] && INET4=1 && ping -c2 -W3 162.159.193.10 >/dev/null 2>&1 && IPV4=1 && STACK=-4 ​​&& ip_case 4 warp
  fi

  # Determine the current WARP status and determine the variable PLAN. The meaning of the variable PLAN is: 1=single stack 2=dual stack 3=WARP is turned on
  [[ "$TRACE4$TRACE6" =~ on|plus ]] && PLAN=3 || PLAN=$((IPV4+IPV6))

  # Determine processor architecture
  case $(uname -m) in
    aarch64 )
      ARCHITECTURE=arm64
      ;;
    x86_64 )
      ARCHITECTURE=amd64
      ;;
    s390x )
      ARCHITECTURE=s390x; CLIENT_NOT_ALLOWED_ARCHITECTURE="$(text 156)"
      ;;
    * )
      error " $(text 134) "
  esac

  # Determine the current Linux Client status and determine the variable CLIENT. The meaning of the variable CLIENT: 0=not installed 1=installed but not activated 2=status activated 3=Client proxy is enabled 5=Client warp is enabled
  CLIENT=0
  if [ -x "$(type -p warp-cli)" ]; then
  CLIENT=1 && CLIENT_INSTALLED="$(text 92)"
    [ "$(systemctl is-enabled warp-svc)" = enabled ] && CLIENT=2
    if [[ "$CLIENT" = 2 && "$(systemctl is-active warp-svc)" = 'active' ]]; then
      local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk '/type/{print $3}')
      [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && check_quota client
      local CLIENT_MODE=$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i +1)}}')
      case "$CLIENT_MODE" in
        WarpProxy )
          [[ "$(ss -nltp | awk '{print $NF}' | awk -F \" '{print $2}')" =~ warp-svc ]] && CLIENT=3 && ip_case d client
          ;;
        Warp )
          [[ "$(ip link show | awk -F': ' '{print $2}')" =~ CloudflareWARP ]] && CLIENT=5 && ip_case d is_luban
      esac
    fi
  fi
# Determine the current WireProxy status and determine the variable WIREPROXY. The meaning of the variable WIREPROXY: 0=not installed, 1=installed, disconnected state, 2=Client is turned on
  WIREPROXY=0
  if [ -x "$(type -p wireproxy)" ]; then
    WIREPROXY=1
    [ "$WIREPROXY" = 1 ] && WIREPROXY_INSTALLED="$(text 92)" && [[ "$(ss -nltp | awk '{print $NF}' | awk -F \" '{print $2}')" =~ wireproxy ]] && WIREPROXY=2 && ip_case d wireproxy
  fi
}

rule_add() {
  ip -4 rule add from 172.16.0.2 lookup 51820
  ip -4 route add default dev CloudflareWARP table 51820
  ip -4 rule add table main suppress_prefixlength 0
  ip -6 rule add oif CloudflareWARP lookup 51820
  ip -6 route add default dev CloudflareWARP table 51820
  ip -6 rule add table main suppress_prefixlength 0
}

rule_del() {
  ip -4 rule delete from 172.16.0.2 lookup 51820
  ip -4 rule delete table main suppress_prefixlength 0
  ip -6 rule delete oif CloudflareWARP lookup 51820
  ip -6 rule delete table main suppress_prefixlength 0
}
# Enter the WARP+ account (if any), the limit number is empty or 26 digits to prevent input errors
input_license() {
  [ -z "$LICENSE" ] && reading " $(text 28) " LICENSE
  i=5
  until [[ -z "$LICENSE" || "$LICENSE" =~ ^[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}-[A-Z0-9a -z]{8}$ ]]; do
    (( i-- )) || true
    [ "$i" = 0 ] && error " $(text 29) " || reading " $(text 30) " LICENSE
  done
  if [ "$INPUT_LICENSE" = 1 ]; then
    [[ -n "$LICENSE" && -z "$NAME" ]] && reading " $(text 102) " NAME
    [ -n "$NAME" ] && NAME="${NAME//[[:space:]]/_}" || NAME=${NAME:-"$(hostname)"}
  fi
}
# Enter the Teams account URL (if any)
input_url_token() {
  if [ "$1" = 'url' ]; then
    [ -z "$TEAM_URL" ] && reading " url: " TEAM_URL
    [ -n "$TEAM_URL" ] && TEAMS_CONTENT=$(curl --retry 2 -m5 -sSL "$TEAM_URL") || return
    if grep -q 'xml version' <<< "$TEAMS_CONTENT"; then
      ADDRESS6=$(expr "$TEAMS_CONTENT" : '.*v6":"\([^[&]*\).*')
      [ -n "$ADDRESS6" ] && PRIVATEKEY=$(expr "$TEAMS_CONTENT" : '.*private_key">\([^<]*\).*')
      [[ -n "$ADDRESS6" && -z "$PRIVATEKEY" ]] && PRIVATEKEY=$(expr "$TEAMS_CONTENT" : '.*private_key">\([^<]\+\).*')
      RESERVED=$(expr "$TEAMS_CONTENT" : '.*;client_id":"\([^&]\{4\}\)')
      CLIENT_ID="$(warp_api "convert" "" "" "" "" "$RESERVED" "decode")"
    else
      ADDRESS6=$(expr "$TEAMS_CONTENT" : '.*"v6":[ ]*"\([^["]\+\).*')
      PRIVATEKEY=$(expr "$TEAMS_CONTENT" : '.*"private_key":[ ]*"\([^"]\+\).*')
      RESERVED=$(expr "$TEAMS_CONTENT" : '.*"client_id":[ ]*"\([^"]\+\).*')
      CLIENT_ID="$(warp_api "convert" "" "" "" "" "$RESERVED" "decode")"
fi

  elif [ "$1" = 'token' ]; then
    [ -z "$TEAM_TOKEN" ] && reading " token: " TEAM_TOKEN
    [ -z "$TEAM_TOKEN" ] && return

    local ERROR_TIMES=0
    while [ "$ERROR_TIMES" -le 3 ]; do
      (( ERROR_TIMES++ ))
      if grep -q 'token is expired' <<< "$TEAMS"; then
        reading " $(text 128) " TEAM_TOKEN
      elif grep -q 'error' <<< "$TEAMS"; then
        reading " $(text 162) " TEAM_TOKEN
      elif grep -q 'organization' <<< "$TEAMS"; then
        break
      fi
      [ -z "$TEAM_TOKEN" ] && return

      unset TEAMS ADDRESS6 PRIVATEKEY CLIENT_ID
      # Detailed description:<[WireGuard] Header / MTU sizes for Wireguard>:https://lists.zx2c4.com/pipermail/wireguard/2017-December/002201.html
  MTU=$((1500-28))
  [ "$IPV4$IPV6" = 01 ] && $PING6 -c1 -W1 -s $MTU -Mdo 2606:4700:d0::a29f:c001 >/dev/null 2>&1 || ping -c1 -W1 -s $MTU -Mdo 162.159.193.10 >/dev/null 2>&1
  until [[ $? = 0 || $MTU -le $((1280+80-28)) ]]; do
    MTU=$((MTU-10))
    [ "$IPV4$IPV6" = 01 ] && $PING6 -c1 -W1 -s $MTU -Mdo 2606:4700:d0::a29f:c001 >/dev/null 2>&1 || ping -c1 -W1 -s $MTU -Mdo 162.159.193.10 >/dev/null 2>&1
  done

  if [ "$MTU" -eq $((1500-28)) ]; then
    MTU=$MTU
  elif [ "$MTU" -le $((1280+80-28)) ]; then
    MTU=$((1280+80-28))
  else
    for i in {0..8}; do
      ((MTU++))
      ( [ "$IPV4$IPV6" = 01 ] && $PING6 -c1 -W1 -s $MTU -Mdo 2606:4700:d0::a29f:c001 >/dev/null 2>&1 ping -c1 -W1 -s $ MTU -Mdo 162.159.193.10 >/dev/null 2>&1 ) break
    done
    ((MTU--))
  fi

  MTU=$((MTU+28-80))
  echo "$MTU" > /tmp/best_mtu
}
# Find the best Endpoint and download the endpoint library according to v4 / v6
best_endpoint() {
  wget $STACK -qO /tmp/endpoint https://gitlab.com/fscarmen/warp/-/raw/main/endpoint/warp-linux-"$ARCHITECTURE" && chmod +x /tmp/endpoint
  [ "$IPV4$IPV6" = 01 ] && wget $STACK -qO /tmp/ip https://gitlab.com/fscarmen/warp/-/raw/main/endpoint/ipv6 || wget $STACK -qO /tmp /ip https://gitlab.com/fscarmen/warp/-/raw/main/endpoint/ipv4

  if [[ -e /tmp/endpoint && -e /tmp/ip ]]; then
    /tmp/endpoint -file /tmp/ip -output /tmp/endpoint_result >/dev/null 2>&1
    # If all packets are lost, LOSS = 100%, indicating that UDP is prohibited, generate the flag /tmp/noudp
    [ "$(grep -sE '[0-9]+[ ]+ms$' /tmp/endpoint_result | awk -F, 'NR==1 {print $2}')" = '100.00%' ] && touch / tmp/noudp || ENDPOINT=$(grep -sE '[0-9]+[ ]+ms$' /tmp/endpoint_result | awk -F, 'NR==1 {print $1}')
    rm -f /tmp/{endpoint,ip,endpoint_result}
  fi
# If it fails, there will be a default value of 162.159.193.10:2408 or [2606:4700:d0::a29f:c001]:2408
  [ "$IPV4$IPV6" = 01 ] && ENDPOINT=${ENDPOINT:-'[2606:4700:d0::a29f:c001]:2408'} || ENDPOINT=${ENDPOINT:-'162.159.193.10:2408 '}

  [ ! -e /tmp/noudp ] && echo "$ENDPOINT" > /tmp/best_endpoint
}

# WARP or WireProxy installation
install() {
  # Select the best MTU in the background
  { best_mtu; }&

  #Backend preferred WARP Endpoint
  { best_endpoint; }&

  # Download two versions of wireguard-go in the background
  { wget --no-check-certificate $STACK -qO /tmp/wireguard-go-20230223 https://gitlab.com/fscarmen/warp/-/raw/main/wireguard-go/wireguard-go-linux-$ ARCHITECTURE-20230223 && chmod +x /tmp/wireguard-go-20230223; }&
  { wget --no-check-certificate $STACK -qO /tmp/wireguard-go-20201118 https://gitlab.com/fscarmen/warp/-/raw/main/wireguard-go/wireguard-go-linux-$ ARCHITECTURE-20201118 && chmod +x /tmp/wireguard-go-20201118; }&
# Based on the previously judged situation, let the user choose to use wireguard kernel or wireguard-go serverd; if it is the wireproxy solution, skip this step
  if [ "$IS_PUFFERFFISH" != 'is_pufferffish' ]; then
    case "$KERNEL_ENABLE@$WIREGUARD_GO_ENABLE" in
      0@0 )
        error " $(text 3) "
        ;;
      0@1 )
        KERNEL_OR_WIREGUARD_GO='wireguard-go with reserved' && info "\n $(text 179) "
        ;;
      1@0 )
        KERNEL_OR_WIREGUARD_GO='wireguard kernel' && info "\n $(text 179) "
        ;;
      1@1 )
        hint "\n $(text 180) \n" && reading " $(text 50) " KERNEL_OR_WIREGUARD_GO_CHOOSE
        KERNEL_OR_WIREGUARD_GO='wireguard kernel' && [ "$KERNEL_OR_WIREGUARD_GO_CHOOSE" = 2 ] && KERNEL_OR_WIREGUARD_GO='wireguard-go with reserved'
    esac
  fi
# Warp working mode: global or non-global, not selected under dnsmasq / wireproxy scheme
  if [[ "$IS_ANEMONE" != 'is_anemone' && "$IS_PUFFERFFISH" != 'is_pufferffish' ]]; then
    [ -z "$GLOBAL_OR_NOT_CHOOSE" ] && hint "\n $(text 182) \n" && reading " $(text 50) " GLOBAL_OR_NOT_CHOOSE
    GLOBAL_OR_NOT="$(text 184)" && [ "$GLOBAL_OR_NOT_CHOOSE" = 2 ] && GLOBAL_OR_NOT="$(text 185)"
  fi

  # WireProxy prohibits repeated installation, custom Port
  if [ "$IS_PUFFERFFISH" = 'is_pufferffish' ]; then
    ss -nltp | grep -q wireproxy && error " $(text 166) " || input_port

  # iptables prohibits repeated installation, not applicable to IPv6 only VPS
  elif [ "$IS_ANEMONE" = 'is_anemone' ]; then
    [ -e /etc/dnsmasq.d/warp.conf ] && error " $(text 167) "
    [ "$m" = 0 ] && error " $(text 147) " || CONF=${CONF1[n]}
  fi
  # If the CONF parameter is not 3 or 4 digits, the correct configuration parameters cannot be detected and the script will exit.
  [[ "$IS_PUFFERFFISH" != 'is_pufferffish' && "${#CONF}" != [34] ]] && error " $(text 172) "

  # First delete the previously installed files that may cause failure
  rm -rf /usr/bin/wireguard-go /etc/wireguard/warp-account.conf

  # Ask if you have a WARP+ or Teams account
  [ -z "$CHOOSE_TYPE" ] && hint "\n $(text 132) \n" && reading " $(text 50) " CHOOSE_TYPE
  case "$CHOOSE_TYPE" in
    2 )
      INPUT_LICENSE=1 && input_license
      ;;
    3)
      [ -z "$CHOOSE_TEAMS" ] && hint "\n $(text 127) \n" && reading " $(text 50) " CHOOSE_TEAMS
      case "$CHOOSE_TEAMS" in
        1 )
          input_url_token url
          ;;
        2 )
          :
          ;;
        3)
          input_url_token input
          ;;
        * )
          input_url_token share
      esac
  esac

  #Select to use IPv4/IPv6 network first
  [ "$IS_PUFFERFFISH" != 'is_pufferffish' ] && hint "\n $(text 105) \n" && reading " $(text 50) " PRIORITY

  # Script start time
  start=$(date +%s)
# If it is an IPv6 only machine, back up the original dns file and then use nat64
  [ "$m" = 0 ] && cp -f /etc/resolv.conf{,.origin} && echo -e "nameserver 2a00:1098:2b::1\nnameserver 2a01:4f9:c010:3f02::1\ nnameserver 2a01:4f8:c2c:123f::1\nnameserver 2a00:1098:2c::1" > /etc/resolv.conf
# Register a WARP account (the warp-account.conf file will be generated to save the account information)
  {
    # If you install WireProxy, try to download the latest official version. If the official WireProxy download fails, cdn will be used to better support dual stack and mainland VPS. and add execution permissions
    if [ "$IS_PUFFERFFISH" = 'is_pufferffish' ]; then
      wireproxy_latest=$(wget --no-check-certificate -qO- -T1 -t1 $STACK "${GH_PROXY}https://api.github.com/repos/pufferffish/wireproxy/releases/latest" | awk -F [v\"] '/tag_name/{print $5; exit}')
      wireproxy_latest=${wireproxy_latest:-'1.0.9'}
      wget --no-check-certificate -T10 -t1 $STACK -O wireproxy.tar.gz ${GH_PROXY}https://github.com/pufferffish/wireproxy/releases/download/v"$wireproxy_latest"/wireproxy_linux_"$ ARCHITECTURE".tar.gz ||
      wget --no-check-certificate $STACK -O wireproxy.tar.gz https://gitlab.com/fscarmen/warp/-/raw/main/wireproxy/wireproxy_linux_"$ARCHITECTURE".tar.gz
      [ -x "$(type -p tar)" ] ${PACKAGE_INSTALL[int]} tar 2>/dev/null ( ${PACKAGE_UPDATE[int]}; ${PACKAGE_INSTALL[int]} tar 2>/dev/null )
      tar xzf wireproxy.tar.gz -C /usr/bin/; rm -f wireproxy.tar.gz
    fi
# Register a WARP account (warp-account.conf uses default values ​​for speed). If you have a WARP+ account, modify the license and upgrade, and save the device name and other information to /etc/wireguard/info.log
    mkdir -p /etc/wireguard/ >/dev/null 2>&1
    warp_api "register" > /etc/wireguard/warp-account.conf "$LICENSE" 2>/dev/null
# Have a License to upgrade your account
    if [ -n "$LICENSE" ]; then
      local UPDATE_RESULT=$(warp_api "license" "/etc/wireguard/warp-account.conf" "$LICENSE")
      if grep -q '"warp_plus": true' <<< "$UPDATE_RESULT"; then
        [ -n "$NAME" ] && warp_api "name" "/etc/wireguard/warp-account.conf" "" "$NAME" >/dev/null 2>&1
        sed -i "s#\([ ]\+\"license\": \"\).*#\1$LICENSE\"#g; s#\"account_type\".*#\"account_type\": \"limited\",#g; s#\([ ]\+\"name\": \"\).*#\1$NAME\"#g" /etc/wireguard/warp-account.conf
        echo "$LICENSE" > /etc/wireguard/license
        echo -e "Device name : $NAME" > /etc/wireguard/info.log
      elif grep -q 'Invalid license' <<< "$UPDATE_RESULT"; then
        warning "\n $(text 169) \n"
      elif grep -q 'Too many connected devices.' <<< "$UPDATE_RESULT"; then
        warning "\n $(text 36) \n"
      else
        warning "\n $(text 42) \n"
      fi
    fi
# Generate WireGuard configuration file (warp.conf)
    if [ -s /etc/wireguard/warp-account.conf ]; then
      cat > /etc/wireguard/warp.conf <<EOF
[Interface]
PrivateKey = $(grep 'private_key' /etc/wireguard/warp-account.conf | cut -d\" -f4)
Address = 172.16.0.2/32
Address = $(grep '"v6.*"$' /etc/wireguard/warp-account.conf | cut -d\" -f4)/128
DNS=8.8.8.8
MTU = 1280
#Reserved = $(warp_api "convert" "/etc/wireguard/warp-account.conf" "" "" "" "" "file")
#Table = off
#PostUp = /etc/wireguard/NonGlobalUp.sh
#PostDown = /etc/wireguard/NonGlobalDown.sh

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = 0.0.0.0/0
AllowedIPs = ::/0
Endpoint = engage.cloudflareclient.com:2408
EOF
# If the wireproxy solution is not used, first determine whether the wireguard kernel must be used. If not, modify the wg-quick file to use the wireguard-go reserved version.
  if [ "$IS_PUFFERFFISH" != 'is_pufferffish' ]; then
    if [ "$WIREGUARD_GO_ENABLE" = '1' ]; then
      # Then download the wireguard-go reserved version based on the wireguard-tools version: wg < v1.0.20210223, wg-go-reserved = v0.0.20201118-reserved; wg >= v1.0.20210223, wg-go-reserved = v0.0.20230223- reserved
      local WIREGUARD_TOOLS_VERSION=$(wg --version | sed "s#.* v1\.0\.\([0-9]\+\) .*#\1#g")
      [[ "$WIREGUARD_TOOLS_VERSION" < 20210223 ]] && mv /tmp/wireguard-go-20201118 /usr/bin/wireguard-go || mv /tmp/wireguard-go-20230223 /usr/bin/wireguard-go
      rm -f /tmp/wireguard-go-*
      if [ "$KERNEL_ENABLE" = '1' ]; then
        cp -f /usr/bin/wg-quick{,.origin}
        cp -f /usr/bin/wg-quick{,.reserved}
        grep -q '^#[[:space:]]*add_if' /usr/bin/wg-quick.reserved || sed -i '/add_if$/ {s/^/# /; N; s/\n /&\twireguard-go "$INTERFACE"\n/}' /usr/bin/wg-quick.reserved
[ "$KERNEL_OR_WIREGUARD_GO" = 'wireguard-go with reserved' ] && cp -f /usr/bin/wg-quick.reserved /usr/bin/wg-quick
      else
        grep -q '^#[[:space:]]*add_if' /usr/bin/wg-quick || sed -i '/add_if$/ {s/^/# /; N; s/\n/& \twireguard-go "$INTERFACE"\n/}' /usr/bin/wg-quick
      fi
    fi
  fi

  wait

  # If all endpoints cannot be connected, the script will terminate.
  if [ -e /tmp/noudp ]; then
    rm -f /tmp/{noudp,best_mtu,best_endpoint} /usr/bin/wireguard-go /etc/wireguard/{wgcf-account.conf,warp-temp.conf,warp-account.conf,warp_unlock.sh,warp .conf.bak,warp.conf,up,proxy.conf.bak,proxy.conf,menu.sh,license,language,info-temp.log,info.log,down,account-temp.conf,NonGlobalUp.sh ,NonGlobalDown.sh}
    [[ -e /etc/wireguard && -z "$(ls -A /etc/wireguard/)" ]] && rmdir /etc/wireguard
    error "\n $(text 188) \n"
  fi
# WARP configuration modification
  MODIFY014="s/\(DNS[ ]\+=[ ]\+\).*/\12606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844, 1.1.1.1,8.8.8.8,8.8.4.4/g;7 s/^/PostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/; s/^.*\:\:\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY016="s/\(DNS[ ]\+=[ ]\+\).*/\12606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844, 1.1.1.1,8.8.8.8,8.8.4.4/g;7 s/^/PostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/; s/^.*0\.\0\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY01D="s/\(DNS[ ]\+=[ ]\+\).*/\12606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844, 1.1.1.1,8.8.8.8,8.8.4.4/g;7 s/^/PostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/; \$a\PersistentKeepalive = 30"
MODIFY104="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860: :8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\n\n/; s/^.*\:\:\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY106="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860: :8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\n\n/; s/^.*0\.\0\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY10D="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860: :8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\n\n/; \$a\PersistentKeepalive = 30"
MODIFY114="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860: :8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\nPostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/;s/^.*\:\:\/0/#&/g;\$a\PersistentKeepalive = 30"
# Change the confirmed teams private key and address6 to Teams account information. If not confirmed, the upgrade will not be performed.
    [ "$CHOOSE_TEAMS" = '2' ] && input_url_token token
    if [ "${CONFIRM_TEAMS_INFO,,}" = 'y' ]; then
      backup_restore_delete backup warp
      sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ]\+=[ ]\+\).*\( /128$\)#\1$ADDRESS6\2#g; s#\(.*Reserved[ ]\+=[ ]\+\).*#\1$CLIENT_ID#g" /etc/wireguard/warp. conf
      [ "$CHOOSE_TEAMS" = '2' ] && echo "$TEAMS" > /etc/wireguard/warp-account.conf || sed -i "s#\(\"private_key\":[ ]\+\"\ ).*\(\"\)#\1$PRIVATEKEY\2#; s#\(\"client_id\":[ ]\+\"\).*\(\"\)#\1$RESERVED\ 2#; s#\(\"v6\":[ ]\+\"\)[0-9a-f].*\(\"\)#\1$ADDRESS6\2#" /etc/wireguard/ warp-account.conf
      echo "$TEAMS" > /etc/wireguard/info.log
    fi

    # Create a soft link shortcut for re-execution. You can use the warp command to set the default language when running again.
    mv -f $0 /etc/wireguard/menu.sh >/dev/null 2>&1
    chmod +x /etc/wireguard/menu.sh >/dev/null 2>&1
    ln -sf /etc/wireguard/menu.sh /usr/bin/warp && info " $(text 38) "
    echo "$L" >/etc/wireguard/language
# Automatically flash until successful (warp bug, sometimes the IP address cannot be obtained), reset the previous related variable values, record the new IPv4 and IPv6 addresses and ownership, IPv4 / IPv6 priority level
    info " $(text 39) "
    unset IP4 IP6 WAN4 WAN6 COUNTRY4 COUNTRY6 ASNORG4 ASNORG6 TRACE4 TRACE6 PLUS4 PLUS6 WARPSTATUS4 WARPSTATUS6
    net no_output

    # If Teams is successfully upgraded, modify the configuration file according to the new account information and log out the old account; if it fails, revert to the original account
    if [[ "$TRACE4$TRACE6" =~ on|plus ]]; then
      warp_api "cancel" "/etc/wireguard/warp-account.conf.bak" >/dev/null 2>&1
      backup_restore_delete delete
    else
      ACCOUNT_CHANGE_FAILED='Teams' && warning "\n $(text 187) \n"
      backup_restore_delete restore warp
      unset CONFIRM_TEAMS_INFO
      net
    fi

    # Show IPv4 / IPv6 priority results
    result_priority

    # Set up warp to start at boot
    ${SYSTEMCTL_ENABLE[int]} >/dev/null 2>&1
# Result prompts, script running time, number of times statistics
    end=$(date +%s)
    echo -e "\n============================================ ==================\n"
    info " IPv4: $WAN4 $COUNTRY4 $ASNORG4 "
    info " IPv6: $WAN6 $COUNTRY6 $ASNORG6 "
    info " $(text 41) " && [ -n "$QUOTA" ] && info " $(text 133) "
    info " $PRIORITY_NOW , $(text 186) "
    echo -e "\n============================================ ==================\n"
    hint " $(text 43) \n" && help
    [[ "$TRACE4$TRACE6" = offoff ]] && warning " $(text 44) "
  fi
  }
client_install() {
  settings() {
    # Set to proxy mode. If you have a WARP+ account, modify the license and upgrade
    info " $(text 84) "
    warp-cli --accept-tos registration new >/dev/null 2>&1
    # If registration fails, a free account will be given. Otherwise, upgrade based on whether there is a license.
    if [[ $(warp-cli --accept-tos registration show) =~ 'Error: Missing registration' ]]; then
      [ ! -d /var/lib/cloudflare-warp ] && mkdir -p /var/lib/cloudflare-warp
      echo '{"registration_id":"317b5a76-3da1-469f-88d6-c3b261da9f10","api_token":"11111111-1111-1111-1111-111111111111","secret_key":"CNUysnWWJmFGTkqYtg/wp DfURUWvHB8+U1FLlVAIB0Q=","public_key ":"DuOi83pAIsbJMP3CJpxq6r3LVGHtqLlzybEIvbczRjo=","override_codes":null}' > /var/lib/cloudflare-warp/reg.json
echo '{"own_public_key":"DuOi83pAIsbJMP3CJpxq6r3LVGHtqLlzybEIvbczRjo=","registration_id":"317b5a76-3da1-469f-88d6-c3b261da9f10","time_created":{"secs_since_epoch":1692163041 ,"nanos_since_epoch":81073202},"interface": {"v4":"172.16.0.2","v6":"2606:4700:110:8d4e:cef9:30c2:6d4a:f97b"},"endpoints":[{"v4":"162.159.192.7:2408 ","v6":"[2606:4700:d0::a29f:c007]:2408"},{"v4":"162.159.192.7:500","v6":"[2606:4700:d0:: a29f:c007]:500"},{"v4":"162.159.192.7:1701","v6":"[2606:4700:d0::a29f:c007]:1701"},{"v4":" 162.159.192.7:4500","v6":"[2606:4700:d0::a29f:c007]:4500"}], "public_key":"bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=","account":{"account_type ":"free","id":"7e0e6c80-24c5-49ba-ba3d-087f45fcd1e9","license":"n01H3Cf4-3Za40C7b-5qOs0c42"},"policy":null,"valid_until":"2023-08- 17T05:17:21.081073724Z","alternate_networks":null,"dex_tests":null,"custom_cert_settings":null}' > /var/lib/cloudflare-warp/conf.json
fi
    ${PACKAGE_UPDATE[int]}
    ${PACKAGE_INSTALL[int]} cloudflare-warp
    [ "$(systemctl is-active warp-svc)" != active ] && ( systemctl start warp-svc; sleep 2 )
    settings
  elif [[ "$CLIENT" = '2' && $(warp-cli --accept-tos status 2>/dev/null) =~ 'Registration missing' ]]; then
    [ "$(systemctl is-active warp-svc)" != active ] && ( systemctl start warp-svc; sleep 2 )
    settings
  else
    warning " $(text 85) "
  fi

  # Create a soft link shortcut for re-execution. You can use the warp command to set the default language when running again.
  mv -f $0 /etc/wireguard/menu.sh >/dev/null 2>&1
  chmod +x /etc/wireguard/menu.sh >/dev/null 2>&1
  ln -sf /etc/wireguard/menu.sh /usr/bin/warp && info " $(text 38) "
  echo "$L" >/etc/wireguard/language

  # Result prompts, script running time, number of times statistics
  local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk '/type/{print $3}')
  [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && check_quota client
if [ "$IS_LUBAN" = 'is_luban' ]; then
    end=$(date +%s)
    echo -e "\n============================================ ==================\n"
    info " $(text 94)\n WARP$CLIENT_AC IPv4: $CFWARP_WAN4 $CFWARP_COUNTRY4 $CFWARP_ASNORG4\n WARP$CLIENT_AC IPv6: $CFWARP_WAN6 $CFWARP_COUNTRY6 $CFWARP_ASNORG6 "
  else
    ip_case d client
    end=$(date +%s)
    echo -e "\n============================================ ==================\n"
    info " $(text 94)\n $(text 27): $CLIENT_SOCKS5\n WARP$CLIENT_AC IPv4: $CLIENT_WAN4 $CLIENT_COUNTRY4 $CLIENT_ASNORG4\n WARP$CLIENT_AC IPv6: $CLIENT_WAN6 $CLIENT_COUNTRY6 $CLIENT_ASNORG6 "
  fi

  [ -n "$QUOTA" ] && info " $(text 63): $QUOTA "
  echo -e "\n============================================ ==================\n"
  hint " $(text 43) \n" && help
}

# iptables+dnsmasq+ipset solution, IPv6 only not applicable
stream_solution() {
  [ "$m" = 0 ] && error " $(text 147) "
echo -e "\n============================================ ==================\n"
  info " $(text 139) "
  echo -e "\n============================================ ==================\n"
  hint " 1. $(text 48) "
  [ "$OPTION" != e ] && hint " 0. $(text 49) \n" || hint " 0. $(text 76) \n"
  reading " $(text 50) " IPTABLES
  case "$IPTABLES" in
    1 )
      CONF=${CONF1[n]}; IS_ANEMONE=is_anemone; install
      ;;
    0 )
      [ "$OPTION" != e ] && menu || exit
      ;;
    * )
      warning " $(text 51) [0-1]"; sleep 1; stream_solution
  esac
}

# wireproxy scheme
wireproxy_solution() {
  ss -nltp | grep -q wireproxy && error " $(text 166) "
echo -e "\n============================================ ==================\n"
  info " $(text 165) "
  echo -e "\n============================================ ==================\n"
  hint " 1. $(text 48) "
  [ "$OPTION" != w ] && hint " 0. $(text 49) \n" || hint " 0. $(text 76) \n"
  reading " $(text 50) " WIREPROXY_CHOOSE
  case "$WIREPROXY_CHOOSE" in
    1 )
      IS_PUFFERFFISH=is_pufferffish; install
      ;;
    0 )
      [ "$OPTION" != w ] && menu || exit
      ;;
    * )
      warning " $(text 51) [0-1]"; sleep 1; wireproxy_solution
  esac
}

# Check WARP+ balance traffic interface
check_quota() {
  local CHECK_TYPE="$1"

  if [ "$CHECK_TYPE" = 'client' ]; then
    QUOTA=$(warp-cli --accept-tos registration show 2>/dev/null | awk -F' ' '/Quota/{print $NF}')
  elif [ -e /etc/wireguard/warp-account.conf ]; then
    QUOTA=$(warp_api "device" "/etc/wireguard/warp-account.conf" | awk '/quota/{print $NF}' | sed "s#,##")
  fi
# Some systems do not rely on bc, so you cannot use $(echo "scale=2; $QUOTA/1000000000000000" | bc) for two decimals. Instead, use the method of counting characters from right to left.
  if [[ "$QUOTA" != 0 && "$QUOTA" =~ ^[0-9]+$ && "$QUOTA" -ge 1000000 ]]; then
    CONVERSION=("1000000000000000000" "1000000000000000" "1000000000000" "1000000000" "1000000")
    UNIT=("EB" "PB" "TB" "GB" "MB")
    for o in ${!CONVERSION[*]}; do
      [[ "$QUOTA" -ge "${CONVERSION[o]}" ]] && break
    done

    QUOTA_INTEGER=$(( $QUOTA / ${CONVERSION[o]} ))
    QUOTA_DECIMALS=${QUOTA:0-$(( ${#CONVERSION[o]} - 1 )):2}
    QUOTA="$QUOTA_INTEGER.$QUOTA_DECIMALS ${UNIT[o]}"
  fi
}
# When changing accounts, backup, restoration and deletion of original account information
backup_restore_delete() {
  local EXECUTE="$1"
  local WARP_ACCOUNT_TYPE="$2"
  if [ "$EXECUTE" = backup ]; then
    case "$WARP_ACCOUNT_TYPE" in
      warp)
        [ -e /etc/wireguard/warp.conf ] && cp -f /etc/wireguard/warp.conf{,.bak}
        [ -e /etc/wireguard/warp-account.conf ] && cp -f /etc/wireguard/warp-account.conf{,.bak}
        [ -e /etc/wireguard/info.log ] && mv -f /etc/wireguard/info.log /etc/wireguard/info.log.bak
        [ -e /etc/wireguard/license ] && mv -f /etc/wireguard/license{,.bak}
        ;;
      wireproxy )
        [ -e /etc/wireguard/warp.conf ] && cp -f /etc/wireguard/warp.conf{,.bak}
        [ -e /etc/wireguard/warp-account.conf ] && cp -f /etc/wireguard/warp-account.conf{,.bak}
        [ -e /etc/wireguard/info.log ] && mv -f /etc/wireguard/info.log /etc/wireguard/info.log.bak
        [ -e /etc/wireguard/license ] && mv -f /etc/wireguard/license{,.bak}
        [ -e /etc/wireguard/proxy.conf ] && cp -f /etc/wireguard/proxy.conf{,.bak}
        ;;
client )
        [ -e /etc/wireguard/license ] && mv -f /etc/wireguard/license{,.bak}
    esac
  elif [ "$EXECUTE" = restore ]; then
    case "$WARP_ACCOUNT_TYPE" in
      warp)
        [ -e /etc/wireguard/info.log ] && rm -f /etc/wireguard/info.log
        [ -e /etc/wireguard/warp.conf.bak ] && mv -f /etc/wireguard/warp.conf.bak /etc/wireguard/warp.conf
        [ -e /etc/wireguard/warp-account.conf.bak ] && mv -f /etc/wireguard/warp-account.conf.bak /etc/wireguard/warp-account.conf
        [ -e /etc/wireguard/info.log.bak ] && mv -f /etc/wireguard/info.log.bak /etc/wireguard/info.log
        [ -e /etc/wireguard/license.bak ] && mv -f /etc/wireguard/license.bak /etc/wireguard/license
        ;;
      wireproxy )
        [ -e /etc/wireguard/info.log ] && rm -f /etc/wireguard/info.log
        [ -e /etc/wireguard/warp.conf.bak ] && mv -f /etc/wireguard/warp.conf.bak /etc/wireguard/warp.conf
[ -e /etc/wireguard/warp-account.conf.bak ] && mv -f /etc/wireguard/warp-account.conf.bak /etc/wireguard/warp-account.conf
        [ -e /etc/wireguard/info.log.bak ] && mv -f /etc/wireguard/info.log.bak /etc/wireguard/info.log
        [ -e /etc/wireguard/license.bak ] && mv -f /etc/wireguard/license.bak /etc/wireguard/license
        [ -e /etc/wireguard/proxy.conf.bak ] && mv -f /etc/wireguard/proxy.conf.bak /etc/wireguard/proxy.conf
        ;;
      client )
        [ -e /etc/wireguard/license.bak ] && mv -f /etc/wireguard/license.bak /etc/wireguard/license
    esac
  elif [ "$EXECUTE" = delete ]; then
    rm -f /etc/wireguard/*.bak
  fi
}
# Change to free account
change_to_free() {
  # Client two mode upgrade plus process: 1. Cancel the original account, delete the original account's License (if any), and stop the service; 2. Register a new account and display the results
  if [ "$UPDATE_ACCOUNT" = client ]; then
    # Process 1: Cancel the original account, delete the license of the original account (if any), and stop the service
    local CLIENT_MODE=$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i +1)}}')
    warp-cli --accept-tos registration delete >/dev/null 2>&1
    [ -e /etc/wireguard/license ] && rm -f /etc/wireguard/license
    [ "$CLIENT_MODE" = 'Warp' ] && rule_del >/dev/null 2>&1

    # Process 2: Register a new account and display the results
    warp-cli --acc
