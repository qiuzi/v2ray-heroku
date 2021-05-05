ARG ARCH=

FROM ${ARCH}golang:1.16.2-alpine3.13 as builder

ARG wg_go_tag=0.0.20210323
ARG wg_tools_tag=v1.0.20210315

RUN apk add --update git build-base libmnl-dev iptables

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
    
FROM alpine:latest

ADD configure.sh /configure.sh

RUN apk add --no-cache --update bash libmnl iptables openresolv iproute2 curl unzip \
 && chmod +x /configure.sh
 
COPY --from=builder /usr/bin/wireguard-go /usr/bin/wg* /usr/bin/
 
CMD ["/configure.sh"]
