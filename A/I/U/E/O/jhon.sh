#!/bin/bash

apt-get update -y

apt-get upgrade -y

apt install jq curl -y

read -p "Masukkan Gmail Cloudflare : " mail

echo $mail > /root/gmail

read -p "Masukkan ApiKey Cloudflare : " key

echo $key > /root/key

read -p "Masukkan Domain Ori : " DOMAIN

echo $DOMAIN > /root/domain

read -p "Masukkan Subdomain : " sub

echo $sub > /root/subdomain

sleep 3

sub=$(cat /root/subdomain)

DOMAIN=$(cat /root/domain)

SUB_DOMAIN=${sub}.$(cat /root/domain)

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

