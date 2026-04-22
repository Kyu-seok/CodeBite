{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const gas = JSON.parse(lines[0]);
const cost = JSON.parse(lines[1]);
const result = new Solution().pickStartStation(gas, cost);
console.log(result);
