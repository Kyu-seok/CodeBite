{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const nums = JSON.parse(input);
new Solution().voidEmptyScans(nums);
console.log(JSON.stringify(nums));
