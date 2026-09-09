FROM registry.access.redhat.com/ubi9/go-toolset:1.26.7-1788409979@sha256:5e68f09a652ac6627a83c57655e42e24575efb278b54336039c9308607fc6b21 as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:6aa59f704742d12328aa43379048f951c052dfb684c22b79080baf34c1f92368
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
