{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const energy = JSON.parse(lines[0]);
const drain = JSON.parse(lines[1]);
const result = new Solution().pickStartStop(energy, drain);
console.log(result);
