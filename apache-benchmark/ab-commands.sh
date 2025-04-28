#!/bin/bash

# Define variables
SERVER_URL=${SERVER_URL:-"http://localhost:3000"}
RUNTIME=${RUNTIME:-"unknown"}
CONCURRENCY=100
REQUESTS=10000

# Make directory for results if it doesn't exist
mkdir -p ab-results

# Test basic endpoints
echo "Testing ping endpoint for $RUNTIME..."
ab -c $CONCURRENCY -n $REQUESTS -g ab-results/ping-$RUNTIME.tsv $SERVER_URL/ping > ab-results/ping-$RUNTIME.txt

echo "Testing compute endpoint for $RUNTIME..."
ab -c $CONCURRENCY -n $REQUESTS -g ab-results/compute-$RUNTIME.tsv $SERVER_URL/compute > ab-results/compute-$RUNTIME.txt

echo "Testing memory endpoint for $RUNTIME..."
ab -c $CONCURRENCY -n $REQUESTS -g ab-results/memory-$RUNTIME.tsv $SERVER_URL/memory > ab-results/memory-$RUNTIME.txt

echo "Testing bulk endpoint for $RUNTIME..."
ab -c $CONCURRENCY -n $REQUESTS -g ab-results/bulk-$RUNTIME.tsv $SERVER_URL/bulk > ab-results/bulk-$RUNTIME.txt

echo "Apache Benchmark testing completed for $RUNTIME. Results are in ab-results directory." 