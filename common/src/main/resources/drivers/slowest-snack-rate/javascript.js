{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const piles = JSON.parse(lines[0]);
const h = parseInt(lines[1]);
const result = new Solution().slowestConveyorSpeed(piles, h);
console.log(result);
