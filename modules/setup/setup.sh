#!/usr/bin/env bash
set -ex

# Setup the dependencies
transactional-update pkg install -ly \
    device-mapper-devel \
    fdupes \
    git \
    glib2-devel-static \
    glibc-devel-static \
    go1.11 \
    go-go-md2man \
    libapparmor-devel \
    libassuan-devel \
    libgpgme-devel \
    libostree-devel \
    libseccomp-devel \
    make \
    netcat-openbsd \
    python \
    selinux-tools
systemctl disable health-checker
systemctl stop sshd
shutdown -r +0
