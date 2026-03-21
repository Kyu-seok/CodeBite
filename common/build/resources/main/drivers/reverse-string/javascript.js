{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const s = JSON.parse(input);
new Solution().reverseString(s);
console.log(JSON.stringify(s));
