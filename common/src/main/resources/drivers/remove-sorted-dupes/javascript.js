{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const nums = JSON.parse(input);
const k = new Solution().removeDuplicates(nums);
console.log(k);
console.log(JSON.stringify(nums.slice(0, k)));
