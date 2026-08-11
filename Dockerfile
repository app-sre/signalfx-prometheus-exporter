FROM registry.access.redhat.com/ubi9/go-toolset:1.26.5-1786351949@sha256:0b471eb04868f3d9d90bf3c668f9c6c7a22cef07474ac9fec067909dfd7dec7c as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:7c372902c8d211db2d25c8277ba534a73b92742a334874dced829a63b0f21221
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
