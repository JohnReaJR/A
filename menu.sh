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

# 自定义字体彩色，read 函数
warning() { echo -e "\033[31m\033[01m$*\033[0m"; }  # 红色
error() { echo -e "\033[31m\033[01m$*\033[0m" && exit 1; }  # 红色
info() { echo -e "\033[32m\033[01m$*\033[0m"; }   # 绿色
hint() { echo -e "\033[33m\033[01m$*\033[0m"; }   # 黄色
reading() { read -rp "$(info "$1")" "$2"; }
text() { grep -q '\$' <<< "${E[$*]}" && eval echo "\$(eval echo "\${${L}[$*]}")" || eval echo "\${${L}[$*]}"; }

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


# 获取 warp 账户信息
warp_api(){
  local RUN=$1
  local FILE_PATH=$2
  local WARP_LICENSE=$3
  local WARP_DEVICE_NAME=$4
  local WARP_TEAM_TOKEN=$5
  local WARP_CONVERT=$6
  local WARP_CONVERT_MODE=$7
  local WARP_API_URL="warp.cloudflare.now.cc"

  if [ -s "$FILE_PATH" ]; then
    # Teams 账户文件
    if grep -q 'xml version' $FILE_PATH; then
      local WARP_DEVICE_ID=$(grep 'correlation_id' $FILE_PATH | sed "s#.*>\(.*\)<.*#\1#")
      local WARP_TOKEN=$(grep 'warp_token' $FILE_PATH | sed "s#.*>\(.*\)<.*#\1#")
      local WARP_CLIENT_ID=$(grep 'client_id' $FILE_PATH | sed "s#.*client_id&quot;:&quot;\([^&]\{4\}\)&.*#\1#")

    # 官方 api 文件
    elif grep -q 'client_id' $FILE_PATH; then
      local WARP_DEVICE_ID=$(grep -m1 '"id' "$FILE_PATH" | cut -d\" -f4)
      local WARP_TOKEN=$(grep '"token' "$FILE_PATH" | cut -d\" -f4)
      local WARP_CLIENT_ID=$(grep 'client_id' "$FILE_PATH" | cut -d\" -f4)

    # client 文件，默认存放路径为 /var/lib/cloudflare-warp/reg.json
    elif grep -q 'registration_id' $FILE_PATH; then
      local WARP_DEVICE_ID=$(cut -d\" -f4 "$FILE_PATH")
      local WARP_TOKEN=$(cut -d\" -f8 "$FILE_PATH")

    # wgcf 文件，默认存放路径为 /etc/wireguard/wgcf-account.toml
    elif grep -q 'access_token' $FILE_PATH; then
      id=$(grep 'device_id' "$FILE_PATH" | cut -d\' -f2)
      token=$(grep 'access_token' "$FILE_PATH" | cut -d\' -f2)

    # warp-go 文件，默认存放路径为 /opt/warp-go/warp.conf
    elif grep -q 'PrivateKey' $FILE_PATH; then
      id=$(awk -F' *= *' '/^Device/{print $2}' "$FILE_PATH")
      token=$(awk -F' *= *' '/^Token/{print $2}' "$FILE_PATH")
    fi
  fi
  
  case "$RUN" in
    register )
      curl -m5 -sL "https://${WARP_API_URL}/?run=register&team_token=${WARP_TEAM_TOKE}"
      ;;
    device )
      curl -m5 -sL "https://${WARP_API_URL}/?run=device&device_id=${WARP_DEVICE_ID}&token=${WARP_TOKEN}"
      ;;
    name )
      curl -m5 -sL "https://${WARP_API_URL}/?run=name&device_id=${WARP_DEVICE_ID}&token=${WARP_TOKEN}&device_name=${WARP_DEVICE_NAME}"
      ;;
    license )
      curl -m5 -sL "https://${WARP_API_URL}/?run=license&device_id=${WARP_DEVICE_ID}&token=${WARP_TOKEN}&license=${WARP_LICENSE}"
      ;;
    cancel )
      # 只保留Teams账户，删除其他账户
      grep -oqE '"id":[ ]+"t.[A-F0-9a-f]{8}-' $FILE_PATH || curl -m5 -sL "https://${WARP_API_URL}/?run=cancel&device_id=${WARP_DEVICE_ID}&token=${WARP_TOKEN}"
      ;;
    convert )
      if [ "$WARP_CONVERT_MODE" = decode ]; then
        curl -m5 -sL "https://${WARP_API_URL}/?run=id&convert=${WARP_CONVERT}" | grep -A4 'reserved' | sed 's/.*\(\[.*\)/\1/g; s/],/]/' | tr -d '[:space:]'
      elif [ "$WARP_CONVERT_MODE" = encode ]; then
        curl -m5 -sL "https://${WARP_API_URL}/?run=id&convert=${WARP_CONVERT//[ \[\]]}" | awk -F '"' '/client_id/{print $(NF-1)}'
      elif [ "$WARP_CONVERT_MODE" = file ]; then
        if grep -sq '"reserved"' $FILE_PATH; then
          grep -A4 'reserved' $FILE_PATH | sed 's/.*\(\[.*\)/\1/g; s/],/]/' | tr -d '[:space:]'
        else
          local WARP_CONVERT=$(awk -F '"' '/"client_id"/{print $(NF-1)}' $FILE_PATH)
          curl -m5 -sL "https://${WARP_API_URL}/?run=id&convert=${WARP_CONVERT}" | grep -A4 'reserved' | sed 's/.*\(\[.*\)/\1/g; s/],/]/' | tr -d '[:space:]'
        fi
      fi
      ;;
  esac
}

# 聚合 IP api 函数
ip_info() {
  local CHECK_46="$1"
  if [[ "$2" =~ ^[0-9]+$ ]]; then
    local INTERFACE_SOCK5="--proxy socks5h://127.0.0.1:$2"
  elif [[ "$2" =~ ^[[:alnum:]]+$ ]]; then
    local INTERFACE_SOCK5="--interface $2"
  fi
  local IS_UNINSTALL="$3"

  [ "$L" = 'C' ] && IS_CHINESE=${IS_CHINESE:-'?lang=zh-CN'}
  [ "$CHECK_46" = '6' ] && CHOOSE_IP_API='https://api-ipv6.ip.sb/geoip' || CHOOSE_IP_API='https://api-ipv4.ip.sb/geoip'
  IP_TRACE=$(curl --retry 2 -ksm5 $INTERFACE_SOCK5 https://www.cloudflare.com/cdn-cgi/trace | awk -F '=' '/^warp=/{print $NF}')
  if [ -n "$IP_TRACE" ]; then
    [ "$IS_UNINSTALL" = 'is_uninstall' ] && local API_IP=$(curl -$CHECK_46 --retry 2 -ksm5 --user-agent Mozilla https://api.ip.sb/ip) || local API_IP=$(curl --retry 2 -ksm5 $INTERFACE_SOCK5 --user-agent Mozilla $CHOOSE_IP_API | sed 's/.*"ip":"\([^"]\+\)".*/\1/')
    [ -n "$API_IP" ] && local IP_JSON=$(curl --retry 2 -ksm5 https://ip.forvps.gq/${API_IP}${IS_CHINESE})
    IP_JSON=${IP_JSON:-"$(curl --retry 3 -ks${CHECK_46}m5 $INTERFACE_SOCK5 --user-agent Mozilla https://ifconfig.co/json)"}

    if [ -n "$IP_JSON" ]; then
      local WAN=$(sed -En 's/.*"(ip|query)":[ ]*"([^"]+)".*/\2/p' <<< "$IP_JSON")
      local COUNTRY=$(sed -En 's/.*"country":[ ]*"([^"]+)".*/\1/p' <<< "$IP_JSON")
      local ASNORG=$(sed -En 's/.*"(isp|asn_org)":[ ]*"([^"]+)".*/\2/p' <<< "$IP_JSON")
    fi
  fi

  echo -e "trace=$IP_TRACE@\nip=$WAN@\ncountry=$COUNTRY@\nasnorg=$ASNORG\n"
}

# 根据场景传参调用自定义 IP api
ip_case() {
  local CHECK_46="$1"
  [ -n "$2" ] && local CHECK_TYPE="$2"
  [ "$3" = 'non-global' ] && local CHECK_NONGLOBAL='warp'

  if [ "$CHECK_TYPE" = "warp" ]; then
    fetch_4() {
      unset IP_RESULT4 COUNTRY4 ASNORG4 TRACE4 IS_UNINSTALL
      local IS_UNINSTALL=${IS_UNINSTALL:-"$1"}
      local IP_RESULT4=$(ip_info 4 "$CHECK_NONGLOBAL" "$IS_UNINSTALL")
      TRACE4=$(expr "$IP_RESULT4" : '.*trace=\([^@]*\).*')
      WAN4=$(expr "$IP_RESULT4" : '.*ip=\([^@]*\).*')
      COUNTRY4=$(expr "$IP_RESULT4" : '.*country=\([^@]*\).*')
      ASNORG4=$(expr "$IP_RESULT4" : '.*asnorg=\([^@]*\).*')
    }

    fetch_6() {
      unset IP_RESULT6 COUNTRY6 ASNORG6 TRACE6 IS_UNINSTALL
      local IS_UNINSTALL=${IS_UNINSTALL:-"$1"}
      local IP_RESULT6=$(ip_info 6 "$CHECK_NONGLOBAL" "$IS_UNINSTALL")
      TRACE6=$(expr "$IP_RESULT6" : '.*trace=\([^@]*\).*')
      WAN6=$(expr "$IP_RESULT6" : '.*ip=\([^@]*\).*')
      COUNTRY6=$(expr "$IP_RESULT6" : '.*country=\([^@]*\).*')
      ASNORG6=$(expr "$IP_RESULT6" : '.*asnorg=\([^@]*\).*')
    }

    case "$CHECK_46" in
      4|6 )
        fetch_$CHECK_46
        ;;
      d )
        # 如在非全局模式，根据 AllowedIPs 的 v4、v6 情况再查 ip 信息；如在全局模式下则全部查
        if [ -e /etc/wireguard/warp.conf ] && grep -q '^Table' /etc/wireguard/warp.conf; then
          grep -q "^#.*0\.\0\/0" 2>/dev/null /etc/wireguard/warp.conf || fetch_4
          grep -q "^#.*\:\:\/0" 2>/dev/null /etc/wireguard/warp.conf || fetch_6
        else
          fetch_4
          fetch_6
        fi
        ;;
      u )
        # 卸载的话，使用不同的 IP api
        fetch_4 is_uninstall
        fetch_6 is_uninstall
    esac
  elif [ "$CHECK_TYPE" = "wireproxy" ]; then
    fetch_4() {
      unset IP_RESULT4 WIREPROXY_TRACE4 WIREPROXY_WAN4 WIREPROXY_COUNTRY4 WIREPROXY_ASNORG4 ACCOUNT QUOTA AC
      local IP_RESULT4=$(ip_info 4 "$WIREPROXY_PORT")
      WIREPROXY_TRACE4=$(expr "$IP_RESULT4" : '.*trace=\([^@]*\).*')
      WIREPROXY_WAN4=$(expr "$IP_RESULT4" : '.*ip=\([^@]*\).*')
      WIREPROXY_COUNTRY4=$(expr "$IP_RESULT4" : '.*country=\([^@]*\).*')
      WIREPROXY_ASNORG4=$(expr "$IP_RESULT4" : '.*asnorg=\([^@]*\).*')
    }

    fetch_6() {
      unset IP_RESULT6 WIREPROXY_TRACE6 WIREPROXY_WAN6 WIREPROXY_COUNTRY6 WIREPROXY_ASNORG6 ACCOUNT QUOTA AC
      local IP_RESULT6=$(ip_info 6 "$WIREPROXY_PORT")
      WIREPROXY_TRACE6=$(expr "$IP_RESULT6" : '.*trace=\([^@]*\).*')
      WIREPROXY_WAN6=$(expr "$IP_RESULT6" : '.*ip=\([^@]*\).*')
      WIREPROXY_COUNTRY6=$(expr "$IP_RESULT6" : '.*country=\([^@]*\).*')
      WIREPROXY_ASNORG6=$(expr "$IP_RESULT6" : '.*asnorg=\([^@]*\).*')
    }

    unset WIREPROXY_SOCKS5 WIREPROXY_PORT
    WIREPROXY_SOCKS5=$(ss -nltp | awk '/"wireproxy"/{print $4}')
    WIREPROXY_PORT=$(cut -d: -f2 <<< "$WIREPROXY_SOCKS5")

    case "$CHECK_46" in
      4|6 )
        fetch_$CHECK_46
        WIREPROXY_ACCOUNT=' Free' && [ "$(eval echo "\$WIREPROXY_TRACE$CHECK_46")" = plus ] && [ -s /etc/wireguard/info.log ] && WIREPROXY_ACCOUNT=' Teams' && grep -sq 'Device name' /etc/wireguard/info.log && WIREPROXY_ACCOUNT='+' && check_quota warp
        ;;
      d )
        fetch_4
        fetch_6
        WIREPROXY_ACCOUNT=' Free' && [[ "$WIREPROXY_TRACE4$WIREPROXY_TRACE6" =~ 'plus' ]] && [ -s /etc/wireguard/info.log ] && WIREPROXY_ACCOUNT=' Teams' && grep -sq 'Device name' /etc/wireguard/info.log && WIREPROXY_ACCOUNT='+' && check_quota warp
    esac
  elif [ "$CHECK_TYPE" = "client" ]; then
    fetch_4(){
      unset IP_RESULT4 CLIENT_TRACE4 CLIENT_WAN4 CLIENT_COUNTRY4 CLIENT_ASNORG4 CLIENT_ACCOUNT QUOTA CLIENT_AC
      local IP_RESULT4=$(ip_info 4 "$CLIENT_PORT")
      CLIENT_TRACE4=$(expr "$IP_RESULT4" : '.*trace=\([^@]*\).*')
      CLIENT_WAN4=$(expr "$IP_RESULT4" : '.*ip=\([^@]*\).*')
      CLIENT_COUNTRY4=$(expr "$IP_RESULT4" : '.*country=\([^@]*\).*')
      CLIENT_ASNORG4=$(expr "$IP_RESULT4" : '.*asnorg=\([^@]*\).*')
    }

    fetch_6(){
      unset IP_RESULT6 CLIENT_TRACE6 CLIENT_WAN6 CLIENT_COUNTRY6 CLIENT_ASNORG6 CLIENT_ACCOUNT QUOTA CLIENT_AC
      local IP_RESULT6=$(ip_info 6 "$CLIENT_PORT")
      CLIENT_TRACE6=$(expr "$IP_RESULT6" : '.*trace=\([^@]*\).*')
      CLIENT_WAN6=$(expr "$IP_RESULT6" : '.*ip=\([^@]*\).*')
      CLIENT_COUNTRY6=$(expr "$IP_RESULT6" : '.*country=\([^@]*\).*')
      CLIENT_ASNORG6=$(expr "$IP_RESULT6" : '.*asnorg=\([^@]*\).*')
    }

    unset CLIENT_SOCKS5 CLIENT_PORT
    CLIENT_SOCKS5=$(ss -nltp | awk '/"warp-svc"/{print $4}')
    CLIENT_PORT=$(cut -d: -f2 <<< "$CLIENT_SOCKS5")

    case "$CHECK_46" in
      4|6 )
        fetch_$CHECK_46
        CLIENT_AC=' Free'
        local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk  '/type/{print $3}')
        [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && check_quota client
        ;;
      d )
        fetch_4
        fetch_6
        CLIENT_AC=' Free'
        local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk  '/type/{print $3}')
        [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && check_quota client
    esac
  elif [ "$CHECK_TYPE" = "is_luban" ]; then
    fetch_4(){
      unset IP_RESULT4 CFWARP_COUNTRY4 CFWARP_ASNORG4 CFWARP_TRACE4 CFWARP_WAN4 CLIENT_ACCOUNT QUOTA CLIENT_AC
      local IP_RESULT4=$(ip_info 4 CloudflareWARP)
      CFWARP_TRACE4=$(expr "$IP_RESULT4" : '.*trace=\([^@]*\).*')
      CFWARP_WAN4=$(expr "$IP_RESULT4" : '.*ip=\([^@]*\).*')
      CFWARP_COUNTRY4=$(expr "$IP_RESULT4" : '.*country=\([^@]*\).*')
      CFWARP_ASNORG4=$(expr "$IP_RESULT4" : '.*asnorg=\([^@]*\).*')
    }

    fetch_6(){
      unset IP_RESULT6 CFWARP_COUNTRY6 CFWARP_ASNORG6 CFWARP_TRACE6 CFWARP_WAN6 CLIENT_ACCOUNT QUOTA CLIENT_AC
      local IP_RESULT6=$(ip_info 6 CloudflareWARP)
      CFWARP_TRACE6=$(expr "$IP_RESULT6" : '.*trace=\([^@]*\).*')
      CFWARP_WAN6=$(expr "$IP_RESULT6" : '.*ip=\([^@]*\).*')
      CFWARP_COUNTRY6=$(expr "$IP_RESULT6" : '.*country=\([^@]*\).*')
      CFWARP_ASNORG6=$(expr "$IP_RESULT6" : '.*asnorg=\([^@]*\).*')
    }

    case "$CHECK_46" in
      4|6 )
        fetch_$CHECK_46
        ;;
      d )
        fetch_4
        fetch_6
        local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk  '/type/{print $3}')
        [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && check_quota client
    esac
  fi
}

# 帮助说明
help() { hint " $(text 6) "; }

# 刷 WARP+ 流量
input() {
  reading " $(text 52) " ID
  i=5
  until [[ "$ID" =~ ^[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}$ ]]; do
    (( i-- )) || true
    [ "$i" = 0 ] && error " $(text 29) " || reading " $(text 53) " ID
  done
}

