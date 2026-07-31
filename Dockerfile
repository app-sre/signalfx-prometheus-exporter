FROM registry.access.redhat.com/ubi9/go-toolset:1.26.5-1785443561@sha256:0b0dd6f4ee311854a6b8e18b3bc52e7aa6b66f935a16c8f9bda173353ab16c64 as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:2a98ec380ad75004992b8538380a5003da64442f0a69237ed236859e023c71d0
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
