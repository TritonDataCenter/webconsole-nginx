#!/bin/bash
set -e -o pipefail

help() {
    echo
    echo 'Usage ./setup.sh ~/path/to/SERVER_KEY ~/path/to/SERVER_CRT'
    echo
    echo 'SERVER_KEY is the filesystem path to a TLS server key file.'
    echo
    echo 'SERVER_CRT is the filesystem path to a TLS server crt file.'
    echo
}

# Check for correct configuration
check() {

    if [ -z "$1" ]; then
        tput rev  # reverse
        tput bold # bold
        echo 'Please provide a path to the NGINX key file.'
        tput sgr0 # clear

        help
        exit 1
    fi

    if [ ! -f "$1" ]; then
        tput rev  # reverse
        tput bold # bold
        echo 'Server key file for NGINX is unreadable.'
        tput sgr0 # clear

        help
        exit 1
    fi

    NGINX_SERVER_KEY_PATH=$1


    if [ -z "$2" ]; then
        tput rev  # reverse
        tput bold # bold
        echo 'Please provide a path to the NGINX crt file.'
        tput sgr0 # clear

        help
        exit 1
    fi

    if [ ! -f "$2" ]; then
        tput rev  # reverse
        tput bold # bold
        echo 'Server crt file for NGINX is unreadable.'
        tput sgr0 # clear

        help
        exit 1
    fi

    NGINX_SERVER_CRT_PATH=$2

    echo '# NGINX Config' > .env
    echo NGINX_CONFIG=/etc/nginx/nginx.conf >> .env
    echo NGINX_SERVER_KEY=$(cat "${NGINX_SERVER_KEY_PATH}" | tr '\n' '#') >> .env
    echo NGINX_SERVER_CRT=$(cat "${NGINX_SERVER_CRT_PATH}" | tr '\n' '#') >> .env
}

# ---------------------------------------------------
# parse arguments

# Get function list
funcs=($(declare -F -p | cut -d " " -f 2))

until
    if [ ! -z "$1" ]; then
        # check if the first arg is a function in this file, or use a default
        if [[ " ${funcs[@]} " =~ " $1 " ]]; then
            cmd=$1
            shift 1
        else
            cmd="check"
        fi

        $cmd "$@"
        if [ $? == 127 ]; then
            help
        fi

        exit
    else
        help
    fi
do
    echo
done
