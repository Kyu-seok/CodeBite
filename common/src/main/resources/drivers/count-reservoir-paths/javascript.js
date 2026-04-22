{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const n = parseInt(input);
const result = new Solution().countReservoirPaths(n);
console.log(result);
