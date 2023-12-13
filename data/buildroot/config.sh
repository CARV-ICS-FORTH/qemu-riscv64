#!/bin/bash

export VM_BIOS=/data/fw_jump.elf
export VM_KERNEL=/data/Image
export VM_DRIVE=/data/rootfs.ext2

export VM_CPU_FEATURES="v=true,vlen=1024,vext_spec=v1.0"
export VM_APPEND="root=/dev/vda"
