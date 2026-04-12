{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const result = new Solution().lengthOfLongestSubstring(input);
console.log(result);
