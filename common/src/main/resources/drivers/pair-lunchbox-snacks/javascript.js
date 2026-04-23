{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const weights = JSON.parse(lines[0]);
const capacity = parseInt(lines[1]);
const result = new Solution().pairCrates(weights, capacity);
console.log(result);
