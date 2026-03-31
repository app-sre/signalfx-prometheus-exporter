FROM registry.access.redhat.com/ubi9/go-toolset:1.25.8-1774968108@sha256:c64ef498cb9389d27fc39f11ec1d0bb0372d827f112728a95dd386515568487e as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:83006d535923fcf1345067873524a3980316f51794f01d8655be55d6e9387183
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
