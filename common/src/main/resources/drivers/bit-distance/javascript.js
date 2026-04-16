{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const x = parseInt(lines[0]);
const y = parseInt(lines[1]);
const result = new Solution().bitDistance(x, y);
console.log(result);
