 #!/bin/bash

clear

	#Cek user root
	if [ "$EUID" -ne "0" ]
	then
		echo "Login Akses Root Dulu Om"
		exit
	fi

	#Choose External Port
	echo "Masukan Port Yang Ingin Di Open"
	read -r "extport"

	#Find vpn address
	echo "Masukan IP Yang Ingin Dipointing"
	read "vpsip"

	#Find Internal port
	echo "Masukan Port Internal"
	read "intport"

	#What protocol

	echo "Masukan protocol tcp / udp / tcp/udp"
	read protocol
	if [ \( "$protocol" == "tcp" \) -o \( "$protocol" == "udp" \) -o \( "$protocol" == "tcp/udp" \) ]
	then
		echo "Selesai"
	else
		echo "Harap Tentukan Protocol !!!"
		exit
	fi

	#Periksa kembali dengan pengguna apakah ini konfigurasi yang benar
	echo "Silahkan Konfirmasi Apakah Konfigurasi Dibawah Ini Sudah Benar"
	echo "$vpsip:$intport Dengan Protocol $protocol Dan Port $extport Sebagai Port External [y/n]"
	read "konfirmasi"

	#Execution
	if [ "$konfirmasi" == "y" ]
	then

		if [ "$protocol" == "tcp" ]
		then
			iptables -A PREROUTING -t nat -i  ens4 -p tcp --dport "$extport" -j DNAT --to "$vpsip":"$intport"
			iptables -A FORWARD -p tcp -d "$vpsip" --dport "$extport" -j ACCEPT
		fi

		if [ "$protocol" == "udp" ]
		then
			iptables -A PREROUTING -t nat -i ens4 -p udp --dport "$extport" -j DNAT --to "$vpsip":"$intport"
			iptables -A FORWARD -p udp -d "$vpsip" --dport "$extport" -j ACCEPT
		fi

		if [ "$protocol" == "tcp/udp" ]
		then
			iptables -A PREROUTING -t nat -i  ens4 -p tcp --dport "$extport" -j DNAT --to "$vpsip":"$intport"
			iptables -A FORWARD -p tcp -d "$vpsip" --dport "$extport" -j ACCEPT
			iptables -A PREROUTING -t nat -i ens4 -p udp --dport "$extport" -j DNAT --to "$vpsip":"$intport"
			iptables -A FORWARD -p udp -d "$vpsip" --dport "$extport" -j ACCEPT
		fi

	else
		echo "Script Dihentikan..."
		exit
	fi

	#Asking To Save rules
	echo "Apakah Anda ingin menyimpan aturan atau menghapusnya saat reboot? [y/n]"
	read "simpan"

	if [ "$simpan" == "y" ]
	then
		echo "Menyimpan Data..."
		iptables-save > /etc/iptables.up.rules
		iptables-restore -t < /etc/iptables.up.rules
		netfilter-persistent save
		netfilter-persistent reload
		systemctl daemon-reload
		sleep 1
	fi

	#Reminder to port foward server side
	#echo "Selesai! Ingatlah untuk menambahkan aturan firewall untuk $extport $protocol sisi server"