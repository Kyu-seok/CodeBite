{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8');
const s = input.split('\n')[0];
const result = new Solution().reverseWords(s);
console.log(result);
