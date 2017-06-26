#!/bin/bash -e

source ./env.vars
export KOPS_STATE_STORE=${KOPS_STATE_STORE}

./.bin/kops delete cluster --name k8s.$HOSTED_ZONE_DOMAIN --yes