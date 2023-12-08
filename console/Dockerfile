FROM golang:1.21.3-bookworm AS builder

ENV GO111MODULE=on

RUN go install github.com/sorenisanerd/gotty@v1.5.0

FROM debian:bookworm

COPY --from=builder /go/bin/gotty /usr/local/bin/gotty

RUN apt-get update && \
    apt-get install -y tini telnet && \
    apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

ENTRYPOINT ["tini", "--"]

CMD ["gotty", "-w", "telnet", "127.0.0.1", "10023"]
