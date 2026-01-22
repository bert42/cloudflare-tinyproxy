FROM registry.access.redhat.com/ubi9/ubi-minimal

RUN microdnf install -y tinyproxy && microdnf clean all

EXPOSE 61234

USER nobody

CMD ["tinyproxy", "-d", "-c", "/etc/tinyproxy/tinyproxy.conf"]
