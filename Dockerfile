FROM registry.access.redhat.com/ubi9/go-toolset:1.26.10-1793621864@sha256:5f0dead6a152de46a19f51322ea8e06d0d9f282a4937d663cf5a226cb8744bc8 as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:dfa0eb04abc59221544e74862432496add1f491f915c9b531880f91affc0e12c
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