plus() {
  echo -e "\n==============================================================\n"
  info " $(text 54) "
  echo -e "\n==============================================================\n"
  hint " $(text 55) "
  [ "$OPTION" != p ] && hint " 0. $(text 49) \n" || hint " 0. $(text 76) \n"
  reading " $(text 50) " CHOOSEPLUS
  case "$CHOOSEPLUS" in
    1 )
      input
      [ -x "$(type -p git)" ] || ${PACKAGE_INSTALL[int]} git 2>/dev/null
      [ -x "$(type -p python3)" ] || ${PACKAGE_INSTALL[int]} python3 2>/dev/null
      [ -d ~/warp-plus-cloudflare ] || ${GH_PROXY}git clone https://github.com/aliilapro/warp-plus-cloudflare.git
      echo "$ID" | python3 ~/warp-plus-cloudflare/wp-plus.py
      ;;
    2 )
      input
      reading " $(text 57) " MISSION
      MISSION=${MISSION//[^0-9]/}
      bash <(wget --no-check-certificate -qO- -T8 ${GH_PROXY}https://raw.githubusercontent.com/fscarmen/tools/main/warp_plus.sh) $MISSION $ID
      ;;
    3 )
      input
      reading " $(text 57) " MISSION
      MISSION=${MISSION//[^0-9]/}
      bash <(wget --no-check-certificate -qO- -T8 ${GH_PROXY}https://raw.githubusercontent.com/SoftCreatR/warp-up/main/warp-up.sh) --disclaimer --id $ID --iterations $MISSION
      ;;
    0 )
      [ "$OPTION" != p ] && menu || exit
      ;;
    * )
      warning " $(text 51) [0-3] "; sleep 1; plus
  esac
}

# IPv4 / IPv6 优先设置
stack_priority() {
  [ "$OPTION" = s ] && case "$PRIORITY_SWITCH" in
    4 )
      PRIORITY=1
      ;;
    6 )
      PRIORITY=2
      ;;
    d )
      :
      ;;
    * )
      hint "\n $(text 105) \n" && reading " $(text 50) " PRIORITY
  esac

  [ -e /etc/gai.conf ] && sed -i '/^precedence \:\:ffff\:0\:0/d;/^label 2002\:\:\/16/d' /etc/gai.conf
  case "$PRIORITY" in
    1 )
      echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf
      ;;
    2 )
      echo "label 2002::/16   2" >> /etc/gai.conf
      ;;
  esac
}

# IPv4 / IPv6 优先结果
result_priority() {
  PRIO=(0 0)
  if [ -e /etc/gai.conf ]; then
    grep -qsE "^precedence[ ]+::ffff:0:0/96[ ]+100" /etc/gai.conf && PRIO[0]=1
    grep -qsE "^label[ ]+2002::/16[ ]+2" /etc/gai.conf && PRIO[1]=1
  fi
  case "${PRIO[*]}" in
    '1 0' )
      PRIO=4
      ;;
    '0 1' )
      PRIO=6
      ;;
    * )
      [[ "$(curl -ksm8 --user-agent Mozilla https://www.cloudflare.com/cdn-cgi/trace | awk -F '=' '/^ip/{print $NF}')" =~ ^([0-9]{1,3}\.){3} ]] && PRIO=4 || PRIO=6
  esac
  PRIORITY_NOW=$(text 97)

  # 如是快捷方式切换优先级别的话，显示结果
  [ "$OPTION" = s ] && hint "\n $PRIORITY_NOW \n"
}

# 更换 Netflix IP 时确认期望区域
input_region() {
  [ -n "$NF" ] && REGION=$(curl --user-agent "${UA_Browser}" -$NF $GLOBAL -fs --max-time 10 --write-out "%{redirect_url}" --output /dev/null "https://www.netflix.com/title/$REGION_TITLE" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g')
  [ -n "$WIREPROXY_PORT" ] && REGION=$(curl --user-agent "${UA_Browser}" -sx socks5h://127.0.0.1:$WIREPROXY_PORT -fs --max-time 10 --write-out "%{redirect_url}" --output /dev/null "https://www.netflix.com/title/$REGION_TITLE" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g')
  [ -n "$INTERFACE" ] && REGION=$(curl --user-agent "${UA_Browser}" $INTERFACE -fs --max-time 10 --write-out "%{redirect_url}" --output /dev/null "https://www.netflix.com/title/$REGION_TITLE" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g')
  REGION=${REGION:-'US'}
  reading " $(text 56) " EXPECT
  until [[ -z "$EXPECT" || "${EXPECT,,}" = 'y' || "${EXPECT,,}" =~ ^[a-z]{2}$ ]]; do
    reading " $(text 56) " EXPECT
  done
  [[ -z "$EXPECT" || "${EXPECT,,}" = 'y' ]] && EXPECT="${REGION^^}"
}

# 更换支持 Netflix WARP IP 改编自 [luoxue-bot] 的成熟作品，地址[https://github.com/luoxue-bot/warp_auto_change_ip]
change_ip() {
  change_stack() {
    hint "\n $(text 124) \n" && reading " $(text 50) " NETFLIX
    NF='4' && [ "$NETFLIX" = 2 ] && NF='6'
  }

  change_warp() {
    warp_restart() {
      warning " $(text 126) "
      wg-quick down warp >/dev/null 2>&1
      [ -s /etc/wireguard/info.log ] && grep -q 'Device name' /etc/wireguard/info.log && local LICENSE=$(cat /etc/wireguard/license) && local NAME=$(awk '/Device name/{print $NF}' /etc/wireguard/info.log)
      warp_api "cancel" "/etc/wireguard/warp-account.conf" >/dev/null 2>&1
      warp_api "register" > /etc/wireguard/warp-account.conf 2>/dev/null
      # 如原来是 plus 账户，以相同的 license 升级，并修改账户和 warp 配置文件
      if [[ -n "$LICENSE" && -n "$NAME" ]]; then
        [ -n "$LICENSE" ] && warp_api "license" "/etc/wireguard/warp-account.conf" "$LICENSE" >/dev/null 2>&1
        [ -n "$NAME" ] && warp_api "name" "/etc/wireguard/warp-account.conf" "" "$NAME" >/dev/null 2>&1
        local PRIVATEKEY="$(grep 'private_key' /etc/wireguard/warp-account.conf | cut -d\" -f4)"
        local ADDRESS6="$(grep '"v6.*"$' /etc/wireguard/warp-account.conf | cut -d\" -f4)"
        local CLIENT_ID="$(warp_api "convert" "/etc/wireguard/warp-account.conf" "" "" "" "" "file")"
        [ -s /etc/wireguard/warp.conf ] && sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ]\+=[ ]\+\).*\(/128$\)#\1$ADDRESS6\2#g; s#\(.*Reserved[ ]\+=[ ]\+\).*#\1$CLIENT_ID#g" /etc/wireguard/warp.conf
        sed -i "s#\([ ]\+\"license\": \"\).*#\1$LICENSE\"#g; s#\"account_type\".*#\"account_type\": \"limited\",#g; s#\([ ]\+\"name\": \"\).*#\1$NAME\"#g" /etc/wireguard/warp-account.conf
      fi
      ss -nltp | grep dnsmasq >/dev/null 2>&1 && systemctl restart dnsmasq >/dev/null 2>&1
      wg-quick up warp >/dev/null 2>&1
      sleep $j
    }

    # 检测账户类型为 Team 的不能更换
    if [ -e /etc/wireguard/info.log ] && ! grep -q 'Device name' /etc/wireguard/info.log; then
      hint "\n $(text 95) \n" && reading " $(text 50) " CHANGE_ACCOUNT
      case "$CHANGE_ACCOUNT" in
        2 )
          UPDATE_ACCOUNT=warp
          change_to_plus
          ;;
        3 )
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
      10 )
        NF='4'
        ;;
      11 )
        change_stack
    esac

    # 检测[全局]或[非全局]
    grep -q '^Table' /etc/wireguard/warp.conf && GLOBAL='--interface warp'

    [ -z "$EXPECT" ] && input_region
    i=0; j=10
    while true; do
      (( i++ )) || true
      ip_now=$(date +%s); RUNTIME=$((ip_now - ip_start)); DAY=$(( RUNTIME / 86400 )); HOUR=$(( (RUNTIME % 86400 ) / 3600 )); MIN=$(( (RUNTIME % 86400 % 3600) / 60 )); SEC=$(( RUNTIME % 86400 % 3600 % 60 ))
      [ "$GLOBAL" = '--interface warp' ] && ip_case "$NF" warp non-global || ip_case "$NF" warp
      WAN=$(eval echo \$WAN$NF) && COUNTRY=$(eval echo \$COUNTRY$NF) && ASNORG=$(eval echo \$ASNORG$NF)
      unset RESULT REGION
      for l in ${!RESULT_TITLE[@]}; do
        RESULT[l]=$(curl --user-agent "${UA_Browser}" -$NF $GLOBAL -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/${RESULT_TITLE[l]}")
        [ "${RESULT[l]}" = 200 ] && break
      done
      if [[ "${RESULT[@]}" =~ 200 ]]; then
        REGION=$(curl --user-agent "${UA_Browser}" -"$NF" $GLOBAL -fs --max-time 10 --write-out "%{redirect_url}" --output /dev/null "https://www.netflix.com/title/$REGION_TITLE" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g')
        REGION=${REGION:-'US'}
        grep -qi "$EXPECT" <<< "$REGION" && info " $(text 125) " && i=0 && sleep 1h || warp_restart
      else
        warp_restart
      fi
    done
  }

  change_client() {
    client_restart() {
      local CLIENT_MODE=$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i+1)}}')
      case "$CLIENT_MODE" in
        Warp )
          warning " $(text 126) " && warp-cli --accept-tos registration delete >/dev/null 2>&1
          rule_del >/dev/null 2>&1
          warp-cli --accept-tos registration new >/dev/null 2>&1
          [ -s /etc/wireguard/license ] && warp-cli --accept-tos registration license $(cat /etc/wireguard/license) >/dev/null 2>&1
          sleep $j
          rule_add >/dev/null 2>&1
          ;;
        WarpProxy )
          warning " $(text 126) " && warp-cli --accept-tos registration delete >/dev/null 2>&1
          warp-cli --accept-tos registration delete >/dev/null 2>&1
          warp-cli --accept-tos registration new >/dev/null 2>&1
          [ -s /etc/wireguard/license ] && warp-cli --accept-tos registration license $(cat /etc/wireguard/license) >/dev/null 2>&1
          sleep $j
      esac
    }

    change_stack

    if [ "$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i+1)}}')" = 'WarpProxy' ]; then
      [ -z "$EXPECT" ] && input_region
      i=0; j=10
      while true; do
        (( i++ )) || true
        ip_now=$(date +%s); RUNTIME=$((ip_now - ip_start)); DAY=$(( RUNTIME / 86400 )); HOUR=$(( (RUNTIME % 86400 ) / 3600 )); MIN=$(( (RUNTIME % 86400 % 3600) / 60 )); SEC=$(( RUNTIME %86400 % 3600 % 60 ))
        ip_case "$NF" client
        WAN=$(eval echo "\$CLIENT_WAN$NF") && ASNORG=$(eval echo "\$CLIENT_ASNORG$NF") && COUNTRY=$(eval echo "\$CLIENT_COUNTRY$NF")
        unset RESULT REGION
        for l in ${!RESULT_TITLE[@]}; do
          RESULT[l]=$(curl --user-agent "${UA_Browser}" -"$NF" -sx socks5h://127.0.0.1:$CLIENT_PORT -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/${RESULT_TITLE[l]}")
          [ "${RESULT[l]}" = 200 ] && break
        done
        if [[ "${RESULT[@]}" =~ 200 ]]; then
          REGION=$(curl --user-agent "${UA_Browser}" -"$NF" -sx socks5h://127.0.0.1:$CLIENT_PORT -fs --max-time 10 --write-out "%{redirect_url}" --output /dev/null "https://www.netflix.com/title/$REGION_TITLE" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g')
          REGION=${REGION:-'US'}
          grep -qi "$EXPECT" <<< "$REGION" && info " $(text 125) " && i=0 && sleep 1h || client_restart
        else
          client_restart
        fi
      done

    else
      [ -z "$EXPECT" ] && input_region
      i=0; j=10
      while true; do
        (( i++ )) || true
        ip_now=$(date +%s); RUNTIME=$((ip_now - ip_start)); DAY=$(( RUNTIME / 86400 )); HOUR=$(( (RUNTIME % 86400 ) / 3600 )); MIN=$(( (RUNTIME % 86400 % 3600) / 60 )); SEC=$(( RUNTIME % 86400 % 3600 % 60 ))
        ip_case "$NF" is_luban
        WAN=$(eval echo "\$CFWARP_WAN$NF") && COUNTRY=$(eval echo "\$CFWARP_COUNTRY$NF") && ASNORG=$(eval echo "\$CFWARP_ASNORG$NF")
        unset RESULT REGION
        for l in ${!RESULT_TITLE[@]}; do
          RESULT[l]=$(curl --user-agent "${UA_Browser}" $INTERFACE -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/${RESULT_TITLE[l]}")
          [ "${RESULT[l]}" = 200 ] && break
        done
        [ "${RESULT[0]}" != 200 ] && RESULT[1]=$(curl --user-agent "${UA_Browser}" $INTERFACE -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/${RESULT_TITLE[1]}" 2>&1)
        if [[ "${RESULT[@]}" =~ 200 ]]; then
          REGION=$(curl --user-agent "${UA_Browser}" $INTERFACE -fs --max-time 10 --write-out "%{redirect_url}" --output /dev/null "https://www.netflix.com/title/$REGION_TITLE" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g')
          REGION=${REGION:-'US'}
          grep -qi "$EXPECT" <<< "$REGION" && info " $(text 125) " && i=0 && sleep 1h || client_restart
        else
          client_restart
        fi
      done
    fi
  }

  change_wireproxy() {
    wireproxy_restart() { warning " $(text 126) " && systemctl restart wireproxy; sleep $j; }

    change_stack

    [ -z "$EXPECT" ] && input_region
    i=0; j=3
    while true; do
      (( i++ )) || true
      ip_now=$(date +%s); RUNTIME=$((ip_now - ip_start)); DAY=$(( RUNTIME / 86400 )); HOUR=$(( (RUNTIME % 86400 ) / 3600 )); MIN=$(( (RUNTIME % 86400 % 3600) / 60 )); SEC=$(( RUNTIME % 86400 % 3600 % 60 ))
      ip_case "$NF" wireproxy
      WAN=$(eval echo "\$WIREPROXY_WAN$NF") && ASNORG=$(eval echo "\$WIREPROXY_ASNORG$NF") && COUNTRY=$(eval echo "\$WIREPROXY_COUNTRY$NF")
      unset RESULT REGION
      for l in ${!RESULT_TITLE[@]}; do
        RESULT[l]=$(curl --user-agent "${UA_Browser}" -"$NF" -sx socks5h://127.0.0.1:$WIREPROXY_PORT -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/${RESULT_TITLE[l]}")
        [ "${RESULT[l]}" = 200 ] && break
      done
      if [[ "${RESULT[@]}" =~ 200 ]]; then
        REGION=$(curl --user-agent "${UA_Browser}" -"$NF" -sx socks5h://127.0.0.1:$WIREPROXY_PORT -fs --max-time 10 --write-out "%{redirect_url}" --output /dev/null "https://www.netflix.com/title/$REGION_TITLE" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g')
        REGION=${REGION:-'US'}
        grep -qi "$EXPECT" <<< "$REGION" && info " $(text 125) " && i=0 && sleep 1h || wireproxy_restart
      else
        wireproxy_restart
      fi
    done
  }

  # 设置时区，让时间戳时间准确，显示脚本运行时长，中文为 GMT+8，英文为 UTC; 设置 UA
  ip_start=$(date +%s)
  [ "$SYSTEM" != Alpine ] && ( [ "$L" = C ] && timedatectl set-timezone Asia/Shanghai || timedatectl set-timezone UTC )
  UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"

  # 根据 lmc999 脚本检测 Netflix Title，如获取不到，使用兜底默认值
  local LMC999=($(curl -sSLm4 ${GH_PROXY}https://raw.githubusercontent.com/lmc999/RegionRestrictionCheck/main/check.sh | sed -n 's#.*/title/\([0-9]\+\).*#\1#gp'))
  RESULT_TITLE=(${LMC999[*]:0:2})
  REGION_TITLE=${LMC999[2]}
  [[ ! "${RESULT_TITLE[0]}" =~ ^[0-9]+$ ]] && RESULT_TITLE[0]='81280792'
  [[ ! "${RESULT_TITLE[1]}" =~ ^[0-9]+$ ]] && RESULT_TITLE[1]='70143836'
  [[ ! "$REGION_TITLE" =~ ^[0-9]+$ ]] && REGION_TITLE=${RESULT_TITLE[1]}

  # 根据 WARP interface 、 Client 和 Wireproxy 的安装情况判断刷 IP 的方式
  INSTALL_CHECK=("wg-quick" "warp-cli" "wireproxy")
  CASE_RESAULT=("0 0 0" "0 0 1" "0 1 0" "0 1 1" "1 0 0" "1 0 1" "1 1 0" "1 1 1")
  SHOW_CHOOSE=("$(text 150)" "" "" "$(text 151)" "" "$(text 152)" "$(text 153)" "$(text 154)")
  CHANGE_IP1=("" "change_wireproxy" "change_client" "change_client" "change_warp" "change_warp" "change_warp" "change_warp")
  CHANGE_IP2=("" "" "" "change_wireproxy" "" "change_wireproxy" "change_client" "change_client")
  CHANGE_IP3=("" "" "" "" "" "" "" "change_wireproxy")

  for a in ${!INSTALL_CHECK[@]}; do
    [ -x "$(type -p ${INSTALL_CHECK[a]})" ] && INSTALL_RESULT[a]=1 || INSTALL_RESULT[a]=0
  done

  for b in ${!CASE_RESAULT[@]}; do
    [[ "${INSTALL_RESULT[@]}" = "${CASE_RESAULT[b]}" ]] && break
  done

  case "$b" in
    0 )
      error " $(text 150) "
      ;;
    1|2|4 )
      ${CHANGE_IP1[b]}
      ;;
    * )
      hint "\n ${SHOW_CHOOSE[b]} \n" && reading " $(text 50) " MODE
      case "$MODE" in
        [1-3] )
          $(eval echo "\${CHANGE_IP$MODE[b]}")
          ;;
        * )
          warning " $(text 51) [1-3] "; sleep 1; change_ip
      esac
  esac
}

# 安装BBR
bbrInstall() {
  echo -e "\n==============================================================\n"
  info " $(text 47) "
  echo -e "\n==============================================================\n"
  hint " 1. $(text 48) "
  [ "$OPTION" != b ] && hint " 0. $(text 49) \n" || hint " 0. $(text 76) \n"
  reading " $(text 50) " BBR
  case "$BBR" in
    1 )
      wget --no-check-certificate -N "${GH_PROXY}https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
      ;;
    0 )
      [ "$OPTION" != b ] && menu || exit
      ;;
    * )
      warning " $(text 51) [0-1]"; sleep 1; bbrInstall
  esac
}

