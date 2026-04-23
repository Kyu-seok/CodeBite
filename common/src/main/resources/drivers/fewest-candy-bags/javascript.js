{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const coins = JSON.parse(lines[0]);
const amount = parseInt(lines[1]);
console.log(new Solution().fewestBagSizes(coins, amount));
