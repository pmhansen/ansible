#!/bin/sh

certbot certonly --dns-cloudflare \
        --dns-cloudflare-credentials /root/.secrets/cloudflare.ini \
        -d flexdevel.com,*.flexdevel.com \
        --agree-tos --non-interactive -m ph@pbnet.dk --keep-until-expiring \
        --preferred-challenges dns-01

certbot certonly --standalone --agree-tos --expand \
        --non-interactive -m ph@pbnet.dk --preferred-challenges http \
        --http-01-port 8888 --renew-with-new-domains --keep-until-expiring \
        -d balder.pbnet.dk \
        -d ipsc2-dk-test.dmrplus.dk \
        -d gw.oz4red.dk \
        -d clips.pbnet.dk \
        -d knahrvorn.pbnet.dk \
        -d tiddly.pbnet.dk \
        -d nextcloud.pbnet.dk \
        -d boxknox.com \
        -d api.pbnet.dk \
        -d consul.pbnet.dk \
        -d nomad.pbnet.dk \
        -d keoa.pbnet.dk \
        -d xlx238.d-star4all.dk \
        -d xlx238.dstar4all.dk \
        -d d-star4all.dk \
        -d www.d-star4all.dk \
        -d dstar4all.dk \
        -d www.dstar4all.dk \
        -d ntfy.pbnet.dk \
        -d vault.pbnet.dk

cat /etc/letsencrypt/live/flexdevel.com/privkey.pem > /etc/letsencrypt/live/flexdevel.com/flexdevel.pem
cat /etc/letsencrypt/live/flexdevel.com/fullchain.pem >> /etc/letsencrypt/live/flexdevel.com/flexdevel.pem
cat /etc/letsencrypt/live/flexdevel.com/privkey.pem > /mnt/nas1/docker/certs/flexdevel.key.pem
cat /etc/letsencrypt/live/flexdevel.com/fullchain.pem > /mnt/nas1/docker/certs/flexdevel.crt.pem
cat /etc/letsencrypt/live/balder.pbnet.dk-0001/privkey.pem > /etc/letsencrypt/live/balder.pbnet.dk-0001/balder.pem
cat /etc/letsencrypt/live/balder.pbnet.dk-0001/fullchain.pem >> /etc/letsencrypt/live/balder.pbnet.dk-0001/balder.pem

consul kv put "certs/letsencrypt/flexdevel-com/cert" @"/etc/letsencrypt/live/flexdevel.com/fullchain.pem"
consul kv put "certs/letsencrypt/flexdevel-com/key" @"/etc/letsencrypt/live/flexdevel.com/privkey.pem"
consul kv put "certs/letsencrypt/balder-pbnet-dk/cert" @"/etc/letsencrypt/live/balder.pbnet.dk-0001/fullchain.pem"
consul kv put "certs/letsencrypt/balder-pbnet-dk/key" @"/etc/letsencrypt/live/balder.pbnet.dk-0001/privkey.pem"

base64 -w0 /etc/letsencrypt/live/balder.pbnet.dk-0001/privkey.pem | consul kv put "certs/letsencrypt/balder-pbnet-dk/base64/key" -
base64 -w0 /etc/letsencrypt/live/balder.pbnet.dk-0001/fullchain.pem | consul kv put "certs/letsencrypt/balder-pbnet-dk/base64/cert" -
