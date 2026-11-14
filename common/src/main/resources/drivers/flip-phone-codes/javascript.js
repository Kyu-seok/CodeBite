{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const result = new Solution().letterCombinations(input).sort();
console.log(JSON.stringify(result));
