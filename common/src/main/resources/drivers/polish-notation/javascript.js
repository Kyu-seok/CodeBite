{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const tokens = JSON.parse(input);
const result = new Solution().evalRPN(tokens);
console.log(result);
