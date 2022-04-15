#!/bin/bash

if [ -f /local/repository/proxy-setup-complete ]; then
    echo "Proxy setup already ran; not running again"
    exit 0
fi

# Install dependencies
sudo apt -y update
sudo apt -y install libsctp-dev

# Move to repository folder
cd /local/repository

# Clone broker
git clone https://github.com/EpiSci/oai-lte-5g-multi-ue-proxy.git
cd oai-lte-5g-multi-ue-proxy/

# Compile proxy
make

touch /local/repository/proxy-setup-complete