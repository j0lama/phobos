#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "USE: sudo ./ue_run.sh <UE MSIN>"
    exit 1
fi

if [ ! -f /local/repository/ue-setup-complete ]; then
    echo "The UE setup has not finished. Please wait"
    exit 0
fi

cd /local/repository/openairinterface5g/
source oaienv
cd cmake_targets/

# Generate SIM card
sed -i "s/CUSTOM_MSIN/$1/g" /local/repository/config/ran/sim.conf

# Configure SIMs
cd ran_build/build
sudo ../../../targets/bin/conf2uedata -c /local/repository/config/ran/sim.conf -o .
sudo ../../../targets/bin/usim -g -c /local/repository/config/ran/sim.conf -o .
sudo ../../../targets/bin/nvram -g -c /local/repository/config/ran/sim.conf -o .

sudo -E ./lte-uesoftmodem -O /local/repository/config/ran/ue.conf --L2-emul 5 --nokrnmod 1 --ue-idx-standalone 2 --num-ues 1 --node-number 2 --log_config.global_log_options level,nocolor,time,thread_id | tee /local/repository/ue.log 2>&1