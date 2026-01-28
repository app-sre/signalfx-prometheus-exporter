# SignalFX Prometheus Exporter - AI Agent Context

## Project Overview
This is a Go-based Prometheus exporter that bridges the gap between SignalFX (Splunk Observability Cloud) and Prometheus monitoring systems. It provides a Prometheus scrape target for SignalFX metrics using the SignalFlow language.

## Tech Stack
- **Language**: Go
- **Key Dependencies**:
  - gorilla/mux (HTTP routing)
  - prometheus/client_golang (Prometheus metrics)
  - signalfx/signalfx-go (SignalFX integration)
  - signalfx/signalflow-client-go/v2 (SignalFlow streaming)
  - spf13/cobra (CLI framework)
  - go.uber.org/zap (logging)
  - gopkg.in/yaml.v3 (configuration)

## Project Structure
- `main.go` - Application entry point
- `cmd/` - CLI commands
- `serve/` - HTTP server implementation
- `config/` - Configuration handling
- `utils/` - Utility functions
- `docs/` - Documentation
- `examples/` - Configuration examples

## Build & Test Commands
- `make gotest` - Run tests with CGO disabled
- `make gobuild` - Build binary (runs tests first)
- `make build` - Build container image
- `make container-test` - Run tests in container

## Key Features
- Streams metrics from SignalFX using SignalFlow language
- Converts to Prometheus-compatible metrics
- Supports metric grouping and filtering
- Template-based metric name/label generation
- Observability endpoint for internal metrics

## Development Guidelines
- Always run tests before building: `make gotest`
- Build produces binary: `signalfx-prometheus-exporter`
- Container builds use Docker/Podman with BuildKit
- Configuration via YAML files and CLI flags

## Commit Standards
- Use `Assisted-by:` instead of `Co-Authored-By:`
- Remove whitespace-only lines
- Use double newlines for EOF

## Important Notes
- Process needs restart for config changes
- Warmup time required for complete metric availability
- Counter metrics may have issues with multiple replicas
- Stream-based architecture requires careful scraping timing