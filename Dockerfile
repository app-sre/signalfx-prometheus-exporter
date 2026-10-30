FROM registry.access.redhat.com/ubi9/go-toolset:1.26.10-1793232557@sha256:a3b89f072fe0704b9388f3c9ad5681a6cf16293324e3f25ca0107bc09217cf62 as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:bba2b4bbf0ed15cfe7dd72a1e17ae7d2015a141f306b304e1a2785c41400e39c
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