# 关闭 WARP 网络接口，并删除 WARP
uninstall() {
  unset IP4 IP6 WAN4 WAN6 COUNTRY4 COUNTRY6 ASNORG4 ASNORG6

  # 卸载 WARP
  uninstall_warp() {
    wg-quick down warp >/dev/null 2>&1
    systemctl disable --now wg-quick@warp >/dev/null 2>&1; sleep 3
    [ -x "$(type -p rpm)" ] && rpm -e wireguard-tools 2>/dev/null
    systemctl restart systemd-resolved >/dev/null 2>&1; sleep 3
    warp_api "cancel" "/etc/wireguard/warp-account.conf" >/dev/null 2>&1
    rm -rf /usr/bin/wireguard-go /usr/bin/warp /etc/dnsmasq.d/warp.conf /usr/bin/wireproxy /etc/local.d/warp.start
    [ -e /etc/gai.conf ] && sed -i '/^precedence \:\:ffff\:0\:0/d;/^label 2002\:\:\/16/d' /etc/gai.conf
    [ -e /usr/bin/tun.sh ] && rm -f /usr/bin/tun.sh
    [ -e /etc/crontab ] && sed -i '/tun.sh/d' /etc/crontab
    [ -e /etc/iproute2/rt_tables ] && sed -i "/250   warp/d" /etc/iproute2/rt_tables
    [ -e /etc/resolv.conf.origin ] && mv -f /etc/resolv.conf.origin /etc/resolv.conf
  }

  # 卸载 Linux Client
  uninstall_client() {
    warp-cli --accept-tos disconnect >/dev/null 2>&1
    warp-cli --accept-tos registration delete >/dev/null 2>&1
    rule_del >/dev/null 2>&1
    ${PACKAGE_UNINSTALL[int]} cloudflare-warp 2>/dev/null
    systemctl disable --now warp-svc >/dev/null 2>&1
    rm -rf /usr/bin/wireguard-go /usr/bin/warp $HOME/.local/share/warp /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg /etc/apt/sources.list.d/cloudflare-client.list /etc/yum.repos.d/cloudflare-warp.repo
  }

  # 卸载 Wireproxy
  uninstall_wireproxy() {
    if [ "$SYSTEM" = Alpine ]; then
      rc-update del wireproxy default
      rc-service wireproxy stop >/dev/null 2>&1
      rm -f /etc/init.d/wireproxy
    else
      systemctl disable --now wireproxy
    fi

    warp_api "cancel" "/etc/wireguard/warp-account.conf" >/dev/null 2>&1
    rm -rf /usr/bin/wireguard-go /usr/bin/warp /etc/dnsmasq.d/warp.conf /usr/bin/wireproxy /lib/systemd/system/wireproxy.service
    [ -e /etc/gai.conf ] && sed -i '/^precedence \:\:ffff\:0\:0/d;/^label 2002\:\:\/16/d' /etc/gai.conf
    [ -e /usr/bin/tun.sh ] && rm -f /usr/bin/tun.sh && sed -i '/tun.sh/d' /etc/crontab
  }

  # 如已安装 warp_unlock 项目，先行卸载
  [ -e /usr/bin/warp_unlock.sh ] && bash <(curl -sSL https://gitlab.com/fscarmen/warp_unlock/-/raw/main/unlock.sh) -U -$L

  # 根据已安装情况执行卸载任务并显示结果
  UNINSTALL_CHECK=("wg-quick" "warp-cli" "wireproxy")
  UNINSTALL_DO=("uninstall_warp" "uninstall_client" "uninstall_wireproxy")
  UNINSTALL_DEPENDENCIES=("wireguard-tools openresolv " "" " openresolv ")
  UNINSTALL_NOT_ARCH=("wireguard-dkms " "" "wireguard-dkms resolvconf ")
  UNINSTALL_DNSMASQ=("ipset dnsmasq resolvconf ")
  UNINSTALL_RESULT=("$(text 117)" "$(text 119)" "$(text 98)")
  for i in ${!UNINSTALL_CHECK[@]}; do
    [ -x "$(type -p ${UNINSTALL_CHECK[i]})" ] && UNINSTALL_DO_LIST[i]=1 && UNINSTALL_DEPENDENCIES_LIST+=${UNINSTALL_DEPENDENCIES[i]}
    [[ $SYSTEM != "Arch" && $(dkms status 2>/dev/null) =~ wireguard ]] && UNINSTALL_DEPENDENCIES_LIST+=${UNINSTALL_NOT_ARCH[i]}
    [ -e /etc/dnsmasq.d/warp.conf ] && UNINSTALL_DEPENDENCIES_LIST+=${UNINSTALL_DNSMASQ[i]}
  done

  # 列出依赖，确认是手动还是自动卸载
  UNINSTALL_DEPENDENCIES_LIST=$(echo $UNINSTALL_DEPENDENCIES_LIST | sed "s/ /\n/g" | sort -u | paste -d " " -s)
  [ "$UNINSTALL_DEPENDENCIES_LIST" != '' ] && hint "\n $(text 79) \n" && reading " $(text 170) " CONFIRM_UNINSTALL

  # 卸载核心程序
  for i in ${!UNINSTALL_CHECK[@]}; do
    [[ "${UNINSTALL_DO_LIST[i]}" = 1 ]] && ( ${UNINSTALL_DO[i]}; info " ${UNINSTALL_RESULT[i]} " )
  done

  # 删除本脚本安装在 /etc/wireguard/ 下的所有文件，如果删除后目录为空，一并把目录删除
  rm -f /usr/bin/wg-quick.{origin,reserved}
  rm -f /tmp/{best_mtu,/tmp/best_endpoint,wireguard-go-*}
  rm -f /etc/wireguard/{wgcf-account.conf,warp-temp.conf,warp-account.conf,warp_unlock.sh,warp.conf.bak,warp.conf,up,proxy.conf.bak,proxy.conf,menu.sh,license,language,info-temp.log,info.log,down,account-temp.conf,NonGlobalUp.sh,NonGlobalDown.sh}
  [[ -e /etc/wireguard && -z "$(ls -A /etc/wireguard/)" ]] && rmdir /etc/wireguard

  # 选择自动卸载依赖执行以下
  [[ "$UNINSTALL_DEPENDENCIES_LIST" != '' && "${CONFIRM_UNINSTALL,,}" = 'y' ]] && ( ${PACKAGE_UNINSTALL[int]} $UNINSTALL_DEPENDENCIES_LIST 2>/dev/null; info " $(text 171) \n" )

  # 显示卸载结果
  systemctl restart systemd-resolved >/dev/null 2>&1; sleep 3
  ip_case u warp
  info " $(text 45)\n IPv4: $WAN4 $COUNTRY4 $ASNORG4\n IPv6: $WAN6 $COUNTRY6 $ASNORG6 "
}

# 同步脚本至最新版本
ver() {
  mkdir -p /tmp; rm -f /tmp/menu.sh
  wget -O /tmp/menu.sh https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh
  if [ -s /tmp/menu.sh ]; then
    mv /tmp/menu.sh /etc/wireguard/
    chmod +x /etc/wireguard/menu.sh
    ln -sf /etc/wireguard/menu.sh /usr/bin/warp
    info " $(text 64):$(grep ^VERSION /etc/wireguard/menu.sh | sed "s/.*=//g")  $(text 18):$(grep "${L}\[1\]" /etc/wireguard/menu.sh | cut -d \" -f2) "
  else
    error " $(text 65) "
  fi
  exit
}

# 由于warp bug，有时候获取不了ip地址，加入刷网络脚本手动运行，并在定时任务加设置 VPS 重启后自动运行,i=当前尝试次数，j=要尝试的次数
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
  LAN4=$(ip route get 192.168.193.10 2>/dev/null | awk '{for (i=0; i<NF; i++) if ($i=="src") {print $(i+1)}}')
  LAN6=$(ip route get 2606:4700:d0::a29f:c001 2>/dev/null | awk '{for (i=0; i<NF; i++) if ($i=="src") {print $(i+1)}}')
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
        echo -e " ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓\n $(text 20): $SYS\n\n $(text 21):$(uname -r) \n\n $(text 40): ${MENU_OPTION[MENU_CHOOSE]} \n\n $ERROR_MESSAGE\n ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ "
        error " $(text 13) "
      else
        break
      fi
    fi
  done

  if [[ "$TRACE4$TRACE6" =~ on|plus ]]; then
    TYPE=' Free' && [ -e /etc/wireguard/info.log ] && TYPE=' Teams' && grep -sq 'Device name' /etc/wireguard/info.log && TYPE='+' && check_quota warp
    info " $(text 14), $(text 186) "
    [ "$NO_OUTPUT" != 'no_output' ] && info " IPv4:$WAN4 $COUNTRY4 $ASNORG4\n IPv6:$WAN6 $COUNTRY6 $ASNORG6 " && [ -n "$QUOTA" ] && info " $(text 25): $(awk '/Device name/{print $NF}' /etc/wireguard/info.log)\n $(text 63): $QUOTA "
  fi
}

# WARP 开关，先检查是否已安装，再根据当前状态转向相反状态
onoff() {
  [ ! -x "$(type -p wg-quick)" ] && error " $(text 155) "
  [ -n "$(wg 2>/dev/null)" ] && (wg-quick down warp >/dev/null 2>&1; info " $(text 15) ") || net
}

