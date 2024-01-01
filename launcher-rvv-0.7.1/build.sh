#!/bin/bash

#
# FOundation for Reasearch and Technology - Hellas (FORTH) 2022
# Coumputer Architecture and VLSI lab (CARV)
# Use this code at your own RISC
#

# This is Yet Another Automation for RISC-V (yaafrv)

TOP_PATH=$(pwd)
QEMU_COMMIT_ID=qemu-for-vector-0.7.1
QEMU_REPOSITORY=https://github.com/sifive/riscv-qemu.git
QEMU_PATH=$(pwd)/riscv-qemu
QEMU_RISCV_SYSTEM=$QEMU_PATH/build/riscv64-softmmu/qemu-system-riscv64

git clone --depth 1 --branch $QEMU_COMMIT_ID $QEMU_REPOSITORY
cd $QEMU_PATH
#following line fixes an error that occures under certain env conditions
sed -i 's/nopie/no\-pie/' configure
mkdir build
cd build
../configure --disable-docs --disable-werror --target-list=riscv64-softmmu,riscv64-linux-user
make -j 8
cd $TOP_PATH
stat $QEMU_RISCV_SYSTEM
if [ $? -ne 0 ]; then
    echo "ERROR: failed to build QEMU"
    exit 1
fi
echo "QEMU built successfully!"

cd $QEMU_PATH
cd build
make install
