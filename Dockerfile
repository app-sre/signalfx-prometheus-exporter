FROM registry.access.redhat.com/ubi9/go-toolset:1.26.5-1786023237@sha256:5d26ff5606bd6590930e7cfc202b510e3fe2c7a7a1720860f444ab49c45128cb as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:57c8151c51445a07e503dab9dc9211dc3cdeac9d45ed81a10954b7d770659b3b
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