# Client 开关，先检查是否已安装，再根据当前状态转向相反状态
client_onoff() {
  [ ! -x "$(type -p warp-cli)" ] && error " $(text 93) "
  if [ "$(warp-cli --accept-tos status | awk '/Status update/{for (i=0; i<NF; i++) if ($i=="update:") {print $(i+1)}}')" = 'Connected' ]; then
    local CLIENT_MODE=$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i+1)}}')
    [ "$CLIENT_MODE" = 'Warp' ] && rule_del >/dev/null 2>&1
    warp-cli --accept-tos disconnect >/dev/null 2>&1
    info " $(text 91) " && exit 0
  else
    warp-cli --accept-tos connect >/dev/null 2>&1; sleep 2
    local CLIENT_MODE=$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i+1)}}')
    if [ "$CLIENT_MODE" = 'WarpProxy' ]; then
      ip_case d client
      local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk  '/type/{print $3}')
      [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && check_quota client
      [[ $(ss -nltp | awk '{print $NF}' | awk -F \" '{print $2}') =~ warp-svc ]] && info " $(text 90)\n $(text 27): $CLIENT_SOCKS5\n WARP$CLIENT_AC IPv4: $CLIENT_WAN4 $CLIENT_COUNTRY4 $CLIENT_ASNORG4\n WARP$CLIENT_AC IPv6: $CLIENT_WAN6 $CLIENT_COUNTRY6 $CLIENT_ASNORG6 "
      [ -n "$QUOTA" ] && info " $(text 63): $QUOTA "
      exit 0

    elif [ "$CLIENT_MODE" = 'Warp' ]; then
      rule_add >/dev/null 2>&1
      ip_case d is_luban
      local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk  '/type/{print $3}')
      [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && check_quota client
      [[ $(ip link show | awk -F': ' '{print $2}') =~ CloudflareWARP ]] && info " $(text 90)\n WARP$CLIENT_AC IPv4: $CFWARP_WAN4 $CFWARP_COUNTRY4  $CFWARP_ASNORG4\n WARP$CLIENT_AC IPv6: $CFWARP_WAN6 $CFWARP_COUNTRY6  $CFWARP_ASNORG6 "
      [ -n "$QUOTA" ] && info " $(text 63): $QUOTA "
      exit 0
    fi
  fi
}

# WireProxy 开关，先检查是否已安装，再根据当前状态转向相反状态
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

# 检查系统 WARP 单双栈情况。为了速度，先检查 warp 配置文件里的情况，再判断 trace
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

  # 判断用于检测 NAT VSP，以选择正确配置文件
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

# 对于 CentOS 9 / AlmaLinux 9 / RockyLinux 9 及类似的系统，由于 wg-quick 不能对 openresolv 进行操作，所以直接处理 /etc/resolv.conf 文件
centos9_resolv() {
  local EXECUTE=$1
  local STACK=$2
  if [ "$EXECUTE" = 'backup' ]; then
    cp -f /etc/resolv.conf{,.origin}
  elif [ "$EXECUTE" = 'generate' ]; then
    [ "$STACK" = '0' ] && echo -e "# Generated by WARP script\nnameserver 2606:4700:4700::1111\nnameserver 2001:4860:4860::8888\nnameserver 2001:4860:4860::8844\nnameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf || echo -e "# Generated by WARP script\nnameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4\nnameserver 2606:4700:4700::1111\nnameserver 2001:4860:4860::8888\nnameserver 2001:4860:4860::8844" > /etc/resolv.conf
  elif [ "$EXECUTE" = 'restore' ]; then
    [ -s /etc/resolv.conf.origin ] && mv -f /etc/resolv.conf.origin /etc/resolv.conf
  fi
}

# 单双栈在线互换。先看菜单是否有选择，再看传参数值，再没有显示2个可选项
stack_switch() {
  # WARP 单双栈切换选项
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
    [[ "$T4@$T6@$SWITCHCHOOSE" =~ '1@0@4'|'0@1@6'|'1@1@D' ]] && error "\n $(text 146) \n" || TO="$T4$T6$SWITCHCHOOSE"
  fi
  [ "${#TO}" != 3 ] && error " $(text 172) " || sed -i "$(eval echo "\$SWITCH$TO")" /etc/wireguard/warp.conf
  ${SYSTEMCTL_RESTART[int]}; sleep 1
  net
}

# 内核 / wireguard-go with reserved 在线互换
kernel_reserved_switch() {
  # 先判断是否可以转换
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

# 全局 / 非全局 在线互换
working_mode_switch() {
  # 先判断当前工作模式
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

# 检测系统信息
check_system_info() {
  info " $(text 37) "

  # 判断是否有加载 wireguard 内核，如没有先尝试是否可以加载，再重新判断一次
  if [ ! -e /sys/module/wireguard ]; then
    [ -s /lib/modules/$(uname -r)/kernel/drivers/net/wireguard/wireguard.ko* ] && [ -x "$(type -p lsmod)" ] && ! lsmod | grep -q wireguard && [ -x "$(type -p modprobe)" ] && modprobe wireguard
    [ -e /sys/module/wireguard ] && KERNEL_ENABLE=1 || KERNEL_ENABLE=0
  else
    KERNEL_ENABLE=1
  fi

  # 必须加载 TUN 模块，先尝试在线打开 TUN。尝试成功放到启动项，失败作提示并退出脚本
  TUN=$(cat /dev/net/tun 2>&1)
  if [[ "$TUN" =~ 'in bad state'|'处于错误状态' ]]; then
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
    if [[ "$TUN" =~ 'in bad state'|'处于错误状态' ]]; then
      WIREGUARD_GO_ENABLE=1
      [ "$SYSTEM" != Alpine ] && echo "@reboot root bash /usr/bin/tun.sh" >> /etc/crontab
    else
      WIREGUARD_GO_ENABLE=0
      rm -f /usr/bin/tun.sh
    fi
  fi

  # 判断机器原生状态类型
  IPV4=0; IPV6=0
  LAN4=$(ip route get 192.168.193.10 2>/dev/null | awk '{for (i=0; i<NF; i++) if ($i=="src") {print $(i+1)}}')
  LAN6=$(ip route get 2606:4700:d0::a29f:c001 2>/dev/null | awk '{for (i=0; i<NF; i++) if ($i=="src") {print $(i+1)}}')

  # 先查是否非局，优先 warp IP，再原生 IP
  if [[ $(ip link show | awk -F': ' '{print $2}') =~ warp ]]; then
    GLOBAL_OR_NOT="$(text 185)"
    if grep -q '^AllowedIPs.*:\:\/0' 2>/dev/null /etc/wireguard/warp.conf; then
      STACK=-6 && ip_case 6 warp non-global
    else
      [[ "$LAN6" != "::1" && "$LAN6" =~ ^[a-f0-9:]+$ ]] && INET6=1 && $PING6 -c2 -w10 2606:4700:d0::a29f:c001 >/dev/null 2>&1 && IPV6=1 && STACK=-6 && ip_case 6 warp
    fi
    if grep -q '^AllowedIPs.*0\.\0\/0' 2>/dev/null /etc/wireguard/warp.conf; then
      STACK=-4 && ip_case 4 warp non-global
    else
      [[ "$LAN4" =~ ^([0-9]{1,3}\.){3} ]] && INET4=1 && ping -c2 -W3 162.159.193.10 >/dev/null 2>&1 && IPV4=1 && STACK=-4 && ip_case 4 warp
    fi
  else
    [[ "$LAN6" != "::1" && "$LAN6" =~ ^[a-f0-9:]+$ ]] && INET6=1 && $PING6 -c2 -w10 2606:4700:d0::a29f:c001 >/dev/null 2>&1 && IPV6=1 && STACK=-6 && ip_case 6 warp
    [[ "$LAN4" =~ ^([0-9]{1,3}\.){3} ]] && INET4=1 && ping -c2 -W3 162.159.193.10 >/dev/null 2>&1 && IPV4=1 && STACK=-4 && ip_case 4 warp
  fi

  # 判断当前 WARP 状态，决定变量 PLAN，变量 PLAN 含义:1=单栈  2=双栈  3=WARP已开启
  [[ "$TRACE4$TRACE6" =~ on|plus ]] && PLAN=3 || PLAN=$((IPV4+IPV6))

  # 判断处理器架构
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

  # 判断当前 Linux Client 状态，决定变量 CLIENT，变量 CLIENT 含义:0=未安装  1=已安装未激活  2=状态激活  3=Client proxy 已开启  5=Client warp 已开启
  CLIENT=0
  if [ -x "$(type -p warp-cli)" ]; then
    CLIENT=1 && CLIENT_INSTALLED="$(text 92)"
    [ "$(systemctl is-enabled warp-svc)" = enabled ] && CLIENT=2
    if [[ "$CLIENT" = 2 && "$(systemctl is-active warp-svc)" = 'active' ]]; then
      local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk  '/type/{print $3}')
      [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && check_quota client
      local CLIENT_MODE=$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i+1)}}')
      case "$CLIENT_MODE" in
        WarpProxy )
          [[ "$(ss -nltp | awk '{print $NF}' | awk -F \" '{print $2}')" =~ warp-svc ]] && CLIENT=3 && ip_case d client
          ;;
        Warp )
          [[ "$(ip link show | awk -F': ' '{print $2}')" =~ CloudflareWARP ]] && CLIENT=5 && ip_case d is_luban
      esac
    fi
  fi

  # 判断当前 WireProxy 状态，决定变量 WIREPROXY，变量 WIREPROXY 含义:0=未安装，1=已安装,断开状态，2=Client 已开启
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

# 输入 WARP+ 账户（如有），限制位数为空或者26位以防输入错误
input_license() {
  [ -z "$LICENSE" ] && reading " $(text 28) " LICENSE
  i=5
  until [[ -z "$LICENSE" || "$LICENSE" =~ ^[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}$ ]]; do
    (( i-- )) || true
    [ "$i" = 0 ] && error " $(text 29) " || reading " $(text 30) " LICENSE
  done
  if [ "$INPUT_LICENSE" = 1 ]; then
    [[ -n "$LICENSE" && -z "$NAME" ]] && reading " $(text 102) " NAME
    [ -n "$NAME" ] && NAME="${NAME//[[:space:]]/_}" || NAME=${NAME:-"$(hostname)"}
  fi
}

# 输入 Teams 账户 URL（如有）
input_url_token() {
  if [ "$1" = 'url' ]; then
    [ -z "$TEAM_URL" ] && reading " url: " TEAM_URL
    [ -n "$TEAM_URL" ] && TEAMS_CONTENT=$(curl --retry 2 -m5 -sSL "$TEAM_URL") || return
    if grep -q 'xml version' <<< "$TEAMS_CONTENT"; then
      ADDRESS6=$(expr "$TEAMS_CONTENT" : '.*v6&quot;:&quot;\([^[&]*\).*')
      [ -n "$ADDRESS6" ] && PRIVATEKEY=$(expr "$TEAMS_CONTENT" : '.*private_key&quot;>\([^<]*\).*')
      [[ -n "$ADDRESS6" && -z "$PRIVATEKEY" ]] && PRIVATEKEY=$(expr "$TEAMS_CONTENT" : '.*private_key">\([^<]\+\).*')
      RESERVED=$(expr "$TEAMS_CONTENT" : '.*;client_id&quot;:&quot;\([^&]\{4\}\)')
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
      TEAMS=$(warp_api "register" "" "" "" "$TEAM_TOKEN" 2>&1)
      ADDRESS6=$(expr "$TEAMS" : '.*"v6":[ ]*"\([^"]*\).*')
      PRIVATEKEY=$(expr "$TEAMS" : '.*"private_key":[ ]*"\([^"]*\).*')
      RESERVED=$(expr "$TEAMS" : '.*"client_id":[ ]*"\([^"]*\).*')
      CLIENT_ID="$(warp_api "convert" "" "" "" "" "$RESERVED" "decode")"
    done

  elif [ "$1" = 'input' ]; then
    reading " private key: " PRIVATEKEY
    [ -n "$PRIVATEKEY" ] && reading " IPv6: " ADDRESS6 || return
    ADDRESS6=${ADDRESS6//\/128/}
    [[ -n "$PRIVATEKEY" && -n "$ADDRESS6" ]] && reading " Reserved or client_id: " RESERVED_OR_CLIENT_ID || return
    if [[ "$RESERVED_OR_CLIENT_ID" =~ ^[a-zA-Z+/]{4}$ ]]; then
      RESERVED=$RESERVED_OR_CLIENT_ID
      CLIENT_ID="$(warp_api "convert" "" "" "" "" "$RESERVED" "decode")"
    elif [[ "$RESERVED_OR_CLIENT_ID" =~ ([0-9]{1,3}){3} ]]; then
      RESERVED=$(warp_api "convert" "" "" "" "" "$RESERVED_OR_CLIENT_ID" "encode")
      CLIENT_ID="$(warp_api "convert" "" "" "" "" "$RESERVED" "decode")"
    fi

  elif [ "$1" = 'share' ]; then
    PRIVATEKEY=MKTg1UXzTGCB7IrRzfATwjC4MGFFE2WHibpHrBUzDUs=
    ADDRESS6=2606:4700:110:8147:4c61:5525:9014:dd3
    CLIENT_ID='[153, 228, 25]'
  fi

  [[ "$PRIVATEKEY" =~ ^[A-Z0-9a-z/+]{43}=$ ]] && MATCH[0]=$(text 135) || MATCH[0]=$(text 136)
  [[ "$ADDRESS6" =~ ^[0-9a-f]{4}(:[0-9a-f]{0,4}){7}$ ]] && MATCH[1]=$(text 135) || MATCH[1]=$(text 136)
  [[ "$CLIENT_ID" =~ ^\[[0-9]{1,3}(,[[:space:]]*[0-9]{1,3}){2}\]$ ]] && MATCH[2]=$(text 135) || MATCH[2]=$(text 136)

  [ "$1" != 'token' ] && TEAMS="{\"private_key\": \"$PRIVATEKEY\", \"v6\": \"$ADDRESS6\", \"client_id\": \"$CLIENT_ID\"}"
  hint "\n $(text 130) \n" && reading " $(text 131) " CONFIRM_TEAMS_INFO
}

# 升级 WARP+ 账户（如有），限制位数为空或者26位以防输入错误，WARP interface 可以自定义设备名(不允许字符串间有空格，如遇到将会以_代替)
update_license() {
  [ -z "$LICENSE" ] && reading " $(text 61) " LICENSE
  i=5
  until [[ "$LICENSE" =~ ^[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}$ ]]; do
    (( i-- )) || true
    [ "$i" = 0 ] && error " $(text 29) " || reading " $(text 100) " LICENSE
  done
  [[ -z "$CLIENT_ACCOUNT" && "$CHOOSE_TYPE" = 2 && -n "$LICENSE" && -z "$NAME" ]] && reading " $(text 102) " NAME
  [ -n "$NAME" ] && NAME="${NAME//[[:space:]]/_}" || NAME=${NAME:-"$(hostname)"}
}

# 输入 Linux Client 端口,先检查默认的40000是否被占用,限制4-5位数字,准确匹配空闲端口
input_port() {
  i=5
  PORT=40000
  ss -nltp | awk '{print $4}' | awk -F: '{print $NF}' | grep -qw $PORT && reading " $(text 103) " PORT || reading " $(text 104) " PORT
  PORT=${PORT:-'40000'}
  until grep -qE "^[1-9][0-9]{3,4}$" <<< $PORT && [[ "$PORT" -ge 1000 && "$PORT" -le 65535 ]] && [[ ! $(ss -nltp) =~ :"$PORT"[[:space:]] ]]; do
    (( i-- )) || true
    [ "$i" = 0 ] && error " $(text 29) "
    if grep -qwE "^[1-9][0-9]{3,4}$" <<< $PORT; then
      if [[ "$PORT" -ge 1000 && "$PORT" -le 65535 ]]; then
        ss -nltp | awk '{print $4}' | awk -F: '{print $NF}' | grep -qw $PORT && reading " $(text 103) " PORT
      else
        reading " $(text 111) " PORT
        PORT=${PORT:-'40000'}
      fi
    else
      reading " $(text 111) " PORT
      PORT=${PORT:-'40000'}
    fi
  done
}

# Linux Client 或 WireProxy 端口
change_port() {
  socks5_port() { input_port; warp-cli --accept-tos proxy port "$PORT"; }
  wireproxy_port() {
    input_port
    sed -i "s/BindAddress.*/BindAddress = 127.0.0.1:$PORT/g" /etc/wireguard/proxy.conf
    systemctl restart wireproxy
  }

  INSTALL_CHECK=("$CLIENT" "$WIREPROXY")
  CASE_RESAULT=("0 1" "1 0" "1 1")
  SHOW_CHOOSE=("" "" "$(text 151)")
  CHANGE_PORT1=("wireproxy_port" "socks5_port" "socks5_port")
  CHANGE_PORT2=("" "" "wireproxy_port")

  for e in ${!INSTALL_CHECK[@]}; do
    [[ "${INSTALL_CHECK[e]}" -gt 1 ]] && INSTALL_RESULT[e]=1 || INSTALL_RESULT[e]=0
  done

  for f in ${!CASE_RESAULT[@]}; do
    [[ "${INSTALL_RESULT[@]}" = "${CASE_RESAULT[f]}" ]] && break
  done

  case "$f" in
    0|1 )
      ${CHANGE_PORT1[f]}
      sleep 1
      ss -nltp | grep -q ":$PORT" && info " $(text 122) " || error " $(text 34) "
      ;;
    2 )
      hint " ${SHOW_CHOOSE[f]} " && reading " $(text 50) " MODE
        case "$MODE" in
          [1-2] )
            $(eval echo "\${CHANGE_IP$MODE[f]}")
            sleep 1
            ss -nltp | grep -q ":$PORT" && info " $(text 122) " || error " $(text 34) "
            ;;
          * )
            warning " $(text 51) [1-2] "; sleep 1; change_port
        esac
  esac
}

# 选用 iptables+dnsmasq+ipset 方案执行
iptables_solution() {
  ${PACKAGE_INSTALL[int]} ipset dnsmasq resolvconf mtr

  # 创建 dnsmasq 规则文件
  cat >/etc/dnsmasq.d/warp.conf << EOF
#!/usr/bin/env bash
server=1.1.1.1
server=8.8.8.8
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
ipset=/chatgpt.com/warp

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

  # 创建 PostUp 和 PreDown
  cat >/etc/wireguard/up << EOF
#!/usr/bin/env bash

ipset create warp hash:ip
iptables -t mangle -N fwmark
iptables -t mangle -A PREROUTING -j fwmark
iptables -t mangle -A OUTPUT -j fwmark
iptables -t mangle -A fwmark -m set --match-set warp dst -j MARK --set-mark 2
ip rule add fwmark 2 table warp
ip route add default dev warp table warp
iptables -t nat -A POSTROUTING -m mark --mark 0x2 -j MASQUERADE
iptables -t mangle -A POSTROUTING -o warp -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
EOF

  cat >/etc/wireguard/down << EOF
#!/usr/bin/env bash

iptables -t mangle -D PREROUTING -j fwmark
iptables -t mangle -D OUTPUT -j fwmark
iptables -t mangle -D fwmark -m set --match-set warp dst -j MARK --set-mark 2
ip rule del fwmark 2 table warp
iptables -t mangle -D POSTROUTING -o warp -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -t nat -D POSTROUTING -m mark --mark 0x2 -j MASQUERADE
iptables -t mangle -F fwmark
iptables -t mangle -X fwmark
sleep 2
ipset destroy warp
EOF

  chmod +x /etc/wireguard/up /etc/wireguard/down

  # 修改 warp.conf 和 warp.conf 文件
  sed -i "s/^Post.*/#&/g; /Table/s/#//g; /Table/a\PostUp = /etc/wireguard/up\nPredown = /etc/wireguard/down" /etc/wireguard/warp.conf
  [ "$m" = 0 ] && sed -i "2i server=2606:4700:4700::1111\nserver=2001:4860:4860::8888\nserver=2001:4860:4860::8844" /etc/dnsmasq.d/warp.conf
  ! grep -q 'warp' /etc/iproute2/rt_tables && echo '250   warp' >>/etc/iproute2/rt_tables
  systemctl disable systemd-resolved --now >/dev/null 2>&1 && sleep 2
  systemctl enable dnsmasq --now >/dev/null 2>&1 && sleep 2
}

# 寻找最佳 MTU
best_mtu() {
  # 反复测试最佳 MTU。 Wireguard Header:IPv4=60 bytes,IPv6=80 bytes，1280 ≤ MTU ≤ 1420。 ping = 8(ICMP回显示请求和回显应答报文格式长度) + 20(IP首部) 。
  # 详细说明:<[WireGuard] Header / MTU sizes for Wireguard>:https://lists.zx2c4.com/pipermail/wireguard/2017-December/002201.html
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
      (( MTU++ ))
      ( [ "$IPV4$IPV6" = 01 ] && $PING6 -c1 -W1 -s $MTU -Mdo 2606:4700:d0::a29f:c001 >/dev/null 2>&1 || ping -c1 -W1 -s $MTU -Mdo 162.159.193.10 >/dev/null 2>&1 ) || break
    done
    (( MTU-- ))
  fi

  MTU=$((MTU+28-80))
  echo "$MTU" > /tmp/best_mtu
}

# 寻找最佳 Endpoint，根据 v4 / v6 情况下载 endpoint 库
best_endpoint() {
  wget $STACK -qO /tmp/endpoint https://gitlab.com/fscarmen/warp/-/raw/main/endpoint/warp-linux-"$ARCHITECTURE" && chmod +x /tmp/endpoint
  [ "$IPV4$IPV6" = 01 ] && wget $STACK -qO /tmp/ip https://gitlab.com/fscarmen/warp/-/raw/main/endpoint/ipv6 || wget $STACK -qO /tmp/ip https://gitlab.com/fscarmen/warp/-/raw/main/endpoint/ipv4

  if [[ -e /tmp/endpoint && -e /tmp/ip ]]; then
    /tmp/endpoint -file /tmp/ip -output /tmp/endpoint_result >/dev/null 2>&1
    # 如果全部是数据包丢失，LOSS = 100%，说明 UDP 被禁止，生成标志 /tmp/noudp
    [ "$(grep -sE '[0-9]+[ ]+ms$' /tmp/endpoint_result | awk -F, 'NR==1 {print $2}')" = '100.00%' ] && touch /tmp/noudp || ENDPOINT=$(grep -sE '[0-9]+[ ]+ms$' /tmp/endpoint_result | awk -F, 'NR==1 {print $1}')
    rm -f /tmp/{endpoint,ip,endpoint_result}
  fi

  # 如果失败，会有默认值 162.159.193.10:2408 或 [2606:4700:d0::a29f:c001]:2408
  [ "$IPV4$IPV6" = 01 ] && ENDPOINT=${ENDPOINT:-'[2606:4700:d0::a29f:c001]:2408'} || ENDPOINT=${ENDPOINT:-'162.159.193.10:2408'}

  [ ! -e /tmp/noudp ] && echo "$ENDPOINT" > /tmp/best_endpoint
}

