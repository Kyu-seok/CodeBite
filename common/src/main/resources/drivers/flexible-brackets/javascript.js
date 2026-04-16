{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const s = input.split('\n')[0];
const result = new Solution().checkValid(s);
console.log(result);
