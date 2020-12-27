ARG ARCH=

FROM ${ARCH}golang:1.15.5-alpine3.12 as builder

ARG wg_go_tag=v0.0.20201118
ARG wg_tools_tag=v1.0.20200827

RUN apk add --update git build-base libmnl-dev iptables openvpn

RUN git clone https://git.zx2c4.com/wireguard-go && \
    cd wireguard-go && \
    git checkout $wg_go_tag && \
    make && \
    make install

ENV WITH_WGQUICK=yes
RUN git clone https://git.zx2c4.com/wireguard-tools && \
    cd wireguard-tools && \
    git checkout $wg_tools_tag && \
    cd src && \
    make && \
    make install

FROM ${ARCH}alpine:3.12

RUN apk add --no-cache --update bash libmnl iptables iproute2

RUN mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && chmod 600 /dev/net/tun

COPY --from=builder /usr/bin/wireguard-go /usr/bin/wg* /usr/bin/