# WARP 或 WireProxy 安装
install() {
  # 后台优选最佳 MTU
  { best_mtu; }&

  # 后台优选优选 WARP Endpoint
  { best_endpoint; }&

  # 后台下载 wireguard-go 两个版本
  { wget --no-check-certificate $STACK -qO /tmp/wireguard-go-20230223 https://gitlab.com/fscarmen/warp/-/raw/main/wireguard-go/wireguard-go-linux-$ARCHITECTURE-20230223 && chmod +x /tmp/wireguard-go-20230223; }&
  { wget --no-check-certificate $STACK -qO /tmp/wireguard-go-20201118 https://gitlab.com/fscarmen/warp/-/raw/main/wireguard-go/wireguard-go-linux-$ARCHITECTURE-20201118 && chmod +x /tmp/wireguard-go-20201118; }&

  # 根据之前判断的情况，让用户选择使用 wireguard 内核还是 wireguard-go serverd; 若为 wireproxy 方案则跳过此步
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

  # Warp 工作模式: 全局或非全局，在 dnsmasq / wireproxy 方案下不选择
  if [[ "$IS_ANEMONE" != 'is_anemone' && "$IS_PUFFERFFISH" != 'is_pufferffish' ]]; then
    [ -z "$GLOBAL_OR_NOT_CHOOSE" ] && hint "\n $(text 182) \n" && reading " $(text 50) " GLOBAL_OR_NOT_CHOOSE
    GLOBAL_OR_NOT="$(text 184)" && [ "$GLOBAL_OR_NOT_CHOOSE" = 2 ] && GLOBAL_OR_NOT="$(text 185)"
  fi

  # WireProxy 禁止重复安装，自定义 Port
  if [ "$IS_PUFFERFFISH" = 'is_pufferffish' ]; then
    ss -nltp | grep -q wireproxy && error " $(text 166) " || input_port

  # iptables 禁止重复安装，不适用于 IPv6 only VPS
  elif [ "$IS_ANEMONE" = 'is_anemone' ]; then
    [ -e /etc/dnsmasq.d/warp.conf ] && error " $(text 167) "
    [ "$m" = 0 ] && error " $(text 147) " || CONF=${CONF1[n]}
  fi

  # CONF 参数如果不是3位或4位， 即检测不出正确的配置参数， 脚本退出
  [[ "$IS_PUFFERFFISH" != 'is_pufferffish' && "${#CONF}" != [34] ]] && error " $(text 172) "

  # 先删除之前安装，可能导致失败的文件
  rm -rf /usr/bin/wireguard-go /etc/wireguard/warp-account.conf

  # 询问是否有 WARP+ 或 Teams 账户
  [ -z "$CHOOSE_TYPE" ] && hint "\n $(text 132) \n" && reading " $(text 50) " CHOOSE_TYPE
  case "$CHOOSE_TYPE" in
    2 )
      INPUT_LICENSE=1 && input_license
      ;;
    3 )
      [ -z "$CHOOSE_TEAMS" ] && hint "\n $(text 127) \n" && reading " $(text 50) " CHOOSE_TEAMS
      case "$CHOOSE_TEAMS" in
        1 )
          input_url_token url
          ;;
        2 )
          :
          ;;
        3 )
          input_url_token input
          ;;
        * )
          input_url_token share
      esac
  esac

  # 选择优先使用 IPv4 /IPv6 网络
  [ "$IS_PUFFERFFISH" != 'is_pufferffish' ] && hint "\n $(text 105) \n" && reading " $(text 50) " PRIORITY

  # 脚本开始时间
  start=$(date +%s)

  # 如果是 IPv6 only 机器，备份原 dns 文件，再使用 nat64
  [ "$m" = 0 ] && cp -f /etc/resolv.conf{,.origin} && echo -e "nameserver 2a00:1098:2b::1\nnameserver 2a01:4f9:c010:3f02::1\nnameserver 2a01:4f8:c2c:123f::1\nnameserver 2a00:1098:2c::1" > /etc/resolv.conf

  # 注册 WARP 账户 (将生成 warp-account.conf 文件保存账户信息)
  {
    # 如安装 WireProxy ，尽量下载官方的最新版本，如官方 WireProxy 下载不成功，将使用 cdn，以更好的支持双栈和大陆 VPS。并添加执行权限
    if [ "$IS_PUFFERFFISH" = 'is_pufferffish' ]; then
      wireproxy_latest=$(wget --no-check-certificate -qO- -T1 -t1 $STACK "${GH_PROXY}https://api.github.com/repos/pufferffish/wireproxy/releases/latest" | awk -F [v\"] '/tag_name/{print $5; exit}')
      wireproxy_latest=${wireproxy_latest:-'1.0.9'}
      wget --no-check-certificate -T10 -t1 $STACK -O wireproxy.tar.gz ${GH_PROXY}https://github.com/pufferffish/wireproxy/releases/download/v"$wireproxy_latest"/wireproxy_linux_"$ARCHITECTURE".tar.gz ||
      wget --no-check-certificate $STACK -O wireproxy.tar.gz https://gitlab.com/fscarmen/warp/-/raw/main/wireproxy/wireproxy_linux_"$ARCHITECTURE".tar.gz
      [ -x "$(type -p tar)" ] || ${PACKAGE_INSTALL[int]} tar 2>/dev/null || ( ${PACKAGE_UPDATE[int]}; ${PACKAGE_INSTALL[int]} tar 2>/dev/null )
      tar xzf wireproxy.tar.gz -C /usr/bin/; rm -f wireproxy.tar.gz
    fi

    # 注册 WARP 账户 ( warp-account.conf 使用默认值加快速度)。如有 WARP+ 账户，修改 license 并升级，并把设备名等信息保存到 /etc/wireguard/info.log
    mkdir -p /etc/wireguard/ >/dev/null 2>&1
    warp_api "register" > /etc/wireguard/warp-account.conf "$LICENSE" 2>/dev/null

    # 有 License 来升级账户
    if [ -n "$LICENSE" ]; then
      local UPDATE_RESULT=$(warp_api "license" "/etc/wireguard/warp-account.conf" "$LICENSE")
      if grep -q '"warp_plus": true' <<< "$UPDATE_RESULT"; then
        [ -n "$NAME" ] && warp_api "name" "/etc/wireguard/warp-account.conf" "" "$NAME" >/dev/null 2>&1
        sed -i "s#\([ ]\+\"license\": \"\).*#\1$LICENSE\"#g; s#\"account_type\".*#\"account_type\": \"limited\",#g; s#\([ ]\+\"name\": \"\).*#\1$NAME\"#g" /etc/wireguard/warp-account.conf
        echo "$LICENSE" > /etc/wireguard/license
        echo -e "Device name   : $NAME" > /etc/wireguard/info.log
      elif grep -q 'Invalid license' <<< "$UPDATE_RESULT"; then
        warning "\n $(text 169) \n"
      elif grep -q 'Too many connected devices.' <<< "$UPDATE_RESULT"; then
        warning "\n $(text 36) \n"
      else
        warning "\n $(text 42) \n"
      fi
    fi

    # 生成 WireGuard 配置文件 (warp.conf)
    if [ -s /etc/wireguard/warp-account.conf ]; then
      cat > /etc/wireguard/warp.conf <<EOF
[Interface]
PrivateKey = $(grep 'private_key' /etc/wireguard/warp-account.conf | cut -d\" -f4)
Address = 172.16.0.2/32
Address = $(grep '"v6.*"$' /etc/wireguard/warp-account.conf | cut -d\" -f4)/128
DNS = 8.8.8.8
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

      cat > /etc/wireguard/NonGlobalUp.sh <<EOF
sleep 5
ip -4 rule add from 172.16.0.2 lookup 51820
ip -4 rule add table main suppress_prefixlength 0
ip -4 route add default dev warp table 51820
ip -6 rule add oif warp lookup 51820
ip -6 rule add table main suppress_prefixlength 0
ip -6 route add default dev warp table 51820
EOF

      cat > /etc/wireguard/NonGlobalDown.sh <<EOF
ip -4 rule delete oif warp lookup 51820
ip -4 rule delete table main suppress_prefixlength 0
ip -6 rule delete oif warp lookup 51820
ip -6 rule delete table main suppress_prefixlength 0
EOF

      chmod +x /etc/wireguard/NonGlobal*.sh
      info "\n $(text 33) \n"
    fi
  }&

  # 对于 IPv4 only VPS 开启 IPv6 支持
  # 感谢 P3terx 大神项目这块的技术指导。项目:https://github.com/P3TERX/warp.sh/blob/main/warp.sh
  {
    [ "$IPV4$IPV6" = 10 ] && [[ $(sysctl -a 2>/dev/null | grep 'disable_ipv6.*=.*1') || $(grep -s "disable_ipv6.*=.*1" /etc/sysctl.{conf,d/*} ) ]] &&
    (sed -i '/disable_ipv6/d' /etc/sysctl.{conf,d/*}
    echo 'net.ipv6.conf.all.disable_ipv6 = 0' >/etc/sysctl.d/ipv6.conf
    sysctl -w net.ipv6.conf.all.disable_ipv6=0)
  }&

  # 后台设置优先使用 IPv4 /IPv6 网络
  { stack_priority; }&

  # 根据系统选择需要安装的依赖
  info "\n $(text 32) \n"

  case "$SYSTEM" in
    Debian )
      local DEBIAN_VERSION=$(echo $SYS | sed "s/[^0-9.]//g" | cut -d. -f1)
      # 添加 backports 源,之后才能安装 wireguard-tools
      if [ "$DEBIAN_VERSION" = '9' ]; then
        echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
        echo -e "Package: *\nPin: release a=unstable\nPin-Priority: 150\n" > /etc/apt/preferences.d/limit-unstable
      elif
        [ "$DEBIAN_VERSION" = '10' ]; then
        echo 'deb http://archive.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/backports.list
      else
        echo "deb http://deb.debian.org/debian $(awk -F '=' '/VERSION_CODENAME/{print $2}' /etc/os-release)-backports main" > /etc/apt/sources.list.d/backports.list
      fi
      # 获取最新的软件包列表和更新已安装软件包的信息
      ${PACKAGE_UPDATE[int]}

      # 安装一些必要的网络工具包和wireguard-tools (Wire-Guard 配置工具:wg、wg-quick)
      ${PACKAGE_INSTALL[int]} --no-install-recommends net-tools openresolv dnsutils iptables
      [ "$IS_PUFFERFFISH" != 'is_pufferffish' ] && ${PACKAGE_INSTALL[int]} --no-install-recommends wireguard-tools
      ;;

    Ubuntu )
      # 获取最新的软件包列表和更新已安装软件包的信息
      ${PACKAGE_UPDATE[int]}

      # 安装一些必要的网络工具包和 wireguard-tools (Wire-Guard 配置工具:wg、wg-quick)
      ${PACKAGE_INSTALL[int]} --no-install-recommends net-tools openresolv dnsutils iptables
      [ "$IS_PUFFERFFISH" != 'is_pufferffish' ] && ${PACKAGE_INSTALL[int]} --no-install-recommends wireguard-tools
      ;;

    CentOS|Fedora )
      # 安装一些必要的网络工具包和wireguard-tools (Wire-Guard 配置工具:wg、wg-quick)
      [ "$SYSTEM" = 'CentOS' ] && ${PACKAGE_INSTALL[int]} epel-release
      ${PACKAGE_INSTALL[int]} net-tools iptables
      [ "$IS_PUFFERFFISH" != 'is_pufferffish' ] && ${PACKAGE_INSTALL[int]} wireguard-tools

      # 升级所有包同时也升级软件和系统内核
      ${PACKAGE_UPDATE[int]}

      # s390x wireguard-tools 安装
      [ "$ARCHITECTURE" = s390x ] && [ ! -x "$(type -p wg)" ] && rpm -i https://mirrors.cloud.tencent.com/epel/8/Everything/s390x/Packages/w/wireguard-tools-1.0.20210914-1.el8.s390x.rpm

      # CentOS Stream 9 需要安装 resolvconf
      [[ "$SYSTEM" = CentOS && "$(expr "$SYS" : '.*\s\([0-9]\{1,\}\)\.*')" = 9 ]] && [ ! -x "$(type -p resolvconf)" ] &&
      wget $STACK -P /usr/sbin ${GH_PROXY}https://github.com/fscarmen/warp/releases/download/resolvconf/resolvconf && chmod +x /usr/sbin/resolvconf
      ;;

    Alpine )
      # 安装一些必要的网络工具包和wireguard-tools (Wire-Guard 配置工具:wg、wg-quick)
      ${PACKAGE_INSTALL[int]} net-tools iproute2 openresolv openrc iptables ip6tables
      [ "$IS_PUFFERFFISH" != 'is_pufferffish' ] && ${PACKAGE_INSTALL[int]} wireguard-tools
      ;;

    Arch )
      # 安装一些必要的网络工具包和wireguard-tools (Wire-Guard 配置工具:wg、wg-quick)
      ${PACKAGE_INSTALL[int]} openresolv
      [ "$IS_PUFFERFFISH" != 'is_pufferffish' ] && ${PACKAGE_INSTALL[int]} wireguard-tools
  esac

  # 在不是 wireproxy 方案的前提下，先判断是否一定要用 wireguard kernel，如果不是，修改 wg-quick 文件，以使用 wireguard-go reserved 版
  if [ "$IS_PUFFERFFISH" != 'is_pufferffish' ]; then
    if [ "$WIREGUARD_GO_ENABLE" = '1' ]; then
      # 则根据 wireguard-tools 版本判断下载 wireguard-go reserved 版本: wg < v1.0.20210223 , wg-go-reserved = v0.0.20201118-reserved; wg >= v1.0.20210223 , wg-go-reserved = v0.0.20230223-reserved
      local WIREGUARD_TOOLS_VERSION=$(wg --version | sed "s#.* v1\.0\.\([0-9]\+\) .*#\1#g")
      [[ "$WIREGUARD_TOOLS_VERSION" < 20210223 ]] && mv /tmp/wireguard-go-20201118 /usr/bin/wireguard-go || mv /tmp/wireguard-go-20230223 /usr/bin/wireguard-go
      rm -f /tmp/wireguard-go-*
      if [ "$KERNEL_ENABLE" = '1' ]; then
        cp -f /usr/bin/wg-quick{,.origin}
        cp -f /usr/bin/wg-quick{,.reserved}
        grep -q '^#[[:space:]]*add_if' /usr/bin/wg-quick.reserved || sed -i '/add_if$/ {s/^/# /; N; s/\n/&\twireguard-go "$INTERFACE"\n/}' /usr/bin/wg-quick.reserved
        [ "$KERNEL_OR_WIREGUARD_GO" = 'wireguard-go with reserved' ] && cp -f /usr/bin/wg-quick.reserved /usr/bin/wg-quick
      else
        grep -q '^#[[:space:]]*add_if' /usr/bin/wg-quick || sed -i '/add_if$/ {s/^/# /; N; s/\n/&\twireguard-go "$INTERFACE"\n/}' /usr/bin/wg-quick
      fi
    fi
  fi

  wait

  # 如有所有 endpoint 都不能连通的情况，脚本中止
  if [ -e /tmp/noudp ]; then
    rm -f /tmp/{noudp,best_mtu,best_endpoint} /usr/bin/wireguard-go /etc/wireguard/{wgcf-account.conf,warp-temp.conf,warp-account.conf,warp_unlock.sh,warp.conf.bak,warp.conf,up,proxy.conf.bak,proxy.conf,menu.sh,license,language,info-temp.log,info.log,down,account-temp.conf,NonGlobalUp.sh,NonGlobalDown.sh}
    [[ -e /etc/wireguard && -z "$(ls -A /etc/wireguard/)" ]] && rmdir /etc/wireguard
    error "\n $(text 188) \n"
  fi

  # WARP 配置修改
  MODIFY014="s/\(DNS[ ]\+=[ ]\+\).*/\12606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844,1.1.1.1,8.8.8.8,8.8.4.4/g;7 s/^/PostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/;s/^.*\:\:\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY016="s/\(DNS[ ]\+=[ ]\+\).*/\12606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844,1.1.1.1,8.8.8.8,8.8.4.4/g;7 s/^/PostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/;s/^.*0\.\0\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY01D="s/\(DNS[ ]\+=[ ]\+\).*/\12606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844,1.1.1.1,8.8.8.8,8.8.4.4/g;7 s/^/PostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/;\$a\PersistentKeepalive = 30"
  MODIFY104="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\n\n/;s/^.*\:\:\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY106="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\n\n/;s/^.*0\.\0\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY10D="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\n\n/;\$a\PersistentKeepalive = 30"
  MODIFY114="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\nPostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/;s/^.*\:\:\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY116="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\nPostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/;s/^.*0\.\0\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY11D="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\nPostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/;\$a\PersistentKeepalive = 30"
  MODIFY11N4="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\nPostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/;s/^.*\:\:\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY11N6="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\nPostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/;s/^.*0\.\0\/0/#&/g;\$a\PersistentKeepalive = 30"
  MODIFY11ND="s/\(DNS[ ]\+=[ ]\+\).*/\11.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;7 s/^/PostUp = ip -4 rule add from $LAN4 lookup main\nPostDown = ip -4 rule delete from $LAN4 lookup main\nPostUp = ip -6 rule add from $LAN6 lookup main\nPostDown = ip -6 rule delete from $LAN6 lookup main\n\n/;\$a\PersistentKeepalive = 30"

  # 修改配置文件
  sed -i "$(eval echo "\$MODIFY$CONF")" /etc/wireguard/warp.conf
  [ -e /tmp/best_mtu ] && MTU=$(cat /tmp/best_mtu) && rm -f /tmp/best_mtu && sed -i "s/MTU.*/MTU = $MTU/g" /etc/wireguard/warp.conf
  [ -e /tmp/best_endpoint ] && ENDPOINT=$(cat /tmp/best_endpoint) && rm -f /tmp/best_endpoint && sed -i "s/engage.*/$ENDPOINT/g" /etc/wireguard/warp.conf
  [ "$GLOBAL_OR_NOT" = "$(text 185)" ] && sed -i "/Table/s/#//g;/NonGlobal/s/#//g" /etc/wireguard/warp.conf
  info "\n $(text 81) \n"

  # 对于 CentOS 9 / AlmaLinux 9 / RockyLinux 9 及类似系统的处理
  if [ "${SYSTEM}_${MAJOR_VERSION}" = 'CentOS_9' ]; then
    centos9_resolv backup
    centos9_resolv generate $m
    sed -i 's/^\(DNS[[:space:]]=.*\)/#\1/' /etc/wireguard/warp.conf
  fi

  if [ "$IS_PUFFERFFISH" = 'is_pufferffish' ]; then
    # 默认 Endpoint 和 DNS 默认 IPv4 和 双栈的，如是 IPv6 修改默认值
    local ENDPOINT=$(awk '/^Endpoint/{print $NF}' /etc/wireguard/warp.conf)
    local MTU=$(awk '/^MTU/{print $NF}' /etc/wireguard/warp.conf)
    local FREE_ADDRESS6=$(awk '/^Address.*128$/{print $NF}' /etc/wireguard/warp.conf)
    local FREE_PRIVATEKEY=$(awk '/PrivateKey/{print $NF}' /etc/wireguard/warp.conf)
    [ "$m" = 0 ] && local DNS='2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844,1.1.1.1,8.8.8.8,8.8.4.4' || local DNS='1.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844'

    # 创建 Wireproxy 配置文件
    cat > /etc/wireguard/proxy.conf << EOF
# The [Interface] and [Peer] configurations follow the same semantics and meaning
# of a wg-quick configuration. To understand what these fields mean, please refer to:
# https://wiki.archlinux.org/title/WireGuard#Persistent_configuration
# https://www.wireguard.com/#simple-network-interface
[Interface]
Address = 172.16.0.2/32 # The subnet should be /32 and /128 for IPv4 and v6 respectively
Address = $FREE_ADDRESS6
MTU = $MTU
PrivateKey = $FREE_PRIVATEKEY
DNS = $DNS

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
# PresharedKey = UItQuvLsyh50ucXHfjF0bbR4IIpVBd74lwKc8uIPXXs= (optional)
Endpoint = $ENDPOINT
# PersistentKeepalive = 25 (optional)

# TCPClientTunnel is a tunnel listening on your machine,
# and it forwards any TCP traffic received to the specified target via wireguard.
# Flow:
# <an app on your LAN> --> localhost:25565 --(wireguard)--> play.cubecraft.net:25565
#[TCPClientTunnel]
#BindAddress = 127.0.0.1:25565
#Target = play.cubecraft.net:25565

# TCPServerTunnel is a tunnel listening on wireguard,
# and it forwards any TCP traffic received to the specified target via local network.
# Flow:
# <an app on your wireguard network> --(wireguard)--> 172.16.31.2:3422 --> localhost:25545
#[TCPServerTunnel]
#ListenPort = 3422
#Target = localhost:25545

# Socks5 creates a socks5 proxy on your LAN, and all traffic would be routed via wireguard.
[Socks5]
BindAddress = 127.0.0.1:$PORT

# Socks5 authentication parameters, specifying username and password enables
# proxy authentication.
#Username = ...
# Avoid using spaces in the password field
#Password = ...
EOF

    # 创建 WireProxy systemd 进程守护
    if [ "$SYSTEM" = Alpine ]; then
      cat > /etc/init.d/wireproxy << EOF
#!/sbin/openrc-run

description="WireProxy for WARP"
command="/usr/bin/wireproxy"
command_args="-c /etc/wireguard/proxy.conf"
command_background=true
pidfile="/var/run/wireproxy.pid"
EOF
      chmod +x /etc/init.d/wireproxy
    else
      cat > /lib/systemd/system/wireproxy.service << EOF
[Unit]
Description=WireProxy for WARP
After=network.target
Documentation=https://github.com/fscarmen/warp-sh
Documentation=https://github.com/pufferffish/wireproxy

[Service]
ExecStart=/usr/bin/wireproxy -c /etc/wireguard/proxy.conf
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    fi

    # 保存好配置文件, 如有 Teams，改为 Teams 账户信息
    mv -f $0 /etc/wireguard/menu.sh >/dev/null 2>&1
    [ "$CHOOSE_TEAMS" = '2' ] && input_url_token token
    if [ "${CONFIRM_TEAMS_INFO,,}" = 'y' ]; then
      backup_restore_delete backup wireproxy
      sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ]\+=[ ]\+\).*\(/128$\)#\1$ADDRESS6\2#g; s#\(.*Reserved[ ]\+=[ ]\+\).*#\1$CLIENT_ID#g" /etc/wireguard/warp.conf
      [ "$CHOOSE_TEAMS" = '2' ] && echo "$TEAMS" > /etc/wireguard/warp-account.conf || sed -i "s#\(\"private_key\":[ ]\+\"\).*\(\"\)#\1$PRIVATEKEY\2#; s#\(\"client_id\":[ ]\+\"\).*\(\"\)#\1$RESERVED\2#; s#\(\"v6\":[ ]\+\"\)[0-9a-f].*\(\"\)#\1$ADDRESS6\2#" /etc/wireguard/warp-account.conf
      sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ]\+=[ ]\+\).*\(/128$\)#\1$ADDRESS6\2#g" /etc/wireguard/proxy.conf
      echo "$TEAMS" > /etc/wireguard/info.log
    fi

    # 创建再次执行的软链接快捷方式，再次运行可以用 warp 指令,设置默认语言
    chmod +x /etc/wireguard/menu.sh >/dev/null 2>&1
    ln -sf /etc/wireguard/menu.sh /usr/bin/warp && info " $(text 38) "
    echo "$L" >/etc/wireguard/language

    # 如成功升级 Teams ，根据新账户信息修改配置文件并注销旧账户; 如失败则还原为原账户
    wireproxy_onoff no_output
    if [[ "$WIREPROXY_TRACE4$WIREPROXY_TRACE6" =~ on|plus ]]; then
      warp_api "cancel" "/etc/wireguard/warp-account.conf.bak" >/dev/null 2>&1
      backup_restore_delete delete
    else
      ACCOUNT_CHANGE_FAILED='Teams' && warning "\n $(text 187) \n"
      backup_restore_delete restore wireproxy
      unset CONFIRM_TEAMS_INFO
      wireproxy_onoff no_output
    fi

    # 设置开机启动 wireproxy
    [ "$SYSTEM" = Alpine ] && rc-update add wireproxy default || systemctl enable --now wireproxy
    sleep 1

    # 结果提示，脚本运行时间，次数统计
    end=$(date +%s)
    info " $(text 149)\n $(text 27): $WIREPROXY_SOCKS5\n WARP$WIREPROXY_ACCOUNT\n IPv4: $WIREPROXY_WAN4 $WIREPROXY_COUNTRY4 $WIREPROXY_ASNORG4\n IPv6: $WIREPROXY_WAN6 $WIREPROXY_COUNTRY6 $WIREPROXY_ASNORG6"
    [ -n "$QUOTA" ] && info " $(text 63): $QUOTA "
    echo -e "\n==============================================================\n"
    hint " $(text 43) \n" && help

  else
    [ "$IS_ANEMONE" = 'is_anemone' ] && ( iptables_solution; systemctl restart dnsmasq >/dev/null 2>&1 )

    # 经过确认的 teams private key 和 address6，改为 Teams 账户信息，不确认则不升级
    [ "$CHOOSE_TEAMS" = '2' ] && input_url_token token
    if [ "${CONFIRM_TEAMS_INFO,,}" = 'y' ]; then
      backup_restore_delete backup warp
      sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ]\+=[ ]\+\).*\(/128$\)#\1$ADDRESS6\2#g; s#\(.*Reserved[ ]\+=[ ]\+\).*#\1$CLIENT_ID#g" /etc/wireguard/warp.conf
      [ "$CHOOSE_TEAMS" = '2' ] && echo "$TEAMS" > /etc/wireguard/warp-account.conf || sed -i "s#\(\"private_key\":[ ]\+\"\).*\(\"\)#\1$PRIVATEKEY\2#; s#\(\"client_id\":[ ]\+\"\).*\(\"\)#\1$RESERVED\2#; s#\(\"v6\":[ ]\+\"\)[0-9a-f].*\(\"\)#\1$ADDRESS6\2#" /etc/wireguard/warp-account.conf
      echo "$TEAMS" > /etc/wireguard/info.log
    fi

    # 创建再次执行的软链接快捷方式，再次运行可以用 warp 指令,设置默认语言
    mv -f $0 /etc/wireguard/menu.sh >/dev/null 2>&1
    chmod +x /etc/wireguard/menu.sh >/dev/null 2>&1
    ln -sf /etc/wireguard/menu.sh /usr/bin/warp && info " $(text 38) "
    echo "$L" >/etc/wireguard/language

    # 自动刷直至成功（ warp bug，有时候获取不了ip地址），重置之前的相关变量值，记录新的 IPv4 和 IPv6 地址和归属地，IPv4 / IPv6 优先级别
    info " $(text 39) "
    unset IP4 IP6 WAN4 WAN6 COUNTRY4 COUNTRY6 ASNORG4 ASNORG6 TRACE4 TRACE6 PLUS4 PLUS6 WARPSTATUS4 WARPSTATUS6
    net no_output

    # 如成功升级 Teams ，根据新账户信息修改配置文件并注销旧账户; 如失败则还原为原账户
    if [[ "$TRACE4$TRACE6" =~ on|plus ]]; then
      warp_api "cancel" "/etc/wireguard/warp-account.conf.bak" >/dev/null 2>&1
      backup_restore_delete delete
    else
      ACCOUNT_CHANGE_FAILED='Teams' && warning "\n $(text 187) \n"
      backup_restore_delete restore warp
      unset CONFIRM_TEAMS_INFO
      net
    fi

    # 显示 IPv4 / IPv6 优先结果
    result_priority

    # 设置开机启动 warp
    ${SYSTEMCTL_ENABLE[int]} >/dev/null 2>&1

    # 结果提示，脚本运行时间，次数统计
    end=$(date +%s)
    echo -e "\n==============================================================\n"
    info " IPv4: $WAN4 $COUNTRY4  $ASNORG4 "
    info " IPv6: $WAN6 $COUNTRY6  $ASNORG6 "
    info " $(text 41) " && [ -n "$QUOTA" ] && info " $(text 133) "
    info " $PRIORITY_NOW , $(text 186) "
    echo -e "\n==============================================================\n"
    hint " $(text 43) \n" && help
    [[ "$TRACE4$TRACE6" = offoff ]] && warning " $(text 44) "
  fi
  }

client_install() {
  settings() {
    # 设置为代理模式，如有 WARP+ 账户，修改 license 并升级
    info " $(text 84) "
    warp-cli --accept-tos registration new >/dev/null 2>&1
    # 注册失败，给予一个免费账户。否则根据是否有 License 来升级
    if [[ $(warp-cli --accept-tos registration show) =~ 'Error: Missing registration' ]]; then
      [ ! -d /var/lib/cloudflare-warp ] && mkdir -p /var/lib/cloudflare-warp
      echo '{"registration_id":"317b5a76-3da1-469f-88d6-c3b261da9f10","api_token":"11111111-1111-1111-1111-111111111111","secret_key":"CNUysnWWJmFGTkqYtg/wpDfURUWvHB8+U1FLlVAIB0Q=","public_key":"DuOi83pAIsbJMP3CJpxq6r3LVGHtqLlzybEIvbczRjo=","override_codes":null}' > /var/lib/cloudflare-warp/reg.json
      echo '{"own_public_key":"DuOi83pAIsbJMP3CJpxq6r3LVGHtqLlzybEIvbczRjo=","registration_id":"317b5a76-3da1-469f-88d6-c3b261da9f10","time_created":{"secs_since_epoch":1692163041,"nanos_since_epoch":81073202},"interface":{"v4":"172.16.0.2","v6":"2606:4700:110:8d4e:cef9:30c2:6d4a:f97b"},"endpoints":[{"v4":"162.159.192.7:2408","v6":"[2606:4700:d0::a29f:c007]:2408"},{"v4":"162.159.192.7:500","v6":"[2606:4700:d0::a29f:c007]:500"},{"v4":"162.159.192.7:1701","v6":"[2606:4700:d0::a29f:c007]:1701"},{"v4":"162.159.192.7:4500","v6":"[2606:4700:d0::a29f:c007]:4500"}],"public_key":"bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=","account":{"account_type":"free","id":"7e0e6c80-24c5-49ba-ba3d-087f45fcd1e9","license":"n01H3Cf4-3Za40C7b-5qOs0c42"},"policy":null,"valid_until":"2023-08-17T05:17:21.081073724Z","alternate_networks":null,"dex_tests":null,"custom_cert_settings":null}' > /var/lib/cloudflare-warp/conf.json
      warp-cli --accept-tos disconnect >/dev/null 2>&1
      warp-cli --accept-tos connect >/dev/null 2>&1
      sleep 1
      [[ $(warp-cli --accept-tos registration show) =~ 'Free' ]] && warning "\n $(text 107) \n"
    elif [ -n "$LICENSE" ]; then
      hint " $(text 35) " && warp-cli --accept-tos registration license "$LICENSE" >/dev/null 2>&1 && sleep 1 &&
      local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk  '/type/{print $3}') &&
      [ "$CLIENT_ACCOUNT" = Limited ] && TYPE='+' && echo "$LICENSE" > /etc/wireguard/license && info " $(text 62) " ||
      warning " $(text 36) "
    fi

    wait
    [ -e /tmp/noudp ] && rm -f /tmp/noudp && error "\n $(text 188) \n"

    # 根据优选出来的 endpoint 设置
    [ -e /tmp/best_endpoint ] && ENDPOINT=$(cat /tmp/best_endpoint) && rm -f /tmp/best_endpoint
    warp-cli --accept-tos tunnel endpoint set $ENDPOINT >/dev/null 2>&1
    [ "$(warp-cli --accept-tos settings | awk '/WARP endpoint/{print $NF}')" = "$ENDPOINT" ] && info "\n $(text 81) \n"

    # 判断安装模式: IS_LUBAN=is_luban 为 warp interface 模式，否则为 socks5 proxy 模式
    if [ "$IS_LUBAN" = 'is_luban' ]; then
      i=1; j=3
      hint " $(text 11)\n $(text 12) "
      #####  warp-cli --accept-tos tunnel ip-range add/remove <cidr>
      warp-cli --accept-tos add-excluded-route 0.0.0.0/0 >/dev/null 2>&1
      warp-cli --accept-tos add-excluded-route ::0/0 >/dev/null 2>&1
      warp-cli --accept-tos mode warp >/dev/null 2>&1
      warp-cli --accept-tos tunnel endpoint "$ENDPOINT" >/dev/null 2>&1
      warp-cli --accept-tos connect >/dev/null 2>&1
      sleep 5
      rule_add >/dev/null 2>&1
      ip_case d is_luban
      until [[ -n "$CFWARP_WAN4" && -n "$CFWARP_WAN6" ]]; do
        (( i++ )) || true
        hint " $(text 12) "
        warp-cli --accept-tos disconnect >/dev/null 2>&1
        rule_del >/dev/null 2>&1
        sleep 2
        warp-cli --accept-tos connect >/dev/null 2>&1
        sleep 5
        rule_add >/dev/null 2>&1
        ip_case d is_luban
        if [ "$i" = "$j" ]; then
          warp-cli --accept-tos disconnect >/dev/null 2>&1
          rule_del >/dev/null 2>&1
          error " $(text 13) "
        fi
      done
      info " $(text 14) "
    else
      warp-cli --accept-tos mode proxy >/dev/null 2>&1
      warp-cli --accept-tos proxy port "$PORT" >/dev/null 2>&1
      warp-cli --accept-tos tunnel endpoint "$ENDPOINT" >/dev/null 2>&1
      warp-cli --accept-tos connect >/dev/null 2>&1
      sleep 2 && [[ ! $(ss -nltp | awk '{print $NF}' | awk -F \" '{print $2}') =~ warp-svc ]] && error " $(text 87) " || info " $(text 86) "
    fi
  }

  # 禁止安装的情况: 1. 重复安装; 2. 非 AMD64 CPU 架构; 3. 非 Ubuntu / Debian / CentOS 系统
  [ "$CLIENT" -ge 2 ] && error " $(text 85) "
  [[ ! "$ARCHITECTURE" =~ ^(arm64|amd64)$ ]] && error " $(text 101) "
  [[ ! "$SYSTEM" =~ Ubuntu|Debian|CentOS ]] && error " $(text 191) "

  # 后台优选 WARP Endpoint
  { best_endpoint; }&

  # 安装 WARP Linux Client
  [[ "$SYSTEM" = 'CentOS' && "$(expr "$SYS" : '.*\s\([0-9]\{1,\}\)\.*')" -le 7 ]] && error " $(text 145) "
  input_license
  [ "$IS_LUBAN" != 'is_luban' ] && input_port
  start=$(date +%s)
  mkdir -p /etc/wireguard/ >/dev/null 2>&1
  if [ "$CLIENT" = 0 ]; then
    info " $(text 83) "
    if grep -q "CentOS\|Fedora" <<< "$SYSTEM"; then
      curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo | tee /etc/yum.repos.d/cloudflare-warp.repo
    else
      # 暂时没有 Ubuntu 24.04 (noble)，替换为 22.04 (jammy)
      local VERSION_CODENAME=$(awk -F '=' '/VERSION_CODENAME/{print $2}' /etc/os-release | sed 's/noble/jammy/')
      curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
      echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $VERSION_CODENAME main" | tee /etc/apt/sources.list.d/cloudflare-client.list
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

  # 创建再次执行的软链接快捷方式，再次运行可以用 warp 指令,设置默认语言
  mv -f $0 /etc/wireguard/menu.sh >/dev/null 2>&1
  chmod +x /etc/wireguard/menu.sh >/dev/null 2>&1
  ln -sf /etc/wireguard/menu.sh /usr/bin/warp && info " $(text 38) "
  echo "$L" >/etc/wireguard/language

  # 结果提示，脚本运行时间，次数统计
  local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk  '/type/{print $3}')
  [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && check_quota client

  if [ "$IS_LUBAN" = 'is_luban' ]; then
    end=$(date +%s)
    echo -e "\n==============================================================\n"
    info " $(text 94)\n WARP$CLIENT_AC IPv4: $CFWARP_WAN4 $CFWARP_COUNTRY4  $CFWARP_ASNORG4\n WARP$CLIENT_AC IPv6: $CFWARP_WAN6 $CFWARP_COUNTRY6  $CFWARP_ASNORG6 "
  else
    ip_case d client
    end=$(date +%s)
    echo -e "\n==============================================================\n"
    info " $(text 94)\n $(text 27): $CLIENT_SOCKS5\n WARP$CLIENT_AC IPv4: $CLIENT_WAN4 $CLIENT_COUNTRY4 $CLIENT_ASNORG4\n WARP$CLIENT_AC IPv6: $CLIENT_WAN6 $CLIENT_COUNTRY6 $CLIENT_ASNORG6 "
  fi

  [ -n "$QUOTA" ] && info " $(text 63): $QUOTA "
  echo -e "\n==============================================================\n"
  hint " $(text 43) \n" && help
}

# iptables+dnsmasq+ipset 方案，IPv6 only 不适用
stream_solution() {
  [ "$m" = 0 ] && error " $(text 147) "

  echo -e "\n==============================================================\n"
  info " $(text 139) "
  echo -e "\n==============================================================\n"
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

# wireproxy 方案
wireproxy_solution() {
  ss -nltp | grep -q wireproxy && error " $(text 166) "

  echo -e "\n==============================================================\n"
  info " $(text 165) "
  echo -e "\n==============================================================\n"
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

# 查 WARP+ 余额流量接口
check_quota() {
  local CHECK_TYPE="$1"

  if [ "$CHECK_TYPE" = 'client' ]; then
    QUOTA=$(warp-cli --accept-tos registration show 2>/dev/null | awk -F' ' '/Quota/{print $NF}')
  elif [ -e /etc/wireguard/warp-account.conf ]; then
    QUOTA=$(warp_api "device" "/etc/wireguard/warp-account.conf" | awk '/quota/{print $NF}' | sed "s#,##")
  fi

  # 部分系统没有依赖 bc，所以两个小数不能用 $(echo "scale=2; $QUOTA/1000000000000000" | bc)，改为从右往左数字符数的方法
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

# 更换账户时，原有账户信息的备份、还原和删除
backup_restore_delete() {
  local EXECUTE="$1"
  local WARP_ACCOUNT_TYPE="$2"
  if [ "$EXECUTE" = backup ]; then
    case "$WARP_ACCOUNT_TYPE" in
      warp )
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
      warp )
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

# 更换为免费账户
change_to_free() {
  # client 两个模式升级 plus 流程: 1.注销原账户，删除原账户的 License(如有)，停止服务; 2.注册新账户，并显示结果
  if [ "$UPDATE_ACCOUNT" = client ]; then
    # 流程1:注销原账户，删除原账户的 License(如有)，停止服务
    local CLIENT_MODE=$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i+1)}}')
    warp-cli --accept-tos registration delete >/dev/null 2>&1
    [ -e /etc/wireguard/license ] && rm -f /etc/wireguard/license
    [ "$CLIENT_MODE" = 'Warp' ] && rule_del >/dev/null 2>&1

    # 流程2:注册新账户，并显示结果
    warp-cli --accept-tos registration new >/dev/null 2>&1
    unset AC && TYPE=' Free'
    sleep 2
    if [ "$CLIENT_MODE" = 'Warp' ]; then
      rule_add >/dev/null 2>&1
      ip_case d is_luban
      info " WARP$CLIENT_AC IPv4: $CFWARP_WAN4 $CFWARP_COUNTRY4  $CFWARP_ASNORG4\n WARP$CLIENT_AC IPv6: $CFWARP_WAN6 $CFWARP_COUNTRY6  $CFWARP_ASNORG6\n $(text 62) "
    elif [ "$CLIENT_MODE" = 'WarpProxy' ]; then
      ip_case d client
      info " $(text 27): $CLIENT_SOCKS5\n WARP$CLIENT_AC\n IPv4: $CLIENT_WAN4 $CLIENT_COUNTRY4 $CLIENT_ASNORG4\n IPv6: $CLIENT_WAN6 $CLIENT_COUNTRY6 $CLIENT_ASNORG6\n $(text 62) "
    fi
    exit 0
  elif [[ "$UPDATE_ACCOUNT" =~ 'warp'|'wireproxy' ]]; then
    # 如原账户类型是 free，只启动服务不升级
    if [ "$ACCOUNT_TYPE" = free ]; then
      if [ "$UPDATE_ACCOUNT" = 'warp' ]; then
        net
      elif [ "$UPDATE_ACCOUNT" = 'wireproxy' ]; then
        systemctl restart wireproxy; sleep 1
        ip_case d wireproxy
        TYPE=' Free' && info " $(text 27): $WIREPROXY_SOCKS5\n WARP$WIREPROXY_ACCOUNT\n IPv4: $WIREPROXY_WAN4 $WIREPROXY_COUNTRY4 $WIREPROXY_ASNORG4\n IPv6: $WIREPROXY_WAN6 $WIREPROXY_COUNTRY6 $WIREPROXY_ASNORG6\n $(text 62) "
      fi
      exit 0
    fi

    # warp 和 wireproxy 更换 free 流程: 1.先停止服务; 2. 备份原账户信息; 3.注册新账户; 4.如成功，根据新账户信息修改配置文件并注销旧账户; 如失败则还原为原账户
    # 流程1:停止服务
    case "$UPDATE_ACCOUNT" in
      warp )
        wg-quick down warp >/dev/null 2>&1
        ;;
      wireproxy )
        systemctl stop wireproxy
    esac

    # 流程2:备份原账户信息
    case "$UPDATE_ACCOUNT" in
      warp )
        backup_restore_delete backup warp
        ;;
      wireproxy )
        backup_restore_delete backup wireproxy
    esac

    # 流程3:注册新账户
    warp_api "register" > /etc/wireguard/warp-account.conf 2>/dev/null

    # 流程4:如成功，根据新账户信息修改配置文件并注销旧账户; 如失败则还原为原账户
    # 如升级成功的处理: 删除原账户信息文件，注销原账户
    if grep -q 'warp_plus' /etc/wireguard/warp-account.conf; then
      warp_api "cancel" "/etc/wireguard/warp-account.conf.bak" >/dev/null 2>&1
      backup_restore_delete delete
      local PRIVATEKEY="$(grep 'private_key' /etc/wireguard/warp-account.conf | cut -d\" -f4)"
      local ADDRESS6="$(grep '"v6.*"$' /etc/wireguard/warp-account.conf | cut -d\" -f4)"
      local CLIENT_ID="$(warp_api "convert" "/etc/wireguard/warp-account.conf" "" "" "" "" "file")"
      sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ]\+=[ ]\+\).*\(/128$\)#\1$ADDRESS6\2#g; s#\(.*Reserved[ ]\+=[ ]\+\).*#\1$CLIENT_ID#g" /etc/wireguard/warp.conf
      [ "$UPDATE_ACCOUNT" = 'wireproxy' ] && sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ]\+=[ ]\+\).*\(/128$\)#\1$ADDRESS6\2#g" /etc/wireguard/proxy.conf
      TYPE=' Free' && [ -e /etc/wireguard/info.log ] && TYPE=' Teams' && grep -q 'Device name' /etc/wireguard/info.log && TYPE='+'
      info "\n $(text 62) \n"

    # 升级失败的处理，提示并还原为原账户
    else
      ACCOUNT_CHANGE_FAILED='Free' && warning "\n $(text 187) \n"
      case "$UPDATE_ACCOUNT" in
        warp )
          backup_restore_delete restore warp
          ;;
        wireproxy )
          backup_restore_delete restore wireproxy
      esac
    fi

    # 运行 warp 方案
    case "$UPDATE_ACCOUNT" in
      warp )
        net
        ;;
      wireproxy )
        wireproxy_onoff
    esac
    info " $(text 62) "
  fi
}

