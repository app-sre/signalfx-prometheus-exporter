FROM registry.access.redhat.com/ubi9/go-toolset:1.26.7-1791928822@sha256:f9e171ed4a2ecfd284b6d977d60f6a0ed33eac8628ad806a80cdf3521cb8bede as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:a21d19f72557aa893a0f6ca1177bb1ffd91df6015e60470a116c50a6a05efcd9
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
