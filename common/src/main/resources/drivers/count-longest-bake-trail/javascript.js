{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const nums = JSON.parse(input);
const result = new Solution().countLongestTrail(nums);
console.log(result);
