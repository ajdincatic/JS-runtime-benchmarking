#!/bin/bash

# Define variables
SERVER_URL="http://localhost:3000"
CONCURRENCY=100
REQUESTS=10000

# Make directory for results if it doesn't exist
mkdir -p ab-results

# Test basic endpoints
echo "Testing ping endpoint..."
ab -c $CONCURRENCY -n $REQUESTS -g ab-results/ping.tsv $SERVER_URL/ping > ab-results/ping.txt

echo "Testing compute endpoint..."
ab -c $CONCURRENCY -n $REQUESTS -g ab-results/compute.tsv $SERVER_URL/compute > ab-results/compute.txt

echo "Testing memory endpoint..."
ab -c $CONCURRENCY -n $REQUESTS -g ab-results/memory.tsv $SERVER_URL/memory > ab-results/memory.txt

echo "Testing bulk endpoint..."
ab -c $CONCURRENCY -n $REQUESTS -g ab-results/bulk.tsv $SERVER_URL/bulk > ab-results/bulk.txt

echo "Apache Benchmark testing completed. Results are in ab-results directory." 