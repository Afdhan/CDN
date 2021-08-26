#!/bin/bash


red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
cyan='\x1b[96m'
white='\x1b[37m'
bold='\033[1m'
off='\x1b[m'

clear

	if [ "$EUID" -ne "0" ]; then
		echo "Login Akses Root Dulu Om"
		exit 0
	fi

protocoll=()
ipnya=()
portnya=()
portt=()


echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "           ${green}POINTING VPS${off}"
echo -e "${cyan}======================================${off}"
echo -e "${green}"
echo -e "     1 ⸩  Tambahkan Rule Point Iptables"
echo -e "     2 ⸩  Hapus Rule Point Iptables"
echo -e "     x ⸩  Keluar"
echo -e "${off}"
echo -e "${cyan}======================================${off}"
echo -e "${green}"
read -p "     Pilih Nomor  [1-2 / x] :  " prot
echo -e "${off}"

if [[ $plh == '2' ]]; then
echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "            ${green}HAPUS RULE${off}"
echo -e "${cyan}======================================${off}"
echo -e "${green}"
echo -e "       Port Di Open $portt"
echo -e "       IP Dipointing $ipnya"
echo -e "       Port Internal $portnya"
echo -e "       Protocol $protocoll"
echo -e "${off}"
echo -e "${cyan}======================================${off}"
echo -e "${green}"
read -p "   Hapus Rule Pointing Iptables Diatas? [y/n] :  " hps
echo -e "${off}"

if [[ $hps == "y" ]] || [[ $hps == "Y" ]]; then

		if [[ $protocoll == "tcp" ]]; then
			iptables -D PREROUTING -t nat -i  ens4 -p tcp --dport "$portnya" -j DNAT --to "$ipnya":"$portt"
			iptables -D FORWARD -p tcp -d "$ipnya" --dport "$portnya" -j ACCEPT
		elif [[ $protocoll == "udp" ]]; then
			iptables -D PREROUTING -t nat -i ens4 -p udp --dport "$portnya" -j DNAT --to "$ipnya":"$portt"
			iptables -D FORWARD -p udp -d "$ipnya" --dport "$portnya" -j ACCEPT
		elif [[ $protocoll == "tcp/udp" ]]; then
			iptables -D PREROUTING -t nat -i  ens4 -p tcp --dport "$portnya" -j DNAT --to "$ipnya":"$portt"
			iptables -D FORWARD -p tcp -d "$ipnya" --dport "$portnya" -j ACCEPT
			iptables -D PREROUTING -t nat -i ens4 -p udp --dport "$portnya" -j DNAT --to "$ipnya":"$portt"
			iptables -D FORWARD -p udp -d "$ipnya" --dport "$portnya" -j ACCEPT
		fi

	else
		echo -e "${red}Script Dihentikan...!${off}"
		sleep 2
		menu
	fi
	
		iptables-save > /etc/iptables.up.rules
		iptables-restore -t < /etc/iptables.up.rules
		netfilter-persistent save
		netfilter-persistent reload
		systemctl daemon-reload
		sleep 1
fi


if [[ $plh == '1' ]]; then

	read -p "Masukan Port Yang Ingin Di Open :  " extport
        portt+=("$extport")
	read -p "Masukan IP Yang Ingin Dipointing :  " vpsip
        ipnya+=("$vpsip")
	read -p "Masukan Port Internal :  " intport
        portnya+=("$intport")
	 
echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "           ${green}PILIH PROTOCOL${off}"
echo -e "${cyan}======================================${off}"
echo -e "${green}"
echo -e "     1 ⸩  Protocol TCP"
echo -e "     2 ⸩  Protocol UDP"
echo -e "     3 ⸩  Protocol TCP/UDP"
echo -e "     x ⸩  Keluar"
echo -e "${off}"
echo -e "${cyan}======================================${off}"
echo -e "${green}"
read -p "     Pilih Nomor  [1-3 / x] :  " prot
echo -e "${off}"
	
	if [[ $prot == "1" ]]; then
	proto="tcp"
	elif [[ $prot == "2" ]]; then
	proto="udp"
	elif [[ $prot == "3" ]]; then
	proto="tcp/udp"
	elif [[ $prot == "x" ]]; then
	sleep 1
	menu
	else
	echo -e "Tentukan Protocol!"
	exit 0
	fi
	
        protocoll+=("$proto")
	#Periksa kembali dengan pengguna apakah ini konfigurasi yang benar
	echo -e "${cyan}======================================${off}"
	echo "   IP:Port : $vpsip:$intport"
    echo "   Protocol : $proto"
    echo "   Port Di Open : $extport"
    echo -e "${cyan}======================================${off}"
	read -p "  Konfirmasi Konfigurasi Diatas [y/n] :  " konfirmasi

	#Execution
	if [[ $konfirmasi == "y" ]] || [[ $konfirmasi == "Y" ]]; then

		if [[ $proto == "tcp" ]]; then
			iptables -A PREROUTING -t nat -i  ens4 -p tcp --dport "$extport" -j DNAT --to "$vpsip":"$intport"
			iptables -A FORWARD -p tcp -d "$vpsip" --dport "$extport" -j ACCEPT
		elif [[ $proto == "udp" ]]; then
			iptables -A PREROUTING -t nat -i ens4 -p udp --dport "$extport" -j DNAT --to "$vpsip":"$intport"
			iptables -A FORWARD -p udp -d "$vpsip" --dport "$extport" -j ACCEPT
		elif [[ $proto == "tcp/udp" ]]; then
			iptables -A PREROUTING -t nat -i  ens4 -p tcp --dport "$extport" -j DNAT --to "$vpsip":"$intport"
			iptables -A FORWARD -p tcp -d "$vpsip" --dport "$extport" -j ACCEPT
			iptables -A PREROUTING -t nat -i ens4 -p udp --dport "$extport" -j DNAT --to "$vpsip":"$intport"
			iptables -A FORWARD -p udp -d "$vpsip" --dport "$extport" -j ACCEPT
		fi

	else
		echo -e "${red}Script Dihentikan...!${off}"
		sleep 2
		menu
	fi
	
		iptables-save > /etc/iptables.up.rules
		iptables-restore -t < /etc/iptables.up.rules
		netfilter-persistent save
		netfilter-persistent reload
		systemctl daemon-reload
		sleep 1

figlet -f slant Selesai | lolcat
else
sleep 2
menu
fi
