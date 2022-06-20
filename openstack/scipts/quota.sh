#!/bin/bash
set -xeuo pipefail
eval $(openstack project show --format shell --domain $OS_PROJECT_DOMAIN_NAME $OS_PROJECT_NAME)
openstack quota set --instances 20 $id
openstack quota set --volumes 20 $id
openstack quota set --cores 40 $id
openstack quota set --ram 96000 $id
openstack quota set --secgroups 40 $id
