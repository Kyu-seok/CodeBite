{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const nums = JSON.parse(lines[0]);
const result = new Solution().findMin(nums);
console.log(result);
