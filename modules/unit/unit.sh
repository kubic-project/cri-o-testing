#!/usr/bin/env bash
set -ex

# Run the unit tests
cd $GOSRC/github.com/kubernetes-sigs/cri-o
make testunit
