module signalfx-prometheus-exporter

go 1.22

// Could not get past signalfx-go 1.30.0 without major changes
require (
	github.com/gorilla/mux v1.8.1
	github.com/prometheus/client_golang v1.20.5
	github.com/prometheus/client_model v0.6.1
	github.com/signalfx/signalfx-go v1.30.0
	github.com/spf13/cobra v1.8.1
	github.com/stretchr/testify v1.9.0
	go.uber.org/zap v1.27.0
	golang.org/x/sync v0.9.0
	gopkg.in/yaml.v3 v3.0.1
)

require (
	github.com/beorn7/perks v1.0.1 // indirect
	github.com/cespare/xxhash/v2 v2.3.0 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/gorilla/websocket v1.4.2 // indirect
	github.com/inconshreveable/mousetrap v1.1.0 // indirect
	github.com/klauspost/compress v1.17.9 // indirect
	github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/prometheus/common v0.55.0 // indirect
	github.com/prometheus/procfs v0.15.1 // indirect
	github.com/signalfx/golib/v3 v3.3.47 // indirect
	github.com/spf13/pflag v1.0.5 // indirect
	go.uber.org/multierr v1.10.0 // indirect
	golang.org/x/sys v0.22.0 // indirect
	google.golang.org/protobuf v1.34.2 // indirect
)
