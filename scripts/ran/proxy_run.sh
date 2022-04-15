#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "USE: sudo ./proxy_run.sh <Number of UEs>"
    exit 1
fi

if [ -f /local/repository/proxy-setup-complete ]; then
    echo "The Proxy setup has not finished. Please wait"
    exit 0
fi

cd /local/repository/oai-lte-5g-multi-ue-proxy/

sudo -E ./build/proxy $1 192.168.2.1 192.168.2.2 192.168.2.3