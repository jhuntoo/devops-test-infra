#!/bin/bash -e

source ./env.vars
export KOPS_STATE_STORE=${KOPS_STATE_STORE}
./scripts/install_kops.sh
./scripts/install_helm.sh
./scripts/install_kubectl.sh

echo k8s.${HOSTED_ZONE_DOMAIN}
./.bin/kops create cluster k8s.${HOSTED_ZONE_DOMAIN} \
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
./.bin/helm ls

while [ $? -ne 0 ]; do
    sleep 10
    echo 'Waiting for Tiller to become available'
    ./.bin/helm ls
done


set -e # re-enable exit on error
./.bin/kubectl apply -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.5.0.yaml
./.bin/kubectl apply -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/monitoring-standalone/v1.2.0.yaml
./.bin/helm upgrade --install --set image=${WEB_APP_IMAGE} --set baseDomain=${HOSTED_ZONE_DOMAIN} web-app ./charts/web-app/

