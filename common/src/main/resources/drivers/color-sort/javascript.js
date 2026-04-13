{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const nums = JSON.parse(input);
new Solution().sortColors(nums);
console.log(JSON.stringify(nums));
