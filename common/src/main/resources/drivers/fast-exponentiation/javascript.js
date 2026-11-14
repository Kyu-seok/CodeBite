{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const base = parseFloat(lines[0]);
const exponent = parseInt(lines[1]);
const result = new Solution().power(base, exponent);
console.log(result.toFixed(5));
