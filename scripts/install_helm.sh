#!/usr/bin/env bash
HELMVERSION=v2.5.0
PLATFORM=`uname | tr '[:upper:]' '[:lower:]'`
HELM_TAR_FILE="helm-${HELMVERSION}-$PLATFORM-amd64.tar.gz"

if [ -f ./.bin/helm ]
then
  echo 'skipping download of helm'
else
  mkdir -p .bin
  curl -sSL "http://storage.googleapis.com/kubernetes-helm/${HELM_TAR_FILE}" -o ./.bin/${HELM_TAR_FILE} &&
  tar zxvf ./.bin/${HELM_TAR_FILE}  -C ./.bin/ --strip-components 1 $PLATFORM-amd64/helm  &&
  rm ./.bin/${HELM_TAR_FILE}
fi


