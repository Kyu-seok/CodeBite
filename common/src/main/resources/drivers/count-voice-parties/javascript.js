{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const n = parseInt(lines[0]);
const relays = JSON.parse(lines[1]);
const result = new Solution().countParties(n, relays);
console.log(result);
