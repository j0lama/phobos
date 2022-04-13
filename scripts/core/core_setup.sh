#!/bin/bash

# Move to repository folder
cd /local/repository

# Install Mongo
sudo apt update
sudo apt install mongodb


# Install dependencies
sudo apt install python3-pip python3-setuptools python3-wheel ninja-build build-essential flex bison git libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libidn11-dev libmongoc-dev libbson-dev libyaml-dev libnghttp2-dev libmicrohttpd-dev libcurl4-gnutls-dev libnghttp2-dev libtins-dev libtalloc-dev meson

# Clone Open5GS
git clone https://github.com/open5gs/open5gs

# Compile Open5GS
cd open5gs
meson build --prefix=`pwd`/install
ninja -C build

# Configure TUN device
sudo ./misc/netconf.sh

# Configure IP Tables (Only IPv4)
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE


# Configure the core
cd ./install/etc/open5gs/
cp /local/repository/config/open5gs/* .
sed -i 's/mcc: 901/mcc: 208/g' mme.conf

# Add Users
for i in $(seq -f "%010g" 1 1500)
do
	echo "UE: 20893$i"
	/local/repository/open5gs/misc/db/open5gs-dbctl add 20893$i 00001111222233334444555566667777 88889999AAAABBBBCCCCDDDDEEEEFFFF
done