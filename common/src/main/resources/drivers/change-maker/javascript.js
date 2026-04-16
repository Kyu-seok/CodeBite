{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const amount = parseInt(lines[0]);
const coins = JSON.parse(lines[1]);
const result = new Solution().changeMaker(amount, coins);
console.log(result);
