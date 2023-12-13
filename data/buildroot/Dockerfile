FROM ubuntu:22.04 AS builder

RUN apt-get update && \
    apt-get install -y build-essential git file wget cpio unzip rsync bc && \
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

FROM scratch

COPY --from=builder /root/buildroot/output/images/fw_jump.elf /data/
COPY --from=builder /root/buildroot/output/images/Image /data/
COPY --from=builder /root/buildroot/output/images/rootfs.ext2 /data/
COPY config.sh /data/
