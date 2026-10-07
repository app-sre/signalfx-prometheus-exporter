FROM registry.access.redhat.com/ubi9/go-toolset:1.26.7-1791182877@sha256:d45bb2ba2e518d3edf14ad3baf6c57fdc7cc44c996cad1200f71036f7c1c8d29 as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:5ed244b62bbf4095080144d9d35eb8fcd3d39a9801f94aadd63b9d10978a01ae
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