# 更换为 WARP+ 账户
change_to_plus() {
  update_license
  # client 两个模式升级 plus 流程: 1.如原账户为 plus，备份原 License; 2.注销原账户，停止服务; 3.使用新 License 升级账户; 4.如成功则删除原账户信息文件，保存 license 并显示结果; 如失败则看原账户有没有 License 用于还原
  if [ "$UPDATE_ACCOUNT" = client ]; then
    [ "$(warp-cli --accept-tos registration show 2>/dev/null | awk '/License/{print $NF}')" = "$LICENSE" ] && KEY_LICENSE='License' && error " $(text 31) "
    # 流程1:如原账户为 plus，备份原 License
    backup_restore_delete backup client

    # 流程2:注销原账户，停止服务
    hint "\n $(text 35) \n"
    warp-cli --accept-tos registration delete >/dev/null 2>&1
    local CLIENT_MODE=$(warp-cli --accept-tos settings | awk '/Mode:/{for (i=0; i<NF; i++) if ($i=="Mode:") {print $(i+1)}}')
    [ "$CLIENT_MODE" = 'Warp' ] && rule_del >/dev/null 2>&1

    # 流程3:使用新 License 升级账户
    warp-cli --accept-tos registration new >/dev/null 2>&1 &&
    [ -n "$LICENSE" ] && LICENSE_STATUS=$(warp-cli --accept-tos registration license "$LICENSE")
    sleep 1

    # 流程4:如成功则删除原账户信息文件，保存 license 并显示结果; 如失败则看原账户有没有 License 用于还原
    if [ "$LICENSE_STATUS" = Success ]; then
      backup_restore_delete del
      echo "$LICENSE" > /etc/wireguard/license
    else
      case "$LICENSE_STATUS" in
          *Invalid\ license* )
            warning "\n $(text 169) \n"
            ;;
          *Too\ many\ devices* )
            warning "\n $(text 36) \n"
            ;;
          *Error* )
            warning "\n $(text 42) \n"
      esac
      ACCOUNT_CHANGE_FAILED='Plus' && warning "\n $(text 187) \n"
      backup_restore_delete restore client
      [ -e /etc/wireguard/license ] && warp-cli --accept-tos registration license "$(cat /etc/wireguard/license)" >/dev/null 2>&1; sleep 1
    fi
    local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk '/type/{print $3}')
    unset AC && TYPE=' Free' && [ "$CLIENT_ACCOUNT" = Limited ] && CLIENT_AC='+' && TYPE='+' && check_quota client
    if [ "$CLIENT_MODE" = 'Warp' ]; then
      rule_add >/dev/null 2>&1
      ip_case d is_luban
      [ "$TYPE" = '+' ] && CLIENT_PLUS="$(text 63): $QUOTA"
      info " WARP$CLIENT_AC IPv4: $CFWARP_WAN4 $CFWARP_COUNTRY4  $CFWARP_ASNORG4\n WARP$CLIENT_AC IPv6: $CFWARP_WAN6 $CFWARP_COUNTRY6  $CFWARP_ASNORG6\n $CLIENT_PLUS\n $(text 62) \n"
    elif [ "$CLIENT_MODE" = 'WarpProxy' ]; then
      ip_case d client
      [ "$TYPE" = '+' ] && CLIENT_PLUS="$(text 63): $QUOTA"
      info " $(text 27): $CLIENT_SOCKS5\n WARP$CLIENT_AC\n IPv4: $CLIENT_WAN4 $CLIENT_COUNTRY4 $CLIENT_ASNORG4\n IPv6: $CLIENT_WAN6 $CLIENT_COUNTRY6 $CLIENT_ASNORG6\n $CLIENT_PLUS\n $(text 62) \n"
    fi
  elif [[ "$UPDATE_ACCOUNT" =~ 'warp'|'wireproxy' ]]; then
    # 如现正使用着 WARP+ 账户，并且新输入的 License 也与现一样的话，脚本退出
    [ "$ACCOUNT_TYPE" = + ] && grep -q "$LICENSE" /etc/wireguard/warp-account.conf && KEY_LICENSE='License' && error " $(text 31) "
    hint "\n $(text 35) \n"

    # warp 和 wireproxy 升级 plus 流程: 1.停止服务; 2.备份原账户信息; 3.注册新账户; 4.使用 License 升级账户; 5.如成功，根据新账户信息修改配置文件并注销旧账户; 如失败则还原为原账户
    # 流程1:停止服务
    case "$UPDATE_ACCOUNT" in
      warp )
        wg-quick down warp >/dev/null 2>&1
        ;;
      wireproxy )
        systemctl stop wireproxy
    esac

    # 流程2:备份原账户信息
    case "$UPDATE_ACCOUNT" in
      warp )
        backup_restore_delete backup warp
        ;;
      wireproxy )
        backup_restore_delete backup wireproxy
    esac

    # 流程3:注册新账户
    warp_api "register" > /etc/wireguard/warp-account.conf 2>/dev/null

    # 流程4:使用 License 升级账户
    local UPDATE_RESULT=$(warp_api "license" "/etc/wireguard/warp-account.conf" "$LICENSE")

    # 流程5:如成功，根据新账户信息修改配置文件并注销旧账户; 如失败则还原为原账户
    # 如升级成功的处理: 删除原账户信息文件，注销原账户
    if grep -q '"warp_plus": true' <<< "$UPDATE_RESULT"; then
      [ -n "$NAME" ] && warp_api "name" "/etc/wireguard/warp-account.conf" "" "$NAME" >/dev/null 2>&1
      warp_api "cancel" "/etc/wireguard/warp-account.conf.bak" >/dev/null 2>&1
      backup_restore_delete delete
      local PRIVATEKEY="$(grep 'private_key' /etc/wireguard/warp-account.conf | cut -d\" -f4)"
      local ADDRESS6="$(grep '"v6.*"$' /etc/wireguard/warp-account.conf | cut -d\" -f4)"
      local CLIENT_ID="$(warp_api "convert" "/etc/wireguard/warp-account.conf" "" "" "" "" "file")"
      sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ]\+=[ ]\+\).*\(/128$\)#\1$ADDRESS6\2#g; s#\(.*Reserved[ ]\+=[ ]\+\).*#\1$CLIENT_ID#g" /etc/wireguard/warp.conf
      [ "$UPDATE_ACCOUNT" = 'wireproxy' ] && sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ]\+=[ ]\+\).*\(/128$\)#\1$ADDRESS6\2#g" /etc/wireguard/proxy.conf
      sed -i "s#\([ ]\+\"license\": \"\).*#\1$LICENSE\"#g; s#\"account_type\".*#\"account_type\": \"limited\",#g; s#\([ ]\+\"name\": \"\).*#\1$NAME\"#g" /etc/wireguard/warp-account.conf
      echo -e "Device name   : $NAME" > /etc/wireguard/info.log
      echo "$LICENSE" > /etc/wireguard/license
      TYPE=' Free' && [ -e /etc/wireguard/info.log ] && TYPE=' Teams' && grep -q 'Device name' /etc/wireguard/info.log && TYPE='+'
      info "\n $(text 62) \n"

    # 升级失败的处理，提示并还原为原账户
    else
      case "$UPDATE_RESULT" in
        *Invalid\ license* )
          warning "\n $(text 169) \n"
          ;;
        *Too\ many\ connected\ devices* )
          warning "\n $(text 36) \n"
          ;;
        * )
          warning "\n $(text 42) \n"
      esac

      ACCOUNT_CHANGE_FAILED='Plus' && warning "\n $(text 187) \n"
      case "$UPDATE_ACCOUNT" in
        warp )
          backup_restore_delete restore warp
          ;;
        wireproxy )
          backup_restore_delete restore wireproxy
      esac
    fi

    # 运行 warp 方案
    case "$UPDATE_ACCOUNT" in
      warp )
        net
        ;;
      wireproxy )
        wireproxy_onoff
    esac
    info " $(text 62) "
  fi
}

