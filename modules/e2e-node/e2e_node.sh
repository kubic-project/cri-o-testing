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
make test-e2e-node \
    PARALLELISM=1 \
    RUNTIME=remote \
    CONTAINER_RUNTIME_ENDPOINT=unix:///var/run/crio.sock \
    IMAGE_SERVICE_ENDPOINT=/var/run/crio/crio.sock \
    TEST_ARGS='--prepull-images=true --kubelet-flags="--cgroup-driver=systemd"' \
    FOCUS="\[Conformance\]"
