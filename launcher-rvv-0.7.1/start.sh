#!/bin/bash

if [ -f /data/config.sh ]; then
    source /data/config.sh
fi

CPU=rv64
if [ ! -z "${VM_CPU_FEATURES}" ]; then
    CPU="${CPU},${VM_CPU_FEATURES}"
fi

APPEND=
if [ ! -z "${VM_APPEND}" ]; then
    APPEND="-append ${VM_APPEND}"
fi

qemu-system-riscv64 \
    -nographic \
    -machine virt \
    -cpu ${CPU} \
    -smp ${VM_CPU_COUNT} \
    -m ${VM_MEMORY} \
    -bios ${VM_BIOS} \
    -kernel ${VM_KERNEL} ${APPEND}\
    -device virtio-net-device,netdev=eth0 \
    -netdev user,id=eth0 \
    -drive file=${VM_DRIVE},format=raw,if=virtio \
    -serial telnet:127.0.0.1:10023,server,nowait
