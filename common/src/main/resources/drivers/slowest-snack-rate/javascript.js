{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const piles = JSON.parse(lines[0]);
const hours = parseInt(lines[1]);
const result = new Solution().minEatingRate(piles, hours);
console.log(result);
