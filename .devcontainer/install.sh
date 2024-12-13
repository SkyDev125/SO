#!/bin/bash

# Require elevated privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run with root privileges."
  exit 1
fi

# Fix Hash Sum Mismatch
mkdir /etc/gcrypt
echo all >>/etc/gcrypt/hwf.deny
apt-get update

# Update the package lists for upgrades and new package installations
apt-get update

# Install clang-format
apt-get install -y clang-format

# Install pip
apt-get install -y python3-pip

# Install lizard
pip3 install lizard

# Install jinja2
pip3 install jinja2

# meld

# Install diff
sudo apt-get install diffutils

# Install all manuals
sudo apt install -y man-db manpages-posix manpages-dev manpages-posix-dev

# apt-get download libgcc-10-dev
# dpkg -x "libgcc-10-dev_10.5.0-1ubuntu1~20.04_amd64.deb" .
# sudo cp usr/lib/gcc/x86_64-linux-gnu/10/libtsan_preinit.o /usr/lib/gcc/x86_64-linux-gnu/9/
