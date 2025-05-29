module signalfx-prometheus-exporter

go 1.23.0

toolchain go1.23.6

// Could not get past signalfx-go 1.30.0 without major changes
require (
	github.com/gorilla/mux v1.8.1
	github.com/prometheus/client_golang v1.22.0
	github.com/prometheus/client_model v0.6.1
	github.com/signalfx/signalfx-go v1.30.0
	github.com/spf13/cobra v1.9.1
	github.com/stretchr/testify v1.10.0
	go.uber.org/zap v1.27.0
	golang.org/x/sync v0.13.0
	gopkg.in/yaml.v3 v3.0.1
)

require (
	github.com/beorn7/perks v1.0.1 // indirect
	github.com/cespare/xxhash/v2 v2.3.0 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/gorilla/websocket v1.5.3 // indirect
	github.com/inconshreveable/mousetrap v1.1.0 // indirect
	github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/prometheus/common v0.63.0 // indirect
	github.com/prometheus/procfs v0.16.0 // indirect
	github.com/signalfx/golib/v3 v3.3.55 // indirect
	github.com/spf13/pflag v1.0.6 // indirect
	go.uber.org/multierr v1.11.0 // indirect
	golang.org/x/sys v0.32.0 // indirect
	google.golang.org/protobuf v1.36.6 // indirect
)
