#!/bin/bash
bersih
clear
uuid1=$(cat /etc/trojan-go/uuid.txt)
uuid2=$(cat /etc/trojan/uuid.txt)
source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
trojango="$(cat ~/log-install.txt | grep -i TrojanGO | cut -d: -f2|sed 's/ //g')"
tr="$(cat ~/log-install.txt | grep -i TrojanGFW | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXIST} && ${user_EXISTS} == '0' ]]; do
		read -rp "Remarks : " -e user
		user_EXIST=$(grep -w $user /etc/trojan-go/akun.conf | wc -l)
        user_EXISTS=$(grep -w $user /etc/trojan/akun.conf | wc -l)
		if [[ ${user_EXIST} == "1" ]] || [[ ${user_EXISTS}  == '1' ]]; then
			echo ""
			echo "Nama User Sudah Ada, Harap Masukkan Nama Lain!"
			exit 1
		fi
	done
#users="WorldSSH_GO_$user"
#user2="WorldSSH_GFW_$user"
uuid=$(cat /proc/sys/kernel/random/uuid)
echo $uuid > /etc/trojan/$user-uuid.txt
read -p "Expired (hari) : " masaaktif
tnggl="$tgl2 $bln2, $thn2"
sed -i '/"'""$uuid1""'"$/a\,"'""$uuid""'"' /etc/trojan-go/config.json
sed -i '/"'""$uuid2""'"$/a\,"'""$uuid""'"' /etc/trojan/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo -e "### $user $exp" >> /etc/trojan-go/akun.conf
echo -e "### $user $exp" >> /etc/trojan/akun.conf
systemctl restart trojan-go
systemctl restart trojan
trojangolink="trojan-go://${uuid}@${domain}:${trojango}/?sni=${domain}&type=ws&host=${domain}&path=/WorldSSH&encryption=none#${user}"
trojanlink="trojan://${uuid}@${domain}:${tr}/?sni=bug-anda.com#${user}"

clear
echo -e ""
echo -e "================================="
echo -e " ~> TROJAN VPN"
echo -e "================================="
echo -e " Remarks          : ${user}"
echo -e " Host             : ${domain}"
echo -e " Port Trojan-GFW  : ${tr}"
echo -e " Port Trojan-GO   : ${trojango}"
echo -e " Key Trojan-GFW   : ${uuid}"
echo -e " Key Trojan-GO    : ${uuid}"
echo -e " Password Igniter : ${uuid}"
echo -e " Path WebSocket   : /WorldSSH"
echo -e "================================="
echo -e " Trojan-GFW       : ${trojanlink}"
echo -e "================================="
echo -e " Trojan-GO        : ${trojangolink}"
echo -e "================================="
echo -e " Aktif Selama     : $masaaktif Hari"
echo -e " Dibuat Pada      : $tnggl"
echo -e " Berakhir Pada    : $exp"
echo -e "================================="
echo -e " - Mod By Dhansss X NezaVPN"
echo -e ""
