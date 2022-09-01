#!/bin/bash

clear
uuid1=$(cat /etc/trojan-go/uuid.txt)

source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
trojango="$(cat ~/log-install.txt | grep -i TroGO | cut -d: -f2|sed 's/ //g')"
path="$(cat /etc/trojan-go/config.json | grep "path" | cut -d: -f2|sed 's/ //g' | cut -d '"' -f 2)"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXIST} == '0' ]]; do
		read -rp "Remarks : " -e user
		user_EXIST=$(grep -w $user /etc/trojan-go/akun.conf | wc -l)
		if [[ ${user_EXIST} == "1" ]]; then
			echo ""
			echo "Username already used!"
			exit 1
		fi
	done
uuid=$user
#$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (hari) : " masaaktif
tgl=$(date -d "$masaaktif days" +"%d")
bln=$(date -d "$masaaktif days" +"%b")
thn=$(date -d "$masaaktif days" +"%Y")
expe="$tgl $bln, $thn"
tgl2=$(date +"%d")
bln2=$(date +"%b")
thn2=$(date +"%Y")
tnggl="$tgl2 $bln2, $thn2"
sed -i '/"'""$uuid1""'"$/a\,"'""$uuid""'"' /etc/trojan-go/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo -e "### $user $exp" >> /etc/trojan-go/akun.conf
systemctl restart trojan-go

trojangolink="trojan-go://${uuid}@${domain}:${trojango}/?sni=${domain}&type=ws&host=${domain}&path=${path}&encryption=none#${user}"
cat>/etc/panel/$user-trojango.json<<EOF
"created": "${tnggl}",
"expired": "${expe}",
[
      {
      "user": "${user}",
      "host": "${domain}",
      "port": "${trojango}",
      "uuid": "${uuid}",
      "path": "${path}",
      "enc": "none",
      "type": "ws"
     }
]
EOF
clear
echo -e "SUCCESS"
