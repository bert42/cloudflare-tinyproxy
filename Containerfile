FROM docker.io/library/alpine:3.21

RUN apk add --no-cache tinyproxy

EXPOSE 61234

CMD ["tinyproxy", "-d", "-c", "/etc/tinyproxy/tinyproxy.conf"]
