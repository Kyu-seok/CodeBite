{USER_CODE}

const doodle = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const result = new Solution().countPalindromicSubstrings(doodle);
console.log(result);
