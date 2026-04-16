{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const n = parseInt(lines[0]);
const flights = JSON.parse(lines[1]);
const src = parseInt(lines[2]);
const dst = parseInt(lines[3]);
const k = parseInt(lines[4]);
const result = new Solution().findCheapestPrice(n, flights, src, dst, k);
console.log(result);
