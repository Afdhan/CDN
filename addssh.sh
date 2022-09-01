#!/bin/bash

# DELETE AKUN EXPIRED
               hariini=`date +%Y-%m-%d`
               cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
               totalaccounts=`cat /tmp/expirelist.txt | wc -l`
               for((i=1; i<=$totalaccounts; i++ ))
               do
               tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
               username=`echo $tuserval | cut -f1 -d:`
               userexp=`echo $tuserval | cut -f2 -d:`
               userexpireinseconds=$(( $userexp * 86400 ))
               tglexp=`date -d @$userexpireinseconds`             
               tgl=`echo $tglexp |awk -F" " '{print $3}'`
               while [ ${#tgl} -lt 2 ]
               do
               tgl="0"$tgl
               done
               while [ ${#username} -lt 15 ]
               do
               username=$username" " 
               done
               bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
               echo "echo "Expired- User : $username Expire at : $tgl $bulantahun"" >> /usr/local/bin/alluser
               todaystime=`date +%s`
               if [ $userexpireinseconds -ge $todaystime ] ;
               then
		    	:
               else
               
               userdel $username
               fi
               done
# DELETE

ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
COUNTRY=$(curl -s ipinfo.io/country )

MYIP=$(wget -qO- ipinfo.io/ip);
clear
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif

source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi


wsssh="$(cat ~/log-install.txt | grep -w "Websocket SSH" | cut -d: -f2|sed 's/ //g')"
wsovpn="$(cat ~/log-install.txt | grep -w "Websocket Openvpn" | cut -d: -f2|sed 's/ //g')"
ssl="$(cat ~/log-install.txt | grep -w "Stunnel" | cut -d: -f2|sed 's/ //g')"
drop="$(cat ~/log-install.txt | grep -w "\- Dropbear" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid Proxy" | cut -d: -f2)"
ohps="$(cat ~/log-install.txt | grep -w "OHP SSH" | cut -d: -f2|sed 's/ //g')"
ohpd="$(cat ~/log-install.txt | grep -w "OHP Dropbear" | cut -d: -f2|sed 's/ //g')"
ohpv="$(cat ~/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2|sed 's/ //g')"
nginx="$(cat ~/log-install.txt | grep -w "Nginx" | cut -d: -f2|sed 's/ //g')"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

tgl=$(date -d "$masaaktif days" +"%d")
bln=$(date -d "$masaaktif days" +"%b")
thn=$(date -d "$masaaktif days" +"%Y")
expe="$tgl $bln, $thn"
tgl2=$(date +"%d")
bln2=$(date +"%b")
thn2=$(date +"%Y")
tnggl="$tgl2 $bln2, $thn2"
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null



cat > /etc/panel/ssh-$Login.json <<END
{
	  "user": "${Login}",
      "pass": "${Pass}",
      "openssh": "22",
      "dropbear": "${drop}",
      "stunnel": "${ssl}",
      "wsssh": "${wsssh}",
      "wstls": "443",
      "wsovpn": "${wsovpn}",
      "squid": "${sqd}",
      "ohps": "${ohps}",
      "ohpd": "${ohpd}",
      "ohpv": "${ohpv}",
      "badvpn": "7100-7300",
      "socks5": "8080",
      "ovpn_tcp1": "http://${domain}:${nginx}/client-tcp-$ovpn.ovpn",
      "ovpn_tcp2": "http://${domain}:${nginx}/client-tcp-443.ovpn",
      "ovpn_udp": "http://${domain}:${nginx}/client-udp-$ovpn2.ovpn",
      "ovpn_ssl": "http://${domain}:${nginx}/client-tcp-ssl.ovpn",
      "created": "${tnggl}",
      "expired": "${expe}"
 }
END
clear
echo "SUCCESS"

