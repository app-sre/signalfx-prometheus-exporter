FROM registry.access.redhat.com/ubi9/go-toolset:1.26.7-1789040808@sha256:685ccca486cc2c82b0818d835abecb1aed7a396e76ba416cfc47c28067f5d365 as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:984df0a2b8d9011d419b0ad260b25f6b74b7ce69ab0595b75522e30f8849f27f
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
