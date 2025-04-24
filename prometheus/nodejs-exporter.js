const express = require('express');
const client = require('prom-client');
const app = express();

// Create a Registry to register the metrics
const register = new client.Registry();

// Add a default label which is added to all metrics
register.setDefaultLabels({
  app: 'nodejs-benchmark-app'
});

// Enable the collection of default metrics
client.collectDefaultMetrics({ register });

// Define custom metrics
const httpRequestDurationMicroseconds = new client.Histogram({
  name: 'http_request_duration_ms',
  help: 'Duration of HTTP requests in ms',
  labelNames: ['route', 'method', 'status'],
  buckets: [0.1, 5, 15, 50, 100, 200, 500, 1000, 2000, 5000]
});

const endpointHitCounter = new client.Counter({
  name: 'endpoint_hits_total',
  help: 'Number of hits to each endpoint',
  labelNames: ['endpoint']
});

// Register the custom metrics
register.registerMetric(httpRequestDurationMicroseconds);
register.registerMetric(endpointHitCounter);

// Define route for metrics endpoint
app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', register.contentType);
    res.end(await register.metrics());
  } catch (err) {
    res.status(500).end(err);
  }
});

// Start the app
app.listen(9090, () => {
  console.log('Node.js Prometheus exporter listening on port 9090');
});

// Export the metrics objects so they can be used in the main app
module.exports = {
  httpRequestDurationMicroseconds,
  endpointHitCounter
}; 