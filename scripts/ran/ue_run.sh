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

# Generate MSIN based on the ID
MSIN=$(printf "%010d" $1)

# Configure SIMs
cd ran_build/build
cp /local/repository/config/ran/sim.conf /local/repository/config/ran/tmp_sim.conf # Create a copy of the configuration file
sed -i "s/CUSTOM_MSIN/$MSIN/g" /local/repository/config/ran/tmp_sim.conf # Add the MSIN
sudo ../../../targets/bin/conf2uedata -c /local/repository/config/ran/tmp_sim.conf -o . # Compile 
rm /local/repository/config/ran/tmp_sim.conf # Remove SIM config file copy

sudo -E ./lte-uesoftmodem -O /local/repository/config/ran/ue.conf --L2-emul 5 --nokrnmod 1 --ue-idx-standalone 2 --node-number 2 --log_config.global_log_options level,nocolor,time,thread_id | tee /local/repository/ue.log 2>&1