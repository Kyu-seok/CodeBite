{USER_CODE}

const brackets = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const result = new Solution().isValidBrackets(brackets);
console.log(result);
