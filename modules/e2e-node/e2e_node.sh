#!/usr/bin/env bash
set -ex

# Start crio
cd $GOSRC/github.com/kubernetes-sigs/cri-o
nohup bin/crio --config $HOME/crio.conf &

# Get Kubernetes
mkdir -p $GOSRC/k8s.io
cd $GOSRC/k8s.io
git clone https://github.com/kubernetes/kubernetes --depth 1
cd kubernetes

# Run the node end-to-end tests
CRIO_SOCKET=unix:///var/run/crio/crio.sock
make test-e2e-node \
    RUNTIME=remote \
    CONTAINER_RUNTIME_ENDPOINT=$CRIO_SOCKET \
    IMAGE_SERVICE_ENDPOINT=$CRIO_SOCKET \
    TEST_ARGS='--prepull-images=true --feature-gates=VolumeSubpathEnvExpansion=true'
