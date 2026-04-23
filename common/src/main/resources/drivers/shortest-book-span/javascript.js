{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const s = lines[0].trim();
const t = lines[1].trim();
const result = new Solution().shortestShelfSpan(s, t);
console.log(result);
