FROM alpine:latest

ADD configure.sh /configure.sh

RUN apk add --no-cache ca-certificates curl unzip wireguard-tools golang git \
 && chmod +x /configure.sh

CMD /configure.sh
