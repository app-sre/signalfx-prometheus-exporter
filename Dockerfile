FROM registry.access.redhat.com/ubi9/go-toolset:1.23.6-1747059472@sha256:a7d68b27e36edc6befe7dde94dd1db34c728a47df602998bd66c737d84813b5a as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:21ed5a01130d3a77eb4a26a80de70a4433860255b394e95dc2c26817de1da061
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
