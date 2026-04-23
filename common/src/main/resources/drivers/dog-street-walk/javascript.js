{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const tickets = JSON.parse(input);
const result = new Solution().traceStreetSweep(tickets);
console.log(JSON.stringify(result));
