import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 100 },    // Low load: 100 users
    { duration: '1m', target: 100 },     // Maintain low load for 1 minute
    { duration: '30s', target: 0 },      // Ramp-down to 0 users

    { duration: '30s', target: 500 },    // Medium load: 500 users
    { duration: '1m', target: 500 },     // Maintain medium load for 1 minute
    { duration: '30s', target: 0 },      // Ramp-down to 0 users

    { duration: '30s', target: 1000 },   // High load: 1000 users
    { duration: '1m', target: 1000 },    // Maintain high load for 1 minute
    { duration: '30s', target: 0 },      // Ramp-down to 0 users
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests should be below 500ms
  },
};

// Get the target URL from environment variable or use default
const BASE_URL = `http://localhost:${__ENV.TARGET || 3000}`;

export default function() {
  // Basic test for ping endpoint
  let pingRes = http.get(`${BASE_URL}/ping`);
  check(pingRes, {
    'ping status is 200': (r) => r.status === 200,
    'ping response has correct message': (r) => JSON.parse(r.body).message === 'pong',
  });
  
  sleep(1);
  
  // CPU test
  let computeRes = http.get(`${BASE_URL}/compute`);
  check(computeRes, {
    'compute status is 200': (r) => r.status === 200,
    'compute has result property': (r) => JSON.parse(r.body).hasOwnProperty('result'),
  });
  
  sleep(1);
  
  // Memory test
  let memoryRes = http.get(`${BASE_URL}/memory`);
  check(memoryRes, {
    'memory status is 200': (r) => r.status === 200,
    'memory response has correct size': (r) => JSON.parse(r.body).size === 1000000,
  });
  
  sleep(1);
  
  // Test bulk endpoint
  let bulkRes = http.get(`${BASE_URL}/bulk`);
  check(bulkRes, {
    'bulk status is 200': (r) => r.status === 200,
  });
  
  sleep(1);
} 