# 更换为 Teams 流程: 1.停止服务; 2.备份原账户信息; 3.多种途径升级 Teams 账户; 4.如成功，根据新账户信息修改配置文件并注销旧账户; 如失败则还原为原账户
change_to_teams() {
  # 选择升级途径
  [ -z "$CHOOSE_TEAMS" ] && hint "\n $(text 127) \n" && reading " $(text 50) " CHOOSE_TEAMS
  case "$CHOOSE_TEAMS" in
    1 )
      input_url_token url
      ;;
    2 )
      input_url_token token
      ;;
    3 )
      input_url_token input
      ;;
    * )
      input_url_token share
  esac

  # If the entered PrivateKey is the same as the one currently used, it will prompt that there is no need to change and propose
  grep -q "$PRIVATEKEY" /etc/wireguard/warp.conf && KEY_LICENSE='Private key' && error " $(text 31) "

  # Process 1: Confirm upgrade information and stop service
  if [ "${CONFIRM_TEAMS_INFO,,}" = 'y' ]; then
    case "$UPDATE_ACCOUNT" in
      warp )
        wg-quick down warp >/dev/null 2>&1
        ;;
      wireproxy )
        systemctl stop wireproxy
    esac
  else
    exit 0
  fi

  # Process 2: Back up original account information
  case "$UPDATE_ACCOUNT" in
    warp )
      backup_restore_delete backup warp
      ;;
    wireproxy )
      backup_restore_delete backup wireproxy
  esac

  # Process 3: Upgrade Teams account through multiple ways
  sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ]\+=[ ]\+\).*\(/128$\)#\1$ADDRESS6\2#g; s#\(.*Reserved[ ]\+=[ ]\+\).*#\1$CLIENT_ID#g" /etc/wireguard/warp.conf
  [ "$CHOOSE_TEAMS" = '2' ] && echo "$TEAMS" > /etc/wireguard/warp-account.conf || sed -i "s#\(\"private_key\":[ ]\+\"\).*\(\"\)#\1$PRIVATEKEY\2#; s#\(\"client_id\":[ ]\+\"\).*\(\"\)#\1$RESERVED\2#; s#\(\"v6\":[ ]\+\"\)[0-9a-f].*\(\"\)#\1$ADDRESS6\2#" /etc/wireguard/warp-account.conf
  [ "$UPDATE_ACCOUNT" = 'wireproxy' ] && sed -i "s#\(PrivateKey[ ]\+=[ ]\+\).*#\1$PRIVATEKEY#g; s#\(Address[ ]\+=[ ]\+\).*\(/128$\)#\1$ADDRESS6\2#g" /etc/wireguard/proxy.conf
  # First create info.log to determine the account type
  echo "$TEAMS" > /etc/wireguard/info.log

  # Process 4: If successful, modify the configuration file according to the new account information and cancel the old account; if failed, revert to the original account
  case "$UPDATE_ACCOUNT" in
    warp )
      net
      if [[ "$TRACE4$TRACE6" =~ on|plus ]]; then
        warp_api "cancel" "/etc/wireguard/warp-account.conf.bak" >/dev/null 2>&1
        backup_restore_delete delete
        TYPE=' Free' && [ -e /etc/wireguard/info.log ] && TYPE=' Teams' && grep -q 'Device name' /etc/wireguard/info.log && TYPE='+'
        info "\n $(text 62) \n"
      else
        ACCOUNT_CHANGE_FAILED='Teams' && warning "\n $(text 187) \n"
        backup_restore_delete restore warp
        unset CONFIRM_TEAMS_INFO
        net
      fi
      ;;
    wireproxy )
      wireproxy_onoff
      if [[ "$WIREPROXY_TRACE4$WIREPROXY_TRACE6" =~ on|plus ]]; then
        warp_api "cancel" "/etc/wireguard/warp-account.conf.bak" >/dev/null 2>&1
        backup_restore_delete delete
        TYPE=' Free' && [ -e /etc/wireguard/info.log ] && TYPE=' Teams' && grep -q 'Device name' /etc/wireguard/info.log && TYPE='+'
        info "\n $(text 62) \n"
      else
        ACCOUNT_CHANGE_FAILED='Teams' && warning "\n $(text 187) \n"
        backup_restore_delete restore wireproxy
        unset CONFIRM_TEAMS_INFO
        wireproxy_onoff
      fi
  esac
}

