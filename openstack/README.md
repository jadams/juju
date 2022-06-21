# Charmed Openstack

## Deploy
```
juju bootstrap maas-local
juju add-model openstack
juju deploy ./bundle.yaml
```

### Vault
```
export VAULT_ADDR="x.x.x.x:8200"
vault operator init -key-shares=5 -key-threshold=3
vault operator unseal xxx
export VAULT_TOKEN=xxx
vault token create -ttl=10m
juju run-action --wait vault/leader authorize-charm token=xxx
juju run-action --wait vault/leader generate-root-ca
```

### Octavia
```
juju run-action glance-simplestreams-sync/leader sync-images
juju config neutron-api enable-ml2-port-security=true
cd openstack/scripts
./octavia_certificates.sh
juju run-action octavia/0 configure-resources
juju run-action octavia-diskimage-retrofit/leader retrofit-image
```

### Misc settings
```
juju config nova-cloud-controller console-access-protocol=novnc
juju config nova-compute enable-vtpm=true
juju config nova-compute extra-repositories=ppa:openstack-charmers/swtpm
```

## Scale
```
juju add-unit nova-compute -n3
juju add-unit ceph-osd --to 3
juju add-unit ceph-osd --to 4
juju add-unit ceph-osd --to 5
```
