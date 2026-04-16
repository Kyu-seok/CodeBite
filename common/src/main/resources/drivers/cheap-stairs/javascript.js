{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const cost = JSON.parse(input);
const result = new Solution().minCostClimbingStairs(cost);
console.log(result);
