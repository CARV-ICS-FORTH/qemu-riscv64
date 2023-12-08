FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y qemu-system-misc opensbi u-boot-qemu qemu-utils && \
    apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

ENV VM_CPU_FEATURES=
ENV VM_CPU_COUNT 4
ENV VM_MEMORY 2048
ENV VM_BIOS /usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.elf
ENV VM_KERNEL /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf
ENV VM_DRIVE /data/disk.img

COPY start.sh /
CMD ./start.sh
