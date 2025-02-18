FROM registry.access.redhat.com/ubi9/go-toolset:1.22.9-1737480393@sha256:b0627f14a2179df19f449623328cd4f6db9b6e0c369e9a91dae811c1cd9402cb as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:14f14e03d68f7fd5f2b18a13478b6b127c341b346c86b6e0b886ed2b7573b8e0
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
