#!/bin/bash
set -euo pipefail

for i in $(openstack security group list | awk '/default/{ print $2 }'); do
   openstack security group rule create $i --protocol icmp --remote-ip 0.0.0.0/0;
   openstack security group rule create $i --protocol tcp --remote-ip 0.0.0.0/0 --dst-port 22;
done
