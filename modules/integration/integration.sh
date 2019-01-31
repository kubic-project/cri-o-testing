#!/usr/bin/env bash
set -ex

# Install bats
git clone https://github.com/bats-core/bats-core --depth 1
cd bats-core
./install.sh $HOME/.local

# Prepare the cni plugins
CNI_DIR=$HOME/cni
mkdir -p $CNI_DIR
cp /usr/lib/cni/* $CNI_DIR
cp $GOSRC/github.com/kubernetes-sigs/cri-o/test/cni_plugin_helper.bash $CNI_DIR
sed -i 's;/opt/cni/bin;/usr/lib/cni;g' $CNI_DIR/cni_plugin_helper.bash

# Run local integration test
cd $GOSRC/github.com/kubernetes-sigs/cri-o
echo N >$HOME/apparmor_enabled
make localintegration \
    TRAVIS=true \
    CRIO_CNI_PLUGIN=$CNI_DIR \
    APPARMOR_PARAMETERS_FILE_PATH=$HOME/apparmor_enabled
