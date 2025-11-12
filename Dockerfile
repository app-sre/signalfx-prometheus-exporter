FROM registry.access.redhat.com/ubi9/go-toolset:1.24.6-1762373805@sha256:6f0e6c534d6b785530f7961089f444bbb14d384bfa3ea09070f5a70029b4a5cb as builder
COPY LICENSE /licenses/LICENSE
WORKDIR /build
RUN git config --global --add safe.directory /build
COPY . .
RUN make gobuild

FROM builder as test
RUN make gotest

FROM registry.access.redhat.com/ubi9-minimal@sha256:2ddd6e10383981c7d10e4966a7c0edce7159f8ca91b1691cafabc78bae79d8f8
RUN microdnf update -y && microdnf install -y ca-certificates && rm -rf /var/cache/yum
COPY --from=builder /build/signalfx-prometheus-exporter /
ENTRYPOINT ["/signalfx-prometheus-exporter"]
CMD ["serve"]
