#!/bin/bash

#
# FOundation for Reasearch and Technology - Hellas (FORTH) 2022
# Coumputer Architecture and VLSI lab (CARV)
# Use this code at your own RISC
#

# This is Yet Another Automation for RISC-V (yaafrv)

TOP_PATH=$(pwd)
BUILDROOT_TAG=2023.02
BUILDROOT_REPOSITORY=git://git.buildroot.net/buildroot
BUILDROOT_PATH=$(pwd)/buildroot
BIOS_PATH=$BUILDROOT_PATH/output/images/fw_jump.elf
KERNEL_PATH=$BUILDROOT_PATH/output/images/Image
ROOTFS_PATH=$BUILDROOT_PATH/output/images/rootfs.ext2
CONFIG_PATH=$(pwd)/config

git clone --depth 1 --branch $BUILDROOT_TAG $BUILDROOT_REPOSITORY
cd $BUILDROOT_PATH
cp $CONFIG_PATH/buildroot-config .config
make olddefconfig
make -j 8
cd $TOP_PATH
stat $BIOS_PATH
if [ $? -ne 0 ]; then
    echo "ERROR: buildroot failed to build opensbi"
    exit 1
fi
stat $KERNEL_PATH
if [ $? -ne 0 ]; then
    echo "ERROR: buildroot failed to build linux kernel"
    exit 1
fi
stat $ROOTFS_PATH
if [ $? -ne 0 ]; then
    echo "ERROR: buildroot failed to build the rootfs"
    exit 1
fi
echo "Buildroot images built successfully!"

