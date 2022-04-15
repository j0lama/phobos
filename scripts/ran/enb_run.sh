#!/bin/bash

cd /local/repository/openairinterface5g/
source oaienv
cd cmake_targets/

sudo -E ./ran_build/build/lte-softmodem -O /local/repository/config/ran/enb.conf --emulate-l1 --nsa --log_config.global_log_options level,nocolor,time,thread_id | tee eNB.log 2>&1