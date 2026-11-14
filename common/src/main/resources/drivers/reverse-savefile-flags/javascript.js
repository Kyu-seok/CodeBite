{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const statusWord = parseInt(input);
const result = new Solution().reverseFlags(statusWord);
console.log(result);
