#!/bin/bash

echo "JavaScript Runtime Benchmarking Suite"
echo "====================================="

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

is_port_in_use() {
  lsof -i:3000 > /dev/null 2>&1
  return $?
}

kill_port_process() {
  echo "Killing any process using port 3000..."
  kill $(lsof -t -i:3000) 2>/dev/null || true
  sleep 3
}

echo "Checking for required runtimes..."

MISSING_RUNTIMES=0

if ! command_exists node; then
  echo "Node.js is not installed. Please install it first."
  MISSING_RUNTIMES=1
else
  if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    if [ -f ".nvmrc" ]; then
      echo "Running nvm use with version from .nvmrc..."
      nvm use
    else
      echo "No .nvmrc file found. Cannot use specified Node version."
    fi
  else
    echo "nvm not found. Using system Node version."
  fi

  echo "Node.js is installed. Version: $(node --version)"
fi

if ! command_exists deno; then
  echo "Deno is not installed. Please install it first."
  MISSING_RUNTIMES=1
else
  echo "Deno is installed. Version: $(deno --version)"
fi

if ! command_exists bun; then
  echo "Bun is not installed. Please install it first."
  MISSING_RUNTIMES=1
else
  echo "Bun is installed. Version: $(bun --version)"
fi

if [ $MISSING_RUNTIMES -eq 1 ]; then
  echo "Please install missing runtimes before proceeding."
  exit 1
else
  echo "All required runtimes are installed."
fi

echo "Checking for benchmark tools..."

MISSING_BENCHMARKS=0

if ! command_exists k6; then
  echo "k6 is not installed. Please install it first."
  MISSING_BENCHMARKS=1
else
  echo "k6 is installed."
fi

if ! command_exists ab; then
  echo "Apache Benchmark (ab) is not installed. Please install it first."
  MISSING_BENCHMARKS=1
else
  echo "Apache Benchmark (ab) is installed."
fi

if ! command_exists artillery; then
  echo "Artillery is not installed. Please install it first."
  MISSING_BENCHMARKS=1
else
  echo "Artillery is installed."
fi

if [ $MISSING_BENCHMARKS -eq 1 ]; then
  echo "Please install missing benchmark tools before proceeding."
  exit 1
else
  echo "All required benchmark tools are installed."
fi

# Clear previous benchmark results
echo "Clearing previous benchmark results..."
rm -rf results
rm -rf ab-results

# Create results directory
mkdir -p results
mkdir -p ab-results

# Make sure port 3000 is free before starting
kill_port_process

# Function to run benchmarks
run_benchmarks() {
  local runtime=$1
  
  echo "Running benchmarks for $runtime on port 3000..."
  
  # k6 benchmarks if available
  if command_exists k6; then
    echo "Running k6 benchmarks for $runtime..."
    k6 run -e TARGET=3000 k6-scripts/basic-test.js > results/k6-$runtime.log
  fi
  
  # Apache Benchmark if available
  if command_exists ab; then
    echo "Running Apache Benchmark for $runtime..."
    chmod +x apache-benchmark/ab-commands.sh
    SERVER_URL="http://localhost:3000" RUNTIME="$runtime" ./apache-benchmark/ab-commands.sh > results/ab-$runtime.log
  fi
  
  # Artillery if available
  if command_exists artillery; then
    echo "Running Artillery benchmarks for $runtime..."
    artillery run --target http://localhost:3000 artillery/config.yml > results/artillery-$runtime.log
  fi
}

# Run Node.js server and benchmarks
echo "Starting Node.js server..."
if is_port_in_use; then
  echo "Port 3000 is already in use. Killing the process..."
  kill_port_process
fi

node servers/node-server.js > results/node-server.log 2>&1 &
NODE_PID=$!
echo "Node.js server started with PID: $NODE_PID"

# Wait for server to start
echo "Waiting for server to initialize..."
sleep 5

# Run benchmarks for Node.js
run_benchmarks "nodejs"

# Stop Node.js server
echo "Stopping Node.js server..."
kill -9 $NODE_PID 2>/dev/null || true
kill_port_process

# Run Deno server and benchmarks
echo "Starting Deno server..."
if is_port_in_use; then
  echo "Port 3000 is already in use. Killing the process..."
  kill_port_process
fi

deno run --allow-net servers/deno-server.ts > results/deno-server.log 2>&1 &
DENO_PID=$!
echo "Deno server started with PID: $DENO_PID"

# Wait for server to start
echo "Waiting for server to initialize..."
sleep 5

# Run benchmarks for Deno
run_benchmarks "deno"

# Stop Deno server
echo "Stopping Deno server..."
kill -9 $DENO_PID 2>/dev/null || true
kill_port_process

# Run Bun server and benchmarks
echo "Starting Bun server..."
if is_port_in_use; then
  echo "Port 3000 is already in use. Killing the process..."
  kill_port_process
fi

bun servers/bun-server.js > results/bun-server.log 2>&1 &
BUN_PID=$!
echo "Bun server started with PID: $BUN_PID"

# Wait for server to start
echo "Waiting for server to initialize..."
sleep 5

# Run benchmarks for Bun
run_benchmarks "bun"

# Stop Bun server
echo "Stopping Bun server..."
kill -9 $BUN_PID 2>/dev/null || true
kill_port_process

echo "Benchmark run completed. Results are in the 'results' directory." 