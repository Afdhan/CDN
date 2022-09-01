#!/bin/bash

clear
source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
tls="$(cat ~/log-install.txt | grep -w "V2RAY Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "V2RAY Vless None TLS" | cut -d: -f2|sed 's/ //g')"
path=$(cat /etc/v2ray/vless.json | grep "path" | cut -d: -f2|sed 's/ //g' | cut -d '"' -f 2)
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Remarks: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/v2ray/vless.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '2' ]]; then
			echo ""
			echo "Username already used!"
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (hari): " masaaktif
tgl=$(date -d "$masaaktif days" +"%d")
bln=$(date -d "$masaaktif days" +"%b")
thn=$(date -d "$masaaktif days" +"%Y")
expe="$tgl $bln, $thn"
tgl2=$(date +"%d")
bln2=$(date +"%b")
thn2=$(date +"%Y")
tnggl="$tgl2 $bln2, $thn2"
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/v2ray/vless.json
sed -i '/#none$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/v2ray/vnone.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=$path&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${uuid}@${domain}:$none?path=$path&encryption=none&type=ws#${user}"
systemctl restart v2ray@vless
systemctl restart v2ray@vnone
cat>/etc/panel/$user-vless.json<<EOF
"created": "${tnggl}",
"expired": "${expe}",
[
      {
      "user": "${user}",
      "host": "${domain}",
      "port": "$tls",
      "uuid": "${uuid}",
      "path": "${path}",
      "sec": "tls",
      "enc": "none",
      "type": "ws"
     }
],
[
     {
      "user": "${user}",
      "host": "${domain}",
      "port": "${none}",
      "uuid": "${uuid}",
      "path": "${path}",
      "sec": "",
      "enc": "none",
      "type": "ws"
     }
]
EOF

clear
echo -e "SUCCESS"
