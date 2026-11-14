{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const socks = JSON.parse(input);
const result = new Solution().smallestMissingNumber(socks);
console.log(result);
