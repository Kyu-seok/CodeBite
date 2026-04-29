{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const nums = JSON.parse(lines[0]);
const target = parseInt(lines[1]);
const result = new Solution().findPairIndices(nums, target);
if (Array.isArray(result) && result.length === 2 && result[0] > result[1]) {
    [result[0], result[1]] = [result[1], result[0]];
}
console.log(JSON.stringify(result));
