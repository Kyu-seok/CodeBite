{USER_CODE}

const phrase = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const result = new Solution().isPalindrome(phrase);
console.log(result);
