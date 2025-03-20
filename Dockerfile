FROM registry.access.redhat.com/ubi9/go-toolset:1.22.9-1742197705@sha256:564c50dbad93a50dfe1439b295f021dae0bdc8c2aef3ad8be7b2a4dde52f0e2f as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:bafd57451de2daa71ed301b277d49bd120b474ed438367f087eac0b885a668dc
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
