#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "USE: sudo ./ue_run.sh <UE ID>"
    exit 1
fi

cd /local/repository/openairinterface5g/
source oaienv
cd cmake_targets/

sudo -E ./ran_build/build/lte-uesoftmodem -O /local/repository/config/ran/ue.conf --L2-emul 5 --nokrnmod 1 --ue-idx-standalone $1 --num-ues 1 --node-number $1 --nsa --log_config.global_log_options level,nocolor,time,thread_id | tee ue_$node_id.log 2>&1