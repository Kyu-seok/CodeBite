{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const m = parseInt(lines[0]);
const n = parseInt(lines[1]);
const result = new Solution().countGateRoutes(m, n);
console.log(result);
