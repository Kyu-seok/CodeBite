{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const x = parseInt(input);
const result = new Solution().mySqrt(x);
console.log(result);
