{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const s = lines[0];
const p = lines[1];
const result = new Solution().isMatch(s, p);
console.log(result);
