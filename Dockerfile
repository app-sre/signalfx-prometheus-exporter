FROM registry.access.redhat.com/ubi9/go-toolset:1.24.4-1753723266@sha256:6ef4378dccbf2319fa67a856151e0f79540b05bd577ec4d394edc953aa246556 as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:aaf57d07d6e192bcb72190f9841f41501b8b3dffdc5e60db2f7a668c2513ab6b
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
