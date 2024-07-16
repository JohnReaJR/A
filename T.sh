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
C[54]="To brush WARP+ traffic, you can choose the mature works of the following three authors, please be familiar with them:\n • [ALIILAPRO], address [https://github.com/ALIILAPRO/warp-plus-cloudflare]\n • [mixool], at [https://github.com/mixool/across/tree/master/wireguard]\n • [SoftCreatR], at [https://github.com/SoftCreatR/warp-up]\n Download address: https://1.1.1.1/, visit and take care of Apple's external ID\n Obtain the WARP+ ID and fill it in below. Method: Menu 3 in the upper right corner of the App-->Advanced-->Diagnosis-->ID\n Important. : There is no increase in traffic after brushing the script. Processing: Menu 3 in the upper right corner --> Advanced --> Connection options --> Reset encryption key\n Best to use screen to run tasks in the background"
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
E[126]="\$(date +'%F %T') Try \${i}. Failed. IPv\$NF: \$WAN \$COUNTRY \$ASNORG. Retry after \${j} seconds . Brush ip running time:\$DAY days \$HOUR hours \$MIN minutes \$SEC seconds"
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

  for g in "${!DEPS_CHECK[@]}"; do
    [ ! -x "$(type -p ${DEPS_CHECK[g]})" ] && [[ ! "${DEPS[@]}" =~ "${DEPS_INSTALL[g]}" ]] && DEPS+=( ${DEPS_INSTALL[g]})
  done

  if [ "${#DEPS[@]}" -ge 1 ]; then
    info "\n $(text 7) ${DEPS[@]} \n"
    ${PACKAGE_UPDATE[int]} >/dev/null 2>&1
    ${PACKAGE_INSTALL[int]} ${DEPS[@]} >/dev/null 2>&1
  else
    info "\n $(text 8) \n"
  fi

  PING6='ping -6' && [ -x "$(type -p ping6)" ] && PING6='ping6'
}
