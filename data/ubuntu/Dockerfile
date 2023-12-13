FROM alpine:3.18.5 AS downloader

RUN apk add --no-cache curl xz

WORKDIR /root

RUN curl -LO https://cdimage.ubuntu.com/releases/22.04.3/release/ubuntu-22.04.3-preinstalled-server-riscv64+unmatched.img.xz && \
    xz -dk ubuntu-22.04.3-preinstalled-server-riscv64+unmatched.img.xz && \
    rm ubuntu-22.04.3-preinstalled-server-riscv64+unmatched.img.xz

FROM scratch

COPY --from=downloader /root/ubuntu-22.04.3-preinstalled-server-riscv64+unmatched.img /data/
COPY config.sh /data/
