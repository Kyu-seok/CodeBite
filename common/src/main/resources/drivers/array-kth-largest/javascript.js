{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const nums = JSON.parse(lines[0]);
const k = parseInt(lines[1]);
const result = new Solution().findKthLargest(nums, k);
console.log(result);
