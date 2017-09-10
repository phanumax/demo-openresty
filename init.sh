#!/bin/sh
set +e
echo "Machine has $(grep processor /proc/cpuinfo | wc -l) cores and $(awk '/MemTotal/ {print $2}' /proc/meminfo) kB RAM."

# Create cache folders if they don't exits
mkdir -p /cache/ssl /cache/web
chown nobody:nobody -R /cache/ssl /cache/web

# This step is very slow, you can cache it by keeping
# a rw volume mounted on /cache. Re-using the dhparam.pem
# does not hurt security much.
if [ ! -f /cache/ssl/dhparam.pem ]
then
	echo "Generating Diffie-Hellman parameters...(2048 bit)"
	echo "This takes about 20 minutes. You can cache it by mounting a"
	echo "rw volume under \"/cache\"."
	openssl dhparam -out /cache/ssl/dhparam.pem 2048
else
	echo "Using existing Diffie-Hellman parameters."
fi

if [ ! -f /cache/ssl/resty-auto-ssl-fallback.key ]
then
	echo "Generating self-signed fallback certificate..."
	openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
		-subj '/CN=sni-support-required-for-valid-ssl' \
		-keyout /cache/ssl/resty-auto-ssl-fallback.key \
		-out /cache/ssl/resty-auto-ssl-fallback.crt
else
	echo "Using existing self-signed fallback certificate."
fi

echo "Starting nginx..."
#exec /usr/local/openresty/bin/openresty -c /etc/nginx/nginx.conf 
nginx -c /etc/nginx/nginx.conf
tail -f 

