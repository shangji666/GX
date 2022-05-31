#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN='\033[0m'

red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}

green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}

yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}

clear
read -rp "是否安装脚本？ [Y/N]：" yesno

if [[ $yesno =~ "Y"|"y" ]]; then
    rm -f railgun kazari.json
    yellow "开始安装..."
    wget -N https://raw.githubusercontent.com/Misaka-blog/GX/master/railgun
    chmod +x railgun
    read -rp "请设置UUID（如无设置则使用脚本默认的）：" uuid
    if [[ -z $uuid ]]; then
        uuid="8d4a8f5e-c2f7-4c1b-b8c0-f8f5a9b6c384"
    fi
    cat <<EOF > kazari.json
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": 12345,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none"
            }
        },
        {
            "port": 11111,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF
    nohup ./railgun -config=kazari.json &>/dev/null &
    green "Goorm Xray 已安装完成！"
    yellow "请认真阅读项目说明文档，配置端口转发！"
    yellow "别忘记给项目点一个免费的Star！"
else
    red "已取消安装，脚本退出！"
    exit 1
fi
