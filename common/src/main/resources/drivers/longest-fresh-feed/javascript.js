{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const result = new Solution().longestFreshFeed(input);
console.log(result);
