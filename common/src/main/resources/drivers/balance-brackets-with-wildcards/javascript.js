{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const brackets = input.split('\n')[0];
const result = new Solution().canBalance(brackets);
console.log(result);
