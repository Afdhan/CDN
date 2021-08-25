#!/bin/bash

grey='\x1b[90m'
red='\x1b[91m'
green='\x1b[92m'
yellow='\x1b[93m'
blue='\x1b[94m'
purple='\x1b[95m'
cyan='\x1b[96m'
white='\x1b[37m'
bold='\033[1m'
off='\x1b[m'
flag='\x1b[47;41m'
NC='\x1b[m'
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
COUNTRY=$(curl -s ipinfo.io/country )

MYIP=$(wget -qO- ipinfo.io/ip);
IZIN=$( curl https://afdhan.github.io/sce/izin | grep $MYIP )
echo "Memeriksa Hak Akses VPS..."
if [ $MYIP = $IZIN ]; then
clear
echo -e "${green}Akses Diizinkan...${NC}"
sleep 1
else
clear
echo -e "${red}Akses Diblokir!${NC}";
echo "Hanya Untuk Pengguna Berbayar!"
echo "Silahkan Hubungi Admin"
exit 0
fi
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
users="Trojan-GO_$user"
user2="Trojan-GFW_#$user"
read -p "Expired (hari) : " masaaktif
tgl=$(date -d "$masaaktif days" +"%d")
bln=$(date -d "$masaaktif days" +"%b")
thn=$(date -d "$masaaktif days" +"%Y")
expe="$tgl $bln, $thn"
tgl2=$(date +"%d")
bln2=$(date +"%b")
thn2=$(date +"%Y")
tnggl="$tgl2 $bln2, $thn2"
sed -i '/"'""$uuid1""'"$/a\,"'""$users""'"' /etc/trojan-go/config.json
sed -i '/"'""$uuid2""'"$/a\,"'""$user2""'"' /etc/trojan/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo -e "### $user $exp" >> /etc/trojan-go/akun.conf
echo -e "### $user $exp" >> /etc/trojan/akun.conf
systemctl restart trojan-go
systemctl restart trojan
trojangolink="trojan-go://${users}@${domain}:${trojango}/?sni=${domain}&type=ws&host=${domain}&path=/DhanZaa&encryption=none#${user}"
trojanlink="trojan://${user2}@${domain}:${tr}/?sni=bug-anda.com#${user}"
cat > client.json << END
{
    "run_type": "client",
    "local_addr": "127.0.0.1",
    "local_port": 1080,
    "remote_addr": "${domain}",
    "remote_port": ${trojango},
    "dns": [
        "1.1.1.1"
    ],
    "password": [
        "${users}"
    ],
    "ssl": {
        "sni": "${domain}"
    },
    "websocket": {
        "enabled": true,
        "path": "\/DhanZaa",
        "hostname": "${domain}"
    }
}
END
mv client.json /home/vps/public_html/Igniter-GO.json
clear
echo -e ""
echo -e "${cyan}=================================${off}"
echo -e "${purple} ~> TROJAN VPN${off}"
echo -e "${cyan}=================================${off}"
echo -e " ${green}ISP                : ${ISP}"
echo -e " CITY               : ${CITY}"
echo -e " COUNTRY            : ${COUNTRY}"
echo -e " Remarks            : ${user}"
echo -e " Host               : ${domain}"
echo -e " Port Trojan-GFW    : ${tr}"
echo -e " Port Trojan-GO     : ${trojango}"
echo -e " Key Trojan-GFW     : ${user2}"
echo -e " Key Trojan-GO      : ${users}"
echo -e " Igniter Password   : ${users}"
echo -e " Path Trojan-GO     : /DhanZaa${off}"
echo -e "${cyan}=================================${off}"
echo -e " Trojan-GFW  : ${trojanlink}" | lolcat
echo -e "${cyan}=================================${off}"
echo -e " Trojan-GO   : ${trojangolink}" | lolcat
echo -e "${cyan}=================================${off}"
echo -e " Igniter-GO  : http://${domain}:81/Igniter-GO.json" | lolcat
echo -e "${cyan}=================================${off}"
echo -e " ${green}Aktif Selama   : $masaaktif Hari"
echo -e " Dibuat Pada    : $tnggl"
echo -e " Berakhir Pada  : $expe${off}"
echo -e "${cyan}=================================${off}"
echo -e " ${purple}- Mod By Dhansss X NezaVPN${off}"
echo -e ""
