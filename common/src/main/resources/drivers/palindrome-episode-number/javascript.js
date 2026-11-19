{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const episode = parseInt(input);
const result = new Solution().isPalindrome(episode);
console.log(result);
