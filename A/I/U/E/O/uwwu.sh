#!/bin/bash

blue="\e[1;34m"
off="\x1b[m"

echo -e "${blue}AUTO ENCRYPT STARTING${off}"
sleep 1
cd /usr/bin
mkdir -p enc
shc -r -f usernew && rm usernew && rm usernew.x.c && mv usernew.x usernew && chmod +x usernew && cp usernew enc/usernew.sh
shc -r -f hostnya && rm hostnya && rm hostnya.x.c && mv hostnya.x hostnya && chmod +x hostnya && cp hostnya enc/host.sh
shc -r -f add-ws && rm add-ws && rm add-ws.x.c && mv add-ws.x add-ws && chmod +x add-ws && cp add-ws enc/add-ws.sh
shc -r -f add-vless && rm add-vless && rm add-vless.x.c && mv add-vless.x add-vless && chmod +x add-vless && cp add-wg enc/add-vless.sh
shc -r -f add-wg && rm add-wg && rm add-wg.x.c && mv add-wg.x add-wg && chmod +x add-wg && cp add-wg enc/add-wg.sh
shc -r -f add-ss && rm add-ss && rm add-ss.x.c && mv add-ss.x add-ss && chmod +x add-ss && cp add-ss enc/add-ss.sh
shc -r -f add-ssr && rm add-ssr && rm add-ssr.x.c && mv add-ssr.x add-ssr && chmod +x add-ssr && cp add-ssr enc/add-ssr.sh
shc -r -f add-tr && rm add-tr && rm add-tr.x.c && mv add-tr.x add-tr && chmod +x add-tr && cp add-tr enc/add-tr.sh
shc -r -f add-sstp && rm add-sstp && rm add-sstp.x.c && mv add-sstp.x add-sstp && chmod +x add-sstp && cp add-sstp enc/add-sstp.sh
shc -r -f add-pptp && rm add-pptp && rm add-pptp.x.c && mv add-pptp.x add-pptp && chmod +x add-pptp && cp add-pptp enc/add-pptp.sh
shc -r -f add-l2tp && rm add-l2tp && rm add-l2tp.x.c && mv add-l2tp.x add-l2tp && chmod +x add-l2tp && cp add-l2tp enc/add-l2tp.sh
shc -r -f trial && rm trial && rm trial.x.c && mv trial.x trial && chmod +x trial && cp trial enc/trial.sh
shc -r -f status && rm status && rm status.x.c && mv status.x status && chmod +x status && cp status enc/status.sh
shc -r -f clear-log && rm clear-log && rm clear-log.x.c && mv clear-log.x clear-log && chmod +x clear-log && cp clear-log enc/clear-log.sh
shc -r -f bw && rm bw && rm bw.x.c && mv bw.x bw && chmod +x bw && cp bw enc/bandwith.sh
shc -r -f menu && rm menu && rm menu.x.c && mv menu.x menu && chmod +x menu && cp menu enc/menu.sh
shc -r -f hapus && rm hapus && rm hapus.x.c && mv hapus.x hapus && chmod +x hapus && cp hapus enc/hapus.sh
shc -r -f certv2ray &&rm certv2ray && rm certv2ray.x.c && mv certv2ray.x certv2ray && chmod +x certv2ray && cp certv2ray enc/cert.sh
shc -r -f trialws && rm trialws && rm trialws.x.c && mv trialws.x trialws && chmod +x trialws && cp trialws enc/trialws.sh
shc -r -f updatee && rm updatee && rm updatee.x.c && mv updatee.x updatee && chmod +x updatee && cp updatee enc/updatee.sh
shc -r -f autokill && rm autokill && rm autokill.x.c && mv autokill.x autokill && chmod +x autokill && cp autokill enc/autokill.sh
sleep 0.5
zip -r encrypt.zip enc > /dev/null 2>&1
cp -r encrypt.zip /home/vps/public_html/enc.zip
rm -rf encrypt.zip
rm -rf enc
cd
rm -f uwwu.sh
