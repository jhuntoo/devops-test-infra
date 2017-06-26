#!/bin/bash -e

source ./env.vars
export KOPS_STATE_STORE=${KOPS_STATE_STORE}
./scripts/install_terraform.sh
./scripts/install_kops.sh
./scripts/install_helm.sh
./scripts/install_kubectl.sh

echo $CLUSTER_DOMAIN
./.bin/kops create cluster $CLUSTER_DOMAIN \
  --node-count 1 \
  --zones eu-west-1a \
  --node-size t2.micro \
  --master-size t2.micro \
  --master-zones eu-west-1a \
  --networking weave \
  --topology public \
  --yes

set +e # temporarily disable exit on error
./.bin/kubectl cluster-info
while [ $? -ne 0 ]; do
    sleep 10
    echo 'Waiting for Cluster to become available'
    ./.bin/kubectl cluster-info
done

./.bin/helm init

./helm ls
while [ $? -ne 0 ]; do
    sleep 10
    echo 'Waiting for Tiller to become available'
    ./.bin/helm ls
done


set -e # re-enable exit on error
./.bin/helm init