#!/bin/bash

if [ -f /local/repository/ue-setup-complete ]; then
    echo "UE setup already ran; not running again"
    exit 0
fi

# Move to repository folder
cd /local/repository

# Clone repository
git clone https://github.com/j0lama/openairinterface5g.git

cd openairinterface5g/
source oaienv
cd cmake_targets/

# Build OAI
sudo ./build_oai -I
sudo ./build_oai --UE

FRONTHAUL_IFACE=$(ip route list 192.168.2.3/24 | awk '{print $3}') # Get fronthaul network interface
sed -i "s/FRONTHAUL_IFACE/$FRONTHAUL_IFACE/g" /local/repository/config/ran/ue.conf

touch /local/repository/ue-setup-complete