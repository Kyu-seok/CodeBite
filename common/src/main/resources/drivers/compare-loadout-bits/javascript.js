{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const leftFlags = parseInt(lines[0]);
const rightFlags = parseInt(lines[1]);
const result = new Solution().countFlagMismatches(leftFlags, rightFlags);
console.log(result);
