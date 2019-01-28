#!/usr/bin/env bash
set -ex

# Install bats
git clone https://github.com/bats-core/bats-core --depth 1
cd bats-core
./install.sh $HOME/.local

# Run local integration test
setenforce 0
cd $GOSRC/github.com/kubernetes-sigs/cri-o
set -x
make localintegration
ret=$?
setenforce 1
exit $ret
