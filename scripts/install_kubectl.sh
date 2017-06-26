#!/usr/bin/env bash
KUBECTL_VERSION=v1.6.6
PLATFORM=`uname | tr '[:upper:]' '[:lower:]'`
HELM_TAR_FILE="helm-${HELMVERSION}-$PLATFORM-amd64.tar.gz"

if [ -f ./.bin/kubectl ]
then
  echo 'skipping download of kubectl'
else
    echo 'downloading kubectl'
  curl -sSL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/$PLATFORM/amd64/kubectl -o ./.bin/kubectl
fi


