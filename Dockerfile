FROM registry.access.redhat.com/ubi9/go-toolset:1.26.5-1787668499@sha256:f221165cd493d89c13ce384e8e58914571ea353f47a1443698d981494842ff83 as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:580752f96d36c4132bffd30f9c34865bf4bd87f6aa161c969d117f21732e50f7
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
