{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const nums = JSON.parse(input);
const result = new Solution().pickPlotHaul(nums);
console.log(result);
