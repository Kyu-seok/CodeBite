{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const weights = JSON.parse(lines[0]);
const days = parseInt(lines[1]);
const result = new Solution().smallestFlowRate(weights, days);
console.log(result);
