{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const x = parseFloat(lines[0]);
const n = parseInt(lines[1]);
const result = new Solution().raiseForecastFactor(x, n);
console.log(result.toFixed(5));
