{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const nums = JSON.parse(input);
const result = new Solution().listRepeatedCodes(nums);
result.sort((a, b) => a - b);
console.log(JSON.stringify(result));
