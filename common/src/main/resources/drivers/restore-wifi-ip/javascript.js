{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const digits = input;
const result = new Solution().restoreIpAddresses(digits);
result.sort();
console.log(JSON.stringify(result));
