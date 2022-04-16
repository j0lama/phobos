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

touch /local/repository/ue-setup-complete