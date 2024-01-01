#!/bin/bash

export VM_BIOS=/data/fw_jump.elf
export VM_KERNEL=/data/Image
export VM_DRIVE=/data/rootfs.ext2

export VM_CPU_FEATURES="x-v=true,vlen=128,elen=64,vext_spec=v0.7.1"
export VM_APPEND="root=/dev/vda"
