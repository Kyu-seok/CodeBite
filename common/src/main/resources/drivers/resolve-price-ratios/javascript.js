{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const equations = JSON.parse(lines[0]);
const values = JSON.parse(lines[1]);
const queries = JSON.parse(lines[2]);
const result = new Solution().resolvePriceRatios(equations, values, queries);
const formatted = result.map(v => v.toFixed(5)).join(',');
console.log(`[${formatted}]`);
