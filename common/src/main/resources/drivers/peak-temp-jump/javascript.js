{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const prices = JSON.parse(input);
const result = new Solution().maxTempSwing(prices);
console.log(result);
