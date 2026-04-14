{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const n = parseInt(lines[0]);
const edges = JSON.parse(lines[1]);
const result = new Solution().countComponents(n, edges);
console.log(result);
