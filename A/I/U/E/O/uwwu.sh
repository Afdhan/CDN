#!/bin/bash

blue="\e[1;34m"
off="\x1b[m"

apt install shc -y

cd /usr/bin

echo -e "${blue}AUTO ENCRYPT STARTING${off}"
sleep 1

shc -r -f usernew && rm usernew && rm usernew.x.c && mv usernew.x usernew && chmod +x usernew

shc -r -f hostnya && rm hostnya && rm hostnya.x.c && mv hostnya.x hostnya && chmod +x hostnya

shc -r -f add-ws && rm add-ws && rm add-ws.x.c && mv add-ws.x add-ws && chmod +x add-ws

shc -r -f add-vless && rm add-vless && rm add-vless.x.c && mv add-vless.x add-vless && chmod +x add-vless

shc -r -f add-wg && rm add-wg && rm add-wg.x.c && mv add-wg.x add-wg && chmod +x add-wg

shc -r -f add-ss
rm add-ss
rm add-ss.x.c
mv add-ss.x add-ss
chmod +x add-ss

shc -r -f add-ssr
rm add-ssr
rm add-ssr.x.c
mv add-ssr.x add-ssr
chmod +x add-ssr

shc -r -f add-tr
rm add-tr
rm add-tr.x.c
mv add-tr.x add-tr
chmod +x add-tr

shc -r -f add-sstp
rm add-sstp
rm add-sstp.x.c
mv add-sstp.x add-sstp
chmod +x add-sstp

shc -r -f add-pptp
rm add-pptp
rm add-pptp.x.c
mv add-pptp.x add-pptp
chmod +x add-pptp

shc -r -f add-l2tp
rm add-l2tp
rm add-l2tp.x.c
mv add-l2tp.x add-l2tp
chmod +x add-l2tp

shc -r -f trial
rm trial
rm trial.x.c
mv trial.x trial
chmod +x trial

shc -r -f status
rm status
rm status.x.c
mv status.x status
chmod +x status

shc -r -f clear-log
rm clear-log
rm clear-log.x.c
mv clear-log.x clear-log
chmod +x clear-log

shc -r -f bw && rm bw && rm bw.x.c && mv bw.x bw && chmod +x bw

shc -r -f menu && rm menu && rm menu.x.c && mv menu.x menu && chmod +x menu

shc -r -f hapus && rm hapus && rm hapus.x.c && mv hapus.x hapus && chmod +x hapus

shc -r -f certv2ray &&rm certv2ray && rm certv2ray.x.c && mv certv2ray.x certv2ray && chmod +x certv2ray

shc -r -f trialws && rm trialws && rm trialws.x.c && mv trialws.x trialws && chmod +x trialws

shc -r -f updatee && rm updatee && rm updatee.x.c && mv updatee.x updatee && chmod +x updatee

shc -r -f autokill && rm autokill && rm autokill.x.c && mv autokill.x autokill && chmod +x autokill

cd

rm -f uwwu.sh
