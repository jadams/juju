#!/bin/bash
set -euo pipefail

openstack network create --external \
   --provider-network-type flat --provider-physical-network physnet1 \
   ext_net

openstack subnet create --network ext_net --no-dhcp \
   --gateway 10.10.10.1 --subnet-range 10.10.10.0/24 \
   --allocation-pool start=10.10.10.50,end=10.10.10.250 \
   ext_subnet

openstack network create int_net

openstack subnet create --network int_net --dns-nameserver 1.1.1.1 \
   --gateway 192.168.0.1 --subnet-range 192.168.0.0/24 \
   --allocation-pool start=192.168.0.10,end=192.168.0.200 \
   int_subnet

openstack router create provider-router
openstack router set --external-gateway ext_net provider-router
openstack router add subnet provider-router int_subnet

