{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const n = parseInt(lines[0]);
const edges = JSON.parse(lines[1]);
const result = new Solution().validTree(n, edges);
console.log(result);