# Free WARP account upgrade WARP+ account
update() {
  warp_wireproxy() {
    grep -qs 'cKE7LmCF61IhqqABGhvJ44jWXp8fKymcMAEVAzbDF2k=' /etc/wireguard/warp.conf && error "\n $(text 106) \n"
    [ ! -e /etc/wireguard/warp-account.conf ] && error " $(text 59) "
    [ ! -e /etc/wireguard/warp.conf ] && error " $(text 60) "

    CHANGE_DO[0]() { [ "$OPTION" != a ] && unset CHOOSE_TYPE && menu || exit; }
    CHANGE_DO[1]() { change_to_free; }
    CHANGE_DO[2]() { change_to_plus; }
    CHANGE_DO[3]() { change_to_teams; }

    # Determine the current WARP account type: free, plus, teams. If it is plus, check the WARP+ balance flow
    [ -z "$ACCOUNT_TYPE" ] && ACCOUNT_TYPE=Free && CHANGE_TYPE=$(text 174) &&
    [ -e /etc/wireguard/info.log ] && ACCOUNT_TYPE=Teams && CHANGE_TYPE=$(text 175) &&
    grep -q 'Device name' /etc/wireguard/info.log && ACCOUNT_TYPE='+' && CHANGE_TYPE=$(text 176) && check_quota warp && PLUS_QUOTA="\\n $(text 63): $QUOTA"

    if [ -z "$CHOOSE_TYPE" ]; then
      hint "\n $(text 173) "
      [ "$OPTION" != a ] && hint " 0. $(text 49) \n" || hint " 0. $(text 76) \n"
      reading " $(text 50) " CHOOSE_TYPE
    fi

    # The input must be a number and less than or equal to 3
    if [[ "$CHOOSE_TYPE" = [0-3] ]]; then
      CHANGE_DO[$CHOOSE_TYPE]
    else
      warning " $(text 51) [0-3] " && unset CHOOSE_TYPE && sleep 1 && update
    fi
  }

  wireproxy_account() {
    UPDATE_ACCOUNT=wireproxy
    warp_wireproxy
  }

  warp_account() {
    UPDATE_ACCOUNT=warp
    warp_wireproxy
  }

  client_account() {
    UPDATE_ACCOUNT=client
    [ "$ARCHITECTURE" = arm64 ] && error " $(text 101) "
    [ -n "$URL" ] && unset CHOOSE_TYPE && warning "\n $(text 9) "

    CHANGE_DO[0]() { menu; }
    CHANGE_DO[1]() { change_to_free; }
    CHANGE_DO[2]() { change_to_plus; }

    # Determine the current WARP account type: free, plus, if it is plus, check the WARP+ balance flow
    local ACCOUNT_TYPE=Free && local CHANGE_TYPE=$(text 177)
    local CLIENT_ACCOUNT=$(warp-cli --accept-tos registration show 2>/dev/null | awk  '/type/{print $3}')
    [ "$CLIENT_ACCOUNT" = Limited ] && ACCOUNT_TYPE='+' && CHANGE_TYPE=$(text 178) && check_quota client && PLUS_QUOTA="$(text 63): $QUOTA"

    if [ -z "$CHOOSE_TYPE" ]; then
      hint "\n $(text 173) "
      [ "$OPTION" != a ] && hint " 0. $(text 49) \n" || hint " 0. $(text 76) \n"
      reading " $(text 50) " CHOOSE_TYPE
    fi

  # Input must be a number and less than or equal to 2
    if [[ "$CHOOSE_TYPE" = [0-2] ]]; then
      CHANGE_DO[$CHOOSE_TYPE]
    else
      warning " $(text 51) [0-2] " && unset CHOOSE_TYPE && sleep 1 && update
    fi
  }

  # Determine the upgrade object based on the installation status of WARP interface, Client and Wireproxy
  INSTALL_CHECK=("wg-quick" "warp-cli" "wireproxy")
  CASE_RESAULT=("0 0 0" "0 0 1" "0 1 0" "0 1 1" "1 0 0" "1 0 1" "1 1 0" "1 1 1")
  SHOW_CHOOSE=("$(text 150)" "" "" "$(text 151)" "" "$(text 152)" "$(text 153)" "$(text 154)")
  ACCOUNT1=("" "wireproxy_account" "client_account" "client_account" "warp_account" "warp_account" "warp_account" "warp_account")
  ACCOUNT2=("" ""  "" "wireproxy_account" "" "wireproxy_account" "client_account" "client_account")
  ACCOUNT3=("" ""  "" "" "" "" "" "wireproxy_account")

  for c in ${!INSTALL_CHECK[@]}; do
    [ -x "$(type -p ${INSTALL_CHECK[c]})" ] && INSTALL_RESULT[c]=1 || INSTALL_RESULT[c]=0
  done

  for d in ${!CASE_RESAULT[@]}; do
    [[ "${INSTALL_RESULT[@]}" = "${CASE_RESAULT[d]}" ]] && break
  done

  case "$d" in
    0 )
      error " $(text 150) "
      ;;
    1|2|4 )
      ${ACCOUNT1[d]}
      ;;
    * )
      hint " ${SHOW_CHOOSE[d]} " && reading " $(text 50) " MODE
      case "$MODE" in
        [1-3] )
          $(eval echo "\${ACCOUNT$MODE[d]}")
          ;;
        * )
          warning " $(text 51) [1-3] "; sleep 1; update
      esac
  esac
}

# Determine the running status of the current WARP network interface and Client, and assign values ​​to menus and actions accordingly
menu_setting() {
  if [[ "$CLIENT" -gt 1 || "$WIREPROXY" -gt 0 ]]; then
    [ "$CLIENT" -lt 3 ] && MENU_OPTION[1]="1.  $(text 88)" || MENU_OPTION[1]="1.  $(text 89)"
    [ "$WIREPROXY" -lt 2 ] && MENU_OPTION[2]="2.  $(text 163)" || MENU_OPTION[2]="2.  $(text 164)"
    MENU_OPTION[3]="3.  $(text 143)"
    MENU_OPTION[4]="4.  $(text 78)"

    ACTION[1]() { client_onoff; }
    ACTION[2]() { wireproxy_onoff; }
    ACTION[3]() { change_port; }
    ACTION[4]() { update; }

  else
    check_stack
    case "$m" in
      [0-2] )
        MENU_OPTION[1]="1.  $(text 66)"
        MENU_OPTION[2]="2.  $(text 67)"
        MENU_OPTION[3]="3.  $(text 68)"
        ACTION[1]() { CONF=${CONF1[n]}; install; }
        ACTION[2]() { CONF=${CONF2[n]}; install; }
        ACTION[3]() { CONF=${CONF3[n]}; install; }
        ;;
      * )
        MENU_OPTION[1]="1.  $(text 141)"
        MENU_OPTION[2]="2.  $(text 142)"
        MENU_OPTION[3]="3.  $(text 78)"
        ACTION[1]() { stack_switch; }
        ACTION[2]() { stack_switch; }
        ACTION[3]() { update; }
    esac
  fi

  [ -e /etc/dnsmasq.d/warp.conf ] && IPTABLE_INSTALLED="$(text 92)"
  [ -n "$(wg 2>/dev/null)" ] && MENU_OPTION[4]="4.  $(text 77)" || MENU_OPTION[4]="4.  $(text 71)"
  if [ -e /etc/wireguard/warp.conf ]; then
    grep -q '#Table' /etc/wireguard/warp.conf && GLOBAL_OR_NOT="$(text 184)" || GLOBAL_OR_NOT="$(text 185)"
  fi

  MENU_OPTION[5]="5.  ${CLIENT_INSTALLED}${CLIENT_NOT_ALLOWED_ARCHITECTURE}$(text 82)"
  MENU_OPTION[6]="6.  $(text 123)"
  MENU_OPTION[7]="7.  $(text 72)"
  MENU_OPTION[8]="8.  $(text 74)"
  MENU_OPTION[9]="9.  $(text 73)"
  MENU_OPTION[10]="10. $(text 75)"
  MENU_OPTION[11]="11. $(text 80)"
  MENU_OPTION[12]="12. ${IPTABLE_INSTALLED}$(text 138)"
  MENU_OPTION[13]="13. ${WIREPROXY_INSTALLED}$(text 148)"
  MENU_OPTION[14]="14. ${CLIENT_INSTALLED}${CLIENT_NOT_ALLOWED_ARCHITECTURE}$(text 168)"
  MENU_OPTION[0]="0.  $(text 76)"

  ACTION[4]() { OPTION=o; onoff; }
  ACTION[5]() { client_install; }; ACTION[6]() { change_ip; }; ACTION[7]() { uninstall; }; ACTION[8]() { plus; }; ACTION[9]() { bbrInstall; }; ACTION[10]() { ver; };
  ACTION[11]() { bash <(curl -sSL https://gitlab.com/fscarmen/warp_unlock/-/raw/main/unlock.sh) -$L; };
  ACTION[12]() { IS_ANEMONE=is_anemone ;install; };
  ACTION[13]() { IS_PUFFERFFISH=is_pufferffish; install; };
  ACTION[14]() { IS_LUBAN=is_luban; client_install; };
  ACTION[0]() { exit; }

  [ -e /etc/wireguard/info.log ] && TYPE=' Teams' && grep -sq 'Device name' /etc/wireguard/info.log 2>/dev/null && check_quota warp && TYPE='+' && PLUSINFO="$(text 25): $(awk '/Device name/{print $NF}' /etc/wireguard/info.log)\t $(text 63): $QUOTA"
  }

# Show menu
menu() {
  clear
  hint " $(text 16) "
  echo -e "======================================================================================================================\n"
  info " $(text 17):$VERSION\n $(text 18):$(text 1)\n $(text 19):\n\t $(text 20):$SYS\n\t $(text 21):$(uname -r)\n\t $(text 22):$ARCHITECTURE\n\t $(text 23):$VIRT "
  info "\t IPv4: $WAN4 $COUNTRY4  $ASNORG4 "
  info "\t IPv6: $WAN6 $COUNTRY6  $ASNORG6 "
  case "$TRACE4$TRACE6" in
    *plus* )
      info "\t $(text 114)\t $PLUSINFO\n\t $(text 186) "
      ;;
    *on* )
      info "\t $(text 115)\n\t $(text 186) "
  esac
  [ "$PLAN" != 3 ] && info "\t $(text 116) "
  case "$CLIENT" in
    0 )
      info "\t $(text 112) "
      ;;
    1|2 )
      info "\t $(text 113) "
      ;;
    3 )
      info "\t WARP$CLIENT_AC $(text 24)\t $(text 27): $CLIENT_SOCKS5\n\t WARP$CLIENT_AC IPv4: $CLIENT_WAN4 $CLIENT_COUNTRY4 $CLIENT_ASNORG4\n\t WARP$CLIENT_AC IPv6: $CLIENT_WAN6 $CLIENT_COUNTRY6 $CLIENT_ASNORG6 "
      [ -n "$QUOTA" ] && info "\t $(text 63): $QUOTA "
      ;;
    5 )
      info "\t WARP$CLIENT_AC $(text 24)\t $(text 58)\n\t WARP$CLIENT_AC IPv4: $CFWARP_WAN4 $CFWARP_COUNTRY4  $CFWARP_ASNORG4\n\t WARP$CLIENT_AC IPv6: $CFWARP_WAN6 $CFWARP_COUNTRY6  $CFWARP_ASNORG6 "
      [ -n "$QUOTA" ] && info "\t $(text 63): $QUOTA "
  esac
  case "$WIREPROXY" in
    0 )
      info "\t $(text 160) "
      ;;
    1 )
      info "\t $(text 161) "
      ;;
    2 )
      info "\t WARP$WIREPROXY_ACCOUNT $(text 159)\t $(text 27): $WIREPROXY_SOCKS5\n\t IPv4: $WIREPROXY_WAN4 $WIREPROXY_COUNTRY4 $WIREPROXY_ASNORG4\n\t IPv6: $WIREPROXY_WAN6 $WIREPROXY_COUNTRY6 $WIREPROXY_ASNORG6 "
  esac
  grep -q '+' <<< $AC$WIREPROXY_ACCOUNT && info "\t $(text 63): $QUOTA "
   echo -e "\n======================================================================================================================\n"
  for ((h=1; h<${#MENU_OPTION[*]}; h++)); do hint " ${MENU_OPTION[h]} "; done
  hint " ${MENU_OPTION[0]} "
  reading "\n $(text 50) " MENU_CHOOSE

# Input must be a number and less than or equal to the maximum optional options
  if [[ $MENU_CHOOSE =~ ^[0-9]{1,2}$ ]] && (( $MENU_CHOOSE >= 0 && $MENU_CHOOSE < ${#MENU_OPTION[*]} )); then
    ACTION[$MENU_CHOOSE]
  else
    warning " $(text 51) [0-$((${#MENU_OPTION[*]}-1))] " && sleep 1 && menu
  fi
}

#Parameter options OPTION: 1=Complete another stack of WARP for IPv4 or IPv6; 2=Install dual-stack WARP; u=Uninstall WARP; b=Upgrade the kernel, enable BBR and DD; o=WARP switch; p=Flash WARP+ flow; other or null = menu interface
[ "$1" != '[option]' ] && OPTION="${1,,}"

# Parameter options URL or License or convert WARP single and dual stack
if [ "$2" != '[lisence]' ]; then
  case "$OPTION" in
    s )
      [[ "${2,,}" = [46d] ]] && PRIORITY_SWITCH="${2,,}"
      ;;
    i )
      [[ "${2,,}" =~ ^[a-z]{2}$ ]] && EXPECT="${2,,}"
  esac
fi

# Customize WARP+ device name
NAME=$3

# Main program runs 1/3
check_cdn
statistics_of_run-times
select_language
check_operating_system

# Set partial suffix 1/3
case "$OPTION" in
  h )
    help; exit 0
    ;;
  p )
    plus; exit 0
    ;;
  i )
    change_ip; exit 0
    ;;
  s )
    stack_priority; result_priority; exit 0
esac

# Main program runs 2/3
check_root

# Set partial suffix 2/3
case "$OPTION" in
  b )
    bbrInstall; exit 0
    ;;
  u )
    uninstall; exit 0
    ;;
  v )
    ver; exit 0
    ;;
  n )
    net; exit 0
    ;;
  o )
    onoff; exit 0
    ;;
  r )
    client_onoff; exit 0
    ;;
  y )
    wireproxy_onoff; exit 0
esac

# Main program runs 3/3
check_dependencies
check_virt $SYSTEM
check_system_info
menu_setting

# Set some suffixes 3/3
case "$OPTION" in
a )
  if [[ "$2" =~ ^[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}$ ]]; then
    CHOOSE_TYPE=2 && LICENSE=$2
  elif [[ "$2" =~ ^http ]]; then
    CHOOSE_TYPE=3 && CHOOSE_TEAMS=1 && TEAM_URL=$2
  elif [[ "$2" =~ ^ey && "${#2}" -gt 120 ]]; then
    CHOOSE_TYPE=3 && CHOOSE_TEAMS=2 && TEAM_TOKEN=$2
  fi
  update
  ;;
# When the Linux Client is already running, WARP IPv4 or dual-stack network interface cannot be installed. If WARP has been run, parameters 4, 6, d are changed from the original installation to switch
[46d] )
  if [ -e /etc/wireguard/warp.conf ]; then
    SWITCHCHOOSE="${OPTION^^}"
    stack_switch
  else
    case "$OPTION" in
      4 )
        [[ "$CLIENT" = [35] ]] && error " $(text 110) "
        CONF=${CONF1[n]}
        ;;
      6 )
        CONF=${CONF2[n]}
        ;;
      d )
        [[ "$CLIENT" = [35] ]] && error " $(text 110) "
        CONF=${CONF3[n]}
    esac
    install
  fi
  ;;
c )
  client_install
  ;;
l )
  IS_LUBAN=is_luban && client_install
  ;;
a )
  update
  ;;
e )
  stream_solution
  ;;
w )
  wireproxy_solution
  ;;
k )
  kernel_reserved_switch
  ;;
g )
  [ ! -e /etc/wireguard/warp.conf ] && ( GLOBAL_OR_NOT_CHOOSE=2 && CONF=${CONF3[n]} && install; true ) || working_mode_switch
  ;;
* )
  menu
esac
