FROM registry.access.redhat.com/ubi9/go-toolset:1.25.3-1764620329@sha256:2e8adc5be8eba060e919a6f7309a7b5ef09dd72d3ae9e747b9eb02e96f35a0f5 as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:161a4e29ea482bab6048c2b36031b4f302ae81e4ff18b83e61785f40dc576f5d
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
