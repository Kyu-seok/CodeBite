{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const s = lines[0].trim();
const k = parseInt(lines[1]);
const result = new Solution().characterReplacement(s, k);
console.log(result);
