#!/bin/bash

source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domin=$(cat /etc/v2ray/domain)
else
domin=$IP
fi

SUB_DOMIN=*.${domin}
CF_ID=afdhan134@gmail.com
CF_KEY=57fc95a923222474d5b90ff5444e0ee6f19ef
set -euo pipefail
IP=$(wget -qO- ipinfo.io/ip);

ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${domin}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMIN}'","content":"'${IP}'","ttl":120,"proxied":false}')


cat > /etc/nginx/sites-enabled/wildcard_subdomain << END
server {
    server_name ${SUB_DOMIN};
    access_log /var/log/nginx/vps-access.log;
    error_log /var/log/nginx/vps-error.log error;
    root /home/vps/public_html;
    
    location / {
       index  index.html index.htm index.php;
       try_files $uri $uri/ /index.php?$args;
    }
    location ~\.php$ {
        include /etc/nginx/fastcgi_params;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
    location ~ /\.ht {
        deny all;
    }
    location ~* /(?:uploads|files)/.*\.php$ {
        deny all;
    }
    location ~* \.(jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc)$ {
         expires 356d;
         add_header Cache-Control "public, no-transform";
    }
    
    
    location ~* \.(css|js)$ {
         expires 2d;
         add_header Cache-Control "public, no-transform";
    }
    listen: 81;
}
END
#listen 443 ssl;
  #  ssl_certificate /etc/v2ray/v2ray.crt;
 #   ssl_certificate_key /etc/v2ray/v2ray.key; 
 systemctl restart nginx
 
