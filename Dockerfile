FROM registry.access.redhat.com/ubi9/go-toolset:1.21.13-2.1727893526@sha256:fd41c001abc243076cc28b63c409ae6d9cbcad401c8124fb67d20fe57a2aa63a as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:9ffc5b7c447ba1918778c60e028216c8a98e3593aec0d3eca330817bc2e31e2b
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
