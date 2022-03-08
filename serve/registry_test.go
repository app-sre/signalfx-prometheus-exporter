package serve_test

import (
	"signalfx-prometheus-exporter/config"
	"signalfx-prometheus-exporter/serve"
	"testing"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/stretchr/testify/assert"
)

var (
	FilterLabel = "label"
	FilterValue = "value"
)

func setupRegistry(minMetrics int) (*serve.FilteringRegistry, *prometheus.Registry) {
	registry := prometheus.NewRegistry()

	grouping := config.GroupingConfig{
		Label: FilterLabel,
		ReadyConditions: config.GroupReadyConditions{
			MinMetrics: minMetrics,
		},
	}

	fr := &serve.FilteringRegistry{
		Grouping:    grouping,
		Registry:    registry,
		FilterValue: FilterValue,
	}

	return fr, registry
}

func TestMinimumMetricsSupplied(t *testing.T) {
	/* test that the filtering registry is not complaining
	   when the minimum required metrics remain after filtering */

	minMetrics := 2
	fr, registry := setupRegistry(minMetrics)

	gaugeWithMatchingLabel := prometheus.NewGaugeVec(
		prometheus.GaugeOpts{Name: "some_gauge"},
		[]string{FilterLabel},
	)
	registry.MustRegister(gaugeWithMatchingLabel)
	counterWithMatchingLabel := prometheus.NewCounterVec(
		prometheus.CounterOpts{Name: "some_counter"},
		[]string{FilterLabel},
	)
	registry.MustRegister(counterWithMatchingLabel)

	gaugeWithMatchingLabel.WithLabelValues(FilterValue).Set(0)
	counterWithMatchingLabel.WithLabelValues(FilterValue).Add(1)

	metricFamilies, err := fr.Gather()
	assert.Nil(t, err)
	assert.NotNil(t, metricFamilies)
	assert.NotEmpty(t, metricFamilies)

	metricCounter := 0
	for _, mf := range metricFamilies {
		metricCounter += len(mf.Metric)
	}
	assert.GreaterOrEqual(t, metricCounter, minMetrics)
}

func TestTooFewSupplied(t *testing.T) {
	/* test that the filtering registry raises and error
	   when less metrics remain as demanded after filtering */

	minMetrics := 2
	fr, registry := setupRegistry(minMetrics)

	gaugeWithMatchingLabel := prometheus.NewGaugeVec(
		prometheus.GaugeOpts{Name: "some_gauge"},
		[]string{FilterLabel},
	)
	registry.MustRegister(gaugeWithMatchingLabel)
	counterWithMatchingLabel := prometheus.NewCounterVec(
		prometheus.CounterOpts{Name: "some_counter"},
		[]string{FilterLabel},
	)
	registry.MustRegister(counterWithMatchingLabel)

	gaugeWithMatchingLabel.WithLabelValues(FilterValue).Set(0)
	counterWithMatchingLabel.WithLabelValues("other_value").Add(1)

	_, err := fr.Gather()
	assert.Error(t, err)
}
