#!/bin/bash

echo "Silahkan Tunggu Timeout 15 Detik Agar Tidak Error"

sleep 15

sub=$(cat /root/subdomain)

DOMAIN=$(cat /root/domain)

SUB_DOMAIN=*.$(cat /root/sdomain)

CF_ID=$(cat /root/gmail)

CF_KEY=$(cat /root/key)

set -euo pipefail

IP=$(wget -qO- ipinfo.io/ip);

ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then

     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)

fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')  

rm -f /root/domain
rm -f /root/sdomain
rm -f /root/subdomain
rm -f /root/gmail
rm -f /root/key

echo $SUB_DOMAIN > /root/wildcard_subdomain

echo "Install Selesai, Configurasi Wildcard Tersimpan Di /etc/nginx/wildcard_subdomain

echo "Domain Wildcard Tersimpan Di /root/wildcard_subdomain

echo ""

rm -f jhon.sh
rm -f w2.sh

