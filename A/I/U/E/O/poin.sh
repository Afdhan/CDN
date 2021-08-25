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

	read -p "Masukan Port Yang Ingin Di Open :  " extport

	read -p "Masukan IP Yang Ingin Dipointing :  " vpsip
	
	read -p "Masukan Port Internal :  " intport
	 
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
read -p "     Pilih Nomor  [1-2 / x] :  " prot
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
	

	#Periksa kembali dengan pengguna apakah ini konfigurasi yang benar
	echo -e "${cyan}======================================${off}"
	echo "   IP:Port : $vpsip:$intport"
    echo "   Protocol : $protocol"
    echo "   Port Di Open : $extport"
    echo -e "${cyan}======================================${off}"
	read -p "  Konfirmasi Konfigurasi Diatas [y/n] :  " konfirmasi

	#Execution
	if [[ $konfirmasi == "y" ]]; then

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
		echo -e "$redScript Dihentikan...!$off"
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
