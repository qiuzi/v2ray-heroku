FROM alpine:latest

ADD configure.sh /configure.sh

RUN apk add --no-cache --update ca-certificates curl unzip wireguard-tools \
 && chmod +x /configure.sh
 
CMD /configure.sh
