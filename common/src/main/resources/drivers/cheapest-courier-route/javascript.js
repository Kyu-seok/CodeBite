{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const n = parseInt(lines[0]);
const links = JSON.parse(lines[1]);
const src = parseInt(lines[2]);
const dst = parseInt(lines[3]);
const maxStops = parseInt(lines[4]);
const result = new Solution().cheapestRoute(n, links, src, dst, maxStops);
console.log(result);
