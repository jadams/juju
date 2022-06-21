# Charmed Kubernetes

## Add clouds
```
juju add-cloud --client
juju autoload-credentials --client
```

## Bootstrap
```
juju bootstrap openstack-maas-local --model-default "network=kubernetes_net" --bootstrap-constraints "allocate-public-ip=true" --constraints "root-disk-source=volume"
```

### Enlarge quota
```
eval $(openstack project show --format shell --domain $OS_PROJECT_DOMAIN_NAME kubernetes)
openstack quota set --instances 20 $id
openstack quota set --volumes 20 $id
openstack quota set --cores 40 $id
openstack quota set --ram 96000 $id
openstack quota set --secgroups 40 $id
```

## Deploy
```
cd 1.21
juju add-model kubernetes
juju set-model-constraints "root-disk-source=volume"
juju deploy ./bundle.yaml --trust
```
