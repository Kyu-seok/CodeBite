{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lockers = JSON.parse(input);
const result = new Solution().largestPosterArea(lockers);
console.log(result);
