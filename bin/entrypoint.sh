#!/bin/bash

# Copy NGINX creds from env vars to files on disk
if [ -n ${!NGINX_SERVER_KEY} ] \
    && [ -n ${!NGINX_SERVER_CRT} ]
then
    nginx_path=/etc/nginx/certs
    mkdir -p $nginx_path
    echo -e "${NGINX_SERVER_KEY}" | tr '#' '\n' > $nginx_path/server.key
    echo -e "${NGINX_SERVER_CRT}" | tr '#' '\n' > $nginx_path/server.crt

    chmod 444 $nginx_path/server.key
    chmod 444 $nginx_path/server.crt
fi

exec "$@"
