#!/bin/bash

# Move to repository folder
cd /local/repository

# Clone repository
git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git
# Change branch
git checkout develop

cd openairinterface5g/
source oaienv
cd cmake_targets/

# Build OAI
sudo ./build_oai -I
sudo ./build_oai --UE --eNB

# eNB config
IFACE=$(ip route list 192.168.4.81/24 | awk '{print $3}')
sed -i "s/IFACE/$IFACE/g" /local/repository/config/ran/enb.conf

# sudo -E ./ran_build/build/lte-softmodem -O /local/repository/config/ran/enb.conf --emulate-l1 --nsa --log_config.global_log_options level,nocolor,time,thread_id | tee eNB.log 2>&1

# Configure UEs

# Clone broker
cd ../..
git clone https://github.com/EpiSci/oai-lte-5g-multi-ue-proxy.git