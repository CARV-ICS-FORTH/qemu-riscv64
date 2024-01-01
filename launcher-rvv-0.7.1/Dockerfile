FROM ubuntu:22.04 AS builder

RUN apt-get update && \
    apt-get install -y build-essential git python3 pkg-config libglib2.0-dev libpixman-1-dev && \
    apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

WORKDIR /root

COPY . /root/
RUN ./build.sh

FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y libglib2.0-0 libpixman-1-0 && \
    apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY --from=builder /usr/local/libexec/* /usr/local/libexec/
COPY --from=builder /usr/local/share/qemu /usr/local/share/qemu

ENV VM_CPU_FEATURES=
ENV VM_CPU_COUNT 4
ENV VM_MEMORY 2048
ENV VM_APPEND=
ENV VM_BIOS=
ENV VM_KERNEL=
ENV VM_DRIVE /data/disk.img

COPY start.sh /
CMD ./start.sh
