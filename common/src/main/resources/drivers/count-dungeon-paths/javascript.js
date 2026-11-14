{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const rows = parseInt(lines[0]);
const cols = parseInt(lines[1]);
const result = new Solution().countPaths(rows, cols);
console.log(result);
