{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const a = parseInt(lines[0]);
const b = parseInt(lines[1]);
const result = new Solution().combineCounters(a, b);
console.log(result);
