#!/bin/bash

if [ -f /local/repository/ue-setup-complete ]; then
    echo "UE setup already ran; not running again"
    exit 0
fi

# Move to repository folder
cd /local/repository

# Clone repository
git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git

cd openairinterface5g/
# Change branch
git checkout develop
source oaienv
cd cmake_targets/

# Build OAI
sudo ./build_oai -I
sudo ./build_oai --UE


# Configure UEs
FRONTHAUL_IFACE=$(ip route list 192.168.2.3/24 | awk '{print $3}')
sed -i "s/FRONTHAUL_IFACE/$FRONTHAUL_IFACE/g" /local/repository/config/ran/ue.conf

# Configure SIMs
cd ran_build/build
sudo ../../../targets/bin/conf2uedata -c /local/repository/config/ran/sim.conf -o .
sudo ../../../targets/bin/usim -g -c /local/repository/config/ran/sim.conf -o .
sudo ../../../targets/bin/nvram -g -c /local/repository/config/ran/sim.conf -o .
cp .u* ../../../cmake_targets

touch /local/repository/ue-setup-complete