#!/bin/bash

if [ -f /local/repository/proxy-setup-complete ]; then
    echo "The Proxy setup has not finished. Please wait"
    exit 0
fi

cd /local/repository/config/core/

sudo srsepc epc.conf
