#!/bin/bash

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