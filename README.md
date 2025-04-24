# Analysis and Experimental Comparison of the Performance of Modern JavaScript Runtime Environments for Server Applications

> **Note**: This repository is part of a Master's thesis research project focused on analyzing and comparing the performance characteristics of modern JavaScript runtime environments for server applications.

This project contains benchmark API endpoints implemented in three different JavaScript runtimes:
- Node.js (with Express)
- Deno
- Bun

## Benchmark Endpoints

Each runtime implements the following endpoints:

### Basic Performance Metrics
1. **Latency / Response Time**: `GET /ping`
2. **CPU Load**: `GET /compute`
3. **Memory Usage**: `GET /memory`
4. **Throughput Test**: `GET /bulk`

All servers listen on port 3000 and return JSON responses for consistent measurement.

## Setup and Running

### Prerequisites

This project uses specific versions of each runtime:
- Node.js: see `.nvmrc` file
- Deno: see `.deno-version` file
- Bun: see `.bun-version` file

### Installation

#### Installing Node.js with nvm
```bash
# Install nvm if you don't have it
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc  # or ~/.zshrc if using zsh

# Install and use the Node.js version specified in .nvmrc
nvm install
nvm use
```

#### Installing Deno v2.1.10
```bash
# Install Deno if you don't have it
curl -fsSL https://deno.land/install.sh | sh

# For a specific version (2.1.10)
curl -fsSL https://deno.land/install.sh | sh -s v2.1.10

# Check version
deno --version
```

#### Installing Bun v1.2.9
```bash
# Install Bun if you don't have it
curl -fsSL https://bun.sh/install | bash

# For a specific version (1.2.9)
curl -fsSL https://bun.sh/install | bash -s "bun-v1.2.9"

# Check version
bun --version
```

### Running the Servers

#### Node.js
```bash
npm run start:node
```

#### Deno
```bash
npm run start:deno
```

#### Bun
```bash
npm run start:bun
```

## Performance Measurement Tools

This project includes configurations for several popular performance measurement tools:

### 1. k6

[k6](https://k6.io/) is an open-source load testing tool that makes performance testing easy and productive for engineering teams.

```bash
# Install k6
# Linux
sudo apt-get install k6

# macOS
brew install k6

# Run basic test
npm run test:k6
```

### 2. Apache Benchmark (ab)

[Apache Benchmark](https://httpd.apache.org/docs/2.4/programs/ab.html) is a command-line tool for measuring the performance of HTTP web servers.

```bash
# Install Apache Benchmark
# Ubuntu/Debian
sudo apt-get install apache2-utils

# macOS
brew install httpd

# Run tests
npm run test:ab
```

### 3. Artillery

[Artillery](https://www.artillery.io/) is a modern, powerful, and easy-to-use load testing toolkit.

```bash
# Install Artillery globally
npm install -g artillery

# Or use the local installation included in package.json
npm install

# Run tests
npm run test:artillery
```

### 4. Prometheus & Grafana

[Prometheus](https://prometheus.io/) is an open-source systems monitoring and alerting toolkit, and [Grafana](https://grafana.com/) is an open-source platform for monitoring and observability.

```bash
# Start Prometheus and Grafana (requires Docker and Docker Compose)
npm run prometheus:start

# Stop Prometheus and Grafana
npm run prometheus:stop
```

After starting, access:
- Prometheus dashboard: http://localhost:9000
- Grafana dashboard: http://localhost:3100 (username: admin, password: admin)

## Running All Benchmarks

To run a complete benchmark suite across all runtimes and tools:

```bash
npm run benchmark
```

This will:
1. Start all servers
2. Run all configured benchmark tools against each server
3. Collect results in the `results` directory
4. Stop all servers

## Endpoint Details

### Basic Endpoints
- `/ping`: Measures latency with minimal response
- `/compute`: CPU-intensive endpoint that simulates computationally demanding operations
- `/memory`: Allocates a larger amount of memory to test RAM usage
- `/bulk`: Used for high numbers of simultaneous requests (requests per second test)

The code in all runtimes is implemented in the simplest possible form, without additional libraries (except Express for Node.js), to focus testing exclusively on the performance of the runtime itself. 

## Master's Thesis Project

This benchmarking suite is developed as part of a Master's thesis on the topic:

**"Analysis and Experimental Comparison of the Performance of Modern JavaScript Runtime Environments for Server Applications"**

The research aims to provide a comprehensive and objective comparison between Node.js, Deno, and Bun, focusing on:

1. HTTP server performance metrics (latency, throughput, and resource utilization)
2. Real-world server application scenarios
3. Quantitative analysis of performance differences
4. Practical recommendations for choosing the appropriate runtime for different server-side use cases

The experimental design includes both microbenchmarks (individual API endpoints) and more complex workloads to simulate real-world server applications.

All benchmark results, analysis methodologies, and conclusions will be documented in the thesis. 