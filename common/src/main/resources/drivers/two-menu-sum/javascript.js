{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const menuPrice = JSON.parse(lines[0]);
const budget = parseInt(lines[1]);
const result = new Solution().findMenuPair(menuPrice, budget);
console.log(JSON.stringify(result));
