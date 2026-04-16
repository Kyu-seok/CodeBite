{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const nums = JSON.parse(lines[0]);
const target = parseInt(lines[1]);
const result = new Solution().shortestCover(nums, target);
console.log(result);
