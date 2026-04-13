{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const s1 = lines[0];
const s2 = lines[1];
const result = new Solution().checkInclusion(s1, s2);
console.log(result);
