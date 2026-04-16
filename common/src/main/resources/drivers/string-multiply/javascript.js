{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const num1 = lines[0].trim();
const num2 = lines[1].trim();
const result = new Solution().multiply(num1, num2);
console.log(result);
