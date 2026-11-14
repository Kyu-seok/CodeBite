{USER_CODE}

const digits = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const result = new Solution().countDecodings(digits);
console.log(result);
