FROM registry.access.redhat.com/ubi9/go-toolset:1.26.5-1785791459@sha256:46376c6723c3a4961a165c2768461e7fac48a79932cdde0a6e6a57724ef61ba0 as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:48fa5d8cda7fc00d270d8747c3eaa54ae196f0820d8540074a9c8c61d5e3056f
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
