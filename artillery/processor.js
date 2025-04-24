function logResponse(requestParams, response, context, ee, next) {
  if (response.statusCode === 200) {
    console.log(`Successful request to ${requestParams.url}`);
    
    // Check response time
    if (response.timings && response.timings.phases) {
      const total = response.timings.phases.total;
      console.log(`Response time: ${total}ms`);
    }
    
    // Validate JSON responses
    try {
      const body = JSON.parse(response.body);
      
      // Different validations based on endpoint
      if (requestParams.url.includes('/ping')) {
        if (body.message !== 'pong') {
          console.log('Warning: Unexpected ping response');
        }
      } else if (requestParams.url.includes('/compute')) {
        if (!body.hasOwnProperty('result')) {
          console.log('Warning: Missing result in compute response');
        }
      } else if (requestParams.url.includes('/memory')) {
        if (!body.hasOwnProperty('size') || body.size !== 1000000) {
          console.log('Warning: Unexpected memory response');
        }
      }
    } catch (error) {
      console.log(`Error parsing JSON response: ${error.message}`);
    }
  } else {
    console.log(`Failed request to ${requestParams.url}: ${response.statusCode}`);
  }
  
  return next();
}

module.exports = {
  logResponse
}; 