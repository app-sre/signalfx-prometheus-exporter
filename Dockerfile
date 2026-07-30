FROM registry.access.redhat.com/ubi9/go-toolset:1.26.5-1785360201@sha256:272a3dd990bba320c2e246119a0019d10d627d0104938d5db77ba5ab3ae3a51d as builder
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
