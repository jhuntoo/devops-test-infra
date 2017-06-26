#!/usr/bin/env bash
KOPS_VERSION=1.6.2
PLATFORM=`uname | tr '[:upper:]' '[:lower:]'`

mkdir -p .bin
[ -f ./.bin/kops ] && echo 'skipping download of kops' || curl -L -o ./.bin/kops https://github.com/kubernetes/kops/releases/download/$KOPS_VERSION/kops-$PLATFORM-amd64
chmod +x ./.bin/kops