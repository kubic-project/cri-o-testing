#!/usr/bin/env bash
set -ex

# Update necessary networking settings
sysctl -w net.ipv4.conf.all.route_localnet=1
iptables -t nat -I POSTROUTING -s 127.0.0.1 ! -d 127.0.0.1 -j MASQUERADE

# Setup golang
echo 'export GOPATH=$HOME/go' >>$HOME/.bashrc
echo 'export GOBIN=$GOPATH/bin' >>$HOME/.bashrc
echo 'export GOSRC=$GOPATH/src' >>$HOME/.bashrc
echo 'export PATH=$GOBIN:$HOME/.local/bin:$PATH' >>$HOME/.bashrc
. $HOME/.bashrc

# Get the latest critest and crictl
go get github.com/kubernetes-sigs/cri-tools/cmd/crictl
go test -c github.com/kubernetes-sigs/cri-tools/cmd/critest -o $GOBIN/critest

# Get and build cri-o
mkdir -p $GOSRC/github.com/kubernetes-sigs
cd $GOSRC/github.com/kubernetes-sigs
git clone https://github.com/kubernetes-sigs/cri-o --depth 1
cd cri-o
if [ ! -z ${pr} ]; then
    git fetch origin pull/${pr}/head:test
    git checkout test
fi
make
