#!/usr/bin/env bash
set -ex

# Start crio
cd $GOSRC/github.com/kubernetes-sigs/cri-o
nohup bin/crio --config $HOME/crio.conf &

# Run critest
$GOBIN/critest --runtime-endpoint /var/run/crio/crio.sock \
    --image-endpoint /var/run/crio/crio.sock \
    --ginkgo.skip="should fail with with an unloaded profile"
