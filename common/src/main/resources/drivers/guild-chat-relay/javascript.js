{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const edges = JSON.parse(lines[0]);
const n = parseInt(lines[1]);
const src = parseInt(lines[2]);
const result = new Solution().propagateAlertWave(edges, n, src);
console.log(result);
