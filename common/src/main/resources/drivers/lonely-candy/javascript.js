{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const candies = JSON.parse(input);
console.log(new Solution().findLonelyCandy(candies));
