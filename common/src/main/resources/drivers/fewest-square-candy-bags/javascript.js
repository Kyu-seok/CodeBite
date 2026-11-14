{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const candies = parseInt(input);
const result = new Solution().fewestBags(candies);
console.log(result);
