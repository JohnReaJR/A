#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Fatal error：${plain} Please run this script with root privilege \n " && exit 1

#This function will be called when user installed x-ui out of sercurity
config_after_install() {
    echo -e "${yellow} Install/update finished need to modify panel settings out of security ${plain}"
    read -p "are you continue,if you type n will skip this at this time[y/n]": config_confirm
    if [[ x"${config_confirm}" == x"y" || x"${config_confirm}" == x"Y" ]]; then
        read -p "please set up your username:" config_account
        echo -e "${yellow}your username will be:${config_account}${plain}"
        read -p "please set up your password:" config_password
        echo -e "${yellow}your password will be:${config_password}${plain}"
        read -p "please set up the panel port:" config_port
        echo -e "${yellow}your panel port is:${config_port}${plain}"
        echo -e "${yellow}initializing,wait some time here...${plain}"
        /root/x-ui/x-ui setting -username ${config_account} -password ${config_password}
        echo -e "${yellow}account name and password set down!${plain}"
        /root/x-ui/x-ui setting -port ${config_port}
        echo -e "${yellow}panel port set down!${plain}"
    else
        echo -e "${red}Canceled, all setting items are default settings${plain}"
    fi
}

install_x-ui() {
    systemctl stop x-ui
    cd /root/x-ui

    if [ $# == 0 ]; then
        last_version=$(curl -Ls "https://api.github.com/repos/hossinasaadi/x-ui/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        if [[ ! -n "$last_version" ]]; then
            echo -e "${red}refresh x-ui version failed,it may due to Github API restriction,please try it later${plain}"
            exit 1
        fi
        echo -e "get x-ui latest version succeed: ${last_version}, begin to install..."
        wget -N --no-check-certificate -O /usr/local/x-ui-linux-${arch}.tar.gz https://github.com/hossinasaadi/x-ui/releases/download/${last_version}/x-ui-linux-${arch}.tar.gz
        if [[ $? -ne 0 ]]; then
            echo -e "${red}dowanload x-ui failed,please be sure that your server can access Github ${plain}"
            exit 1
        fi
    else
        last_version=$1
        url="https://github.com/hossinasaadi/x-ui/releases/download/${last_version}/x-ui-linux-${arch}.tar.gz"
        echo -e "begin to install x-ui v$1"
        wget -N --no-check-certificate -O /usr/local/x-ui-linux-${arch}.tar.gz ${url}
        if [[ $? -ne 0 ]]; then
            echo -e "${red}dowanload x-ui v$1 failed,please check the verison exists${plain}"
            exit 1
        fi
    fi

    if [[ -e /root/x-ui/ ]]; then
        rm /root/x-ui/ -rf
    fi

    tar zxvf x-ui-linux-${arch}.tar.gz
    rm x-ui-linux-${arch}.tar.gz -f
    cd x-ui
    chmod +x x-ui bin/xray-linux-${arch}
    cp -f x-ui.service /etc/systemd/system/
    wget --no-check-certificate -O /usr/bin/x-ui https://raw.githubusercontent.com/hossinasaadi/x-ui/main/x-ui.sh
    chmod +x /root/x-ui/x-ui.sh
    chmod +x /root/x-ui
    config_after_install
    #echo -e "如果是全新安装，默认网页端口为 ${green}54321${plain}，用户名和密码默认都是 ${green}admin${plain}"
    #echo -e "请自行确保此端口没有被其他程序占用，${yellow}并且确保 54321 端口已放行${plain}"
    #    echo -e "若想将 54321 修改为其它端口，输入 x-ui 命令进行修改，同样也要确保你修改的端口也是放行的"
    #echo -e ""
    #echo -e "如果是更新面板，则按你之前的方式访问面板"
    #echo -e ""
    systemctl daemon-reload
    systemctl enable x-ui
    systemctl start x-ui
    echo -e "${green}x-ui v${last_version}${plain} install finished,it is working now..."
    echo -e ""
    echo -e "x-ui control menu usages: "
    echo -e "----------------------------------------------"
    echo -e "x-ui              - Enter     Admin menu"
    echo -e "x-ui start        - Start     x-ui"
    echo -e "x-ui stop         - Stop      x-ui"
    echo -e "x-ui restart      - Restart   x-ui"
    echo -e "x-ui status       - Show      x-ui status"
    echo -e "x-ui enable       - Enable    x-ui on system startup"
    echo -e "x-ui disable      - Disable   x-ui on system startup"
    echo -e "x-ui log          - Check     x-ui logs"
    echo -e "x-ui v2-ui        - Migrate   v2-ui Account data to x-ui"
    echo -e "x-ui update       - Update    x-ui"
    echo -e "x-ui install      - Install   x-ui"
    echo -e "x-ui uninstall    - Uninstall x-ui"
    echo -e "----------------------------------------------"
}

echo -e "${green}excuting...${plain}"
install_base
install_x-ui $1
